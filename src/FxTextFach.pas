unit FxTextFach;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, System.Types, Vcl.ExtActns,
  Vcl.ExtCtrls, Xml.xmldom, Xml.XMLIntf, Vcl.Menus, Xml.Win.msxmldom, Xml.XMLDoc,
  Schule, frxDPIAwareBaseControls, frxDesgnCtrls;

type
  TfrmTextFach = class;

  TRichEditAlign = (reaLeft, reaCenter, reaRight, reaBlock);
  TPunktFachChangeEvent = procedure(Sender: TfrmTextFach; FachPunkt, Wert: Word) of object;

  TBMenuItem = class(TMenuItem)
  private
    { Private-Deklarationen }
    Text: string;
    Wert: Word;
  public
    { Public-Deklarationen }
  end;

  TTextFachMapItem = class(TPersistent)
  private
     TorteNr: Word;
     WStart: Cardinal;
     WLen: Cardinal;
  end;

  TTextFachMappe = class(TStringList)
  private
    function GetTextFachMapItemFromPos(const Pos: Cardinal): TTextFachMapItem;
    function GetTextFachMapItemFromTorteNr(const TorteNr: Word): TTextFachMapItem;
  public
    procedure Clear; override;
    destructor Destroy; override;
  end;

  TfrmTextFach = class(TForm)
    pnlTextFach: TPanel;
    reTextFach: TRichEdit;
    PHTortenMenu: TPopupMenu;
    pnlTextLabel: TPanel;
    lblSchriftgrad: TLabel;
    cmbSchriftgrad: TComboBox;
    pnlDebug: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Shape1: TShape;
    procedure FormCreate(Sender: TObject);
    procedure cmbSchriftgradChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure reTextFachMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure reTextFachChange(Sender: TObject);
    procedure PHTortenMenuPopup(Sender: TObject);
    procedure reTextFachDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private-Deklarationen }
    FFachID: string;
    OldWstart: Cardinal;
    OldWLen: Word;
    FPlatzHalter: IXMLNode;
    FTextFachNode: IXMLNode;
    FTextFachGGLNode: IXMLNode;
    FModus: TZeugnistModus;
    FOnTextFachChange: TNotifyEvent;
    FOnPunktFachChange: TPunktFachChangeEvent;
    cPosMerk: LongInt;
    FTextFachMap: TTextFachMappe;
    function GetSchriftgrad: Byte;
    procedure SetSchriftgrad(const Value: Byte);
    procedure BuildPopupMenu(PHNr: IXMLNode; Nr: Word);
//    function FindMarkWord2(const Pos: Integer; var Number: Word; var MarkWordSart, MarkWordLen: Cardinal): Boolean;
//    function FindMarkWord3(const Pos: Integer; var Number: Word): Boolean;
//    function FindMarkWord4(const Pos: Cardinal; var Number: Word; var MarkWordStart, MarkWordLen: Cardinal): Boolean;
    procedure mitMenuItemClick(Sender: TObject);
    function FindTortenValue(TortenNr: Word): IXMLNode;
//    procedure MarkierenPlatzHalter(PHNode: IXMLNode);
    procedure MakeTextFachMap;
//    procedure SetRichEditAlign(const Value: TRichEditAlign);
    function GetTextFachGGLNode: IXMLNode;
    procedure SetTextFachGGLNode(const Value: IXMLNode);
    function GetPunktGGLFach(const PunktNr: Word): IXMLNode;
    procedure PHTortenMenuClear;
  public
    { Public-Deklarationen }
    procedure SaveTextFachNode;
    procedure ReplaceFachText(TorteNr, Wert: Word);
    property FachID: string read FFachID write FFachID;
    property Modus: TZeugnistModus read FModus write FModus;
    property TextFachGGLNode: IXMLNode read GetTextFachGGLNode write SetTextFachGGLNode;
    property OnTextFachChange: TNotifyEvent read FOnTextFachChange write FOnTextFachChange;
    property OnPunktFachChange: TPunktFachChangeEvent read FOnPunktFachChange write FOnPunktFachChange;
//    property RichEditAlign: TRichEditAlign write SetRichEditAlign;
    procedure InitFromXML(aXMLNode: IXMLNode);
  end;

var
  frmTextFach: TfrmTextFach;

implementation

uses
  WinApi.RichEdit, System.Math;

{$R *.dfm}

procedure TfrmTextFach.BuildPopupMenu(PHNr: IXMLNode; Nr: Word);
var
  Idx: Integer;
  MenuItem: TBMenuItem;
begin
  PHTortenMenuClear;

  if Assigned(PHNr) and (Nr > 0) then
  begin
    PHTortenMenu.Tag := Nr;
    if PHNr.HasChildNodes then
    begin
      for Idx := 0 to PHNr.ChildNodes.Count - 1 do
      begin
        MenuItem := TBMenuItem.Create(PHTortenMenu);
        MenuItem.Caption := VarToStr(PHNr.ChildNodes.Get(Idx).NodeValue);
        MenuItem.Text := VarToStr(PHNr.ChildNodes.Get(Idx).NodeValue);
        MenuItem.Name := 'mitValue' + FormatFloat('00', Idx + 1);
        MenuItem.Wert := StrToInt(StringReplace(PHNr.ChildNodes.Get(Idx).NodeName, 'VALUE', '', [rfReplaceAll, rfIgnoreCase]));
        MenuItem.OnClick := mitMenuItemClick;
        PHTortenMenu.Items.Add(MenuItem);
      end;
    end else
      Assert(Assigned(PHNr.ChildNodes), 'PHNr.ChildNodes ist leer!');
  end;
end;

procedure TfrmTextFach.cmbSchriftgradChange(Sender: TObject);
var
  PosCursor: Integer;
  Idx: Integer;
  WStart, Wlan: Cardinal;
begin
  reTextFach.Lines.BeginUpdate;
  try
    PosCursor := reTextFach.SelStart;
    reTextFach.SelectAll;
    reTextFach.SelAttributes.Size := StrToInt(cmbSchriftgrad.Items.Strings[cmbSchriftgrad.ItemIndex]);

    Idx := 1;
    while Idx < Length(reTextFach.Text) do
    begin
      if GetEffektText(reTextFach, Idx, CFM_STRIKEOUT, WStart, Wlan) then
      begin
        reTextFach.Perform(EM_HIDESELECTION, 1, 0); // disable Showing of selection
        reTextFach.SelStart := WStart;
        reTextFach.SelLength := Wlan;
        reTextFach.SelAttributes.Size := 1;
        Idx := WStart + Wlan + 1;
      end else
        Inc(idx);
    end;

    reTextFach.SelStart := PosCursor;
  finally
    reTextFach.Lines.EndUpdate;
  end;

  if Assigned(FOnTextFachChange) then
    OnTextFachChange(Self);
end;

//function TfrmTextFach.FindMarkWord2(const Pos: Integer; var Number: Word;
//  var MarkWordSart, MarkWordLen: Cardinal): Boolean;
//var
//  WStart, CurrSelStart: Integer;
//  WLen, CurrSelLen: Integer;
//  CurrPos, CurrLen: Integer;
//begin
//  Result := False;
//  WStart := 0;  WLen := 0;
//  MarkWordSart := 0; MarkWordLen := 0;
//  Number := 0;  CurrPos := soFromBeginning;
//
//  CurrSelStart := reTextFach.SelStart;
//  CurrSelLen := reTextFach.SelLength;
//
//  while CurrPos < reTextFach.GetTextLen do
//  begin
//    CurrLen := 1;
//
//    WStart := CurrPos;
//    WLen := CurrLen;
//    SendMessage(reTextFach.Handle, EM_SETSEL, WPARAM(WStart), LPARAM(WStart + WLen));
////    reTextFach.SelStart := WStart;
////    reTextFach.SelLength := WLen;
//    if WLen > 1 then
//      if CharInSet(reTextFach.SelText[WLen], ['.']) then
//        SendMessage(reTextFach.Handle, EM_SETSEL, WPARAM(WStart), LPARAM(WStart + WLen - 1));
////        reTextFach.SelLength := WLen - 1;
//
//    if not ((reTextFach.SelAttributes.Color = clRed) and (reTextFach.SelAttributes.Style = [fsUnderline])) then
//      Inc(CurrPos)
//    else
//    begin
//      repeat
//        WLen := CurrLen;
//        Inc(CurrLen);
//        SendMessage(reTextFach.Handle, EM_SETSEL, WPARAM(WStart), LPARAM(WStart + CurrLen));
////        reTextFach.SelLength := CurrLen;
//      until not ((reTextFach.SelAttributes.Color = clRed) and (reTextFach.SelAttributes.Style = [fsUnderline]));
//    end;
//
//    SendMessage(reTextFach.Handle, EM_SETSEL, WPARAM(WStart), LPARAM(WStart + WLen));
////    reTextFach.SelLength := WLen;
//    if (reTextFach.SelAttributes.Color = clRed) and (reTextFach.SelAttributes.Style = [fsUnderline]) then
//    begin
//      Inc(Number);
//      Label5.Caption := 'Wort Nr.: ' + IntToStr(Number);
//      if (Pos >= WStart) and (Pos <= WStart + WLen) then
//      begin
//        Result := True;
//        Break;
//      end;
//      CurrPos := WStart + WLen + 1;
//    end;
//  end;
//
//  if not Result then
//  begin
//    reTextFach.SelStart := CurrSelStart;
//    reTextFach.SelLength := CurrSelLen;
//  end else
//  begin
//    MarkWordSart := WStart;
//    MarkWordLen := WLen;
//  end;
//end;

//function TfrmTextFach.FindMarkWord3(const Pos: Integer;
//  var Number: Word): Boolean;
//var
//  WStart, WLen: Cardinal;
//begin
//  Result := False;
//  Number := 0;
//  if GetEffektText(reTextFach, Pos, CFM_UNDERLINE, WStart, WLen) then
//  begin
//    Result := True;
//    reTextFach.Perform(EM_HIDESELECTION, 1, 0); // disable Showing of selection
//    Number := StrToIntDef(GetEffektText(reTextFach, WStart + WLen + 1, CFM_STRIKEOUT), 0);
//    Label5.Caption := 'Wort Nr.: ' + IntToStr(Number);
//  end;
//end;

//function TfrmTextFach.FindMarkWord4(const Pos: Cardinal; var Number: Word;
//  var MarkWordStart, MarkWordLen: Cardinal): Boolean;
//var
//  WStart, WLen: Cardinal;
//  CurrPos: Integer;
//begin
//  if cmbSchriftgrad.CanFocus then
//    cmbSchriftgrad.SetFocus;
//
//  Result := False;
//  CurrPos := soFromBeginning;
//  WStart := 0;  WLen := 0;
//  MarkWordStart := 0; MarkWordLen := 0;
//  Number := 0;
//
//  while CurrPos < reTextFach.GetTextLen do
//  begin
//    if GetEffektText(reTextFach, CurrPos, CFM_UNDERLINE, WStart, WLen) then
//    begin
//      Inc(Number);
//      if (Pos >= WStart) and (Pos <= WStart + WLen) then
//      begin
//        Result := True;
//        MarkWordStart := WStart;
//        MarkWordLen := WLen - 1;
//        if reTextFach.CanFocus then
//          reTextFach.SetFocus;
//        Break;
//      end;
//      CurrPos := WStart + WLen + 1;
//    end else
//      Inc(CurrPos);
//  end;
//
//  if reTextFach.CanFocus then
//    reTextFach.SetFocus;
//
//  if not Result then
//    Number := 0;
//  Label5.Caption := 'Wort Nr.: ' + IntToStr(Number);
//  Label6.Caption := 'Mark.Wort Start: ' + IntToStr(MarkWordStart);
//  Label7.Caption := 'Mark.Wort Len: ' + IntToStr(MarkWordLen);
//end;

function TfrmTextFach.FindTortenValue(TortenNr: Word): IXMLNode;
var
  Idx: Integer;
  PHName: string;
begin
  Result := nil;
  if Assigned(FPlatzHalter) and FPlatzHalter.HasChildNodes then
  begin
    for Idx := 0 to FPlatzHalter.ChildNodes.Count - 1 do
    begin
      PHName := VarToStr(FPlatzHalter.ChildNodes.Get(Idx).Attributes['NAME']);
      if AnsiSameText('TORTE' + FormatFloat('00', TortenNr), PHName) then
      begin
        Result := FPlatzHalter.ChildNodes.Get(Idx);
        Break;
      end;
    end;
  end;
end;

procedure TfrmTextFach.FormCreate(Sender: TObject);
begin
  Parent := Owner as TWinControl;
  BorderStyle := bsNone;
  ParentBackground := False;

  FTextFachMap := TTextFachMappe.Create;
  reTextFach.Font.Assign(GS_Hoisbuettel_FontEdit);

{$IFDEF DEBUG}
  pnlDebug.Visible := True;
{$ELSE}
  pnlDebug.Visible := False;
{$ENDIF}

  cmbSchriftgrad.Items.Clear;
  cmbSchriftgrad.Items.Add('8');
  cmbSchriftgrad.Items.Add('9');
  cmbSchriftgrad.Items.Add('10');
  cmbSchriftgrad.Items.Add('11');
  cmbSchriftgrad.Items.Add('12');
  cmbSchriftgrad.Items.Add('14');
  cmbSchriftgrad.Items.Add('16');
  cmbSchriftgrad.Items.Add('18');

  cmbSchriftgrad.ItemIndex := 0;

//  SendMessage(reTextFach.Handle, EM_SETTEXTMODE, TM_MULTILEVELUNDO, 0);
//  SendMessage(reTextFach.Handle, EM_SETUNDOLIMIT, 15, 0);

  FModus := fpNormal;
end;

procedure TfrmTextFach.FormDestroy(Sender: TObject);
begin
  FTextFachMap.Free;
end;

procedure TfrmTextFach.FormResize(Sender: TObject);
begin
  reTextFach.Invalidate;
end;

procedure TfrmTextFach.FormShow(Sender: TObject);
begin
  Top := 100;
  Align := alClient;
end;

procedure TfrmTextFach.SaveTextFachNode;
var
  WorkStream: TStringStream;
begin
  if Assigned(FTextFachNode) then
  begin
    WorkStream := TStringStream.Create;
    reTextFach.Lines.BeginUpdate;
    try
      reTextFach.SelStart := soFromBeginning;
      reTextFach.Lines.SaveToStream(WorkStream);
      FTextFachNode.ChildValues['RTFText'] := WorkStream.DataString;
    finally
      reTextFach.SelStart := OldWstart;
      reTextFach.SelLength := OldWLen;
      reTextFach.Lines.EndUpdate;
      WorkStream.Free;
    end;
    FTextFachNode.ChildNodes.Nodes['RTFText'].Attributes['Schriftgrad'] := GetSchriftgrad;
    FTextFachNode.ChildValues['Schriftgrad'] := GetSchriftgrad;
  end;
end;

function TfrmTextFach.GetTextFachGGLNode: IXMLNode;
begin
  Result := nil;
  if Assigned(FTextFachGGLNode) then
    Result := FTextFachGGLNode;
end;

function TfrmTextFach.GetPunktGGLFach(const PunktNr: Word): IXMLNode;
var
  Idx: Integer;
begin
  Result := nil;
  if Assigned(FTextFachGGLNode) then
  begin
    for Idx := 0 to FTextFachGGLNode.ChildNodes.Count - 1 do
    begin
      if AnsiSameText(FTextFachGGLNode.ChildNodes[Idx].NodeName, 'PUNKT') then
      begin
        if StrToInt(VarToStr(FTextFachGGLNode.ChildNodes[Idx].ChildNodes.FindNode('SortNr').NodeValue)) = PunktNr then
        begin
          Result := FTextFachGGLNode.ChildNodes[Idx];
          Break;
        end;
      end;
    end;
  end;
end;

procedure TfrmTextFach.PHTortenMenuClear;
var
  Idx: Integer;
begin
  for Idx := PHTortenMenu.Items.Count - 1 downto 0 do
    PHTortenMenu.Items.Items[Idx].Free;
  PHTortenMenu.Tag := 0;
end;

function TfrmTextFach.GetSchriftgrad: Byte;
begin
  Result := StrToIntDef(cmbSchriftgrad.Items.Strings[cmbSchriftgrad.ItemIndex], MemoSGDef);
end;

procedure TfrmTextFach.InitFromXML(aXMLNode: IXMLNode);
var
  RTFTextNode: IXMLNode;
  WorkStream: TStringStream;
begin
  FTextFachNode := aXMLNode;

  if Assigned(FTextFachNode) and FTextFachNode.HasChildNodes then
  begin
    reTextFach.Lines.BeginUpdate;
    reTextFach.Lines.Clear;
    RTFTextNode := FTextFachNode.ChildNodes.FindNode('RTFText');
    if Assigned(RTFTextNode) then
    begin
      WorkStream := TStringStream.Create;
      WorkStream.WriteString(RTFTextNode.NodeValue);
      WorkStream.Position := soFromBeginning;
      reTextFach.Lines.LoadFromStream(WorkStream);
      WorkStream.Free;

      if RTFTextNode.HasAttribute('Schriftgrad') then
        SetSchriftgrad(StrToIntDef(VarToStr(RTFTextNode.Attributes['Schriftgrad']), MemoSGDef));
    end;
    reTextFach.Lines.EndUpdate;

    FPlatzHalter := FTextFachNode.ChildNodes.FindNode('PLATZHALTER');
//    if Assigned(FPlatzHalter) then
//      MarkierenPlatzHalter(FPlatzHalter);
    MakeTextFachMap;
  end;
end;

procedure TfrmTextFach.MakeTextFachMap;
var
  Pos: Integer;
  TorteNr: Integer;
  WStart, WLen: Cardinal;
  TextFachMapItem: TTextFachMapItem;
  WinControl: TWinControl;
begin
  FTextFachMap.Clear;
  Pos := soFromBeginning;

  WinControl := ActiveControl;
  if cmbSchriftgrad.CanFocus then
    cmbSchriftgrad.SetFocus;
  try
    while Pos <= reTextFach.GetTextLen do
    begin
      if GetEffektText(reTextFach, Pos, CFM_UNDERLINE, WStart, WLen) then
      begin
        TorteNr := StrToIntDef(GetEffektText(reTextFach, WStart + WLen + 1, CFM_STRIKEOUT), 0);
        if TorteNr > 0 then
        begin
          TextFachMapItem := TTextFachMapItem.Create;
          TextFachMapItem.TorteNr := TorteNr;
          TextFachMapItem.WStart  := WStart;
          TextFachMapItem.WLen    := WLen;
          FTextFachMap.AddObject(IntToStr(TorteNr), TextFachMapItem);
        end;
        Pos := WStart + WLen + 2;
      end else
        Inc(Pos);
    end;
  finally
    if Assigned(WinControl) then
      if WinControl.CanFocus then
        WinControl.SetFocus;
  end;
end;

//procedure TfrmTextFach.MarkierenPlatzHalter(PHNode: IXMLNode);
//var
//  Pos: Integer;
//  Idx: Integer;
//  PHName: string;
//begin
//  Pos := soFromBeginning;
//  reTextFach.SelAttributes.Color := clBlack;
//  reTextFach.SelAttributes.Style := [];
//
//  reTextFach.Lines.BeginUpdate;
//  try
//    for Idx := 0 to PHNode.ChildNodes.Count - 1 do
//    begin
//      PHName := VarToStr(PHNode.ChildNodes.Get(Idx).Attributes['NAME']);
//      Pos := reTextFach.FindText(PHName, Pos, reTextFach.GetTextLen, [stWholeWord]);
//      if Pos >= 0 then
//      begin
//        reTextFach.SelStart := Pos;
//        reTextFach.SelLength := Length(PHName);
//
//        reTextFach.SelAttributes.Color := clRed;
//        reTextFach.SelAttributes.Style := [fsUnderline];
//      end;
//    end;
//  finally
//    reTextFach.Lines.EndUpdate;
//  end;
//end;

procedure TfrmTextFach.mitMenuItemClick(Sender: TObject);
var
  FachPunkt: IXMLNode;
  Wert: Integer;
begin
  reTextFach.Lines.BeginUpdate;
  reTextFach.SelText := TBMenuItem(Sender).Text;
  reTextFach.Lines.EndUpdate;

  MakeTextFachMap;

  if Assigned(FOnTextFachChange) then
    OnTextFachChange(Self);

  if Assigned(FTextFachGGLNode) then
  begin
    FachPunkt := GetPunktGGLFach(PHTortenMenu.Tag);
    if Assigned(FachPunkt) then
    begin
      case TBMenuItem(Sender).Wert of
        1: Wert := 100;
        2: Wert := 80;
        3: Wert := 60;
        4: Wert := 40;
        5: Wert := 20;
      else
        Wert := 0;
      end;
      FachPunkt.ChildValues['Wert'] := Wert;

      if Assigned(FOnPunktFachChange) then
        OnPunktFachChange(Self, PHTortenMenu.Tag, Wert);
    end;
  end;
end;

procedure TfrmTextFach.PHTortenMenuPopup(Sender: TObject);
begin
  SendMessage(reTextFach.Handle, EM_SETSEL, WPARAM(OldWstart), LPARAM(OldWstart + OldWLen));
end;

procedure TfrmTextFach.ReplaceFachText(TorteNr, Wert: Word);
var
  TortenValueNode: IXMLNode;
  TextFachMapItem: TTextFachMapItem;
  ReplaceText: string;
begin
  TextFachMapItem := FTextFachMap.GetTextFachMapItemFromTorteNr(TorteNr);
  if Assigned(TextFachMapItem) and (TextFachMapItem.TorteNr <> 0) then
  begin
    Label7.Caption := 'Torte Nr.: ' + IntToStr(TextFachMapItem.TorteNr);
    TortenValueNode := FindTortenValue(TextFachMapItem.TorteNr);
    if Assigned(TortenValueNode) then
    begin
      SendMessage(reTextFach.Handle, EM_SETSEL, WPARAM(TextFachMapItem.WStart), LPARAM(TextFachMapItem.WStart + TextFachMapItem.WLen));
      Label4.Caption := 'Sel. Text: ' + reTextFach.SelText;
      if Wert = 0 then
        ReplaceText := 'TORTE' + FormatFloat('00', TorteNr)
      else
        ReplaceText := TortenValueNode.ChildValues['VALUE' + FormatFloat('00', Wert)];
      if ReplaceText <> '' then
      begin
        reTextFach.SelText := ReplaceText;
        MakeTextFachMap;
      end;
    end;
  end;
end;

procedure TfrmTextFach.reTextFachChange(Sender: TObject);
begin
  if Assigned(FOnTextFachChange) then
    OnTextFachChange(Self);
end;

procedure TfrmTextFach.reTextFachDblClick(Sender: TObject);
begin
  Abort;
end;

procedure TfrmTextFach.reTextFachMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  cPos: LongInt;
  P: TPoint;
  TortenValueNode: IXMLNode;
  TextFachMapItem: TTextFachMapItem;
begin
  P := Point(X, Y);
  Label1.Caption := 'X: ' + FormatFloat('000', X) + '; Y: ' + FormatFloat('000', Y);
  cPos := LoWord(reTextFach.Perform(EM_CHARFROMPOS, 0, DWord(@P)));           // Get the CharIndex
  Label2.Caption := 'Pos.: ' + IntToStr(cPos);
  if (cPos > 0) and (cPos < reTextFach.GetTextLen) and (cPosMerk <> cPos) then
  begin
    cPosMerk := cPos;

    TextFachMapItem := FTextFachMap.GetTextFachMapItemFromPos(cPos);
    if Assigned(TextFachMapItem) and (TextFachMapItem.TorteNr <> 0) then
    begin
      Label7.Caption := 'Torte Nr.: ' + IntToStr(TextFachMapItem.TorteNr);
      TortenValueNode := FindTortenValue(TextFachMapItem.TorteNr);
      if Assigned(TortenValueNode) then
      begin
        SendMessage(reTextFach.Handle, EM_SETSEL, WPARAM(TextFachMapItem.WStart), LPARAM(TextFachMapItem.WStart + TextFachMapItem.WLen));
        OldWstart := TextFachMapItem.WStart;
        OldWLen := TextFachMapItem.WLen;
        Label4.Caption := 'Sel. Text: ' + reTextFach.SelText;
        BuildPopupMenu(TortenValueNode, TextFachMapItem.TorteNr);
        reTextFach.PopupMenu := PHTortenMenu;
      end else
      begin
        PHTortenMenuClear;
        reTextFach.PopupMenu := nil;
      end;
    end else
    begin
      PHTortenMenuClear;
      reTextFach.PopupMenu := nil;
    end;
  end;
end;

procedure TfrmTextFach.SetTextFachGGLNode(const Value: IXMLNode);
begin
  FTextFachGGLNode := Value;
end;

//procedure TfrmTextFach.SetRichEditAlign(const Value: TRichEditAlign);
//begin
//  case Value of
//    reaLeft: TRichEditAlignLeft.Create();
//    reaCenter:
//    reaRight:
//    reaBlock:
//  end;
//end;

procedure TfrmTextFach.SetSchriftgrad(const Value: Byte);
begin
  cmbSchriftgrad.ItemIndex := cmbSchriftgrad.Items.IndexOf(IntToStr(Value));
  cmbSchriftgradChange(nil);
end;

{ TTextFachMappe }

procedure TTextFachMappe.Clear;
var
  Idx: Integer;
begin
  for Idx := Count - 1 downto 0 do
    Objects[Idx].Free;

  inherited;
end;

destructor TTextFachMappe.Destroy;
var
  Idx: Integer;
begin
  for Idx := Count - 1 downto 0 do
    Objects[Idx].Free;

  inherited;
end;

function TTextFachMappe.GetTextFachMapItemFromPos(
  const Pos: Cardinal): TTextFachMapItem;
var
  Idx: Integer;
  TextFachMapItem: TTextFachMapItem;
begin
  Result := nil;
  for Idx := 0 to Count - 1 do
  begin
    TextFachMapItem := Objects[Idx] as TTextFachMapItem;
    if (Pos >= TextFachMapItem.WStart) and (Pos <= TextFachMapItem.WStart + TextFachMapItem.WLen) then
    begin
      Result := TextFachMapItem;
      Break;
    end;
  end;
end;

function TTextFachMappe.GetTextFachMapItemFromTorteNr(
  const TorteNr: Word): TTextFachMapItem;
var
  Idx: Integer;
  TextFachMapItem: TTextFachMapItem;
begin
  Result := nil;
  for Idx := 0 to Count - 1 do
  begin
    TextFachMapItem := Objects[Idx] as TTextFachMapItem;
    if (TorteNr = TextFachMapItem.TorteNr) then
    begin
      Result := TextFachMapItem;
      Break;
    end;
  end;
end;

end.
