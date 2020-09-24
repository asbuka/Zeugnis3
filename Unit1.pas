unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc, Soap.XSBuiltIns,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frxClass, frxPreview, Vcl.StdCtrls,
  frxDesgn, frxRich, frxChBox, frxDBSet, frxCtrls, frxDesgnCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    frxReport1: TfrxReport;
    btnLoad: TButton;
    OpenSchueler: TOpenDialog;
    btnPreview: TButton;
    DesignB: TButton;
    frxDesigner1: TfrxDesigner;
    frxZeignisInhalt: TfrxUserDataSet;
    frxFach: TfrxUserDataSet;
    ColorBox1: TColorBox;
    procedure FormCreate(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnPreviewClick(Sender: TObject);
    procedure DesignBClick(Sender: TObject);
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
    procedure ColorBox1Change(Sender: TObject);
  private
    { Private-Deklarationen }
    WPath: String;
    PersonalDatenNode: IXMLNode;
    ZeugnisInhaltNode: IXMLNode;
    ZeugnisInhalt2Node: IXMLNode;
    FachNode: IXMLNode;
    PunktNode: IXMLNode;
    XMLSchueler: IXMLDocument;
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

uses
  Schule;

{$R *.dfm}

procedure TForm1.btnLoadClick(Sender: TObject);
var
  LastPath: string;
  Root: IXMLNode;
begin
  LastPath := REG_Einstellungen.ReadString('OPEN', 'Lastpath', HomeVerzeichnis(Self));
  if DirectoryExists(LastPath) then
    OpenSchueler.InitialDir := LastPath
  else
    OpenSchueler.InitialDir := HomeVerzeichnis(Self);
  OpenSchueler.FileName := '';
  if OpenSchueler.Execute then
  begin
    XMLSchueler.XML.Clear;
    XMLSchueler.LoadFromFile(OpenSchueler.FileName);
    Root := XMLSchueler.DocumentElement;
    if Root.ChildNodes.Count > 0 then
    begin
      PersonalDatenNode := Root.ChildNodes.FindNode('PersonalDaten');
      ZeugnisInhaltNode := Root.ChildNodes.FindNode('ZeugnisInhalt');
      ZeugnisInhalt2Node := Root.ChildNodes.FindNode('ZeugnisInhalt2');
    end else
    begin
      PersonalDatenNode := nil;
      ZeugnisInhaltNode := nil;
      ZeugnisInhalt2Node := nil;
    end;
  end;
end;

procedure TForm1.btnPreviewClick(Sender: TObject);
begin
  frxReport1.ShowReport;
end;

procedure TForm1.ColorBox1Change(Sender: TObject);
begin
  ShowMessage(IntToStr(ColorBox1.Selected));
end;

procedure TForm1.DesignBClick(Sender: TObject);
begin
  frxReport1.DesignReport;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  XMLSchueler := NewXMLDocument;
  XMLSchueler.Encoding := 'UTF-8';

  WPath := ExtractFilePath(Application.ExeName);
  frxReport1.LoadFromFile(WPath + 'Reports\ErsteReport.fr3');
//  frxReport1.PreviewOptions.Buttons := frxReport1.PreviewOptions.Buttons + [pbInplaceEdit ,pbSelection, pbCopy, pbPaste];
//  frxReport1.PreviewOptions.AllowPreviewEdit := True;
end;

procedure TForm1.frxFachCheckEOF(Sender: TObject; var Eof: Boolean);
begin
  Eof := True;
  if Assigned(FachNode) then
    Eof := (frxFach.RecNo >= FachNode.ChildNodes.Count);
end;

procedure TForm1.frxFachFirst(Sender: TObject);
begin
  PunktNode := nil;
  if Assigned(FachNode) then
    PunktNode := FachNode.ChildNodes.First;
end;

procedure TForm1.frxFachGetValue(const VarName: string; var Value: Variant);
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
      if Assigned(PunktNode.ChildNodes.FindNode('Schriftgrad')) then
        Value := PunktNode.ChildValues['Schriftgrad'];
  end;
end;

procedure TForm1.frxFachNext(Sender: TObject);
begin
  if Assigned(FachNode) and Assigned(PunktNode) then
    PunktNode := PunktNode.NextSibling;
end;

procedure TForm1.frxFachPrior(Sender: TObject);
begin
  if Assigned(FachNode) and Assigned(PunktNode) then
    PunktNode := PunktNode.PreviousSibling;
end;

procedure TForm1.frxZeignisInhaltCheckEOF(Sender: TObject; var Eof: Boolean);
begin
  Eof := True;
  if Assigned(ZeugnisInhaltNode) then
    Eof := frxZeignisInhalt.RecNo >= ZeugnisInhaltNode.ChildNodes.Count;
end;

procedure TForm1.frxZeignisInhaltFirst(Sender: TObject);
begin
  FachNode := nil;
  if Assigned(ZeugnisInhaltNode) then
    FachNode := ZeugnisInhaltNode.ChildNodes.First;
end;

procedure TForm1.frxZeignisInhaltGetValue(const VarName: string;
  var Value: Variant);
begin
  Value := null;
  if Assigned(PersonalDatenNode) then
  begin
    if VarName = 'K_Nachname' then
      if Assigned(PersonalDatenNode.ChildNodes.FindNode('Nachname')) then
        Value := PersonalDatenNode.ChildValues['Nachname'];
    if VarName = 'K_Vorname' then
      if Assigned(PersonalDatenNode.ChildNodes.FindNode('Vorname')) then
        Value := PersonalDatenNode.ChildValues['Vorname'];
    if VarName = 'K_KlasseZiffer' then
      if Assigned(PersonalDatenNode.ChildNodes.FindNode('KlasseZiffer')) then
        Value := PersonalDatenNode.ChildValues['KlasseZiffer'];
    if VarName = 'K_KlasseBuchstabe' then
      if Assigned(PersonalDatenNode.ChildNodes.FindNode('KlasseBuchstabe')) then
        Value := PersonalDatenNode.ChildValues['KlasseBuchstabe'];
    if VarName = 'K_Schuljahr' then
      if Assigned(PersonalDatenNode.ChildNodes.FindNode('Schuljahr')) then
        Value := PersonalDatenNode.ChildValues['Schuljahr'];
    if VarName = 'K_Halbjahr' then
      if Assigned(PersonalDatenNode.ChildNodes.FindNode('Halbjahr')) then
        Value := PersonalDatenNode.ChildValues['Halbjahr'];
    if VarName = 'K_Konferenz' then
      if Assigned(PersonalDatenNode.ChildNodes.FindNode('Konferenz')) then
        Value := XMLTimeToDateTime(PersonalDatenNode.ChildValues['Konferenz']);
    if VarName = 'K_Ausstellungsdatum' then
      if Assigned(PersonalDatenNode.ChildNodes.FindNode('Ausstellungsdatum')) then
        Value := XMLTimeToDateTime(PersonalDatenNode.ChildValues['Ausstellungsdatum']);
    if VarName = 'K_Versaeumnisse' then
      if Assigned(PersonalDatenNode.ChildNodes.FindNode('Versaeumnisse2')) then
        Value := PersonalDatenNode.ChildValues['Versaeumnisse2'];
    if VarName = 'K_Foerderschwerpunkt' then
      if Assigned(PersonalDatenNode.ChildNodes.FindNode('Foerderschwerpunkt')) then
        Value := PersonalDatenNode.ChildValues['Foerderschwerpunkt']
      else
        Value := '';
  end;
  if Assigned(FachNode) then
  begin
    if VarName = 'Fachname' then
    begin
      if FachNode.HasAttribute('Bezeichnung') then
        Value := FachNode.Attributes['Bezeichnung']
      else if FachNode.HasAttribute('Name')then
        Value := FachNode.Attributes['Name'];
    end;
    if VarName = 'Seitenumbruch' then
      if FachNode.HasAttribute('Seitenumbruch')then
        Value := s2b(FachNode.Attributes['Seitenumbruch']);
    if VarName = 'Torten' then
      if FachNode.HasAttribute('Torten')then
        Value := s2b(FachNode.Attributes['Torten']);
  end;
end;

procedure TForm1.frxZeignisInhaltNext(Sender: TObject);
begin
  if Assigned(ZeugnisInhaltNode) and Assigned(FachNode) then
    FachNode := FachNode.NextSibling;
end;

procedure TForm1.frxZeignisInhaltPrior(Sender: TObject);
begin
  if Assigned(ZeugnisInhaltNode) and Assigned(FachNode) then
    FachNode := FachNode.PreviousSibling;
end;

end.
