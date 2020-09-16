unit Schule;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShlObj, Winapi.WinInet, Vcl.Forms,
  System.IniFiles, System.Win.Registry, System.SysUtils,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls;

const
  TO_ADVANCEDTYPOGRAPHY         = $0001;

  RTFBeispiel = '{\rtf1\ansi\ansicpg1252\deff0\deflang1031{\fonttbl{\f0\fnil\fcharset0 Comic Sans MS;}}\viewkind4\uc1\pard\f0\fs16 Beispiel RTF text\par}';
  GSHoisbuettel = 'Zeugnis Grundschule Hoisbüttel';
  RegGSHoisbuettel = 'Software\GSHoisbuettel\Zeugnis\';
  SchueleVersion = 3;

  MemoSGDef = 8;
//  ScrollWidth = 16;
  XAbstand = 40;
  YAbstand = 10;
  RightPunktenAbstand = 30;
  RightTortenAbstand = RightPunktenAbstand + 3;

  LF = #13+#10;
  E_OPEN_PRINTER = 'Fehler beim Öffnen des Druckers' + LF + '%s';

type
  TZeugnistModus = (fpLoad, fpNormal, fpEdit);

  function DeleteTrailingBlanks(const Str: String): String;
  function GetFileVersion(Datei: string): string;
  function s2b(const S: string): Boolean;
  function b2s(const Value: Boolean): string;
  function CheckLexicon(const Input: string): string;
  function GetUniqueComponentName(AOwner: TComponent; const CompName: string): string;
  function GetTempFile(const Extension: string): string;
  function IsRTF(sText: string): Boolean;
  function RTF2PlainText(sRTF: String): string;
  function HomeVerzeichnis(Form: TForm): string;
  function InstallExt(Extension, ExtDescription, FileDescription,
    OpenWith, ParamString: string; IconIndex: Integer): Boolean;
  procedure Restore_ViewerSketchListWidth;
  procedure Save_ViewerSketchListWidth;
  procedure Ini2Reg(Form: TForm);
  function IsConnectedToInternet: Boolean;

  function GetWinErrorMsgStr(dwErrorCode: DWord): string;
  function GetPrinterDevMode(strPrinter: string; var pDevmode: pDevMode): Boolean;
  function GetPrinterDevModeGlobal(strPrinter: string; var hGlbMem: hGlobal): Boolean;
  function OpenPrinter(const strPrinter: string; var hPrt: THandle): Boolean;

var
  ApplicationPath: string;
  INI_Einstellungen: TIniFile;
  REG_Einstellungen: TRegistryIniFile;

  GS_Hoisbuettel_FontLabel: TFont;
  GS_Hoisbuettel_FontEdit: TFont;

implementation

uses
  Dialogs, RichEdit, WinApi.WinSpool, Vcl.Printers;

function DeleteTrailingBlanks(const Str: String): String;
var
  ALen: Integer;
begin
  Result := Str;

  ALen := Length(Result);
  while (ALen > 0) and ((Result[ALen] = ' ') or (Result[ALen] = #0) or (Result[ALen] = #10) or (Result[ALen] = #13)) do
    Dec(ALen);
  if ALen <> Length(Result) then
    Delete(Result, ALen + 1, 255);
end;

function RTF2PlainText(sRTF: String): string;
var
 aRE: TRichEdit;
 aStream: TStringStream;
begin
   aRE := TRichEdit.Create(nil);
   //RTF Bug: Beim Laden des Texttes über
   //LoadFromStream werden die ersten Zeichen nach dem Tab verschluckt.
   // Deswegen hier dieser Wokarround
   sRTF := StringReplace(sRTF,'\tab','\tab ',[rfReplaceAll]);
   aStream := TStringStream.Create(sRTF);
   try
      aRE.Visible := False;
      aRE.ParentWindow := Application.Handle;
      if aRE.ParentWindow = 0 then
        aRE.ParentWindow := GetDesktopWindow;
      aRE.PlainText := False;
      aRE.Lines.LoadFromStream(aStream);
      aRE.PlainText := True;
      aStream.Position := soFromBeginning;
      aStream.Size := 0;
      aRE.Lines.SaveToStream(aStream);
      Result := aStream.DataString;
   finally
     aRE.Free;
     aStream.Free;
   end;
end;

function GetFileVersion(Datei: string): string;
var
  lpVerInfo: Pointer;
  rVerValue: PVSFixedFileInfo;
  dwInfoSize: Cardinal;
  dwValueSize: Cardinal;
  dwDummy: Cardinal;
  lpstrPath: PChar;
begin
  if Trim(Datei) = EmptyStr then
    lpstrPath := PChar(ParamStr(0))
  else
    lpstrPath := PChar(Datei);

  dwInfoSize := GetFileVersionInfoSize(lpstrPath, dwDummy);

  if dwInfoSize = 0 then
  begin
    Result := 'No version specification';
    Exit;
  end;

  GetMem(lpVerInfo, dwInfoSize);
  GetFileVersionInfo(lpstrPath, 0, dwInfoSize, lpVerInfo);
  VerQueryValue(lpVerInfo, '', pointer(rVerValue), dwValueSize);

  with rVerValue^ do
  begin
    Result := IntTostr(dwFileVersionMS shr 16);
    Result := Result + '.' + IntTostr(dwFileVersionMS and $FFFF);
    Result := Result + '.' + IntTostr(dwFileVersionLS shr 16);
    Result := Result + '.' + IntTostr(dwFileVersionLS and $FFFF);
  end;
  FreeMem(lpVerInfo, dwInfoSize);
end;

function s2b(const S: string): Boolean;
begin
  if Length(S) = 1 then
    Result := CharInSet(S[1], ['T', 't', 'J', 'j', '1'])
  else
    Result := False
end;

function b2s(const Value: Boolean): string;
begin
  if Value then
    Result := 'T'
  else
    Result := 'F';
end;

function CheckLexicon(const Input: string): string;
var
  FLexicon: TStringList;
  Idx: Integer;
begin
  Result := Input;
  FLexicon := TStringList.Create;
  try
    INI_Einstellungen.ReadSectionValues('LEXICON', FLexicon);
    for Idx := 0 to FLexicon.Count - 1 do
      Result := StringReplace(Input, Trim(FLexicon.Names[Idx]), Trim(FLexicon.ValueFromIndex[Idx]), [rfReplaceAll]);
  finally
    FLexicon.Free;
  end;
end;

function GetUniqueComponentName(AOwner: TComponent; const CompName: string): string;
var
  Idx: Word;
begin
  Result := CompName;   Idx := 0;
  while Assigned(AOwner.FindComponent(Result)) do
  begin
    Inc(Idx);
    Result := CompName + IntToStr(Idx);
  end;
end;

function GetTempFile(const Extension: string): string;
var
  Buffer: array[0..MAX_PATH] of Char;
begin
  repeat
    GetTempPath(SizeOf(Buffer) - 1, Buffer);
    GetTempFileName(Buffer, '~', 0, Buffer);
    Result := ChangeFileExt(Buffer, Extension);
  until not FileExists(Result);
end;

function IsRTF(sText: string): Boolean;
begin
  sText := Trim(sText);
  Result := Copy(sText, 1, 5) = '{\rtf';
end;

function HomeVerzeichnis(Form: TForm): string;
var
 PI : PItemIDList;
 A  : array[0..200] of Char;
begin
  SHGetSpecialFolderLocation(Form.Handle, CSIDL_PERSONAL, PI);
  SHGetPathFromIDList(PI, A);
  Result := A;
end;

function InstallExt(Extension, ExtDescription, FileDescription,
  OpenWith, ParamString: string; IconIndex: Integer): Boolean;
var
  Reg: TRegistry;
begin
  //  InstallExt('.schueler', 'ZeugnisFile', 'Zeugnis File', ParamStr(0), '%1', 1);
  Result := False;
  if Extension <> '' then
  begin
    if Extension[1] <> '.' then
      Extension := '.' + Extension;

    Reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_CLASSES_ROOT;
      Reg.Access := KEY_ALL_ACCESS;
      if Reg.OpenKey(Extension, True) then
      begin
        Reg.WriteString('', ExtDescription);
        if Reg.OpenKey('\' + ExtDescription, True) then
        begin
          Reg.WriteString('', FileDescription);
          if Reg.OpenKey('DefaultIcon', True) then
          begin
            Reg.WriteString('', Format('%s,%d', [OpenWith, IconIndex]));
            if Reg.OpenKey('\' + ExtDescription + '\shell\open\command', True) then
             begin
               Reg.WriteString('', Format('"%s" "%s"', [OpenWith, ParamString]));
               Result := True;
             end;
          end;
        end;
      end;
      SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil);
    finally
      Reg.Free;
    end;
  end;
end;

function IsConnectedToInternet: Boolean;
var
  dwConnectionTypes : DWORD;
begin
  dwConnectionTypes := INTERNET_CONNECTION_MODEM + INTERNET_CONNECTION_LAN + INTERNET_CONNECTION_PROXY;
  Result := InternetGetConnectedState(@dwConnectionTypes, 0);
end;

procedure Restore_ViewerSketchListWidth;
var
  RegWrite: TRegistry;
  RegRead: TRegistry;
begin
  RegWrite := TRegistry.Create(KEY_WRITE);
  RegRead := TRegistry.Create(KEY_READ);
  try
    RegWrite.RootKey := HKEY_CURRENT_USER;
    RegRead.RootKey := HKEY_CURRENT_USER;
    if RegRead.OpenKey(RegGSHoisbuettel + 'ListLabel', False) then
      if RegWrite.OpenKey('Software\combit\cmbtls\ZEUGNIS', False) then
        RegWrite.WriteInteger('LSConfig.ViewerSketchListWidth', RegRead.ReadInteger('PreviewSketchListWidth'));
  finally
    RegWrite.Free;
    RegRead.Free;
  end;
end;

procedure Save_ViewerSketchListWidth;
var
  RegWrite: TRegistry;
  RegRead: TRegistry;
begin
  RegRead := TRegistry.Create(KEY_READ);
  RegWrite := TRegistry.Create(KEY_WRITE);
  try
    RegRead.RootKey := HKEY_CURRENT_USER;
    if RegRead.OpenKey('Software\combit\cmbtls\ZEUGNIS', False) then
      if RegWrite.OpenKey(RegGSHoisbuettel + 'ListLabel', True) then
        RegWrite.WriteInteger('PreviewSketchListWidth', RegRead.ReadInteger('LSConfig.ViewerSketchListWidth'));
  finally
    RegRead.Free;
    RegWrite.Free;
  end;
end;

procedure Ini2Reg(Form: TForm);
begin
  if INI_Einstellungen.SectionExists('FORM') then
  begin
    REG_Einstellungen.WriteInteger('FORM', 'WindowState', INI_Einstellungen.ReadInteger('FORM', 'WindowState', 0));
    REG_Einstellungen.WriteInteger('FORM', 'Top', INI_Einstellungen.ReadInteger('FORM', 'Top', 50));
    REG_Einstellungen.WriteInteger('FORM', 'Left', INI_Einstellungen.ReadInteger('FORM', 'Left', 50));
    REG_Einstellungen.WriteInteger('FORM', 'Width', INI_Einstellungen.ReadInteger('FORM', 'Width', 930));
    REG_Einstellungen.WriteInteger('FORM', 'Height', INI_Einstellungen.ReadInteger('FORM', 'Height', 650));

    REG_Einstellungen.WriteInteger('FORM.LEXICON', 'Top', INI_Einstellungen.ReadInteger('FORM', 'Lexicon.Top', 50));
    REG_Einstellungen.WriteInteger('FORM.LEXICON', 'Left', INI_Einstellungen.ReadInteger('FORM', 'Lexicon.Left', 50));
    REG_Einstellungen.WriteInteger('FORM.LEXICON', 'Width', INI_Einstellungen.ReadInteger('FORM', 'Lexicon.Width', 400));
    REG_Einstellungen.WriteInteger('FORM.LEXICON', 'Height', INI_Einstellungen.ReadInteger('FORM', 'Lexicon.Height', 350));

    INI_Einstellungen.EraseSection('FORM');
  end;
  if INI_Einstellungen.SectionExists('EINGABE') then
  begin
    REG_Einstellungen.WriteBool('EINGABE', 'QuickVorschau', INI_Einstellungen.ReadBool('EINGABE', 'QuickVorschau', False));
    REG_Einstellungen.WriteInteger('EINGABE', 'PnlQuickVorschauWidth', INI_Einstellungen.ReadInteger('EINGABE', 'PnlQuickVorschauWidth', 185));

    INI_Einstellungen.EraseSection('EINGABE');
  end;
  if INI_Einstellungen.SectionExists('OPEN') then
  begin
    REG_Einstellungen.WriteString('OPEN', 'Lastpath', INI_Einstellungen.ReadString('OPEN', 'Lastpath', HomeVerzeichnis(Form)));

    INI_Einstellungen.EraseSection('OPEN');
  end;
  if INI_Einstellungen.SectionExists('SAVE') then
  begin
    REG_Einstellungen.WriteString('SAVE', 'Lastpath', INI_Einstellungen.ReadString('SAVE', 'Lastpath', HomeVerzeichnis(Form)));

    INI_Einstellungen.EraseSection('SAVE');
  end;
  if INI_Einstellungen.SectionExists('PRINTER') then
  begin
    REG_Einstellungen.WriteString('PRINTER', 'Name', INI_Einstellungen.ReadString('PRINTER', 'Name', HomeVerzeichnis(Form)));

    INI_Einstellungen.EraseSection('PRINTER');
  end;
  if INI_Einstellungen.SectionExists('ListLabel') then
  begin
    REG_Einstellungen.WriteInteger('ListLabel', 'PreviewSketchListWidth', INI_Einstellungen.ReadInteger('ListLabel', 'PreviewSketchListWidth', 250));

    INI_Einstellungen.EraseSection('ListLabel');
  end;
  if INI_Einstellungen.SectionExists('UPDATE') then
    INI_Einstellungen.EraseSection('UPDATE');
  if INI_Einstellungen.SectionExists('VERSIONEN') then
    INI_Einstellungen.EraseSection('VERSIONEN');
//  if INI_Einstellungen.SectionExists('LEXICON') then
//  begin
//    FLexicon := TStringList.Create;
//    try
//      INI_Einstellungen.ReadSectionValues('LEXICON', FLexicon);
//      for Idx := FLexicon.Count - 1 downto 0 do
//        INI_Einstellungen.DeleteKey('LEXICON', FLexicon.Names[idx]);
//    finally
//      FLexicon.Free;
//    end;
//  end;
end;

function GetWinErrorMsgStr(dwErrorCode: DWORD): string;
var
  pErrorMsgBuffer: Pointer;
  strError       : string ;
begin
   FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_FROM_SYSTEM,
                 NIL, dwErrorCode, GetSystemDefaultLangID, @pErrorMsgBuffer, 0, NIL );
   try
      strError := StrPas(pChar(pErrorMsgBuffer));
      strError := '(Code: '+IntToStr(dwErrorCode) +' )'+ strError;
   finally
      LocalFree(LongInt(pErrorMsgBuffer));
   end;
end;

function GetPrinterDevMode(strPrinter: string; var pDevmode: pDevMode): Boolean;
var
  hPrt        : THandle;
  lnDocPropRes: LongInt;
  lnSizeNeeded: LongInt;
begin
   hPrt        := 0    ;
   Result      := FALSE;
   pDevMode    := NIL  ;
   if(Not OpenPrinter(strPrinter, hPrt) ) then
   begin
      MessageDlg(Format(E_OPEN_PRINTER, [GetWinErrorMsgStr(GetLastError)]), mtError, [mbOk] ,0);
      Exit;
   end;

   try
      lnSizeNeeded := DocumentProperties(0, hPrt, NIL,  pDevmode^, pDevmode^, 0);
      pDevMode := GlobalAllocPtr(HeapAllocFlags or GMEM_ZEROINIT, lnSizeNeeded);
      lnDocPropRes:= DocumentProperties(0, hPrt, NIL,  pDevmode^, pDevmode^, DM_OUT_BUFFER);
      Result := (lnDocPropRes = IDOK);
      if(Not Result) then
      begin
         GlobalFreePtr(pDevmode);
         pDevMode := NIL
      end;
   finally
      ClosePrinter(hPrt);
   end;
end;

function GetPrinterDevModeGlobal(strPrinter: string; var hGlbMem: hGlobal): Boolean;
var
  hPrt        : THandle ;
  lnDocPropRes: LongInt ;
  lnSizeNeeded: LongInt ;
  aDevMode    : pDevMode;
begin
   hPrt         := 0       ;
   Result       := FALSE   ;
   hGlbMem      := 0       ;
   aDevMode     := NIL     ;

   if(Not OpenPrinter(strPrinter, hPrt) ) then
   begin
      MessageDlg(Format(E_OPEN_PRINTER, [GetWinErrorMsgStr(GetLastError)]), mtError, [mbOk] ,0);
      Exit;
   end;

   try
      lnSizeNeeded:=DocumentProperties(0, hPrt, NIL,  aDevmode^, aDevmode^, 0);
      hGlbMem := GlobalAlloc(GPTR, lnSizeNeeded);
      try
         aDevMode := GlobalLock(hGlbMem);
         try

            lnDocPropRes:= DocumentProperties(0, hPrt, NIL,  aDevmode^, aDevmode^, DM_OUT_BUFFER);
            Result := (lnDocPropRes = IDOK);

         finally
            GlobalUnLock(hGlbMem);
         end;

      finally
         if(Not Result) then begin
            GlobalFree(hGlbMem);
            hGlbMem := 0;
         end;
      end;

   finally
      ClosePrinter(hPrt);
   end;
end;

function OpenPrinter(const strPrinter: string; var hPrt: THandle): Boolean;
var
  aPrtDef: TPrinterDefaults;
begin
   ZeroMemory(@aPrtDef, SizeOf(TPrinterDefaults));
   aPrtDef.DesiredAccess := PRINTER_ACCESS_USE;
   // Drucker öffnen

   Result := WinApi.WinSpool.OpenPrinter(pChar(strPrinter), hPrt, @aPrtDef);
   Result := ( (Result) AND (hPrt <> 0) );
end;

initialization
  ApplicationPath := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName));
  INI_Einstellungen := TIniFile.Create(ApplicationPath + 'zeugnis.ini');
  REG_Einstellungen := TRegistryIniFile.Create(RegGSHoisbuettel);

  GS_Hoisbuettel_FontLabel := TFont.Create;
  GS_Hoisbuettel_FontLabel.Size := 10;
  GS_Hoisbuettel_FontLabel.Name := 'Comic Sans MS';

  GS_Hoisbuettel_FontEdit := TFont.Create;
  GS_Hoisbuettel_FontEdit.Size := 9;
  GS_Hoisbuettel_FontEdit.Name := 'Comic Sans MS';

finalization
  REG_Einstellungen.Free;
  INI_Einstellungen.Free;

  GS_Hoisbuettel_FontLabel.Free;
  GS_Hoisbuettel_FontEdit.Free;

end.
