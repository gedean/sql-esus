unit MainForm;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Forms, Controls, Dialogs, StdCtrls, ActnList,
  main_datamodule, lclintf, Menus, ComCtrls, ExtCtrls, Buttons,
  SynHighlighterSQL, SynEdit;

type

  { TApplicationMainForm }

  TApplicationMainForm = class(TForm)
    ActionOpenReportsFolder: TAction;
    ActionEditorTests: TAction;
    ActionAbout: TAction;
    ActionExecQuery: TAction;
    BitBtn1: TBitBtn;
    CheckBoxSaveToFile: TCheckBox;
    LabeledEditFileName: TLabeledEdit;
    MainActionList: TActionList;
    MainMenu: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItemQueries: TMenuItem;
    MenuItemDuplicates: TMenuItem;
    MenuItemSetup: TMenuItem;
    MenuItemAbout: TMenuItem;
    PanelAppPanel: TPanel;
    StatusBar: TStatusBar;
    SynEditorSql: TSynEdit;
    SynSQLSyn: TSynSQLSyn;
    procedure ActionAboutExecute(Sender: TObject);
    procedure ActionExecQueryExecute(Sender: TObject);
    procedure ActionOpenReportsFolderExecute(Sender: TObject);
    procedure CheckBoxSaveToFileChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SynEditorSqlChange(Sender: TObject);
    function GetSqlEditorTextLength: Integer;
    function IsSqlEditorEmpty: Boolean;

  private

  public

  end;

var
  ApplicationMainForm: TApplicationMainForm;

implementation

{$R *.lfm}

{ TApplicationMainForm }

const
  ZERO_LENGH_TEXT_SIZE  : Integer = 2;

function TApplicationMainForm.GetSqlEditorTextLength : Integer;
begin
  Result := Length(SynEditorSql.Text) - ZERO_LENGH_TEXT_SIZE;
end;

function TApplicationMainForm.IsSqlEditorEmpty: Boolean;
begin
  Result := GetSqlEditorTextLength() = 0;
end;

procedure TApplicationMainForm.ActionExecQueryExecute(Sender: TObject);
const
  MESSAGE_TEXT_TEMPLATE : String = 'Executar o Código Abaixo?' + sLineBreak + '%s';
var
   Query : String;
   MessageText : String;
begin
     Query := SynEditorSql.Lines.Text;
     MessageText := Format(MESSAGE_TEXT_TEMPLATE, [Query]);
  if MessageDlg('Extrator Dados E-SUS Versão 0.0.1', MessageText, mtConfirmation, [mbNo, mbYes], 0) = mrYes then
    If CheckBoxSaveToFile.Checked then
      MainDataModule.ExecuteQuery(Query, LabeledEditFileName.Text)
    else
      MainDataModule.ExecuteQuery(Query);
end;

procedure TApplicationMainForm.ActionOpenReportsFolderExecute(Sender: TObject);
begin
  OpenDocument(MainDataModule.GetReportsFolderFullPath);
end;

procedure TApplicationMainForm.CheckBoxSaveToFileChange(Sender: TObject);
begin
  LabeledEditFileName.Enabled := CheckBoxSaveToFile.Checked;
end;

procedure TApplicationMainForm.ActionAboutExecute(Sender: TObject);
const
  LICENCE : String = 'Licença:';
begin
  MessageDlg('Extrator Dados E-SUS Versão 0.0.1', 'Desenvolvolvimento: Gedean Dias (gedean.dias@akapu.com.br)', mtInformation, [mbOK], 0);
end;

procedure TApplicationMainForm.FormCreate(Sender: TObject);
const
  DATABASE_SERVER_INFO_TEMPLATE : String = 'Servidor: %s:%s';
var
   HistoryFile : THandle;
begin
  If Not DirectoryExists(MainDataModule.GetReportsFolderRelativePath) then
    If Not CreateDir (MainDataModule.GetReportsFolderRelativePath) Then
      MessageDlg('Informação', 'Não foi possível Criar a pasta de Relatórios', mtError, [mbOK], 0);

  If Not FileExists(MainDataModule.HISTORY_FILE_NAME) then
    begin
     HistoryFile := FileCreate(MainDataModule.HISTORY_FILE_NAME);
     FileClose(HistoryFile);
    end;

  StatusBar.Panels[0].Text := Format(DATABASE_SERVER_INFO_TEMPLATE, [MainDataModule.DatabaseConnection.HostName, MainDataModule.DatabaseConnection.Params[0].Remove(0, 5)]);
  StatusBar.Panels[1].Text := 'Relatórios: ' + MainDataModule.GetReportsFolderFullPath;
end;

procedure TApplicationMainForm.SynEditorSqlChange(Sender: TObject);
begin
  ActionExecQuery.Enabled := not IsSqlEditorEmpty;
end;

end.

