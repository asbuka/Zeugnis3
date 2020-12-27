program Zeugnis;



uses
  Vcl.Forms,
  Schule in 'src\Schule.pas' {Schule},
  UnitRecentListe in 'src\UnitRecentListe.pas',
  FxZusatzFach in 'src\FxZusatzFach.pas' {frmZusatzFach},
  FxTorte in 'src\FxTorte.pas' {frmTorte},
  FxBemerkung in 'src\FxBemerkung.pas' {frmBemerkung},
  FxTextFach in 'src\FxTextFach.pas' {frmTextFach},
  FxFachPunkt in 'src\FxFachPunkt.pas' {frmFachPunkt},
  FormularDlg in 'src\FormularDlg.pas' {frmFormularDlg},
  Erfassung in 'src\Erfassung.pas' {frmErfassung};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmErfassung, frmErfassung);
  Application.Run;
end.
