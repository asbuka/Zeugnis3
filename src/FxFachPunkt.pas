unit FxFachPunkt;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Xml.XMLIntf, Schule, Vcl.Buttons;

type
  TfrmFachPunkt = class;

  TPunktFachChangeEvent = procedure(Sender: TfrmFachPunkt; FachPunkt, Wert: Word) of object;

  TfrmFachPunkt = class(TForm)
    pnlFachPunkt: TPanel;
    lblFachPunkt: TLabel;
    Torte_100: TRadioButton;
    Torte_080: TRadioButton;
    Torte_060: TRadioButton;
    Torte_040: TRadioButton;
    Torte_020: TRadioButton;
    ediFachPunkt: TEdit;
    pnlCancel: TPanel;
    cbAbrechen: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure lblFachPunktDblClick(Sender: TObject);
    procedure ediFachPunktExit(Sender: TObject);
    procedure TorteEnter(Sender: TObject);
    procedure pnlFachPunktExit(Sender: TObject);
    procedure Torte_100Click(Sender: TObject);
    procedure Torte_080Click(Sender: TObject);
    procedure Torte_060Click(Sender: TObject);
    procedure Torte_040Click(Sender: TObject);
    procedure Torte_020Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbAbrechenClick(Sender: TObject);
  private
    { Private-Deklarationen }
    FPunktNode: IXMLNode;
    FWert: Integer;
    FOnFachPunktChange: TNotifyEvent;
    FOrderNr: Integer;
    FModus: TZeugnistModus;
    FOnFachPunktDblClick: TNotifyEvent;
    FOnPunktFachChange: TPunktFachChangeEvent;
    FFachID: string;
    procedure SetWert(const Value: Integer);
    function GetFachPunktText: TCaption;
    procedure SetFachPunktText(const Value: TCaption);
    procedure SetTorteVisible(const Value: Boolean);
    procedure SetFachPunktColor(const Value: TColor);
    function GetFachPunktColor: TColor;
    property TorteVisible: Boolean write SetTorteVisible;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure TorteClick(const aWert: Word);
  public
    { Public-Deklarationen }
    property Modus: TZeugnistModus read FModus write FModus;
    property FachID: string read FFachID write FFachID;
    property OrderNr: Integer read FOrderNr write FOrderNr;
    property Wert: Integer read FWert write SetWert;
    property FachPunktText: TCaption read GetFachPunktText write SetFachPunktText;
    property OnFachPunktChange: TNotifyEvent read FOnFachPunktChange write FOnFachPunktChange;
    property OnFachPunktDblClick: TNotifyEvent read FOnFachPunktDblClick write FOnFachPunktDblClick;
    property OnPunktFachChange: TPunktFachChangeEvent read FOnPunktFachChange write FOnPunktFachChange;
    property FachPunktColor: TColor read GetFachPunktColor write SetFachPunktColor;
    procedure InitFromXML(aXMLNode: IXMLNode);
  end;

//var
//  frmFachPunkt: TfrmFachPunkt;

implementation

{$R *.dfm}

procedure TfrmFachPunkt.ediFachPunktExit(Sender: TObject);
var
  AlteText: string;
begin
  if ediFachPunkt.Visible then
  begin
    AlteText := lblFachPunkt.Caption;
    lblFachPunkt.Caption := ediFachPunkt.Text;

    ediFachPunkt.Visible := False;
    lblFachPunkt.Visible := not ediFachPunkt.Visible;
    FModus := fpNormal;

    if CompareText(AlteText, lblFachPunkt.Caption) <> 0 then
    begin
      FPunktNode.ChildValues['Text'] := lblFachPunkt.Caption;
      if Assigned(FOnFachPunktChange) then
        OnFachPunktChange(Self);
    end;
  end;
end;

procedure TfrmFachPunkt.FormCreate(Sender: TObject);
begin
  Parent := Owner as TWinControl;
  BorderStyle := bsNone;
  pnlFachPunkt.BevelOuter := bvNone;
  ParentBackground := False;
  pnlFachPunkt.ParentBackground := False;
  Height := pnlFachPunkt.Height;

  Torte_020.Left := pnlFachPunkt.Width - (Torte_020.Width div 2) - RightPunktenAbstand;
  Torte_040.Left := Torte_020.Left + (Torte_020.Width div 2) - (Torte_040.Width div 2) - XAbstand;
  Torte_060.Left := Torte_040.Left + (Torte_040.Width div 2) - (Torte_060.Width div 2) - XAbstand;
  Torte_080.Left := Torte_060.Left + (Torte_060.Width div 2) - (Torte_080.Width div 2) - XAbstand;
  Torte_100.Left := Torte_080.Left + (Torte_080.Width div 2) - (Torte_100.Width div 2) - XAbstand;

  pnlCancel.Left := Torte_100.Left - pnlCancel.Width - YAbstand;
  cbAbrechen.Visible := False;

  ediFachPunkt.Left := lblFachPunkt.Left;
  ediFachPunkt.Visible := False;

  lblFachPunkt.Font.Assign(GS_Hoisbuettel_FontLabel);
  ediFachPunkt.Font.Assign(GS_Hoisbuettel_FontEdit);

  FModus := fpNormal;
end;

procedure TfrmFachPunkt.FormShow(Sender: TObject);
begin
  Top := 1300;
  Align := alTop;
end;

function TfrmFachPunkt.GetFachPunktColor: TColor;
begin
  Result := pnlFachPunkt.Color;
end;

function TfrmFachPunkt.GetFachPunktText: TCaption;
begin
  Result := lblFachPunkt.Caption;
end;

procedure TfrmFachPunkt.InitFromXML(aXMLNode: IXMLNode);
var
  FontNode: IXMLNode;
begin
  FPunktNode := aXMLNode;

  if Assigned(FPunktNode) and FPunktNode.HasChildNodes then
  begin
    FachPunktText := CheckLexicon(VarToStr(FPunktNode.ChildValues['Text']));

    OrderNr := StrToIntDef(VarToStr(FPunktNode.ChildValues['SortNr']), 0);

    if Assigned(FPunktNode.ChildNodes.FindNode('Farbe')) then
      if (StrToIntDef(VarToStr(FPunktNode.ChildValues['Farbe']), 0) = clGray) then
        FachPunktColor := StrToIntDef(VarToStr(FPunktNode.ChildValues['Farbe']), 0);

    FontNode := FPunktNode.ChildNodes.FindNode('Font');
    if Assigned(FontNode) then
      if FontNode.HasAttribute('FontStyle') then
        if FontNode.Attributes['FontStyle'] = 'fsBold' then
          lblFachPunkt.Font.Style := [fsBold];

    Wert := StrToIntDef(VarToStr(FPunktNode.ChildValues['Wert']), 0);
  end;
end;

procedure TfrmFachPunkt.TorteClick(const aWert: Word);
var
  WertEx: Word;
begin
  if (Modus <> fpLoad) then
  begin
    if FWert <> aWert then
    begin
      FWert := aWert;
      FPunktNode.ChildValues['Wert'] := Wert;
      FachPunktColor := clBtnFace;
      if Assigned(FOnFachPunktChange) then
        OnFachPunktChange(Self);
      if Assigned(FOnPunktFachChange) then
      begin
        case Wert of
          100: WertEx := 1;
           80: WertEx := 2;
           60: WertEx := 3;
           40: WertEx := 4;
           20: WertEx := 5;
        else
          WertEx := 0;
        end;
        OnPunktFachChange(Self, OrderNr, WertEx);
      end;
    end;
  end;
end;

procedure TfrmFachPunkt.lblFachPunktDblClick(Sender: TObject);
begin
  if Assigned(FOnFachPunktDblClick) then
    OnFachPunktDblClick(Self);

  ediFachPunkt.Text := lblFachPunkt.Caption;

  lblFachPunkt.Visible := False;
  ediFachPunkt.Visible := not lblFachPunkt.Visible;

  if ediFachPunkt.CanFocus then
    ediFachPunkt.SetFocus;
end;

procedure TfrmFachPunkt.CMMouseEnter(var Message: TMessage);
var
  ptWork : TPoint;
begin
  GetCursorPos(ptWork);

  if ((WindowFromPoint(ptWork) = pnlFachPunkt.Handle) or (GetParent(WindowFromPoint(ptWork)) = pnlFachPunkt.Handle)) then
  begin
    if (FWert > 0) then
      cbAbrechen.Visible := True;
    pnlFachPunkt.BevelOuter := bvRaised;
  end;
end;

procedure TfrmFachPunkt.CMMouseLeave(var Message: TMessage);
var
  ptWork : TPoint;
begin
  GetCursorPos(ptWork);

  if ((WindowFromPoint(ptWork) <> pnlFachPunkt.Handle) or (GetParent(WindowFromPoint(ptWork)) <> pnlFachPunkt.Handle)) then
  begin
    if cbAbrechen.Visible then
      cbAbrechen.Visible := False;
    pnlFachPunkt.BevelOuter := bvNone;
  end;
end;

procedure TfrmFachPunkt.pnlFachPunktExit(Sender: TObject);
begin
  ediFachPunktExit(ediFachPunkt);
end;

procedure TfrmFachPunkt.SetFachPunktColor(const Value: TColor);
begin
  pnlFachPunkt.Color := Value;
end;

procedure TfrmFachPunkt.SetFachPunktText(const Value: TCaption);
begin
  lblFachPunkt.Caption := Value;
end;

procedure TfrmFachPunkt.SetTorteVisible(const Value: Boolean);
begin
  Torte_020.Visible := Value;
  Torte_040.Visible := Value;
  Torte_060.Visible := Value;
  Torte_080.Visible := Value;
  Torte_100.Visible := Value;

  if Value then
    lblFachPunkt.Width := pnlCancel.Left - lblFachPunkt.Left * 2
  else
    lblFachPunkt.Width := pnlFachPunkt.Width - lblFachPunkt.Left * 2;

  ediFachPunkt.Width := lblFachPunkt.Width;
end;

procedure TfrmFachPunkt.SetWert(const Value: Integer);
begin
  FModus := fpLoad;
  try
    FWert := Value;
    case Wert of
       0: begin
            Torte_020.Checked := False;
            Torte_040.Checked := False;
            Torte_060.Checked := False;
            Torte_080.Checked := False;
            Torte_100.Checked := False;
          end;
      20: Torte_020.Checked := True;
      40: Torte_040.Checked := True;
      60: Torte_060.Checked := True;
      80: Torte_080.Checked := True;
     100: Torte_100.Checked := True;
    end;

    TorteVisible := FWert >= 0;
  finally
    FModus := fpNormal;
  end;
end;

procedure TfrmFachPunkt.TorteEnter(Sender: TObject);
begin
  ediFachPunktExit(ediFachPunkt);
end;

procedure TfrmFachPunkt.cbAbrechenClick(Sender: TObject);
begin
  if (Modus <> fpLoad) then
  begin
    if FWert <> 0 then
    begin
      Wert := 0;
      FachPunktColor := clRed;
      cbAbrechen.Visible := False;
      if Assigned(FOnFachPunktChange)then
        OnFachPunktChange(Self);
      if Assigned(FOnPunktFachChange) then
        OnPunktFachChange(Self, OrderNr, 0);
    end;
  end;
end;

procedure TfrmFachPunkt.Torte_020Click(Sender: TObject);
begin
  TorteClick(20);
end;

procedure TfrmFachPunkt.Torte_040Click(Sender: TObject);
begin
  TorteClick(40);
end;

procedure TfrmFachPunkt.Torte_060Click(Sender: TObject);
begin
  TorteClick(60);
end;

procedure TfrmFachPunkt.Torte_080Click(Sender: TObject);
begin
  TorteClick(80);
end;

procedure TfrmFachPunkt.Torte_100Click(Sender: TObject);
begin
  TorteClick(100);
end;

end.
