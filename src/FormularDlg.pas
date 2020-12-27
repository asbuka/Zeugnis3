unit FormularDlg;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, System.Generics.Collections;

type
  TKlasseVorlage = class(TPersistent)
  private
    Name: String;
    Schwimmen: Boolean;
    Bericht: Boolean;
    GesprGrdl: Boolean;
  public
    FileName: TFileName;
    Klasse: Word;
    HalbJahr: Word;
    FSP: Boolean;
  end;

  TfrmFormularDlg = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    pnlEingabe: TPanel;
    chkStandard: TCheckBox;
    chkFSP: TCheckBox;
    chkSchwimmen: TCheckBox;
    lblFormular: TLabel;
    cmbFormular: TComboBox;
    chkBericht: TCheckBox;
    chkGesprGrdl: TCheckBox;
    procedure cmbFormularClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure chkStandardClick(Sender: TObject);
    procedure chkFSPClick(Sender: TObject);
    procedure chkSchwimmenClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure chkBerichtClick(Sender: TObject);
  private
    { Private-Deklarationen }
//    FKlasse12A: TKlasseVorlage;
    FKlasse12F: TKlasseVorlage;
    FKlasse12B: TKlasseVorlage;
    FKlasse12G: TKlasseVorlage;
//    FKlasse21A: TKlasseVorlage;
    FKlasse21F: TKlasseVorlage;
    FKlasse21B: TKlasseVorlage;
    FKlasse21G: TKlasseVorlage;
//    FKlasse22A: TKlasseVorlage;
    FKlasse22F: TKlasseVorlage;
    FKlasse22B: TKlasseVorlage;
    FKlasse22G: TKlasseVorlage;
    FKlasse31A: TKlasseVorlage;
    FKlasse31F: TKlasseVorlage;
    FKlasse31S: TKlasseVorlage;
    FKlasse31M: TKlasseVorlage;
    FKlasse32A: TKlasseVorlage;
    FKlasse32F: TKlasseVorlage;
    FKlasse32S: TKlasseVorlage;
    FKlasse32M: TKlasseVorlage;
    FKlasse41A: TKlasseVorlage;
    FKlasse41F: TKlasseVorlage;
    FKlasse42A: TKlasseVorlage;
    FKlasse42F: TKlasseVorlage;
    procedure InitCmbFormular;
    procedure InitKlasseVorlage;
  public
    { Public-Deklarationen }
    FVorlagen: TList<TKlasseVorlage>;
  end;

var
  frmFormularDlg: TfrmFormularDlg;

implementation

{$R *.dfm}
{$WARN SYMBOL_PLATFORM OFF}

uses
  Dialogs, System.UITypes, Schule;

procedure TfrmFormularDlg.InitKlasseVorlage;
begin
//  FKlasse12A := TKlasseVorlage.Create;
//  FKlasse12A.Name := 'Zeugnis Klasse 1 (2. Halbjahr)';
//  FKlasse12A.FileName := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName) + 'Vorlagen') + 'Klasse_1_2.klasse';
//  FKlasse12A.Klasse := 1;
//  FKlasse12A.HalbJahr := 2;
//  FKlasse12A.FSP := False;
//  FKlasse12A.Schwimmen := False;
//  FKlasse12A.Bericht := False;
//  FKlasse12A.GesprGrdl := False;
//  FVorlagen.Add(FKlasse12A);

  FKlasse12F := TKlasseVorlage.Create;
  FKlasse12F.Name := 'Zeugnis Klasse 1 (2. Halbjahr) mit FSP';
  FKlasse12F.FileName := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName) + 'Vorlagen') + 'Klasse_1_2_FSP.klasse';
  FKlasse12F.Klasse := 1;
  FKlasse12F.HalbJahr := 2;
  FKlasse12F.FSP := True;
  FKlasse12F.Schwimmen := False;
  FKlasse12F.Bericht := False;
  FKlasse12F.GesprGrdl := False;
  FVorlagen.Add(FKlasse12F);

  FKlasse12B := TKlasseVorlage.Create;
  FKlasse12B.Name := 'Zeugnis Klasse 1 (2. Halbjahr) Bericht';
  FKlasse12B.FileName := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName) + 'Vorlagen') + 'Klasse_1_2_Bericht.klasse';
  FKlasse12B.Klasse := 1;
  FKlasse12B.HalbJahr := 2;
  FKlasse12B.FSP := False;
  FKlasse12B.Schwimmen := False;
  FKlasse12B.Bericht := True;
  FKlasse12B.GesprGrdl := True;
  FVorlagen.Add(FKlasse12B);

  FKlasse12G := TKlasseVorlage.Create;
  FKlasse12G.Name := 'Zeugnis Klasse 1 (2. Halbjahr) Gesprächsgrundlage';
  FKlasse12G.FileName := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName) + 'Vorlagen') + 'Klasse_1_2_GGL.klasse';
  FKlasse12G.Klasse := 1;
  FKlasse12G.HalbJahr := 2;
  FKlasse12G.FSP := False;
  FKlasse12G.Schwimmen := False;
  FKlasse12G.Bericht := False;
  FKlasse12G.GesprGrdl := True;
  FVorlagen.Add(FKlasse12G);

//  FKlasse21A := TKlasseVorlage.Create;
//  FKlasse21A.Name := 'Zeugnis Klasse 2 (1. Halbjahr)';
//  FKlasse21A.FileName := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName) + 'Vorlagen') + 'Klasse_2_1.klasse';
//  FKlasse21A.Klasse := 2;
//  FKlasse21A.HalbJahr := 1;
//  FKlasse21A.FSP := False;
//  FKlasse21A.Schwimmen := False;
//  FKlasse21A.Bericht := False;
//  FKlasse21A.GesprGrdl := False;
//  FVorlagen.Add(FKlasse21A);

  FKlasse21F := TKlasseVorlage.Create;
  FKlasse21F.Name := 'Zeugnis Klasse 2 (1. Halbjahr) mit FSP';
  FKlasse21F.FileName := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName) + 'Vorlagen') + 'Klasse_2_1_FSP.klasse';
  FKlasse21F.Klasse := 2;
  FKlasse21F.HalbJahr := 1;
  FKlasse21F.FSP := True;
  FKlasse21F.Schwimmen := False;
  FKlasse21F.Bericht := False;
  FKlasse21F.GesprGrdl := False;
  FVorlagen.Add(FKlasse21F);

  FKlasse21B := TKlasseVorlage.Create;
  FKlasse21B.Name := 'Zeugnis Klasse 2 (1. Halbjahr) Bericht';
  FKlasse21B.FileName := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName) + 'Vorlagen') + 'Klasse_2_1_Bericht.klasse';
  FKlasse21B.Klasse := 2;
  FKlasse21B.HalbJahr := 1;
  FKlasse21B.FSP := False;
  FKlasse21B.Schwimmen := False;
  FKlasse21B.Bericht := True;
  FKlasse21B.GesprGrdl := True;
  FVorlagen.Add(FKlasse21B);

  FKlasse21G := TKlasseVorlage.Create;
  FKlasse21G.Name := 'Zeugnis Klasse 2 (1. Halbjahr) Gesprächsgrundlage';
  FKlasse21G.FileName := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName) + 'Vorlagen') + 'Klasse_2_1_GGL.klasse';
  FKlasse21G.Klasse := 2;
  FKlasse21G.HalbJahr := 1;
  FKlasse21G.FSP := False;
  FKlasse21G.Schwimmen := False;
  FKlasse21G.Bericht := False;
  FKlasse21G.GesprGrdl := True;
  FVorlagen.Add(FKlasse21G);

//  FKlasse22A := TKlasseVorlage.Create;
//  FKlasse22A.Name := 'Zeugnis Klasse 2 (2. Halbjahr)';
//  FKlasse22A.FileName := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName) + 'Vorlagen') + 'Klasse_2_2.klasse';
//  FKlasse22A.Klasse := 2;
//  FKlasse22A.HalbJahr := 2;
//  FKlasse22A.FSP := False;
//  FKlasse22A.Schwimmen := False;
//  FKlasse22A.Bericht := False;
//  FKlasse22A.GesprGrdl := False;
//  FVorlagen.Add(FKlasse22A);

  FKlasse22F := TKlasseVorlage.Create;
  FKlasse22F.Name := 'Zeugnis Klasse 2 (2. Halbjahr) mit FSP';
  FKlasse22F.FileName := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName) + 'Vorlagen') + 'Klasse_2_2_FSP.klasse';
  FKlasse22F.Klasse := 2;
  FKlasse22F.HalbJahr := 2;
  FKlasse22F.FSP := True;
  FKlasse22F.Schwimmen := False;
  FKlasse22F.Bericht := False;
  FKlasse22F.GesprGrdl := False;
  FVorlagen.Add(FKlasse22F);

  FKlasse22B := TKlasseVorlage.Create;
  FKlasse22B.Name := 'Zeugnis Klasse 2 (2. Halbjahr) Bericht';
  FKlasse22B.FileName := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName) + 'Vorlagen') + 'Klasse_2_2_Bericht.klasse';
  FKlasse22B.Klasse := 2;
  FKlasse22B.HalbJahr := 2;
  FKlasse22B.FSP := False;
  FKlasse22B.Schwimmen := False;
  FKlasse22B.Bericht := True;
  FKlasse22B.GesprGrdl := True;
  FVorlagen.Add(FKlasse22B);

  FKlasse22G := TKlasseVorlage.Create;
  FKlasse22G.Name := 'Zeugnis Klasse 2 (2. Halbjahr) Gesprächsgrundlage';
  FKlasse22G.FileName := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName) + 'Vorlagen') + 'Klasse_2_2_GGL.klasse';
  FKlasse22G.Klasse := 2;
  FKlasse22G.HalbJahr := 2;
  FKlasse22G.FSP := False;
  FKlasse22G.Schwimmen := False;
  FKlasse22G.Bericht := False;
  FKlasse22G.GesprGrdl := True;
  FVorlagen.Add(FKlasse22G);

  FKlasse31A := TKlasseVorlage.Create;
  FKlasse31A.Name := 'Zeugnis Klasse 3 (1. Halbjahr)';
  FKlasse31A.FileName := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName) + 'Vorlagen') + 'Klasse_3_1.klasse';
  FKlasse31A.Klasse := 3;
  FKlasse31A.HalbJahr := 1;
  FKlasse31A.FSP := False;
  FKlasse31A.Schwimmen := False;
  FKlasse31A.Bericht := False;
  FKlasse31A.GesprGrdl := False;
  FVorlagen.Add(FKlasse31A);

  FKlasse31F := TKlasseVorlage.Create;
  FKlasse31F.Name := 'Zeugnis Klasse 3 (1. Halbjahr) mit FSP';
  FKlasse31F.FileName := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName) + 'Vorlagen') + 'Klasse_3_1_FSP.klasse';
  FKlasse31F.Klasse := 3;
  FKlasse31F.HalbJahr := 1;
  FKlasse31F.FSP := True;
  FKlasse31F.Schwimmen := False;
  FKlasse31F.Bericht := False;
  FKlasse31F.GesprGrdl := False;
  FVorlagen.Add(FKlasse31F);

  FKlasse31S:= TKlasseVorlage.Create;
  FKlasse31S.Name := 'Zeugnis Klasse 3 (1. Halbjahr) mit Schwimmen';
  FKlasse31S.FileName := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName) + 'Vorlagen') + 'Klasse_3_1_Schwimmen.klasse';
  FKlasse31S.Klasse := 3;
  FKlasse31S.HalbJahr := 1;
  FKlasse31S.FSP := False;
  FKlasse31S.Schwimmen := True;
  FKlasse31S.Bericht := False;
  FKlasse31S.GesprGrdl := False;
  FVorlagen.Add(FKlasse31S);

  FKlasse31M := TKlasseVorlage.Create;
  FKlasse31M.Name := 'Zeugnis Klasse 3 (1. Halbjahr) mit Schwimmen (FSP)';
  FKlasse31M.FileName := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName) + 'Vorlagen') + 'Klasse_3_1_Schwimmen_FSP.klasse';
  FKlasse31M.Klasse := 3;
  FKlasse31M.HalbJahr := 1;
  FKlasse31M.FSP := True;
  FKlasse31M.Schwimmen := True;
  FKlasse31M.Bericht := False;
  FKlasse31M.GesprGrdl := False;
  FVorlagen.Add(FKlasse31M);

  FKlasse32A := TKlasseVorlage.Create;
  FKlasse32A.Name := 'Zeugnis Klasse 3 (2. Halbjahr)';
  FKlasse32A.FileName := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName) + 'Vorlagen') + 'Klasse_3_2.klasse';
  FKlasse32A.Klasse := 3;
  FKlasse32A.HalbJahr := 2;
  FKlasse32A.FSP := False;
  FKlasse32A.Schwimmen := False;
  FKlasse32A.Bericht := False;
  FKlasse32A.GesprGrdl := False;
  FVorlagen.Add(FKlasse32A);

  FKlasse32F := TKlasseVorlage.Create;
  FKlasse32F.Name := 'Zeugnis Klasse 3 (2. Halbjahr) mit FSP';
  FKlasse32F.FileName := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName) + 'Vorlagen') + 'Klasse_3_2_FSP.klasse';
  FKlasse32F.Klasse := 3;
  FKlasse32F.HalbJahr := 2;
  FKlasse32F.FSP := True;
  FKlasse32F.Schwimmen := False;
  FKlasse32F.Bericht := False;
  FKlasse32F.GesprGrdl := False;
  FVorlagen.Add(FKlasse32F);

  FKlasse32S := TKlasseVorlage.Create;
  FKlasse32S.Name := 'Zeugnis Klasse 3 (2. Halbjahr) mit Schwimmen';
  FKlasse32S.FileName := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName) + 'Vorlagen') + 'Klasse_3_2_Schwimmen.klasse';
  FKlasse32S.Klasse := 3;
  FKlasse32S.HalbJahr := 2;
  FKlasse32S.FSP := False;
  FKlasse32S.Schwimmen := True;
  FKlasse32S.Bericht := False;
  FKlasse32S.GesprGrdl := False;
  FVorlagen.Add(FKlasse32S);

  FKlasse32M := TKlasseVorlage.Create;
  FKlasse32M.Name := 'Zeugnis Klasse 3 (2. Halbjahr) mit Schwimmen (FSP)';
  FKlasse32M.FileName := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName) + 'Vorlagen') + 'Klasse_3_2_Schwimmen_FSP.klasse';
  FKlasse32M.Klasse := 3;
  FKlasse32M.HalbJahr := 2;
  FKlasse32M.FSP := True;
  FKlasse32M.Schwimmen := True;
  FKlasse32M.Bericht := False;
  FKlasse32M.GesprGrdl := False;
  FVorlagen.Add(FKlasse32M);

  FKlasse41A := TKlasseVorlage.Create;
  FKlasse41A.Name := 'Zeugnis Klasse 4 (1. Halbjahr)';
  FKlasse41A.FileName := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName) + 'Vorlagen') + 'Klasse_4_1.klasse';
  FKlasse41A.Klasse := 4;
  FKlasse41A.HalbJahr := 1;
  FKlasse41A.FSP := False;
  FKlasse41A.Schwimmen := False;
  FKlasse41A.Bericht := False;
  FKlasse41A.GesprGrdl := False;
  FVorlagen.Add(FKlasse41A);

  FKlasse41F := TKlasseVorlage.Create;
  FKlasse41F.Name := 'Zeugnis Klasse 4 (1. Halbjahr) mit FSP';
  FKlasse41F.FileName := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName) + 'Vorlagen') + 'Klasse_4_1_FSP.klasse';
  FKlasse41F.Klasse := 4;
  FKlasse41F.HalbJahr := 1;
  FKlasse41F.FSP := True;
  FKlasse41F.Schwimmen := False;
  FKlasse41F.Bericht := False;
  FKlasse41F.GesprGrdl := False;
  FVorlagen.Add(FKlasse41F);

  FKlasse42A := TKlasseVorlage.Create;
  FKlasse42A.Name := 'Zeugnis Klasse 4 (2. Halbjahr)';
  FKlasse42A.FileName := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName) + 'Vorlagen') + 'Klasse_4_2.klasse';
  FKlasse42A.Klasse := 4;
  FKlasse42A.HalbJahr := 2;
  FKlasse42A.FSP := False;
  FKlasse42A.Schwimmen := False;
  FKlasse42A.Bericht := False;
  FKlasse42A.GesprGrdl := False;
  FVorlagen.Add(FKlasse42A);

  FKlasse42F := TKlasseVorlage.Create;
  FKlasse42F.Name := 'Zeugnis Klasse 4 (2. Halbjahr) mit FSP';
  FKlasse42F.FileName := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName) + 'Vorlagen') + 'Klasse_4_2_FSP.klasse';
  FKlasse42F.Klasse := 4;
  FKlasse42F.HalbJahr := 2;
  FKlasse42F.FSP := True;
  FKlasse42F.Schwimmen := False;
  FKlasse42F.Bericht := False;
  FKlasse42F.GesprGrdl := False;
  FVorlagen.Add(FKlasse42F);
end;

procedure TfrmFormularDlg.chkBerichtClick(Sender: TObject);
begin
  InitCmbFormular;
end;

procedure TfrmFormularDlg.chkFSPClick(Sender: TObject);
begin
  InitCmbFormular;
end;

procedure TfrmFormularDlg.chkSchwimmenClick(Sender: TObject);
begin
  InitCmbFormular;
end;

procedure TfrmFormularDlg.chkStandardClick(Sender: TObject);
begin
  InitCmbFormular;
end;

procedure TfrmFormularDlg.cmbFormularClick(Sender: TObject);
var
  KlasseVorlage: TKlasseVorlage;
begin
  if cmbFormular.ItemIndex >= 0 then
  begin
    KlasseVorlage := cmbFormular.Items.Objects[cmbFormular.ItemIndex] as TKlasseVorlage;
    if not FileExists(KlasseVorlage.FileName) then
      MessageDlg('Die Klasse Vorlage "' + KlasseVorlage.FileName + '" kann nicht gefunden werden!', mtError, [mbOK], 0);
  end;
end;

procedure TfrmFormularDlg.FormCreate(Sender: TObject);
begin
  FVorlagen := TList<TKlasseVorlage>.Create;

  InitKlasseVorlage;

  chkStandard.Checked   := REG_Einstellungen.ReadBool('FormularDlg', 'Standard', True);
  chkFSP.Checked        := REG_Einstellungen.ReadBool('FormularDlg', 'FSP', True);
  chkSchwimmen.Checked  := REG_Einstellungen.ReadBool('FormularDlg', 'Schwimmen', True);
  chkBericht.Checked    := REG_Einstellungen.ReadBool('FormularDlg', 'Bericht', True);
  chkGesprGrdl.Checked  := False; //REG_Einstellungen.ReadBool('FormularDlg', 'GGL', True);

  InitCmbFormular;

  cmbFormular.ItemIndex := REG_Einstellungen.ReadInteger('FormularDlg', 'NrFormular', 0);

//  cmbFormularClick(nil)
end;

procedure TfrmFormularDlg.FormDestroy(Sender: TObject);
var
  Idx: Word;
begin
  for Idx := FVorlagen.Count - 1 downto 0 do
    FVorlagen.Items[Idx].Free;

  FVorlagen.Free;

  REG_Einstellungen.WriteBool('FormularDlg', 'Standard', chkStandard.Checked);
  REG_Einstellungen.WriteBool('FormularDlg', 'FSP', chkFSP.Checked);
  REG_Einstellungen.WriteBool('FormularDlg', 'Schwimmen', chkSchwimmen.Checked);
  REG_Einstellungen.WriteBool('FormularDlg', 'Bericht', chkBericht.Checked);
  REG_Einstellungen.WriteBool('FormularDlg', 'GGL', chkGesprGrdl.Checked);
  REG_Einstellungen.WriteInteger('FormularDlg', 'NrFormular', cmbFormular.ItemIndex);
end;

procedure TfrmFormularDlg.FormShow(Sender: TObject);
begin
  if cmbFormular.CanFocus then
    cmbFormular.SetFocus;
end;

procedure TfrmFormularDlg.InitCmbFormular;
var
  Idx: Word;
begin
  with cmbFormular.Items do
  begin
    Clear;

    for Idx := 0 to FVorlagen.Count - 1 do
    begin
      if (chkStandard.Checked and not FVorlagen.Items[Idx].FSP and not FVorlagen.Items[Idx].Schwimmen and not FVorlagen.Items[Idx].Bericht and not FVorlagen.Items[Idx].GesprGrdl) or
         (chkFSP.Checked and FVorlagen.Items[Idx].FSP) or
         (chkSchwimmen.Checked and FVorlagen.Items[Idx].Schwimmen) or
         (chkBericht.Checked and FVorlagen.Items[Idx].Bericht) or
         (chkGesprGrdl.Checked and FVorlagen.Items[Idx].GesprGrdl) then
        AddObject(FVorlagen.Items[Idx].Name, FVorlagen.Items[Idx]);
    end;

    btnOK.Enabled := cmbFormular.Items.Count > 0;
    cmbFormular.ItemIndex := 0;
  end;
end;

end.
