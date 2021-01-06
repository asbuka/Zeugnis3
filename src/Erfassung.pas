unit Erfassung;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc, Soap.XSBuiltIns, Vcl.ComCtrls,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frxClass, frxPreview, Vcl.StdCtrls, Vcl.Clipbrd,
  Schule, UnitRecentListe,
  frxDesgn, frxRich, frxChBox, frxDBSet, frxCtrls, frxDesgnCtrls, Vcl.ExtCtrls,
  FxBemerkung, FxTextFach, FxZusatzFach, FxTorte, FxFachPunkt, FormularDlg,
  System.ImageList, Vcl.ImgList, Vcl.StdActns, Vcl.ExtActns, System.Actions, System.UITypes,
  Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.ToolWin,
  RichEditAlignBlocksatz, dxSkinsCore, dxSkinsDefaultPainters, dxBarBuiltInMenu,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPC, cxClasses,
  Vcl.Menus, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinOffice2016Colorful,
  dxSkinOffice2016Dark, dxSkinOffice2019Colorful, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinTheBezier, dxSkinValentine, dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, uTPLb_CryptographicLibrary,
  uTPLb_BaseNonVisualComponent, uTPLb_Codec;

type
  TFachStatus = (fsNone, fsAktiv, fsNoAktiv);

  TFachTabSheet = class(TTabSheet)
  private
    Seitenumbruch: Boolean;
    Torten: Boolean;
    FFachStatus: TFachStatus;
    Kompetenz: Boolean;
    FID: string;
    FScrollBox: TScrollBox;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TfrmErfassung = class(TForm)
    frxReport1: TfrxReport;
    frxDesigner1: TfrxDesigner;
    frxZeignisInhalt: TfrxUserDataSet;
    frxFach: TfrxUserDataSet;
    pnlKopf: TPanel;
    lblNachname: TLabel;
    lblVorname: TLabel;
    lblKlasse: TLabel;
    lblSchuljahr: TLabel;
    lblKonferenzbeschluss: TLabel;
    lblVersaeumnisse: TLabel;
    lblAusstellungsdatum: TLabel;
    lblFoerderschwerpunkt: TLabel;
    edNachname: TEdit;
    edVorname: TEdit;
    edKlasse: TEdit;
    cmbSchuljahr: TComboBox;
    dtKonferenzbeschluss: TDateTimePicker;
    cmbVersaeumnisse: TComboBox;
    cmbKlasse: TComboBox;
    dtAusstellungsdatum: TDateTimePicker;
    chkQuickPreview: TCheckBox;
    edFoerderschwerpunkt: TEdit;
    pnlReligionPhilosophie: TPanel;
    rbReligion: TRadioButton;
    rbPhilosophie: TRadioButton;
    StatusBar: TStatusBar;
    LargeImageList: TImageList;
    ImageList: TImageList;
    LargeImageListDisable: TImageList;
    ImageListDisable: TImageList;
    ActionManager1: TActionManager;
    EditUndo: TEditUndo;
    EditCut: TEditCut;
    EditCopy: TEditCopy;
    EditPaste: TEditPaste;
    EditDelete: TEditDelete;
    EditSelectAll: TEditSelectAll;
    FormatRichEditAlignLeft: TRichEditAlignLeft;
    FormatRichEditAlignCenter: TRichEditAlignCenter;
    FormatRichEditAlignRight: TRichEditAlignRight;
    FormatRichEditBold: TRichEditBold;
    FormatRichEditItalic: TRichEditItalic;
    FormatRichEditUnderline: TRichEditUnderline;
    FormatRichEditStrikeOut: TRichEditStrikeOut;
    FormatRichEditBullets: TRichEditBullets;
    SaveSchueler: TSaveDialog;
    OpenSchueler: TOpenDialog;
    ToolBar1: TToolBar;
    tbNeu: TToolButton;
    tbOeffnen: TToolButton;
    tbSave: TToolButton;
    tbSaveAs: TToolButton;
    tbSeparator1: TToolButton;
    tbVorschau: TToolButton;
    tbDrucken: TToolButton;
    tbEingabepruefen: TToolButton;
    tbSeparator2: TToolButton;
    tbCut: TToolButton;
    tbCopy: TToolButton;
    tbPaste: TToolButton;
    tbSeparator3: TToolButton;
    tbUndo: TToolButton;
    tbSeparator4: TToolButton;
    tbAlignLeft: TToolButton;
    tbAlignCenter: TToolButton;
    tbAlignRight: TToolButton;
    tbAlignBlock: TToolButton;
    tbAlignBold: TToolButton;
    tbAlignItalic: TToolButton;
    tbUnderline: TToolButton;
    tbStrikeOut: TToolButton;
    tbBullets: TToolButton;
    FormatRichEditAlignBlocksatz: TRichEditAlignBlocksatz;
    MainMenu1: TMainMenu;
    Datei1: TMenuItem;
    mitNeuSchueler: TMenuItem;
    mitOpenSchueler: TMenuItem;
    mitSpeichern: TMenuItem;
    mitSpeichernUnter: TMenuItem;
    mitSchliessen: TMenuItem;
    mitRecentFiles: TMenuItem;
    N2: TMenuItem;
    mitVorschau: TMenuItem;
    mitDrucken: TMenuItem;
    mitStapeldruck: TMenuItem;
    N1: TMenuItem;
    Beenden1: TMenuItem;
    Bearbeiten1: TMenuItem;
    mitUndo: TMenuItem;
    mitRedo: TMenuItem;
    mitAusschneiden: TMenuItem;
    mitKopieren: TMenuItem;
    mitEinfuegen: TMenuItem;
    mitAllesauswaehlen: TMenuItem;
    N3: TMenuItem;
    mitAlignLeft: TMenuItem;
    mitAlignCenter: TMenuItem;
    mitAlignRight: TMenuItem;
    mitAlignBlock: TMenuItem;
    N4: TMenuItem;
    mitEingabepruefen: TMenuItem;
    mitLexicon: TMenuItem;
    mitTextbaustein: TMenuItem;
    mitZusatz: TMenuItem;
    mitBerichtzuClipboard: TMenuItem;
    Hilfe1: TMenuItem;
    Inhalt1: TMenuItem;
    Suchen2: TMenuItem;
    Hilfebenutzen1: TMenuItem;
    Info1: TMenuItem;
    pnlDaten: TPanel;
    Splitter2: TSplitter;
    pnlQuickPreview: TPanel;
    cxZeugnisControl: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    pgZeugnis: TPageControl;
    cxTabSheet2: TcxTabSheet;
    pgZeugnisGGL: TPageControl;
    frxPreview1: TfrxPreview;
    Timer1: TTimer;
    Codec1: TCodec;
    CryptographicLibrary1: TCryptographicLibrary;
    DialogPrintDlg1: TPrintDlg;
    procedure FormCreate(Sender: TObject);
    procedure frxZeignisInhaltPrior(Sender: TObject);
    procedure frxZeignisInhaltNext(Sender: TObject);
    procedure frxZeignisInhaltFirst(Sender: TObject);
    procedure frxZeignisInhaltCheckEOF(Sender: TObject; var Eof: Boolean);
    procedure frxZeignisInhaltGetValue(const VarName: string;
      var Value: Variant);
    procedure frxFachPrior(Sender: TObject);
    procedure frxFachNext(Sender: TObject);
    procedure frxFachFirst(Sender: TObject);
    procedure frxFachCheckEOF(Sender: TObject; var Eof: Boolean);
    procedure frxFachGetValue(const VarName: string; var Value: Variant);
    procedure OnChangeEreignis(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mitNeuSchuelerClick(Sender: TObject);
    procedure mitOpenSchuelerClick(Sender: TObject);
    procedure mitSpeichernClick(Sender: TObject);
    procedure mitSpeichernUnterClick(Sender: TObject);
    procedure mitVorschauClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure mitDruckenClick(Sender: TObject);
    procedure chkQuickPreviewClick(Sender: TObject);
    procedure rgFachClick(Sender: TObject);
  private
    { Private-Deklarationen }
    InXMLToFach: Boolean;
    InXMLToTabSheet: Boolean;
    FachEditModus: Boolean;
    NewZeugnis: Boolean;
    FBericht: Boolean;
    FGesprGrdl: Boolean;
    WPath: string;
    SchuelerFileName: TFileName;
    Root: IXMLNode;
    PersonalDatenNode: IXMLNode;
    ZeugnisInhaltNode: IXMLNode;
    ZeugnisInhaltGGLNode: IXMLNode;
    FachNode: IXMLNode;
    PunktNode: IXMLNode;
    XMLSchueler: IXMLDocument;
    FHalbJahr: SmallInt;
    FChange: Boolean;
    LastChange: TDateTime;
    RecentList: TRecentListe;

    procedure InitComboBox;
    procedure CheckAenderungen;
    function IstEingabeOK: Boolean;
    procedure RecentListClick(SchuelerFile: TFileName);
    procedure InitEingabe(aHalbJahr, aKlasse: Integer; FSP: Boolean);
    procedure PersonalDaten2XML(Root: IXMLNode);
    procedure OnABemerkungChange(Sender: TObject);
    procedure LoadKlasseVorlage(const KlasseVorlage: TFileName);
    procedure DoLoadSchueler;
    procedure DoQuickPreview;
    procedure DeleteActivTabSheet(aPageControl: TPageControl);
    procedure scrEingabeOnResize(Sender: TObject);
    procedure OnFachPunktChangeFromText(Sender: TfrmTextFach; PunktNr, Wert: Word);
    procedure OnFachPunktChangeFromPunkt(Sender: TfrmFachPunkt; PunktNr, Wert: Word);
    procedure FachPunktDblClick(Sender: TObject);
    procedure XMLToTabSheet(aPageControl: TPageControl; aZeugnisInhaltNode: IXMLNode);
    function CreateFachTabSheet(aPageControl: TPageControl; FachNode, FachGGLNode: IXMLNode): TFachTabSheet;
    procedure SetChange(const Value: Boolean);
    procedure DoSaveSchueler;
    procedure LoadDocumnetInfo(aRoot: IXMLNode);
    procedure Zeugnis2XML;
  public
    { Public-Deklarationen }
    property Change: Boolean read FChange write SetChange;
  end;

var
  frmErfassung: TfrmErfassung;

implementation

uses
  System.Math;

{$R *.dfm}
{$WARN SYMBOL_PLATFORM OFF}

procedure TfrmErfassung.mitSpeichernClick(Sender: TObject);
begin
  if IstEingabeOK then
  begin
    if not NewZeugnis then
      DoSaveSchueler
    else
      mitSpeichernUnterClick(nil);
  end else
    Abort;
end;

procedure TfrmErfassung.mitSpeichernUnterClick(Sender: TObject);
var
  LastPath: string;
  TmpFileName: TFileName;
begin
  if IstEingabeOK then
  begin
    LastPath := REG_Einstellungen.ReadString('SAVE', 'Lastpath', HomeVerzeichnis(Self));
    if DirectoryExists(LastPath) then
      SaveSchueler.InitialDir := LastPath
    else
      SaveSchueler.InitialDir := HomeVerzeichnis(Self);
    TmpFileName := 'Klasse ' + edKlasse.Text + cmbKlasse.Items.Strings[cmbKlasse.ItemIndex] + '_' + edNachname.Text + ' ' + edVorname.Text;
    if FBericht then
      TmpFileName := TmpFileName + ' Bericht';
    if FGesprGrdl then
      TmpFileName := TmpFileName + ' GesprGrdl';
    SaveSchueler.FileName := TmpFileName;
    if SaveSchueler.Execute then
    begin
      SchuelerFileName := SaveSchueler.FileName;
      REG_Einstellungen.WriteString('SAVE', 'Lastpath', IncludeTrailingBackslash(ExtractFilePath(SchuelerFileName)));
      DoSaveSchueler;
    end;
  end;
end;

procedure TfrmErfassung.mitVorschauClick(Sender: TObject);
begin
  Zeugnis2XML;
  frxReport1.Preview := nil;
  frxReport1.ShowReport;
end;

procedure TfrmErfassung.CheckAenderungen;
var
  MessDlgResult: Integer;
begin
  if Change then
  begin
    MessDlgResult := MessageDlg('Möchten Sie die Änderungen speichern?', mtConfirmation, [mbYes, mbNo, mbCancel], 0);
    case MessDlgResult of
      mrYes:
        mitSpeichernClick(nil);
      mrNo:
        Change := False;
      mrCancel:
        Abort;
    end;
  end;
end;

procedure TfrmErfassung.chkQuickPreviewClick(Sender: TObject);
begin
  pnlQuickPreview.Visible := chkQuickPreview.Checked;
  Splitter2.Visible := chkQuickPreview.Checked;
end;

procedure TfrmErfassung.DeleteActivTabSheet(aPageControl: TPageControl);
var
  Idx: Integer;
begin
  for Idx := aPageControl.PageCount - 1 downto 0 do
  begin
    if aPageControl.Pages[Idx] is TFachTabSheet then
      aPageControl.Pages[Idx].Free;
  end;

  pnlReligionPhilosophie.Visible := False;
end;

procedure TfrmErfassung.DoLoadSchueler;
var
//  Root: IXMLNode;
  SFVersion: Integer;
  EncriptFileName, TempFileName: TFileName;
begin
  TempFileName := SchuelerFileName;
  if ExtractFileExt(SchuelerFileName) = '.xschueler' then
  begin
    EncriptFileName := GetTempFile;
    Codec1.DecryptFile(EncriptFileName, SchuelerFileName);
    TempFileName := EncriptFileName;
  end;
  if FileExists(TempFileName) then
  begin
    XMLSchueler.XML.Clear;
    XMLSchueler.LoadFromFile(TempFileName);
    Root := XMLSchueler.DocumentElement;

    PersonalDatenNode := nil;
    ZeugnisInhaltNode := nil;
    ZeugnisInhaltGGLNode := nil;

    SFVersion := 1;
    if Root.HasAttribute('Version') then
       SFVersion := StrToIntDef(VarToStr(Root.Attributes['Version']), 0);
    if SFVersion > SchueleVersion then
    begin
      MessageDlg('Die Schülerdatei ist nicht lesbar. Sie wurde von einer neueren Version der Software erzeugt!'+#13#10+
                 'Bitte führen Sie ein Update durch!', mtError, [mbOK], 0);
      Abort;
    end;

    RecentList.CustomItemAdd(SchuelerFileName);
    LoadDocumnetInfo(Root);

    if Root.ChildNodes.Count > 0 then
    begin
      InXMLToTabSheet := True;

      try
        FBericht := False;
        PersonalDatenNode := Root.ChildNodes.FindNode('PersonalDaten');
        if Assigned(PersonalDatenNode) then
        begin
          if Assigned(PersonalDatenNode.ChildNodes.FindNode('Nachname')) then
            edNachname.Text := VarToStr(PersonalDatenNode.ChildValues['Nachname']);
          if Assigned(PersonalDatenNode.ChildNodes.FindNode('Vorname')) then
            edVorname.Text := VarToStr(PersonalDatenNode.ChildValues['Vorname']);
          if Assigned(PersonalDatenNode.ChildNodes.FindNode('KlasseZiffer')) then
            edKlasse.Text := VarToStr(PersonalDatenNode.ChildValues['KlasseZiffer']);
          if Assigned(PersonalDatenNode.ChildNodes.FindNode('KlasseBuchstabe')) then
            cmbKlasse.ItemIndex := cmbKlasse.Items.IndexOf(VarToStr(PersonalDatenNode.ChildValues['KlasseBuchstabe']));
          if Assigned(PersonalDatenNode.ChildNodes.FindNode('Schuljahr')) then
            if Length(VarToStr(PersonalDatenNode.ChildValues['Schuljahr'])) > 2 then
              cmbSchuljahr.ItemIndex := cmbSchuljahr.Items.IndexOf(VarToStr(PersonalDatenNode.ChildValues['Schuljahr']))
            else
              cmbSchuljahr.ItemIndex := PersonalDatenNode.ChildValues['Schuljahr'];
          if Assigned(PersonalDatenNode.ChildNodes.FindNode('Halbjahr')) then
            FHalbJahr := PersonalDatenNode.ChildValues['Halbjahr'];
          if Assigned(PersonalDatenNode.ChildNodes.FindNode('Konferenz')) then
          begin
            if StrToIntDef(PersonalDatenNode.ChildValues['Konferenz'], -1) = -1 then
              dtKonferenzbeschluss.Date := XMLTimeToDateTime(PersonalDatenNode.ChildValues['Konferenz'])
            else
              dtKonferenzbeschluss.Date := PersonalDatenNode.ChildValues['Konferenz'];
          end;
          if Assigned(PersonalDatenNode.ChildNodes.FindNode('Ausstellungsdatum')) then
          begin
            if StrToIntDef(PersonalDatenNode.ChildValues['Ausstellungsdatum'], -1) = -1 then
              dtAusstellungsdatum.Date := XMLTimeToDateTime(PersonalDatenNode.ChildValues['Ausstellungsdatum'])
            else
              dtAusstellungsdatum.Date := PersonalDatenNode.ChildValues['Ausstellungsdatum'];
          end;
          if Assigned(PersonalDatenNode.ChildNodes.FindNode('Versaeumnisse2')) then
            cmbVersaeumnisse.ItemIndex := cmbVersaeumnisse.Items.IndexOf(PersonalDatenNode.ChildValues['Versaeumnisse2'])
          else
          if Assigned(PersonalDatenNode.ChildNodes.FindNode('Versaeumnisse')) then
          begin
            if SFVersion = 1 then
            begin
              if PersonalDatenNode.ChildValues['Versaeumnisse'] > 0 then
                cmbVersaeumnisse.ItemIndex := PersonalDatenNode.ChildValues['Versaeumnisse'] + 1
              else
                cmbVersaeumnisse.ItemIndex := 0;
            end else
              cmbVersaeumnisse.ItemIndex := PersonalDatenNode.ChildValues['Versaeumnisse'];
          end;
          lblFoerderschwerpunkt.Visible := Assigned(PersonalDatenNode.ChildNodes.FindNode('Foerderschwerpunkt'));
          edFoerderschwerpunkt.Visible  := Assigned(PersonalDatenNode.ChildNodes.FindNode('Foerderschwerpunkt'));
          if Assigned(PersonalDatenNode.ChildNodes.FindNode('Foerderschwerpunkt')) then
            edFoerderschwerpunkt.Text := VarToStr(PersonalDatenNode.ChildValues['Foerderschwerpunkt']);
        end;

        ZeugnisInhaltNode := Root.ChildNodes.FindNode('ZeugnisInhalt');
        ZeugnisInhaltGGLNode := Root.ChildNodes.FindNode('ZeugnisInhaltGGL');
        cxZeugnisControl.HideTabs := not (Assigned(ZeugnisInhaltNode) and Assigned(ZeugnisInhaltGGLNode));
        cxZeugnisControl.ActivePage := cxTabSheet1;
        if Assigned(ZeugnisInhaltNode) then
        begin
          if ZeugnisInhaltNode.HasAttribute('Bezeichnung') then
            cxTabSheet1.Caption := ZeugnisInhaltNode.Attributes['Bezeichnung'];
          XMLToTabSheet(pgZeugnis, ZeugnisInhaltNode);
        end;
        if Assigned(ZeugnisInhaltGGLNode) then
        begin
          if ZeugnisInhaltGGLNode.HasAttribute('Bezeichnung') then
            cxTabSheet2.Caption := ZeugnisInhaltGGLNode.Attributes['Bezeichnung'];
          XMLToTabSheet(pgZeugnisGGL, ZeugnisInhaltGGLNode);
        end;
      finally
        InXMLToTabSheet := False;
      end;
    end;
  end;
end;

function TfrmErfassung.CreateFachTabSheet(aPageControl: TPageControl; FachNode, FachGGLNode: IXMLNode): TFachTabSheet;
var
  Idx: Integer;
  FID, FachBez: string;
  NurBemerkung: Boolean;
  ScrollBoxEingabe: TScrollBox;
  Splitter: TSplitter;
  FTextFach       : TfrmTextFach;
  FZusatzFach     : TfrmZusatzFach;
  FBemerkung      : TfrmBemerkung;
  FachZusatzNode  : IXMLNode;
  TextFachNode    : IXMLNode;
  BemerkungNode   : IXMLNode;
begin
  Result := nil;

  if Assigned(FachNode) then
  begin
    if FachNode.HasAttribute('Name')then
    begin
      FachBez := VarToStr(FachNode.Attributes['Name']);
      FID := Trim(StringReplace(VarToStr(FachNode.Attributes['Name']), '*', '', []));
    end;

    if FachNode.HasAttribute('Bezeichnung')then
      FachBez :=  VarToStr(FachNode.Attributes['Bezeichnung']);

    FachZusatzNode := FachNode.ChildNodes.FindNode('FachZusatz');
    TextFachNode   := FachNode.ChildNodes.FindNode('TextFach');
    BemerkungNode  := FachNode.ChildNodes.FindNode('Bemerkung');
    NurBemerkung   := (FachNode.ChildNodes.Count <= 2) and not Assigned(TextFachNode);

    Result := TFachTabSheet.Create(aPageControl);
    Result.PageControl     := aPageControl;
    Result.FID             := FID;
    Result.Caption         := FachBez;
    if FachNode.HasAttribute('Seitenumbruch') then
      Result.Seitenumbruch := s2b(VarToStr(FachNode.Attributes['Seitenumbruch']));
    if FachNode.HasAttribute('Torten') then
      Result.Torten        := s2b(VarToStr(FachNode.Attributes['Torten']));
    if FachNode.HasAttribute('Kompetenz') then
      Result.Kompetenz     := s2b(VarToStr(FachNode.Attributes['Kompetenz']));

    if FachNode.HasAttribute('Aktiv') then
    begin
      Result.FFachStatus := fsNoAktiv;
      if s2b(VarToStr(FachNode.Attributes['Aktiv'])) then
      begin
        rbReligion.Checked := AnsiSameText(FID, 'Religion');
        rbPhilosophie.Checked := AnsiSameText(FID, 'Philosophie');
        Result.FFachStatus := fsAktiv;
      end else
        Result.TabVisible := False;
    end;

    if not NurBemerkung then
    begin
      if Assigned(TextFachNode) then
      begin
        FTextFach := TfrmTextFach.Create(Result);
        FTextFach.FachID := Result.FID;
        FTextFach.OnTextFachChange := OnChangeEreignis;
        FTextFach.OnPunktFachChange := OnFachPunktChangeFromText;
        FTextFach.InitFromXML(TextFachNode);
        FTextFach.TextFachGGLNode := FachGGLNode;
        FTextFach.Show;
      end else
      begin
        if Assigned(FachZusatzNode) then
        begin
          FZusatzFach := TfrmZusatzFach.Create(Result);
          FZusatzFach.OnZusatzFachChange := OnChangeEreignis;
          FZusatzFach.InitFromXML(FachZusatzNode);
          FZusatzFach.Show;
        end;

        TfrmTorte.Create(Result).Show;

        ScrollBoxEingabe := TScrollBox.Create(Result);
        ScrollBoxEingabe.Parent := Result;
        ScrollBoxEingabe.ParentBackground := False;
        ScrollBoxEingabe.Tag := 10;
        ScrollBoxEingabe.Align := alClient;
        ScrollBoxEingabe.OnResize := scrEingabeOnResize;
        ScrollBoxEingabe.BorderStyle := bsNone;

        Result.FScrollBox := ScrollBoxEingabe;

        for Idx := 0 to FachNode.ChildNodes.Count - 1 do
        begin
          if CompareText(VarToStr(FachNode.ChildNodes[Idx].NodeName), 'PUNKT') = 0 then
          begin
            with TfrmFachPunkt.Create(ScrollBoxEingabe) do
            begin
              FachID := Result.FID;
              InitFromXML(FachNode.ChildNodes[Idx]);
              OnFachPunktChange := OnChangeEreignis;
              OnFachPunktDblClick := FachPunktDblClick;
              OnPunktFachChange := OnFachPunktChangeFromPunkt;
              Show;
            end;
          end;
        end;
      end;

      Splitter := TSplitter.Create(Result);
      Splitter.Parent := Result;
      Splitter.Align := alBottom;
      Splitter.Color := clTeal;
      Splitter.Height := 3;
//      Splitter.OnMoved := SplitterMoved;
    end;

    FBemerkung := TfrmBemerkung.Create(Result);
    FBemerkung.FachID := FID;
    FBemerkung.PageControlName := aPageControl.Name;
    FBemerkung.OnBemerkungChange := OnABemerkungChange;
    FBemerkung.NurBemerkung := NurBemerkung;
    FBemerkung.SchriftgradVisible := (NurBemerkung and not FBericht) or FBericht;
    FBemerkung.PopupActionBar.Images := ImageList;
    FBemerkung.InitFromXML(BemerkungNode);

    FBemerkung.mitUndo.Action        := EditUndo;
//    FBemerkung.mitRedo.Action        := EdiTRedo;
    FBemerkung.mitCut.Action         := EditCut;
    FBemerkung.mitCopy.Action        := EditCopy;
    FBemerkung.mitPaste.Action       := EditPaste;
    FBemerkung.mitSelectAll.Action   := EditSelectAll;
////    FBemerkung.mitDelete.Action      := EditDelete;

    FBemerkung.mitAlignLeft.Action   := FormatRichEditAlignLeft;
    FBemerkung.mitAlignCenter.Action := FormatRichEditAlignCenter;
    FBemerkung.mitAlignRight.Action  := FormatRichEditAlignRight;
    FBemerkung.mitAlignBlock.Action  := FormatRichEditAlignBlocksatz;

    FBemerkung.Show;
  end;
end;

procedure TfrmErfassung.DoQuickPreview;
begin
  if chkQuickPreview.Checked then
  begin
    Zeugnis2XML;
    frxReport1.Preview := frxPreview1;
    frxReport1.ShowReport;
    frxReport1.Preview := nil;
  end;
end;

procedure TfrmErfassung.OnABemerkungChange(Sender: TObject);
begin
  OnChangeEreignis(Sender);
//  if True then
//  ShowAnzahlZeichen(TRichEdit(Sender));
end;

procedure TfrmErfassung.OnChangeEreignis(Sender: TObject);
begin
  if not InXMLToTabSheet then
    Change := True;
end;

procedure TfrmErfassung.OnFachPunktChangeFromPunkt(Sender: TfrmFachPunkt;
  PunktNr, Wert: Word);
var
  Idx, Idy: Integer;
begin
  if Assigned(ZeugnisInhaltGGLNode) then
    for Idx := 0 to pgZeugnis.PageCount - 1 do
    begin
      if TFachTabSheet(pgZeugnis.Pages[Idx]).FID = Sender.FachID then
      begin
        for Idy := 0 to TFachTabSheet(pgZeugnis.Pages[Idx]).ControlCount - 1 do
          if TFachTabSheet(pgZeugnis.Pages[Idx]).Controls[Idy] is TfrmTextFach then
          begin
            TfrmTextFach(TFachTabSheet(pgZeugnis.Pages[Idx]).Controls[Idy]).ReplaceFachText(PunktNr, Wert);
            Break;
          end;
      end;
    end;
end;

procedure TfrmErfassung.OnFachPunktChangeFromText(Sender: TfrmTextFach; PunktNr,
  Wert: Word);
var
  Idx, Idy: Integer;
begin
  if Assigned(ZeugnisInhaltGGLNode) then
    for Idx := 0 to pgZeugnisGGL.PageCount - 1 do
    begin
      if TFachTabSheet(pgZeugnisGGL.Pages[Idx]).FID = Sender.FachID then
      begin
        for Idy := 0 to TFachTabSheet(pgZeugnisGGL.Pages[Idx]).FScrollBox.ControlCount - 1 do
          if (TFachTabSheet(pgZeugnisGGL.Pages[Idx]).FScrollBox.Controls[Idy] is TfrmFachPunkt) and
            (TfrmFachPunkt(TFachTabSheet(pgZeugnisGGL.Pages[Idx]).FScrollBox.Controls[Idy]).OrderNr = PunktNr) then
          begin
            TfrmFachPunkt(TFachTabSheet(pgZeugnisGGL.Pages[Idx]).FScrollBox.Controls[Idy]).Wert := Wert;
            Break;
          end;
      end;
    end;
end;

procedure TfrmErfassung.PersonalDaten2XML(Root: IXMLNode);
begin
  if not Assigned(PersonalDatenNode) then
    PersonalDatenNode := Root.AddChild('PersonalDaten', 0);
  Root.Attributes['Nachname']                           := edNachname.Text;
  Root.Attributes['Vorname']                            := edVorname.Text;
  PersonalDatenNode.ChildValues['Nachname']             := edNachname.Text;
  PersonalDatenNode.ChildValues['Vorname']              := edVorname.Text;
  PersonalDatenNode.ChildValues['KlasseZiffer']         := edKlasse.Text;
  PersonalDatenNode.ChildValues['KlasseBuchstabe']      := cmbKlasse.Items.Strings[cmbKlasse.ItemIndex];
  PersonalDatenNode.ChildValues['Schuljahr']            := cmbSchuljahr.Items.Strings[cmbSchuljahr.ItemIndex];
  PersonalDatenNode.ChildValues['Halbjahr']             := FHalbJahr;
  PersonalDatenNode.ChildValues['Konferenz']            := DateTimeToXMLTime(Int(dtKonferenzbeschluss.Date));
  PersonalDatenNode.ChildValues['Ausstellungsdatum']    := DateTimeToXMLTime(Int(dtAusstellungsdatum.Date));
  PersonalDatenNode.ChildValues['Versaeumnisse2']       := cmbVersaeumnisse.Items.Strings[cmbVersaeumnisse.ItemIndex];
  if edFoerderschwerpunkt.Visible then
    PersonalDatenNode.ChildValues['Foerderschwerpunkt'] := edFoerderschwerpunkt.Text;
end;

procedure TfrmErfassung.rgFachClick(Sender: TObject);
var
  Idx: Integer;
  FachPage: TFachTabSheet;
  SetActivePage: Boolean;
  ActivePage: TFachTabSheet;
begin
  if not InXMLToTabSheet then
  begin
    ActivePage := nil;
    SetActivePage := AnsiSameText(TFachTabSheet(pgZeugnis.ActivePage).FID, 'Religion') or AnsiSameText(TFachTabSheet(pgZeugnis.ActivePage).FID, 'Philosophie');
    for Idx := 0 to pgZeugnis.PageCount - 1 do
    begin
      if pgZeugnis.Pages[Idx] is TFachTabSheet then
      begin
        FachPage := pgZeugnis.Pages[Idx] as TFachTabSheet;
        if FachPage.FFachStatus <> fsNone then
        begin
          if AnsiSameText(FachPage.FID, 'Religion') then
            FachPage.TabVisible := rbReligion.Checked;
          if AnsiSameText(FachPage.FID, 'Philosophie') then
            FachPage.TabVisible := rbPhilosophie.Checked;

          if FachPage.TabVisible then
          begin
            FachPage.FFachStatus := fsAktiv;
            ActivePage := FachPage;
          end else
            FachPage.FFachStatus := fsNoAktiv;
        end;
      end;
    end;

    if SetActivePage and Assigned(ActivePage) then
      pgZeugnis.ActivePage := ActivePage;

    if Assigned(ZeugnisInhaltGGLNode) then
    begin
      ActivePage := nil;
      SetActivePage := AnsiSameText(TFachTabSheet(pgZeugnisGGL.ActivePage).FID, 'Religion') or AnsiSameText(TFachTabSheet(pgZeugnisGGL.ActivePage).FID, 'Philosophie');

      for Idx := 0 to pgZeugnisGGL.PageCount - 1 do
      begin
        if pgZeugnisGGL.Pages[Idx] is TFachTabSheet then
        begin
          FachPage := pgZeugnisGGL.Pages[Idx] as TFachTabSheet;
          if FachPage.FFachStatus <> fsNone then
          begin
            if AnsiSameText(FachPage.FID, 'Religion') then
              FachPage.TabVisible := rbReligion.Checked;
            if AnsiSameText(FachPage.FID, 'Philosophie') then
              FachPage.TabVisible := rbPhilosophie.Checked;

            if FachPage.TabVisible then
            begin
              FachPage.FFachStatus := fsAktiv;
              ActivePage := FachPage;
            end else
              FachPage.FFachStatus := fsNoAktiv;
          end;
        end;
      end;

      if SetActivePage and Assigned(ActivePage) then
        pgZeugnisGGL.ActivePage := ActivePage;
    end;

    Change := True;
  end;
end;

procedure TfrmErfassung.RecentListClick(SchuelerFile: TFileName);
begin
  CheckAenderungen;
  SchuelerFileName := SchuelerFile;
  DoLoadSchueler;
end;

procedure TfrmErfassung.scrEingabeOnResize(Sender: TObject);
var
  Idx: Integer;
  FrmTorten: TfrmTorte;
  SB_Visible: Boolean;
  SB_Visible_Alt: Boolean;
begin
  SB_Visible := (GetWindowlong((Sender as TScrollBox).Handle, GWL_STYLE) and WS_VSCROLL) <> 0;

  if not InXMLToFach then
  begin
    for Idx := 0 to (Sender as TScrollBox).Parent.ComponentCount - 1 do
    begin
      if (Sender as TScrollBox).Parent.Components[Idx] is TfrmTorte then
      begin
        FrmTorten := (Sender as TScrollBox).Parent.Components[Idx] as TfrmTorte;
        if FrmTorten.Showing then
        begin
          SB_Visible_Alt := FrmTorten.Torte_020.Left + 2 < FrmTorten.pnlTorten.Width - (FrmTorten.Torte_020.Width div 2) - RightTortenAbstand;

          FrmTorten.Torte_020.Left := FrmTorten.Torte_020.Left + IfThen(SB_Visible, IfThen(not SB_Visible_Alt, GetSystemMetrics(SM_CXVSCROLL) * -1, 0), IfThen(SB_Visible_Alt, GetSystemMetrics(SM_CXVSCROLL), 0));
          FrmTorten.Torte_040.Left := FrmTorten.Torte_040.Left + IfThen(SB_Visible, IfThen(not SB_Visible_Alt, GetSystemMetrics(SM_CXVSCROLL) * -1, 0), IfThen(SB_Visible_Alt, GetSystemMetrics(SM_CXVSCROLL), 0));
          FrmTorten.Torte_060.Left := FrmTorten.Torte_060.Left + IfThen(SB_Visible, IfThen(not SB_Visible_Alt, GetSystemMetrics(SM_CXVSCROLL) * -1, 0), IfThen(SB_Visible_Alt, GetSystemMetrics(SM_CXVSCROLL), 0));
          FrmTorten.Torte_080.Left := FrmTorten.Torte_080.Left + IfThen(SB_Visible, IfThen(not SB_Visible_Alt, GetSystemMetrics(SM_CXVSCROLL) * -1, 0), IfThen(SB_Visible_Alt, GetSystemMetrics(SM_CXVSCROLL), 0));
          FrmTorten.Torte_100.Left := FrmTorten.Torte_100.Left + IfThen(SB_Visible, IfThen(not SB_Visible_Alt, GetSystemMetrics(SM_CXVSCROLL) * -1, 0), IfThen(SB_Visible_Alt, GetSystemMetrics(SM_CXVSCROLL), 0));
        end;

        Break;
      end;
    end;
  end;
end;

procedure TfrmErfassung.SetChange(const Value: Boolean);
begin
  FChange := Value;
  mitSpeichern.Enabled := FChange;
  LastChange := Now;
end;

procedure TfrmErfassung.Timer1Timer(Sender: TObject);
begin
  if chkQuickPreview.Checked then
    if Now - LastChange > 3 / 24 / 3600 then    // 3 Sekunden
    begin
      if Change or (SchuelerFileName <> '') {or (KlasseVorlage <> '')} then
      begin
        Timer1.Enabled := False;
        DoQuickPreview;
      end;
    end;
end;

procedure TfrmErfassung.DoSaveSchueler;
var
  DecriptFileName: TFileName;
begin
  if Change then
  begin
    Zeugnis2XML;
    if ExtractFileExt(SchuelerFileName) = '.xschueler' then
    begin
      DecriptFileName := GetTempFile;
      XMLSchueler.SaveToFile(DecriptFileName);
      Codec1.EncryptFile(DecriptFileName, SchuelerFileName);
      DeleteFile(DecriptFileName);
    end else
      XMLSchueler.SaveToFile(SchuelerFileName);
    NewZeugnis := False;

    RecentList.CustomItemAdd(SchuelerFileName);
  end;
end;

procedure TfrmErfassung.LoadDocumnetInfo(aRoot: IXMLNode);
begin
  if Assigned(aRoot) then
  begin
    FBericht                      := s2b(VarToStr(aRoot.Attributes['Bericht']));
    FGesprGrdl                    := s2b(VarToStr(aRoot.Attributes['GesprGrdl']));
    lblFoerderschwerpunkt.Visible := s2b(VarToStr(aRoot.Attributes['Foerderschwerpunkt']));
    edFoerderschwerpunkt.Visible  := s2b(VarToStr(aRoot.Attributes['Foerderschwerpunkt']));
//    mitTextbaustein.Visible := lblFoerderschwerpunkt.Visible;
  end;
end;

procedure TfrmErfassung.Zeugnis2XML;
var
  Idx: Integer;
  FachPage: TFachTabSheet;
  Idy: Integer;
begin
  if Assigned(Root) then
  begin
    Root.Attributes['Version'] := SchueleVersion;
    Root.Attributes['Bericht'] := b2s(FBericht);
    Root.Attributes['GesprGrdl'] := b2s(FGesprGrdl);
    Root.Attributes['LastChange'] := DateTimeToXMLTime(Now);
    PersonalDaten2XML(Root);
    for Idx := 0 to pgZeugnis.PageCount - 1 do
    begin
      if pgZeugnis.Pages[Idx] is TFachTabSheet then
      begin
        FachPage := pgZeugnis.Pages[Idx] as TFachTabSheet;
        for Idy := 0 to FachPage.ComponentCount - 1 do
        begin
          if (FachPage.Components[Idy] is TfrmZusatzFach) then
            (FachPage.Components[Idy] as TfrmZusatzFach).SaveTextFachNode;
          if (FachPage.Components[Idy] is TfrmTextFach) then
            (FachPage.Components[Idy] as TfrmTextFach).SaveTextFachNode;
          if (FachPage.Components[Idy] is TfrmBemerkung) then
            (FachPage.Components[Idy] as TfrmBemerkung).SaveBemerkungNode;
        end;
      end;
    end;
  end;
end;

procedure TfrmErfassung.FachPunktDblClick(Sender: TObject);
var
  Passwort: string;
  Std, Min, Sek, MSek: Word;
begin
  if not FachEditModus then
  begin
    if InputQuery('Bearbeiten Modus', 'Passwort:', Passwort) then
    begin
      DecodeTime(Now, Std, Min, Sek, MSek);
      if Passwort = FormatFloat('00', Std) + FormatFloat('00', Min) then
        FachEditModus := True
      else
        Abort;
    end else
      Abort;
  end;
end;

procedure TfrmErfassung.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  MessDlgResult: Integer;
begin
  if Change then
  begin
    CanClose := False;
    MessDlgResult := MessageDlg('Möchten Sie die Änderungen speichern?', mtConfirmation, [mbYes, mbNo, mbCancel], 0);
    case MessDlgResult of
      mrYes: if IstEingabeOK then
             begin
                mitSpeichernClick(nil);
                CanClose := True;
             end else
               Abort;
      mrNo: CanClose := True;
      mrCancel: Abort;
    end;
  end;
end;

procedure TfrmErfassung.FormCreate(Sender: TObject);
var
  WindowStateInt: Integer;
  ATop: Integer;
  ALeft: Integer;
  AWidth: Integer;
  AHeight: Integer;
begin
  XMLSchueler := NewXMLDocument;
  XMLSchueler.Encoding := 'UTF-8';
  XMLSchueler.Options := XMLSchueler.Options + [doNodeAutoIndent];

  WPath := ExtractFilePath(Application.ExeName);
  frxReport1.LoadFromFile(WPath + 'Reports\ErsteReport.fr3');
  frxReport1.PreviewOptions.Buttons := frxReport1.PreviewOptions.Buttons + [pbInplaceEdit ,pbSelection, pbCopy, pbPaste];
  frxReport1.PreviewOptions.AllowPreviewEdit := True;

  Change := False;
  FachEditModus := False;
  InXMLToTabSheet := False;
  InitComboBox;
  Clipboard.Clear;

  Codec1.Password := GSHoisbuettel;

  WindowStateInt          := REG_Einstellungen.ReadInteger('FORM', 'WindowState', 0);
  ATop                    := REG_Einstellungen.ReadInteger('FORM', 'Top', 50);
  ALeft                   := REG_Einstellungen.ReadInteger('FORM', 'Left', 50);
  AWidth                  := REG_Einstellungen.ReadInteger('FORM', 'Width', IfThen(Screen.WorkAreaWidth > 930, 930, Screen.WorkAreaWidth - 10));
  AHeight                 := REG_Einstellungen.ReadInteger('FORM', 'Height', IfThen(Screen.WorkAreaHeight > 650, 650, Screen.WorkAreaHeight - 10));
  chkQuickPreview.Checked := REG_Einstellungen.ReadBool('EINGABE', 'QuickVorschau', False);

  RecentList := TRecentListe.Create(Self, mitRecentFiles, 10, RecentListClick);
  DragAcceptFiles(Self.Handle, True);

  case WindowStateInt of
    0: begin
         WindowState := wsNormal;
         Top := ATop;
         Left := ALeft;
         Width := IfThen(Screen.WorkAreaWidth < AWidth, Screen.WorkAreaWidth - 10, AWidth);
         Height := IfThen(Screen.WorkAreaHeight < AHeight, Screen.WorkAreaHeight - 10, AHeight);
       end;
    1: WindowState := wsNormal;
    2: WindowState := wsMaximized;
  end;

  InitEingabe(0, 0, False);
end;

procedure TfrmErfassung.FormDestroy(Sender: TObject);
begin
  case WindowState of
    wsNormal: begin
                REG_Einstellungen.WriteInteger('FORM', 'WindowState', 0);
                REG_Einstellungen.WriteInteger('FORM', 'Top', Self.Top);
                REG_Einstellungen.WriteInteger('FORM', 'Left', Self.Left);
                REG_Einstellungen.WriteInteger('FORM', 'Width', Self.Width);
                REG_Einstellungen.WriteInteger('FORM', 'Height', Self.Height);
              end;
    wsMinimized: REG_Einstellungen.WriteInteger('FORM', 'WindowState', 1);
    wsMaximized: REG_Einstellungen.WriteInteger('FORM', 'WindowState', 2);
  end;

  DragAcceptFiles(Self.Handle, False);
  REG_Einstellungen.WriteBool('EINGABE', 'QuickVorschau', chkQuickPreview.Checked);

  RecentList.Free;
  XMLSchueler.Active := False;
end;

procedure TfrmErfassung.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = Ord('D')) and (Shift = [ssCtrl, ssShift]) then
    frxReport1.DesignReport;
end;

procedure TfrmErfassung.FormShow(Sender: TObject);
begin
  CheckAenderungen;

  if (ParamCount > 0) and (ParamStr(1) <> '') then
  begin
    SchuelerFileName := ParamStr(1);
    DoLoadSchueler;
  end;
end;

procedure TfrmErfassung.frxFachCheckEOF(Sender: TObject; var Eof: Boolean);
begin
  Eof := True;
  if Assigned(FachNode) then
    Eof := (frxFach.RecNo >= FachNode.ChildNodes.Count);
end;

procedure TfrmErfassung.frxFachFirst(Sender: TObject);
begin
  PunktNode := nil;
  if Assigned(FachNode) then
    PunktNode := FachNode.ChildNodes.First;
end;

procedure TfrmErfassung.frxFachGetValue(const VarName: string; var Value: Variant);
begin
  Value := null;
  if Assigned(PunktNode) then
  begin
    if VarName = 'SortNr' then
      if Assigned(PunktNode.ChildNodes.FindNode('SortNr')) then
        Value := PunktNode.ChildValues['SortNr'];
    if VarName = 'LabelText1' then
    begin
      Value := '';
      if Assigned(PunktNode.ChildNodes.FindNode('LabelText1')) then
        Value := VarToStrDef(PunktNode.ChildValues['LabelText1'], '');
    end;
    if VarName = 'LabelText2' then
    begin
      Value := '';
      if Assigned(PunktNode.ChildNodes.FindNode('LabelText2')) then
        Value := VarToStrDef(PunktNode.ChildValues['LabelText2'], '');
    end;
    if VarName = 'Wert' then
      if Assigned(PunktNode.ChildNodes.FindNode('Wert')) then
        Value := PunktNode.ChildValues['Wert'];
    if VarName = 'Text' then
    begin
      Value := '';
      if Assigned(PunktNode.ChildNodes.FindNode('Text')) then
        Value := VarToStrDef(PunktNode.ChildValues['Text'], '');
    end;
    if VarName = 'TextPlan' then
    begin
      Value := '';
      if Assigned(PunktNode.ChildNodes.FindNode('Text')) then
        Value := RTF2PlainText(VarToStrDef(PunktNode.ChildValues['Text'], ''));
    end;
    if VarName = 'Farbe' then
      if Assigned(PunktNode.ChildNodes.FindNode('Farbe')) then
        Value := PunktNode.ChildValues['Farbe'];
    if VarName = 'Font.Style' then
    begin
      Value := '';
      if Assigned(PunktNode.ChildNodes.FindNode('Font')) then
        if PunktNode.ChildNodes.FindNode('Font').HasAttribute('Style')then
          Value := PunktNode.ChildNodes.FindNode('Font').Attributes['Style'];
    end;
    if VarName = 'Schriftgrad' then
    begin
      if Assigned(PunktNode.ChildNodes.FindNode('Schriftgrad')) then
        Value := PunktNode.ChildValues['Schriftgrad']
      else if PunktNode.HasAttribute('Schriftgrad') then
        Value := PunktNode.Attributes['Schriftgrad'];
    end;
    if VarName = 'RTFText' then
      if Assigned(PunktNode.ChildNodes.FindNode('RTFText')) then
        Value := RTFOhneEffekt(PunktNode.ChildValues['RTFText']);
    if VarName = 'RTFTextPlan' then
      if Assigned(PunktNode.ChildNodes.FindNode('RTFText')) then
        Value := RTF2PlainText(PunktNode.ChildValues['RTFText']);
  end;
end;

procedure TfrmErfassung.frxFachNext(Sender: TObject);
begin
  if Assigned(FachNode) and Assigned(PunktNode) then
    PunktNode := PunktNode.NextSibling;
end;

procedure TfrmErfassung.frxFachPrior(Sender: TObject);
begin
  if Assigned(FachNode) and Assigned(PunktNode) then
    PunktNode := PunktNode.PreviousSibling;
end;

procedure TfrmErfassung.frxZeignisInhaltCheckEOF(Sender: TObject; var Eof: Boolean);
begin
  Eof := True;
  if Assigned(ZeugnisInhaltNode) then
    Eof := frxZeignisInhalt.RecNo >= ZeugnisInhaltNode.ChildNodes.Count;
end;

procedure TfrmErfassung.frxZeignisInhaltFirst(Sender: TObject);
begin
  FachNode := nil;
  if Assigned(ZeugnisInhaltNode) then
    FachNode := ZeugnisInhaltNode.ChildNodes.First;
end;

procedure TfrmErfassung.frxZeignisInhaltGetValue(const VarName: string;
  var Value: Variant);
begin
  Value := null;
  if Assigned(PersonalDatenNode) then
  begin
    if VarName = 'K_Nachname' then
      if Assigned(PersonalDatenNode.ChildNodes.FindNode('Nachname')) then
        Value := VarToStr(PersonalDatenNode.ChildValues['Nachname']);
    if VarName = 'K_Vorname' then
      if Assigned(PersonalDatenNode.ChildNodes.FindNode('Vorname')) then
        Value := VarToStr(PersonalDatenNode.ChildValues['Vorname']);
    if VarName = 'K_KlasseZiffer' then
      if Assigned(PersonalDatenNode.ChildNodes.FindNode('KlasseZiffer')) then
        Value := VarToStr(PersonalDatenNode.ChildValues['KlasseZiffer']);
    if VarName = 'K_KlasseBuchstabe' then
      if Assigned(PersonalDatenNode.ChildNodes.FindNode('KlasseBuchstabe')) then
        Value := VarToStr(PersonalDatenNode.ChildValues['KlasseBuchstabe']);
    if VarName = 'K_Schuljahr' then
      if Assigned(PersonalDatenNode.ChildNodes.FindNode('Schuljahr')) then
        Value := VarToStr(PersonalDatenNode.ChildValues['Schuljahr']);
    if VarName = 'K_Halbjahr' then
      if Assigned(PersonalDatenNode.ChildNodes.FindNode('Halbjahr')) then
        Value := VarToStr(PersonalDatenNode.ChildValues['Halbjahr']);
    if VarName = 'K_Konferenz' then
      if Assigned(PersonalDatenNode.ChildNodes.FindNode('Konferenz')) then
        Value := XMLTimeToDateTime(VarToStr(PersonalDatenNode.ChildValues['Konferenz']));
    if VarName = 'K_Ausstellungsdatum' then
      if Assigned(PersonalDatenNode.ChildNodes.FindNode('Ausstellungsdatum')) then
        Value := XMLTimeToDateTime(VarToStr(PersonalDatenNode.ChildValues['Ausstellungsdatum']));
    if VarName = 'K_Versaeumnisse' then
      if Assigned(PersonalDatenNode.ChildNodes.FindNode('Versaeumnisse2')) then
        Value := VarToStr(PersonalDatenNode.ChildValues['Versaeumnisse2']);
    if VarName = 'K_Foerderschwerpunkt' then
      if Assigned(PersonalDatenNode.ChildNodes.FindNode('Foerderschwerpunkt')) then
        Value := VarToStr(PersonalDatenNode.ChildValues['Foerderschwerpunkt'])
      else
        Value := '';
  end;
  if Assigned(FachNode) then
  begin
    if VarName = 'Fachname' then
    begin
      if FachNode.HasAttribute('Bezeichnung') then
        Value := VarToStr(FachNode.Attributes['Bezeichnung'])
      else if FachNode.HasAttribute('Name')then
        Value := VarToStr(FachNode.Attributes['Name']);
    end;
    if VarName = 'Seitenumbruch' then
      if FachNode.HasAttribute('Seitenumbruch') then
        Value := s2b(VarToStr(FachNode.Attributes['Seitenumbruch']));
    if VarName = 'Torten' then
      if FachNode.HasAttribute('Torten') then
        Value := s2b(VarToStr(FachNode.Attributes['Torten']));
  end;
end;

procedure TfrmErfassung.frxZeignisInhaltNext(Sender: TObject);
begin
  if Assigned(ZeugnisInhaltNode) and Assigned(FachNode) then
  begin
    FachNode := FachNode.NextSibling;
    if Assigned(FachNode) and FachNode.HasAttribute('Aktiv') and s2b(VarToStr(FachNode.Attributes['Aktiv'])) then
      frxZeignisInhalt.Next;
  end;
end;

procedure TfrmErfassung.frxZeignisInhaltPrior(Sender: TObject);
begin
  if Assigned(ZeugnisInhaltNode) and Assigned(FachNode) then
  begin
    FachNode := FachNode.PreviousSibling;
    if Assigned(FachNode) and FachNode.HasAttribute('Aktiv') and s2b(VarToStr(FachNode.Attributes['Aktiv'])) then
      frxZeignisInhalt.Prior;
  end;
end;

procedure TfrmErfassung.InitComboBox;
begin
  cmbKlasse.Items.Clear;
  cmbKlasse.Items.Add('a');
  cmbKlasse.Items.Add('b');
  cmbKlasse.Items.Add('c');
  cmbKlasse.Items.Add('d');

  cmbSchuljahr.Items.Clear;
  cmbSchuljahr.Items.Add('2017/2018');
  cmbSchuljahr.Items.Add('2018/2019');
  cmbSchuljahr.Items.Add('2019/2020');
  cmbSchuljahr.Items.Add('2020/2021');
  cmbSchuljahr.Items.Add('2021/2022');
  cmbSchuljahr.Items.Add('2022/2023');
  cmbSchuljahr.Items.Add('2023/2024');

  cmbVersaeumnisse.Items.Clear;
  cmbVersaeumnisse.Items.Add('leer');
  cmbVersaeumnisse.Items.Add('0');
  cmbVersaeumnisse.Items.Add('1');
  cmbVersaeumnisse.Items.Add('2');
  cmbVersaeumnisse.Items.Add('3');
  cmbVersaeumnisse.Items.Add('4');
  cmbVersaeumnisse.Items.Add('5');
  cmbVersaeumnisse.Items.Add('6');
  cmbVersaeumnisse.Items.Add('7');
  cmbVersaeumnisse.Items.Add('8');
  cmbVersaeumnisse.Items.Add('9');
  cmbVersaeumnisse.Items.Add('10');
  cmbVersaeumnisse.Items.Add('11');
  cmbVersaeumnisse.Items.Add('12');
  cmbVersaeumnisse.Items.Add('13');
  cmbVersaeumnisse.Items.Add('14');
  cmbVersaeumnisse.Items.Add('15');
  cmbVersaeumnisse.Items.Add('16');
  cmbVersaeumnisse.Items.Add('17');
  cmbVersaeumnisse.Items.Add('18');
  cmbVersaeumnisse.Items.Add('19');
  cmbVersaeumnisse.Items.Add('20');
  cmbVersaeumnisse.Items.Add('21');
  cmbVersaeumnisse.Items.Add('22');
  cmbVersaeumnisse.Items.Add('23');
  cmbVersaeumnisse.Items.Add('24');
  cmbVersaeumnisse.Items.Add('25');
  cmbVersaeumnisse.Items.Add('26');
  cmbVersaeumnisse.Items.Add('27');
  cmbVersaeumnisse.Items.Add('28');
  cmbVersaeumnisse.Items.Add('29');
  cmbVersaeumnisse.Items.Add('30');
end;

procedure TfrmErfassung.InitEingabe(aHalbJahr, aKlasse: Integer; FSP: Boolean);
var
  Jahr, Monat, Tag: Word;
  Heute: TDate;
begin
  Heute := Now;
  DecodeDate(Heute, Jahr, Monat, Tag);

  FHalbJahr := aHalbJahr;
  edNachname.Text := '';
  edVorname.Text := '';
  cmbKlasse.ItemIndex := -1;
  if NewZeugnis then
  begin
    if (Monat >= 1) and (Monat <= 8) then
      cmbSchuljahr.ItemIndex := cmbSchuljahr.Items.IndexOf(IntToStr(Jahr - 1) + '/' + IntToStr(Jahr))
    else
      cmbSchuljahr.ItemIndex := cmbSchuljahr.Items.IndexOf(IntToStr(Jahr) + '/' + IntToStr(Jahr + 1));
    edKlasse.Text := IntToStr(aKlasse);
    cmbVersaeumnisse.ItemIndex := 0;

    if Trunc(Heute - REG_Einstellungen.ReadDate('EINGABE', 'LastEingabe', Heute)) < 5 * 30 then  // 5 Monate
    begin
      dtKonferenzbeschluss.Date := REG_Einstellungen.ReadDate('EINGABE', 'Konferenz', Heute);
      dtAusstellungsdatum.Date := REG_Einstellungen.ReadDate('EINGABE', 'Ausstellungsdatum', Heute);
      cmbKlasse.ItemIndex := cmbKlasse.Items.IndexOf(REG_Einstellungen.ReadString('EINGABE', 'KlasseBuchstabe', ''));
    end;
  end else
  begin
    cmbSchuljahr.ItemIndex := -1;
    edKlasse.Text := '';
    cmbVersaeumnisse.ItemIndex := -1;

    dtKonferenzbeschluss.Date := Now;
    dtAusstellungsdatum.Date := Now;
    cmbKlasse.ItemIndex := -1;
    pnlReligionPhilosophie.Visible := False;

    cxZeugnisControl.HideTabs := True;
  end;
  edFoerderschwerpunkt.Text := '';

  StatusBar.Panels[0].Text := 'Klasse: ' + edKlasse.Text + cmbKlasse.Items.Strings[cmbKlasse.ItemIndex];
  StatusBar.Panels[1].Text := '';
  StatusBar.Panels[2].Text := 'Schüler(in):';
  StatusBar.Panels[3].Text := '';
  StatusBar.Panels[4].Style := psText;
  StatusBar.Panels[4].Text := '';
  Self.Caption := GSHoisbuettel + '   ' + StatusBar.Panels.Items[0].Text + ' ' + StatusBar.Panels.Items[2].Text;

  lblFoerderschwerpunkt.Visible := FSP;
  edFoerderschwerpunkt.Visible := FSP;
//  mitTextbaustein.Visible := FSP;

  REG_Einstellungen.WriteDate('EINGABE', 'LastEingabe', Heute);

  Change := False;
end;

function TfrmErfassung.IstEingabeOK: Boolean;
begin
  Result := True;
  if edNachname.Text = '' then
  begin
    MessageDlg('Der Nachname ist ein Pflichtfeld!', mtError, [mbOK], 0);
    edNachname.SetFocus;
    Result := False;
    Exit;
  end;
  if edVorname.Text = '' then
  begin
    MessageDlg('Der Vorname ist ein Pflichtfeld!', mtError, [mbOK], 0);
    edVorname.SetFocus;
    Result := False;
    Exit;
  end;
  if cmbKlasse.ItemIndex < 0 then
  begin
    MessageDlg('Die Klasse ist ein Pflichtfeld!', mtError, [mbOK], 0);
    cmbKlasse.SetFocus;
    Result := False;
    Exit;
  end;
  if edFoerderschwerpunkt.Visible then
  begin
    if Trim(edFoerderschwerpunkt.Text) = '' then
    begin
      MessageDlg('Der Förderschwerpunkt ist ein Pflichtfeld!', mtError, [mbOK], 0);
      if edFoerderschwerpunkt.CanFocus then
        edFoerderschwerpunkt.SetFocus;
      Result := False;
      Exit;
    end;
  end;
end;

procedure TfrmErfassung.LoadKlasseVorlage(const KlasseVorlage: TFileName);
//var
//  Root: IXMLNode;
begin
  if FileExists(KlasseVorlage) then
  begin
    XMLSchueler.XML.Clear;
    XMLSchueler.LoadFromFile(KlasseVorlage);
    Root := XMLSchueler.DocumentElement;

    PersonalDatenNode := nil;
    ZeugnisInhaltNode := nil;
    ZeugnisInhaltGGLNode := nil;

    LoadDocumnetInfo(Root);

    InXMLToTabSheet := True;
    NewZeugnis := True;
    try
      ZeugnisInhaltNode := Root.ChildNodes.FindNode('ZeugnisInhalt');
      ZeugnisInhaltGGLNode := Root.ChildNodes.FindNode('ZeugnisInhaltGGL');
      cxZeugnisControl.HideTabs := not (Assigned(ZeugnisInhaltNode) and Assigned(ZeugnisInhaltGGLNode));
      cxZeugnisControl.ActivePage := cxTabSheet1;
      if Assigned(ZeugnisInhaltNode) then
      begin
        if ZeugnisInhaltNode.HasAttribute('Bezeichnung') then
          cxTabSheet1.Caption := ZeugnisInhaltNode.Attributes['Bezeichnung'];
        XMLToTabSheet(pgZeugnis, ZeugnisInhaltNode);
      end;
      if Assigned(ZeugnisInhaltGGLNode) then
      begin
        if ZeugnisInhaltGGLNode.HasAttribute('Bezeichnung') then
          cxTabSheet2.Caption := ZeugnisInhaltGGLNode.Attributes['Bezeichnung'];
        XMLToTabSheet(pgZeugnisGGL, ZeugnisInhaltGGLNode);
      end;
    finally
      InXMLToTabSheet := False;
    end;
    edNachname.SetFocus;
  end;
end;

procedure TfrmErfassung.mitDruckenClick(Sender: TObject);
begin
  Zeugnis2XML;
  frxReport1.Print;
end;

procedure TfrmErfassung.mitNeuSchuelerClick(Sender: TObject);
var
  FormularDlg: TfrmFormularDlg;
  KV: TKlasseVorlage;
begin
  CheckAenderungen;

  FormularDlg := TfrmFormularDlg.Create(Self);
  with FormularDlg do
  try
    if ShowModal = mrOk then
    begin
      SchuelerFileName := '';
      KV := TKlasseVorlage(cmbFormular.Items.Objects[cmbFormular.ItemIndex]);
      LoadKlasseVorlage(KV.FileName);
      InitEingabe(KV.HalbJahr, KV.Klasse, KV.FSP);
    end;
  finally
    Free;
  end;
end;

procedure TfrmErfassung.mitOpenSchuelerClick(Sender: TObject);
var
  LastPath: string;
begin
  LastPath := REG_Einstellungen.ReadString('OPEN', 'Lastpath', HomeVerzeichnis(Self));
  if DirectoryExists(LastPath) then
    OpenSchueler.InitialDir := LastPath
  else
    OpenSchueler.InitialDir := HomeVerzeichnis(Self);
  OpenSchueler.FileName := '';
  if OpenSchueler.Execute then
  begin
    SchuelerFileName := OpenSchueler.FileName;
    REG_Einstellungen.WriteString('OPEN', 'Lastpath', IncludeTrailingBackslash(ExtractFilePath(SchuelerFileName)));
    DoLoadSchueler;
  end;
end;

procedure TfrmErfassung.XMLToTabSheet(aPageControl: TPageControl; aZeugnisInhaltNode: IXMLNode);
var
  Idx: Integer;
  FachGGLNode: IXMLNode;
begin
  FachGGLNode := nil;
  if Assigned(aZeugnisInhaltNode) then
  begin
    pgZeugnis.Visible := False;
    try
      DeleteActivTabSheet(aPageControl);

      for Idx := 0 to aZeugnisInhaltNode.ChildNodes.Count - 1 do
      begin
        if AnsiSameText(aZeugnisInhaltNode.ChildNodes[Idx].NodeName, 'Fach') then
        try
          InXMLToFach := True;
          if Assigned(ZeugnisInhaltGGLNode) then
            FachGGLNode := FindAtributeNode(ZeugnisInhaltGGLNode, 'Name', aZeugnisInhaltNode.ChildNodes[Idx].Attributes['Name']);
          CreateFachTabSheet(aPageControl, aZeugnisInhaltNode.ChildNodes[Idx], FachGGLNode);
        finally
          InXMLToFach := False;
        end;
      end;
    finally
      pnlReligionPhilosophie.Visible := True;
      pgZeugnis.Visible := True;
    end;
  end;
end;

{ TFachTabSheet }

constructor TFachTabSheet.Create(AOwner: TComponent);
begin
  inherited;

  FScrollBox := nil;
  Seitenumbruch := False;
  Torten := False;
  Kompetenz := False;
  FFachStatus := fsNone;
end;

end.
