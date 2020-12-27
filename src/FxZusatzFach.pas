unit FxZusatzFach;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Xml.XMLIntf, Schule;

type
  TfrmZusatzFach = class(TForm)
    pnlFachZusatz: TPanel;
    lblFachZusatzText1: TLabel;
    lblFachZusatzText2: TLabel;
    ediFachZusatz: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure ediFachZusatzChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
    FFachZusatzNode: IXMLNode;
    FOnZusatzFachChange: TNotifyEvent;
    FModus: TZeugnistModus;
    procedure SetLabel1Caption(const Value: TCaption);
    procedure SetLabel2Caption(const Value: TCaption);
    function GetLabel2Visible: Boolean;
    procedure SetFachZusatzText(const Value: TCaption);
  public
    { Public-Deklarationen }
    procedure SaveTextFachNode;
    property Modus: TZeugnistModus read FModus write FModus;
    property OnZusatzFachChange: TNotifyEvent read FOnZusatzFachChange write FOnZusatzFachChange;
    procedure InitFromXML(FachZusatzNode: IXMLNode);
  end;

//var
//  frmZusatzFach: TfrmZusatzFach;

implementation

{$R *.dfm}

procedure TfrmZusatzFach.ediFachZusatzChange(Sender: TObject);
begin
  if Assigned(FOnZusatzFachChange) then
    OnZusatzFachChange(Self);
end;

procedure TfrmZusatzFach.FormCreate(Sender: TObject);
begin
  Parent := Owner as TWinControl;
  BorderStyle := bsNone;
  pnlFachZusatz.BevelOuter := bvNone;
  ParentBackground := False;
  Height := pnlFachZusatz.Height;

  lblFachZusatzText1.Font.Assign(GS_Hoisbuettel_FontLabel);
  lblFachZusatzText2.Font.Assign(GS_Hoisbuettel_FontLabel);
//  ediFachZusatz.Font.Assign(GS_Hoisbuettel_FontEdit);

  lblFachZusatzText1.Caption := '';
  lblFachZusatzText2.Caption := '';
end;

procedure TfrmZusatzFach.FormShow(Sender: TObject);
begin
  Top := 100;
  Align := alTop;
end;

function TfrmZusatzFach.GetLabel2Visible: Boolean;
begin
  Result := lblFachZusatzText2.Visible;
end;

procedure TfrmZusatzFach.InitFromXML(FachZusatzNode: IXMLNode);
begin
  if Assigned(FachZusatzNode) then
  begin
    FFachZusatzNode := FachZusatzNode;
    SetLabel1Caption(VarToStr(FachZusatzNode.ChildValues['LabelText1']));
    lblFachZusatzText2.Visible := not VarIsNull(FachZusatzNode.ChildValues['LabelText2']);
    if lblFachZusatzText2.Visible then
      SetLabel2Caption(VarToStr(FachZusatzNode.ChildValues['LabelText2']));
    SetFachZusatzText(VarToStr(FachZusatzNode.ChildValues['Text']));

    ediFachZusatz.Left := lblFachZusatzText1.Left + lblFachZusatzText1.Canvas.TextWidth(lblFachZusatzText1.Caption) + 10;
    if GetLabel2Visible then
      ediFachZusatz.Width := pnlFachZusatz.Width - lblFachZusatzText1.Left - lblFachZusatzText1.Width - lblFachZusatzText2.Width - 30
    else
      ediFachZusatz.Width := pnlFachZusatz.Width - lblFachZusatzText1.Left - lblFachZusatzText1.Width - 30;

    if Trunc(Now - REG_Einstellungen.ReadDate('EINGABE', 'LastEingabe', Now)) < 5 * 30 then  // 5 Monate
      SetFachZusatzText(REG_Einstellungen.ReadString('EINGABE', 'FachZusatzText', ''));
  end;
end;

procedure TfrmZusatzFach.SaveTextFachNode;
begin
  if Assigned(FFachZusatzNode) then
  begin
    FFachZusatzNode.ChildValues['Text'] := Trim(ediFachZusatz.Text);
  end;
end;

procedure TfrmZusatzFach.SetFachZusatzText(const Value: TCaption);
begin
  ediFachZusatz.Text := Value;
end;

procedure TfrmZusatzFach.SetLabel1Caption(const Value: TCaption);
begin
  lblFachZusatzText1.Caption := Value;
end;

procedure TfrmZusatzFach.SetLabel2Caption(const Value: TCaption);
begin
  lblFachZusatzText2.Caption := Value;

  lblFachZusatzText2.Width := lblFachZusatzText2.Canvas.TextWidth(lblFachZusatzText2.Caption) + 20;
  lblFachZusatzText2.Left := pnlFachZusatz.Width - lblFachZusatzText2.Width - 10;
end;

end.
