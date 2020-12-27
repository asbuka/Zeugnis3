unit FxTorte;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  Schule;

type
  TfrmTorte = class(TForm)
    pnlTorten: TPanel;
    Torte_100: TImage;
    Torte_080: TImage;
    Torte_060: TImage;
    Torte_040: TImage;
    Torte_020: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmTorte: TfrmTorte;

implementation

{$R *.dfm}

procedure TfrmTorte.FormCreate(Sender: TObject);
begin
  Parent := Owner as TWinControl;
  BorderStyle := bsNone;
  pnlTorten.BevelOuter := bvNone;
  ParentBackground := False;
  Height := pnlTorten.Height;

  Torte_020.Left := pnlTorten.Width - (Torte_020.Width div 2) - RightTortenAbstand;
  Torte_040.Left := Torte_020.Left + (Torte_020.Width div 2) - (Torte_040.Width div 2) - XAbstand;
  Torte_060.Left := Torte_040.Left + (Torte_040.Width div 2) - (Torte_060.Width div 2) - XAbstand;
  Torte_080.Left := Torte_060.Left + (Torte_060.Width div 2) - (Torte_080.Width div 2) - XAbstand;
  Torte_100.Left := Torte_080.Left + (Torte_080.Width div 2) - (Torte_100.Width div 2) - XAbstand;
end;

procedure TfrmTorte.FormShow(Sender: TObject);
begin
  Top := 1300;
  Align := alTop;
end;

end.
