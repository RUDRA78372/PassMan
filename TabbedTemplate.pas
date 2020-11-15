unit TabbedTemplate;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.TabControl,
  FMX.StdCtrls, FMX.Gestures, FMX.Controls.Presentation, FMX.Edit, System.Hash,
  System.IOUtils, FMX.Layouts, FMX.ListBox,
  uTPLb_CryptographicLibrary, uTPLb_BaseNonVisualComponent,
  uTPLb_Codec, System.permissions, FMX.DialogService, FMX.ExtCtrls,
  FMX.ScrollBox, FMX.Memo, FMX.Ani, FMX.SearchBox, PMDB,
  FMX.DialogService.Async, FMX.Memo.Types;

type
  TTabbedForm = class(TForm)
    HeaderToolBar: TToolBar;
    ToolBarLabel: TLabel;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    GestureManager1: TGestureManager;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Label2: TLabel;
    StyleBook1: TStyleBook;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Label4: TLabel;
    Edit3: TEdit;
    Button2: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    TrackBar1: TTrackBar;
    Label6: TLabel;
    Label7: TLabel;
    ListBox1: TListBox;
    Label8: TLabel;
    Edit4: TEdit;
    Button3: TButton;
    Button4: TButton;
    Label1: TLabel;
    Button5: TButton;
    Button6: TButton;
    StyleBook2: TStyleBook;
    Memo1: TMemo;
    Panel6: TPanel;
    ImageViewer1: TImageViewer;
    Memo2: TMemo;
    BitmapListAnimation1: TBitmapListAnimation;
    SearchBox1: TSearchBox;
    Layout1: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    Layout4: TLayout;
    procedure FormCreate(Sender: TObject);
    procedure FormGesture(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
    procedure TrackBar1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    // procedure Button10Click(Sender: TObject);
    // procedure Button11Click(Sender: TObject);
  private
    procedure DisplayRationale(Sender: TObject;
      const APermissions: TArray<string>; const APostRationaleProc: TProc);
    procedure RequestPermissionsResult(Sender: TObject;
      const APermissions: TArray<string>;
      const AGrantResults: TArray<TPermissionStatus>);

  const
    PermissionStorageRead = 'android.permission.READ_EXTERNAL_STORAGE';
    PermissionStorageWrite = 'android.permission.WRITE_EXTERNAL_STORAGE';
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TabbedForm: TTabbedForm;
  Password, CurrDir: string;
  MS: TMemorystream;
  PM: TPMDBFile;
  PI: TPassinfo;

implementation

{$R *.fmx}

procedure TTabbedForm.RequestPermissionsResult(Sender: TObject;
  const APermissions: TArray<string>;
  const AGrantResults: TArray<TPermissionStatus>);
begin
  if (Length(AGrantResults) = 1) then
  begin
    case AGrantResults[0] of
      TPermissionStatus.Denied:
        TDialogService.Showmessage
          ('Cannot record and save passwords in database without permissions');
      TPermissionStatus.PermanentlyDenied:
        TDialogService.Showmessage
          ('If you decide you wish to use the app, please go to app settings and enable the read and write storage');
    end;
  end
  else
    TDialogService.Showmessage
      ('Something went wrong with the permission checking');
end;

procedure TTabbedForm.DisplayRationale(Sender: TObject;
  const APermissions: TArray<string>; const APostRationaleProc: TProc);
begin
  TDialogService.Showmessage
    ('We need to be given permission to record and save informations',
    procedure(const AResult: TModalResult)
    begin
      APostRationaleProc;
    end)
end;


procedure TTabbedForm.Button1Click(Sender: TObject);
begin
  PI.Name := Edit3.Text;
  PI.ID := Edit1.Text;
  PI.Password := Edit2.Text;
  PM.Add(PI);
  PM.Finalize;
  MS.SaveToFile(CurrDir + 'Passwords.pmdb');
  if ListBox1.Items.IndexOf(Edit3.Text) < 0 then
    ListBox1.Items.Add(Edit3.Text);
  Showmessage('Saved to database');
end;

function GeneratePass(ALength: Integer; ASLetters, ACLetters, ANumbers,
  ASymbols: Boolean): String;
var
  I: Integer;
begin
  Randomize;
  SetLength(Result, ALength);
  if (ASLetters = False) and (ACLetters = False) and (ANumbers = False) and
    (ASymbols = False) then
  begin
    I := 0;
    while I < ALength do
    begin
      Result[Succ(I)] := ' ';
      Inc(I);
    end;
    exit;
  end;
  I := 0;
  while I < ALength do
  begin
    case Random(4) of
      0:
        if ASLetters then
        begin
          Result[Succ(I)] := chr(Random(26) + $41);
          Inc(I);
        end;
      1:
        if ACLetters then
        begin
          Result[Succ(I)] := chr(Random(26) + $61);
          Inc(I);
        end;
      2:
        if ANumbers then
        begin
          Result[Succ(I)] := chr(Random(10) + $30);
          Inc(I);
        end;
      3:
        if ASymbols then
        begin
          Result[Succ(I)] := chr(Random(16) + $21);
          Inc(I);
        end;
    end;
  end;
end;

procedure TTabbedForm.Button2Click(Sender: TObject);
var
  uppstr, lowstr, numstr, symstr: string;
begin
  Edit2.Text := '';
  Edit2.Text := GeneratePass(strtoint(Label7.Text), CheckBox2.IsChecked,
    CheckBox3.IsChecked, CheckBox1.IsChecked, CheckBox4.IsChecked);
end;

procedure TTabbedForm.Button3Click(Sender: TObject);
var
  Mastpass: TStringstream;
begin

  Password := Edit4.Text;
  Edit4.Text := '';
  Edit4.Password := False;
  Mastpass := TStringstream.Create;
  Mastpass.LoadFromFile(CurrDir + 'PMKey.md5');
  if Thashmd5.GetHashString(Password) = Mastpass.DataString then
  begin
    MS := TMemorystream.Create;
    if fileexists(CurrDir + 'Passwords.pmdb') then
    begin
      MS.LoadFromFile(CurrDir + 'Passwords.pmdb');
      MS.Position := 0;
      PM := TPMDBFile.Create(Password, MS, False);
      PM.List(ListBox1.Items);
    end
    else
      PM := TPMDBFile.Create(Password, MS, true);
    TabItem1.Visible := true;
    TabItem2.Visible := true;
    TabControl1.ActiveTab := TabItem1;
    Showmessage('Program unlocked');
    Button3.Visible := False;
    Button4.Visible := true;
  end
  else
    Showmessage('Invalid password');
  Mastpass.Free;
end;

procedure TTabbedForm.Button4Click(Sender: TObject);
var
  Mastpass: TStringstream;
begin
  Password := Edit4.Text;
  if not fileexists(CurrDir + 'Passwords.pmdb') then
  begin
    MS := TMemorystream.Create;
    PM := TPMDBFile.Create(Password, MS, true);
  end
  else
  begin
    PM.MasterPassword := Password;
    PM.Finalize;
    MS.SaveToFile(CurrDir + 'Passwords.pmdb');
  end;
  if fileexists(CurrDir + 'PMKey.md5') then
    TFile.Delete(CurrDir + 'PMKey.md5');
  Mastpass := TStringstream.Create;
  Password := Edit4.Text;
  Mastpass.WriteString(Thashmd5.GetHashString(Password));
  Mastpass.SaveToFile(CurrDir + 'PMKey.md5');
  Mastpass.Free;
  Showmessage('Password changed');
  Edit4.Text := '';
  TabItem1.Visible := true;
  TabItem2.Visible := true;
  TabControl1.ActiveTab := TabItem1;
end;

procedure TTabbedForm.Button5Click(Sender: TObject);
begin
  PI := PM.LoadPass(ListBox1.Items[ListBox1.ItemIndex]);
  Edit3.Text := PI.Name;
  Edit1.Text := PI.ID;
  Edit2.Text := PI.Password;
  TabControl1.ActiveTab := TabItem1;
end;

procedure TTabbedForm.Button6Click(Sender: TObject);
begin
  FMX.DialogService.Async.TDialogServiceAsync.MessageDialog('Are you sure?',
    System.UITypes.TMsgDlgType.mtConfirmation, [System.UITypes.TMsgDlgBTN.mbYes,
    System.UITypes.TMsgDlgBTN.mbNo], System.UITypes.TMsgDlgBTN.mbNo, 0,
    procedure(const AResult: TModalResult)
    begin
      if AResult = 6 then
      begin
        PM.Delete(ListBox1.Items[ListBox1.ItemIndex]);
        ListBox1.Items.Delete(ListBox1.ItemIndex);
        PM.Finalize;
        MS.SaveToFile(CurrDir + 'Passwords.pmdb');
      end;
    end);
end;

procedure TTabbedForm.Button7Click(Sender: TObject);
begin
  Edit3.Text := '';
end;

procedure TTabbedForm.Button8Click(Sender: TObject);
begin
  Edit1.Text := '';
end;

procedure TTabbedForm.Button9Click(Sender: TObject);
begin
  Edit2.Text := '';
end;

procedure TTabbedForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  PM.Free;
  MS.Free;
end;

procedure TTabbedForm.FormCreate(Sender: TObject);
begin
  { This defines the default active tab at runtime }
  PermissionsService.RequestPermissions([PermissionStorageRead],
    RequestPermissionsResult, DisplayRationale);
  PermissionsService.RequestPermissions([PermissionStorageWrite],
    RequestPermissionsResult, DisplayRationale);
  Randomize;
  (* Tmpdir := Includetrailingbackslash
    (Includetrailingbackslash(TPath.GetSharedDocumentsPath) + 'PassMan' +
    inttostr(Random(Integer.MaxValue))); *)
  // Forcedirectories(Tmpdir);
  CurrDir := Includetrailingbackslash(TPath.GetSharedDocumentsPath);
{$IF DEFINED(ANDROID)}
  TabbedForm.StyleBook := StyleBook2;
  CurrDir := Includetrailingbackslash(TPath.GetSharedDocumentsPath);
  if not fileexists(CurrDir + 'PMKey.md5') then
    Showmessage
      ('If you face any errors changing the master password'#13#10'please restart the application');
{$ELSE}
  TabbedForm.StyleBook := StyleBook1;
  CurrDir := Includetrailingbackslash(GetCurrentDir);
{$ENDIF}
  // TrackBar1.Min := 1;
  // TrackBar1.Max := 32;
  TabItem1.Visible := False;
  TabItem2.Visible := False;
  TabControl1.ActiveTab := TabItem3;

  if fileexists(CurrDir + 'PMKey.md5') then
  begin
    Edit4.Password := true;
    Button4.Visible := False
  end
  else
    Button3.Visible := False;
end;

procedure TTabbedForm.FormGesture(Sender: TObject;
const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
{$IFDEF ANDROID}
  case EventInfo.GestureID of
    sgiLeft:
      begin
        if TabControl1.ActiveTab <> TabControl1.Tabs[TabControl1.TabCount - 1]
        then
          TabControl1.ActiveTab := TabControl1.Tabs[TabControl1.TabIndex + 1];
        Handled := true;
      end;

    sgiRight:
      begin
        if TabControl1.ActiveTab <> TabControl1.Tabs[0] then
          TabControl1.ActiveTab := TabControl1.Tabs[TabControl1.TabIndex - 1];
        Handled := true;
      end;
  end;
{$ENDIF}
end;

procedure TTabbedForm.TrackBar1Change(Sender: TObject);
begin
  Label7.Text := inttostr(trunc(TrackBar1.Value));
end;

end.
