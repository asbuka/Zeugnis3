unit About;

interface

uses
  WinApi.Windows, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, Vcl.ComCtrls, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, IdSSL, IdSSLOpenSSL, System.IOUtils, IdAntiFreezeBase,
  IdAntiFreeze;

const
  StBatchName = 'update.bat';
  StTempDir = 'ZeugnisUpdateFiles';
  StUpdateName = 'ZeugnisSetup.exe';
//  LinkVersionDatei = 'https://vejgvdzf5xhayyml.myfritz.net/nas/filelink.lua?id=279ba45860eb86d9';
  LinkVersionDatei = 'https://vejgvdzf5xhayyml.myfritz.net/nas/filelink.lua?id=916e9db814ffdd4a';
//  LinkSetupDatei   = 'https://vejgvdzf5xhayyml.myfritz.net/nas/filelink.lua?id=68dece339b4a25b2';
  LinkSetupDatei   = 'https://vejgvdzf5xhayyml.myfritz.net/nas/filelink.lua?id=2a19b1931808a842';

type
  TAboutBox = class(TForm)
    pnlGrund: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    lblAktVersion: TLabel;
    OKButton: TButton;
    lblWWW: TLabel;
    Lwww: TLinkLabel;
    lblEMails: TLabel;
    LEmails: TLinkLabel;
    IdHTTP1: TIdHTTP;
    btnUpdate: TButton;
    ProgressBar1: TProgressBar;
    lblVerfVersion: TLabel;
    lblHinweis: TLabel;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    IdAntiFreeze1: TIdAntiFreeze;
    procedure FormShow(Sender: TObject);
    procedure LwwwLinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
    procedure LEmailsLinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
    procedure btnUpdateClick(Sender: TObject);
    procedure IdHTTP1Work(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
    procedure IdHTTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);
    procedure IdHTTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
    FUpdatePath: string;
    FUpdateFileName: TFileName;
    FBatchName: TFileName;
    AktVersion: string;
    function GetInetFile(FileURL, FileName: String): Boolean;
    procedure CreateBatchFile;
    procedure Restart(CloseProgram: Boolean);
  public
    { Public-Deklarationen }
  end;

  TGetRemoteVersionThread = class(TThread)
  private
    FColor: TColor;
    FHinweis: string;
    lblHinweisVisible: Boolean;
    btnUpdateVisible: Boolean;
    FHTTPs: TIdHTTP;
    FIdSSL: TIdSSLIOHandlerSocketOpenSSL;
    FForm: TAboutBox;
    procedure CheckVersion;
    procedure UpdateCaption;
  protected
    procedure Execute; override;
  public
    RemoteVersion: string;
    constructor MyCreate(CreateSuspended: Boolean);
    destructor Destroy; override;
  end;

var
  AboutBox: TAboutBox;

implementation

uses
  ShellApi, Schule, Dialogs;

{$R *.dfm}
{$WARN SYMBOL_PLATFORM OFF}

procedure TAboutBox.FormCreate(Sender: TObject);
var
  TmpPath: string;
begin
  btnUpdate.Visible := False;

  TmpPath := TPath.GetTempPath;
  FUpdatePath := IncludeTrailingBackslash(TmpPath) + StTempDir;
  FUpdateFileName := IncludeTrailingBackslash(FUpdatePath) + StUpdateName;
  FBatchName := IncludeTrailingBackslash(FUpdatePath) + StBatchName;
  If FileExists(FBatchName) then
    DeleteFile(FBatchName);
end;

procedure TAboutBox.FormShow(Sender: TObject);
var
  Thread: TGetRemoteVersionThread;
begin
  AktVersion := GetFileVersion(ParamStr(0));
  lblAktVersion.Caption := 'Aktuelle Version: ' + AktVersion;
  lblVerfVersion.Caption := 'Verfügbare Version: wird ermittelt ...';

  Thread := TGetRemoteVersionThread.MyCreate(True);
  Thread.FForm := Self;
  Thread.Start;
end;

procedure TAboutBox.LEmailsLinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
begin
  ShellExecute(Application.Handle, 'open',
    PChar(Link), nil, nil, sw_ShowNormal);
end;

procedure TAboutBox.LwwwLinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
begin
  ShellExecute(Application.Handle, 'open',
    PChar(Link), nil, nil, sw_ShowNormal);
end;

procedure TAboutBox.CreateBatchFile;
var
  Batch: TStringList;
begin
  Batch := TStringList.Create;
  with Batch do
  begin
    Add('@Echo off');
    Add('PING -n 3 127.0.0.1>nul');
    // für die Wartezeit, bis sich das Programm geschlossen hat.
    Add('start ' + FUpdateFileName);
  end;
  Batch.SaveToFile(fBatchName);
  Batch.Free;

//  ShowMessage(FBatchName);
  ShellExecute(Application.Handle, 'open', PChar(FBatchName), '', PChar(ApplicationPath), SW_HIDE);
end;

procedure TAboutBox.Restart(CloseProgram: Boolean);
begin
  CreateBatchFile;
  if CloseProgram then
    Application.MainForm.Close;
end;

function TAboutBox.GetInetFile(FileURL, FileName: String): Boolean;
var
  LoadStream: TFileStream;
begin
  Result := True;
  LoadStream := TFileStream.Create(FileName, fmCreate or fmShareExclusive);
  try
    try
      IdHTTP1.Get(FileURL, LoadStream);
    except
      Result := False;
    end;
  finally
    LoadStream.Free;
  end;
end;

procedure TAboutBox.IdHTTP1Work(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
  if ProgressBar1.Visible then
    ProgressBar1.Position := ProgressBar1.Position + AWorkCount;
end;

procedure TAboutBox.IdHTTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
begin
  if ProgressBar1.Visible then
  begin
    ProgressBar1.Max := AWorkCountMax;
    ProgressBar1.Position := 0;
  end;
end;

procedure TAboutBox.IdHTTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  if ProgressBar1.Visible then
  begin
    ProgressBar1.Position := 0;
    ProgressBar1.Visible := False;

    Restart(True);
//    ShellExecute(Handle, 'open', FileName, nil, nil, SW_SHOWNORMAL);
  end;
end;

procedure TAboutBox.btnUpdateClick(Sender: TObject);
begin
  if IsConnectedToInternet then
  begin
    lblHinweis.Visible := False;
    ProgressBar1.Visible := True;

    if not DirectoryExists(FUpdatePath) then
      if not ForceDirectories(FUpdatePath) then
         raise Exception.Create('Fehler beim erstellen "' + FUpdatePath + '" Verzeichnis!');

    if GetInetFile(LinkSetupDatei, FUpdateFileName) then
    begin
//     if ProgressBar1.Visible then
//      begin
//        ProgressBar1.Position := 0;
//        ProgressBar1.Visible := False;
//      end;
//
//      Restart(True);
////      ShellExecute(Handle, 'open', FileName, nil, nil, SW_SHOWNORMAL);
    end;
  end;
end;

{ TGetRemoteVersionThread }

destructor TGetRemoteVersionThread.Destroy;
begin
  FHTTPs.Free;
  FIdSSL.Free;

  inherited;
end;

procedure TGetRemoteVersionThread.Execute;
var
  RCode: Integer;
  RText: string;
begin
//  inherited;
  RemoteVersion := 'unbekannt';
  if IsConnectedToInternet then
  begin
    try
      RemoteVersion := FHTTPs.Get(LinkVersionDatei);
      RText := FHTTPs.Response.ResponseText;
      RCode := FHTTPs.Response.ResponseCode;

      if (RCode >= 200) and (RCode < 300) then
        CheckVersion;
    except
      on E: EIdHTTPProtocolException do
      begin
        FForm.OKButton.Enabled := True;
        raise Exception.Create(E.ErrorMessage);
      end;
    end;

    if RCode >= 300 then
    try
      raise Exception.Create('TGetRemoteVersionThread.Execute: ErrorCode: ' + IntToStr(RCode) + ' / ' + RText);
    finally
      RemoteVersion := 'unbekannt';
      Synchronize(UpdateCaption);
    end;
  end else
  begin
    FHinweis := 'Kein Internetzugriff.';    FColor := clBlue;
    lblHinweisVisible := True;  btnUpdateVisible := False;
    Synchronize(UpdateCaption);
  end;
end;

constructor TGetRemoteVersionThread.MyCreate(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);

  FreeOnTerminate := True;
  Priority := tpLower;

  FIdSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  FIdSSL.SSLOptions.Method := sslvTLSv1_2;
  FIdSSL.SSLOptions.Mode := sslmUnassigned;

  FHTTPs := TIdHTTP.Create(nil);
  FHTTPs.HandleRedirects := True;
  FHTTPs.IOHandler := FIdSSL;
end;

procedure TGetRemoteVersionThread.CheckVersion;
begin
  if (RemoteVersion <> '') and (RemoteVersion <> 'unbekannt') then
  begin
    try
      if CompareFileVersion(RemoteVersion, FForm.AktVersion) >= 0 then
      begin
        FHinweis := 'Ihre Version ist aktuell.';    FColor := clGreen;
        lblHinweisVisible := True;  btnUpdateVisible := False;
        Synchronize(UpdateCaption);
      end else
      begin // качаем обновление
        FHinweis := 'Es gibt eine Aktualisierung.';    FColor := clRed;
        lblHinweisVisible := True;  btnUpdateVisible := True;
        Synchronize(UpdateCaption);
      end;
    except
      RemoteVersion := 'unbekannt';
      Synchronize(UpdateCaption);
    end;
  end else
  begin
    FHinweis := '';    FColor := clRed;
    lblHinweisVisible := False;  btnUpdateVisible := False;
    Synchronize(UpdateCaption);
  end;
end;

procedure TGetRemoteVersionThread.UpdateCaption;
begin
  if Assigned(FForm) then
  begin
    FForm.lblVerfVersion.Caption := 'Verfügbare Version: ' + RemoteVersion;
    FForm.lblHinweis.Font.Color := FColor;
    FForm.lblHinweis.Caption := FHinweis;
    FForm.lblHinweis.Visible := lblHinweisVisible;
    FForm.btnUpdate.Visible := btnUpdateVisible;
    FForm.OKButton.Enabled := True;
  end;
end;

end.
