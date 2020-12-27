unit FxBemerkung;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtActns, Vcl.StdActns, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls,
  Vcl.ActnMan, Vcl.ToolWin, Vcl.ActnCtrls, Vcl.ActnMenus, Vcl.ImgList, Vcl.Menus,
  Vcl.ActnPopup, System.Actions, System.ImageList, Xml.XMLIntf,
  Schule;

type
  TfrmBemerkung = class(TForm)
    pnlBemerungLabel: TPanel;
    pnlBemerkungText: TPanel;
    reBemerkung: TRichEdit;
    lblBemerkung: TLabel;
    cmbSchriftgrad: TComboBox;
    lblSchriftgrad: TLabel;
    PopupActionBar: TPopupActionBar;
    mitCut: TMenuItem;
    mitCopy: TMenuItem;
    mitPaste: TMenuItem;
    mitSelectAll: TMenuItem;
    mitUndo: TMenuItem;
    N2: TMenuItem;
    mitRedo: TMenuItem;
    mitAlignLeft: TMenuItem;
    mitAlignCenter: TMenuItem;
    mitAlignRight: TMenuItem;
    mitAlignBlock: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure cmbSchriftgradChange(Sender: TObject);
    procedure reBemerkungChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure pnlBemerkungTextResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FBemerkungNode: IXMLNode;
    FNurBemerkung: Boolean;
    FOnBemerkungChange: TNotifyEvent;
    FModus: TZeugnistModus;
    FFachID: string;
    FPageControlName: string;
    procedure SetNurBemerkung(const Value: Boolean);
    procedure SetRTFText(const Value: string);
    function GetRTFText: string;
    function GetSchriftgrad: Byte;
    procedure SetSchriftgrad(const Value: Byte);
    function GetPlanText: TCaption;
    procedure SetPlanText(const Value: TCaption);
    procedure SetSchriftgradVisible(const Value: Boolean);
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    procedure SaveBemerkungNode;
    property FachID: string read FFachID write FFachID;
    property Modus: TZeugnistModus read FModus write FModus;
    property OnBemerkungChange: TNotifyEvent read FOnBemerkungChange write FOnBemerkungChange;
    property NurBemerkung: Boolean read FNurBemerkung write SetNurBemerkung;
    property SchriftgradVisible: Boolean write SetSchriftgradVisible;
    property PageControlName: string read FPageControlName write FPageControlName;
    procedure InitFromXML(aXMLNode: IXMLNode);
  end;

//var
//  frmBemerkung: TfrmBemerkung;

implementation

uses
  Math, RichEdit;

{$R *.dfm}

procedure TfrmBemerkung.cmbSchriftgradChange(Sender: TObject);
var
  PosCursor: Integer;
begin
  PosCursor := reBemerkung.SelStart;
  reBemerkung.SelectAll;
  reBemerkung.SelAttributes.Size := StrToInt(cmbSchriftgrad.Items.Strings[cmbSchriftgrad.ItemIndex]);
  reBemerkung.SelStart := PosCursor;

  if Assigned(FOnBemerkungChange) then
    OnBemerkungChange(Self);
end;

procedure TfrmBemerkung.FormCreate(Sender: TObject);
begin
  Parent := Owner as TWinControl;
  BorderStyle := bsNone;
  ParentBackground := False;

  reBemerkung.Font.Assign(GS_Hoisbuettel_FontEdit);

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

  SendMessage(reBemerkung.Handle, EM_SETTEXTMODE, TM_MULTILEVELUNDO, 0);
  SendMessage(reBemerkung.Handle, EM_SETUNDOLIMIT, 15, 0);

  FModus := fpNormal;
end;

procedure TfrmBemerkung.FormDestroy(Sender: TObject);
begin
  if not NurBemerkung then
    REG_Einstellungen.WriteInteger(PageControlName + '\Faecher\' + FachID, 'Height', Height);
end;

procedure TfrmBemerkung.FormResize(Sender: TObject);
begin
  reBemerkung.Invalidate;
end;

procedure TfrmBemerkung.FormShow(Sender: TObject);
begin
  Top := 1300;
end;

function TfrmBemerkung.GetSchriftgrad: Byte;
begin
  Result := StrToIntDef(cmbSchriftgrad.Items.Strings[cmbSchriftgrad.ItemIndex], MemoSGDef);
end;

procedure TfrmBemerkung.InitFromXML(aXMLNode: IXMLNode);
begin
  FBemerkungNode := aXMLNode;

  if Assigned(FBemerkungNode) and FBemerkungNode.HasChildNodes then
  begin
    if not VarIsNull(FBemerkungNode.ChildValues['Text']) then
    begin
      if IsRTF(FBemerkungNode.ChildValues['Text']) then
        SetRTFText(VarToStr(FBemerkungNode.ChildValues['Text']))
      else
        SetPlanText(StringReplace(VarToStr(FBemerkungNode.ChildValues['Text']), '<br>', #13#10, [rfReplaceAll, rfIgnorecase]))
    end;
//    if AlignBlocksatz then
//      RichEditAlignBlocksatz(Result.FBemerkung.reBemerkung);
    if not VarIsNull(FBemerkungNode.ChildValues['Schriftgrad']) then
      SetSchriftgrad(StrToIntDef(VarToStr(FBemerkungNode.ChildValues['Schriftgrad']), MemoSGDef));
  end;
end;

function TfrmBemerkung.GetPlanText: TCaption;
begin
  try
    reBemerkung.PlainText := True;
    Result := reBemerkung.Text;
  finally
    reBemerkung.PlainText := False;
  end;
end;

function TfrmBemerkung.GetRTFText: string;
var
  StrSteam: TStringStream;
begin
  StrSteam := TStringStream.Create('');
  try
    reBemerkung.PlainText := False;
    reBemerkung.Lines.SaveToStream(StrSteam);
    Result := StrSteam.DataString;
  finally
    StrSteam.Free;
  end;
end;

procedure TfrmBemerkung.pnlBemerkungTextResize(Sender: TObject);
begin
  reBemerkung.Invalidate;
end;

procedure TfrmBemerkung.reBemerkungChange(Sender: TObject);
begin
  if Assigned(FOnBemerkungChange) then
    OnBemerkungChange(Self);
end;

procedure TfrmBemerkung.SetSchriftgrad(const Value: Byte);
begin
  cmbSchriftgrad.ItemIndex := cmbSchriftgrad.Items.IndexOf(IntToStr(Value));
  cmbSchriftgradChange(nil);
end;

procedure TfrmBemerkung.SetSchriftgradVisible(const Value: Boolean);
begin
  lblSchriftgrad.Visible := Value;
  cmbSchriftgrad.Visible := Value;
end;

procedure TfrmBemerkung.SetRTFText(const Value: String);
var
  StrSteam: TStringStream;
begin
  StrSteam := TStringStream.Create(Value);
  reBemerkung.Lines.BeginUpdate;
  try
    reBemerkung.PlainText := False;
    reBemerkung.Lines.LoadFromStream(StrSteam);
  finally
    reBemerkung.Lines.EndUpdate;
    StrSteam.Free;
  end;

  SendMessage(reBemerkung.Handle, EM_SETTYPOGRAPHYOPTIONS, TO_ADVANCEDTYPOGRAPHY, TO_ADVANCEDTYPOGRAPHY);
//  SendMessage(reBemerkung.Handle, EM_SETCHARFORMAT, TO_ADVANCEDTYPOGRAPHY, TO_ADVANCEDTYPOGRAPHY);
end;

procedure TfrmBemerkung.SaveBemerkungNode;
begin
  if Assigned(FBemerkungNode) then
  begin
    if reBemerkung.PlainText then
      FBemerkungNode.ChildValues['Text'] := GetPlanText
    else
      FBemerkungNode.ChildValues['Text'] := GetRTFText;
    FBemerkungNode.ChildValues['Schriftgrad'] := GetSchriftgrad;
  end;
end;

procedure TfrmBemerkung.SetNurBemerkung(const Value: Boolean);
begin
  FNurBemerkung := Value;

  if FNurBemerkung then
    Align := alClient
  else
  begin
    Align := alBottom;
    Height := REG_Einstellungen.ReadInteger(PageControlName + '\Faecher\' + FachID, 'Height', 150);
  end;

  lblBemerkung.Visible := not FNurBemerkung;
end;

procedure TfrmBemerkung.SetPlanText(const Value: TCaption);
begin
  try
    reBemerkung.PlainText := True;
    reBemerkung.Text := Value;
  finally
    reBemerkung.PlainText := False;
  end;
end;

end.
