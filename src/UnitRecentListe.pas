unit UnitRecentListe;

interface

uses Windows, System.SysUtils, menus, Registry, Forms, Dialogs, Classes,
  Schule;

type
  TOnClickProc = procedure(AFileName: TFileName) of object;

  TRecentListe = class(TPersistent)
  private
    { Private-Deklarationen }
    MaxItems: Integer;
    ParentMenu: TMenuItem;
    Parent: TForm;
    RecentFiles: TStringList;
    ClickProc: TOnClickProc;
  public
    { Public-Deklarationen }
    constructor Create(aParent: TForm; aParentMenu: TMenuItem; aMaxItems: Integer;
      Proc: TOnClickProc);
    destructor Destroy; override;
    procedure CustomItemAdd(Value: string);
    procedure RecentItemsToMenu;
    procedure RecentItemClick(Sender: TObject);
  end;

implementation

{ TRecentListe }

constructor TRecentListe.Create(aParent: TForm; aParentMenu: TMenuItem; aMaxItems: Integer;
  Proc: TOnClickProc);
var
  Idx: Integer;
  LeerItem: TMenuItem;
  NewItem: TMenuItem;
begin
  RecentFiles := TStringList.Create;

  MaxItems := aMaxItems;
  Parent := aParent;
  ParentMenu := aParentMenu;

  LeerItem := TMenuItem.Create(Parent);
  LeerItem.Name := 'mitLeer';
  LeerItem.Caption := 'leer';
  LeerItem.Tag := -1;
  ParentMenu.Add(LeerItem);

  for Idx := 0 to MaxItems - 1 do
  begin
    NewItem := TMenuItem.Create(Parent);
    NewItem.Caption := '';
    NewItem.Tag := Idx;
    NewItem.OnClick := RecentItemClick;
    ParentMenu.Add(NewItem);
  end;

  // Übergebene Prozedur gleich der der lokalen "ClickPorc" setzen
  ClickProc := Proc;

  // über Schliefe alles einlesen
  REG_Einstellungen.ReadSectionValues('RecentFiles', RecentFiles);
  RecentItemsToMenu;
end;

procedure TRecentListe.CustomItemAdd(Value: string);
var
  Idx: Integer;
begin
  // Testen, ob "Value" schon vorkommt
  for Idx := 0 to RecentFiles.Count - 1 do
    if (RecentFiles.ValueFromIndex[Idx] = Value) then
    begin
      RecentFiles.Delete(idx);
      Break;
    end;
  RecentFiles.Insert(0, 'Item=' + Value);

  if RecentFiles.Count > MaxItems then
    RecentFiles.Delete(RecentFiles.Count - 1);

  RecentItemsToMenu;
end;

destructor TRecentListe.Destroy;
var
  Idx: Integer;
begin
  // Daten in der Registry speichern
  for Idx := 0 to RecentFiles.Count - 1 do
    REG_Einstellungen.WriteString('RecentFiles', 'Item' + IntToStr(Idx), RecentFiles.ValueFromIndex[Idx]);

  RecentFiles.Free;

  inherited;
end;

procedure TRecentListe.RecentItemClick(Sender: TObject);
begin
  ClickProc(RecentFiles.ValueFromIndex[TMenuItem(Sender).Tag]);
end;

procedure TRecentListe.RecentItemsToMenu;
var
  Idx: Integer;
begin
  // Die Liste "Items" duchgehen und die MenuItems danach benennen
  for Idx := 0 to RecentFiles.Count - 1 do
    ParentMenu.Items[Idx + 1].Caption := RecentFiles.ValueFromIndex[Idx];

  // Die leeren Einträge unsichtbar machen die vollen sichtbar
  for Idx := 1 to MaxItems do
    ParentMenu.Items[Idx].Visible := not (ParentMenu.Items[Idx].Caption = '');

  ParentMenu.Items[0].Visible := RecentFiles.Count = 0;
end;

end.
