unit Schule;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShlObj, Winapi.WinInet, Vcl.Forms,
  System.IniFiles, System.Win.Registry, System.SysUtils, Vcl.ExtActns, Xml.XMLIntf,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.Variants, System.IOUtils;

const
  TO_ADVANCEDTYPOGRAPHY         = $0001;

  RTFBeispiel = '{\rtf1\ansi\ansicpg1252\deff0\deflang1031{\fonttbl{\f0\fnil\fcharset0 Comic Sans MS;}}\viewkind4\uc1\pard\f0\fs16 Beispiel RTF text\par}';
  GSHoisbuettel = 'Zeugnis Grundschule Hoisbüttel';
  RegGSHoisbuettel = 'Software\GSHoisbuettel\Zeugnis\';
  SchueleVersion = 7;

  MemoSGDef = 8;
//  ScrollWidth = 16;
  XAbstand = 40;
  YAbstand = 10;
  RightPunktenAbstand = 30;
  RightTortenAbstand = RightPunktenAbstand + 3;
  A3_Fach = 1.414;  // 297/210
  LF = #13+#10;
  E_OPEN_PRINTER = 'Fehler beim Öffnen des Druckers' + LF + '%s';

type
  TZeugnistModus = (fpLoad, fpNormal, fpEdit);

  function DeleteTrailingBlanks(const Str: String): String;
  function GetFileVersion(Datei: string): string;
  function CompareFileVersion(const FileVersion1, FileVersion2: String): Integer;
  function s2b(const S: string): Boolean;
  function b2s(const Value: Boolean): string;
  function CheckLexicon(const Input: string): string;
  function GetUniqueComponentName(AOwner: TComponent; const CompName: string): string;
  function GetTempFile(const Extension: string = ''): string;
  function IsRTF(sText: string): Boolean;
  function RTF2PlainText(sRTF: String): string;
  function RTFOhneEffekt(sRTF: String; sFachName: string = ''): string;
  function TrimRTF(sRTF: String): string;
  function SetRTFFontSize(sRTF: String; FontSis: Integer): string;
  function FindAtributeNode(Input: IXMLNode; const AttributesName, AttributesValue: WideString): IXMLNode;
  function HomeVerzeichnis(Form: TForm): string;
  function InstallExt(Extension, ExtDescription, FileDescription,
    OpenWith, ParamString: string; IconIndex: Integer): Boolean;
  procedure Restore_ViewerSketchListWidth;
  procedure Save_ViewerSketchListWidth;
  procedure Ini2Reg(Form: TForm);
  function IsConnectedToInternet: Boolean;
  procedure RichEditAlignBlocksatz(RichEdit: TCustomRichEdit);
  function GetEffektText(aRichEdit: TRichEdit; aPos, aMask: Cardinal): string; overload;
  function GetEffektText(aRichEdit: TRichEdit; aPos, aMask: Cardinal; var WStart, WLen: Cardinal): Boolean; overload;
  function NurZiffern(const asStrg: string ): string;

  function GetWinErrorMsgStr(dwErrorCode: DWord): string;
  function GetPrinterDevMode(strPrinter: string; var pDevmode: pDevMode): Boolean;
  function GetPrinterDevModeGlobal(PrinterName: string; var hGlbMem: hGlobal): Boolean;
  function OpenPrinter(const PrinterName: string; var hPrt: THandle): Boolean;
  procedure EnumerateSpoolJobs(PrinterName: String; JobList: TStrings);
  function GetPapierFormat: SmallInt;
  procedure SetPapierFormat(const Value: SmallInt);
  function GetDefaultPrinter: string;
  procedure SetDefaultPrinter1(NewDefPrinter: string);
  procedure SetDefaultPrinter2(PrinterName: string);
  procedure Delay(dwMilliseconds: Longint);

var
  ApplicationPath: string;
  INI_Einstellungen: TIniFile;
  REG_Einstellungen: TRegistryIniFile;

  GS_Hoisbuettel_FontLabel: TFont;
  GS_Hoisbuettel_FontEdit: TFont;

implementation

{$WARN SYMBOL_PLATFORM OFF}

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

function RTFOhneEffekt(sRTF: String; sFachName: string): string;
var
 aRE: TRichEdit;
 aStream: TStringStream;
 Idx: Integer;
 WStart, WLan: Cardinal;
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

      Idx := 1;
      while Idx < aRE.GetTextLen do
      begin
        if GetEffektText(aRE, Idx, CFM_STRIKEOUT, WStart, Wlan) then
        begin
          aRE.SelStart := WStart;
          aRE.SelLength := Wlan;
          aRE.SelText := '';
          Idx := WStart + 1;
        end else
          Inc(idx);
      end;

      aRE.SelectAll;
      aRE.SelAttributes.Color := clWindowText;
      aRE.SelAttributes.Style := [];
      if sFachName <> '' then
        aRE.Lines.Insert(0, sFachName);
      aStream.Position := soFromBeginning;
      aStream.Size := 0;
      aRE.Lines.SaveToStream(aStream);
      Result := aStream.DataString;
   finally
     aRE.Free;
     aStream.Free;
   end;
end;

function TrimRTF(sRTF: String): string;
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

    if aRE.GetTextLen > 0 then
    begin
      aRE.HideSelection := False;
      repeat
        aRE.SelStart := aRE.GetTextLen;
        aRE.SelLength := -1;
        if (aRE.GetTextLen > 0) and CharInSet(aRE.SelText[1], [' ', #$D]) then
        begin
          aRE.SelText := '';
          aRE.SelStart := aRE.GetTextLen;
          aRE.SelLength := -1;
        end;
      until (aRE.GetTextLen <= 0) or not CharInSet(aRE.SelText[1], [' ', #$D]);

      aStream.Position := soFromBeginning;
      aStream.Size := 0;
      aRE.Lines.SaveToStream(aStream);
      Result := aStream.DataString;
    end else
      Result := sRTF;
  finally
    aRE.Free;
    aStream.Free;
  end;
end;

function SetRTFFontSize(sRTF: String; FontSis: Integer): string;
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
      aRE.SelectAll;
      aRE.SelAttributes.Size := Round(FontSis * A3_Fach);
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
    Result := 'Keine Versionsangabe';
    Exit;
  end;

  GetMem(lpVerInfo, dwInfoSize);
  GetFileVersionInfo(lpstrPath, 0, dwInfoSize, lpVerInfo);
  VerQueryValue(lpVerInfo, '', pointer(rVerValue), dwValueSize);

  with rVerValue^ do
  begin
    Result := IntTostr(dwFileVersionMS shr 16);
    Result := Result + '.' + IntToStr(dwFileVersionMS and $FFFF);
    Result := Result + '.' + IntToStr(dwFileVersionLS shr 16);
    Result := Result + '.' + IntToStr(dwFileVersionLS and $FFFF);
  end;
  FreeMem(lpVerInfo, dwInfoSize);
end;

function CompareFileVersion(const FileVersion1, FileVersion2: String): Integer;
var
  Items1: TStrings;
  Items2: TStrings;
  i: Integer;
  e1: Integer;
  e2: Integer;
begin
//  Result := 0;
  Items1 := TStringList.Create;
  Items2 := TStringList.Create;
  try
    Items1.Delimiter := '.';
    Items1.DelimitedText := FileVersion1;
    Items2.Delimiter := '.';
    Items2.DelimitedText := FileVersion2;
    if Items1.Count <> Items2.Count then
      raise Exception.Create('Inkompatible Versionen: Anzahl der Punkte ist unterschiedlich!');
    Result := 0;
    for i := 0 to Items1.Count - 1 do
    begin
      e1 := StrToIntDef(Items1[i], -1);
      e2 := StrToIntDef(Items2[i], -1);
      if e2 > e1 then
        Result := 1
      else if e2 < e1 then
        Result := -1;
      if Result <> 0 then Exit;
    end;
  finally
    Items1.Free;
    Items2.Free;
  end;
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
begin
  Result := TPath.GetTempFileName;
  if Extension <> '' then
    ChangeFileExt(Result, Extension);
end;

function IsRTF(sText: string): Boolean;
begin
  sText := Trim(sText);
  Result := Copy(sText, 1, 5) = '{\rtf';
end;

function FindAtributeNode(Input: IXMLNode; const AttributesName, AttributesValue: WideString): IXMLNode;
var
  Idx: Integer;
begin
  Result := nil;
  if Assigned(Input) then
  begin
    if Input.HasChildNodes then
      for Idx := 0 to Input.ChildNodes.Count - 1 do
        if Input.ChildNodes[Idx].HasAttribute(AttributesName) then
           if AnsiSameText(VarToStr(Input.ChildNodes[Idx].Attributes[AttributesName]), AttributesValue) then
           begin
             Result := Input.ChildNodes[Idx];
             Break;
           end;
  end;
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
   if not OpenPrinter(strPrinter, hPrt) then
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

function GetPrinterDevModeGlobal(PrinterName: string; var hGlbMem: hGlobal): Boolean;
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

   if not OpenPrinter(PrinterName, hPrt) then
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

procedure RichEditAlignBlocksatz(RichEdit: TCustomRichEdit);
var
  Paragraph: TParaFormat2;
begin
  if RichEdit is TCustomRichEdit then
  begin
    ZeroMemory(@Paragraph, SizeOf(TParaFormat2));
    Paragraph.cbSize := SizeOf(TParaFormat2);
    Paragraph.dwMask := PFM_ALIGNMENT;
    Paragraph.wAlignment := PFA_JUSTIFY;
    SendMessage(TCustomRichEdit(RichEdit).Handle, EM_SETTYPOGRAPHYOPTIONS, TO_ADVANCEDTYPOGRAPHY, TO_ADVANCEDTYPOGRAPHY);
    SendMessage(TCustomRichEdit(RichEdit).Handle, EM_SETPARAFORMAT, 0, Integer(@Paragraph));
  end;
end;

function GetEffektText(aRichEdit: TRichEdit; aPos, aMask: Cardinal): string;
var
  Idx: Integer;
  CharFormat: TCharFormat2;
  SelStart: Integer;
begin
  Result := '';
  if Assigned(aRichEdit) then
  begin
    CharFormat.cbSize := SizeOf(TCharFormat);
    CharFormat.dwMask := aMask; // CFM_STRIKEOUT; CFM_UNDERLINE

    aRichEdit.SelStart := aPos;
    SendMessage(aRichEdit.Handle, EM_GETCHARFORMAT, SCF_SELECTION, LPARAM(@CharFormat));

    if not ((CharFormat.dwEffects and aMask) = 0) then
    begin
      {* Find Beginning of Effekt Text *}
      Idx := aPos;
      while (Idx > 0) do
      begin
        aRichEdit.SelStart := Idx;
        if aRichEdit.Text[Idx] = #10 then
          Break;
        SendMessage(aRichEdit.Handle, EM_GETCHARFORMAT, SCF_SELECTION, LPARAM(@CharFormat));
        if (CharFormat.dwEffects and aMask) = 0 then
          Break;
        Dec(Idx);
      end;

      {* Find Length of Effekt Text *}
      SelStart := Idx;
      Idx := 1;
      while SelStart + Idx <= aRichEdit.GetTextLen do
      begin
        aRichEdit.SelStart := SelStart + Idx;
        if aRichEdit.Text[SelStart + Idx] = #10 then
          Break;
        SendMessage(aRichEdit.Handle, EM_GETCHARFORMAT, SCF_SELECTION, LPARAM(@CharFormat));
        if (CharFormat.dwEffects and aMask) = 0 then
          Break;
        Inc( Idx );
      end;

      aRichEdit.SelStart := SelStart;
      aRichEdit.SelLength := Idx - 1;
      Result := Trim(aRichEdit.SelText);
    end;
  end;
end;

function GetEffektText(aRichEdit: TRichEdit; aPos, aMask: Cardinal; var WStart, WLen: Cardinal): Boolean;
var
  Idx: Integer;
  CharFormat: TCharFormat2;
  SelStart: Integer;
begin
  Result := False;
  if Assigned(aRichEdit) then
  begin
    CharFormat.cbSize := SizeOf(TCharFormat);
    CharFormat.dwMask := aMask; // CFM_STRIKEOUT; CFM_UNDERLINE

    aRichEdit.SelStart := aPos;
    SendMessage(aRichEdit.Handle, EM_GETCHARFORMAT, SCF_SELECTION, LPARAM(@CharFormat));

    if not ((CharFormat.dwEffects and aMask) = 0) then
    begin
      Result := True;
      {* Find Beginning of Effekt Text *}
      Idx := aPos;
      while (Idx > 0) do
      begin
        aRichEdit.SelStart := Idx;
        if aRichEdit.Text[Idx] = #10 then
          Break;
        SendMessage(aRichEdit.Handle, EM_GETCHARFORMAT, SCF_SELECTION, LPARAM(@CharFormat));
        if (CharFormat.dwEffects and aMask) = 0 then
          Break;
        Dec(Idx);
      end;

      {* Find Length of Effekt Text *}
      SelStart := Idx;
      Idx := 1;
      while SelStart + Idx <= aRichEdit.GetTextLen do
      begin
        aRichEdit.SelStart := SelStart + Idx;
        if aRichEdit.Text[SelStart + Idx] = #10 then
          Break;
        SendMessage(aRichEdit.Handle, EM_GETCHARFORMAT, SCF_SELECTION, LPARAM(@CharFormat));
        if (CharFormat.dwEffects and aMask) = 0 then
          Break;
        Inc(Idx);
      end;

      WStart := SelStart;
      WLen := Idx - 1;
    end
  end;
end;

function NurZiffern(const asStrg: string ): string;
var
  I : Integer;
  Z : Char;
begin
  Result := '';
  for I:= 1 to Length(asStrg) do begin
    Z := asStrg[I];
    if (Ord(Z) >=48 ) and (Ord(Z) <= 57) then
      Result := Result + z;
  end;
end;

function OpenPrinter(const PrinterName: string; var hPrt: THandle): Boolean;
var
  aPrtDef: TPrinterDefaults;
begin
   ZeroMemory(@aPrtDef, SizeOf(TPrinterDefaults));
   aPrtDef.DesiredAccess := PRINTER_ACCESS_USE;
   // Drucker öffnen

   Result := WinApi.WinSpool.OpenPrinter(pChar(PrinterName), hPrt, @aPrtDef);
   Result := ( (Result) AND (hPrt <> 0) );
end;

function GetDefaultPrinter: string;
var
  ResStr: array[0..255] of Char;
begin
  GetProfileString('Windows', 'device', '', ResStr, 255);
  Result := StrPas(ResStr);
end;

procedure SetDefaultPrinter1(NewDefPrinter: string);
var
  ResStr: array[0..255] of Char;
begin
  StrPCopy(ResStr, NewdefPrinter);
  WriteProfileString('windows', 'device', ResStr);
  StrCopy(ResStr, 'windows');
  SendMessage(HWND_BROADCAST, WM_WININICHANGE, 0, Longint(@ResStr));
end;

procedure SetDefaultPrinter2(PrinterName: string);
var
  I: Integer;
  Device: PChar;
  Driver: PChar;
  Port: PChar;
  HdeviceMode: THandle;
  aPrinter: TPrinter;
begin
  Printer.PrinterIndex := -1;
  GetMem(Device, 255);
  GetMem(Driver, 255);
  GetMem(Port, 255);
  aPrinter := TPrinter.Create;
  try
    for I := 0 to Printer.Printers.Count - 1 do
    begin
      if Printer.Printers.ValueFromIndex[I] = PrinterName then
      begin
        aprinter.PrinterIndex := i;
        aPrinter.getprinter(device, driver, port, HdeviceMode);
        StrCat(Device, ',');
        StrCat(Device, Driver);
        StrCat(Device, Port);
        WriteProfileString('windows', 'device', Device);
        StrCopy(Device, 'windows');
        SendMessage(HWND_BROADCAST, WM_WININICHANGE, 0, Longint(@Device));
      end;
    end;
  finally
    aPrinter.Free;
  end;
  FreeMem(Device, 255);
  FreeMem(Driver, 255);
  FreeMem(Port, 255);
end;

function GetPapierFormat: SmallInt;
var
  pDMode: PDevMode;
begin
//  Result := 0;

  GetPrinterDevMode(Printer.Printers.Strings[Printer.PrinterIndex], pDMode);
//      pDMode^.dmOrientation := DMORIENT_LANDSCAPE;
//      pDMode^.dmDuplex := dmd
  Result := pDMode^.dmPaperSize;
end;

procedure SetPapierFormat(const Value: SmallInt);
var
  Device: array[0..cchDeviceName-1] of Char;
  Driver: array[0..(MAX_PATH-1)] of Char;
  Port: array[0..32] of Char;
  hDMode: THandle;
  pDMode: PDevMode;
//  sDev: array[0..32] of Char;
begin
  Printer.GetPrinter(Device, Driver, Port, hDMode);
  if hDMode <> 0 then
  begin
    pDMode := GlobalLock(hDMode);
    if pDMode <> nil then
    begin
//      pDMode^.dmOrientation := DMORIENT_LANDSCAPE;
////      // landscape
      pDMode^.dmPaperSize := Value;
////      // (см. win32.hlp DEVMODE)

      GlobalUnlock(hDMode);
    end;
  end;
end;

procedure EnumerateSpoolJobs(PrinterName: String; JobList: TStrings);
var
   aJobs : Array[0..99] of JOB_INFO_1;
   cbBuf : DWORD;
   pcbNeeded : DWORD;
   pcReturned : DWORD;
   hPrinter : THandle;
   i : Integer;
begin
   if not Assigned(JobList) then
     Exit;

   if not OpenPrinter(PrinterName, hPrinter) then
   begin
      MessageDlg(Format(E_OPEN_PRINTER, [GetWinErrorMsgStr(GetLastError)]), mtError, [mbOk] ,0);
      Exit;
   end;

   JobList.Clear;

   try
     cBBuf := 1000;
     Winapi.WinSpool.EnumJobs(hPrinter, 0, 1000, 1, @aJobs, cbBuf, pcbNeeded, pcReturned);
     if pcReturned <= 0 then
       pcReturned := 1;
     for i := 0 to pcReturned - 1 do
     begin
        JobList.AddObject(Format('%d - %s %s %s %d' ,
            [aJobs[i].JobId,
             StrPas(aJobs[i].pDocument),
             StrPas(aJobs[i].pStatus),
             StrPas(aJobs[i].pUserName),
             aJobs[i].TotalPages]), @aJobs[i]);
     end;
   finally
     Winapi.WinSpool.ClosePrinter(hPrinter);
   end;
end;

procedure Delay(dwMilliseconds: Longint);
var
  iStart, iStop: Cardinal;
begin
  iStart := GetTickCount;
  repeat
    iStop := GetTickCount;
    Application.ProcessMessages;
    Sleep(1); // addition from Christian Scheffler to avoid high CPU last
  until (iStop - iStart) >= dwMilliseconds;
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
