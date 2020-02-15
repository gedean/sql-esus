unit main_datamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, BufDataset, pqconnection, sqldb, Dialogs, Controls, lclintf, db;

type

  { TMainDataModule }

  TMainDataModule = class(TDataModule)
    DatabaseConnection: TPQConnection;
    SQLQuery: TSQLQuery;
    SQLQueryListTable: TSQLQuery;
    SQLTransaction: TSQLTransaction;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataSourceListTableDataChange(Sender: TObject; Field: TField);

  public
    const
    EXPORT_FILE_EXTENSION: String = '.csv';

    EXPORT_SQL_TEMPLATE: String = 'COPY  (%s)  TO ''%s'' DELIMITER '';'' CSV HEADER ENCODING ''LATIN1'';';
    EXTRACT_TABLE_SQL_TEMPLATE: String = 'COPY  %s  TO ''%s''.csv DELIMITER '';'' CSV HEADER ENCODING ''LATIN1'';';

    MESSAGE_TITLE : RawByteString = 'Extrator Dados E-SUS Versão 0.0.1';

    REPORTS_FOLDER_NAME : RawByteString = 'Relatorios';
    EXTRACTED_BASE_FOLDER_NAME : RawByteString = 'Base Extraida';
    HISTORY_FILE_NAME : RawByteString = './Historico_Consultas.txt';

    function GetReportsFolderRelativePath : String;
    function GetReportsFolderFullPath : String;

    function GetExtractedBaseFolderRelativePath : String;
    function GetExtractedBaseFolderFullPath : String;

    function GetHistoryFileFullPath : String;

    procedure ExecuteQuery(Query: String);
    procedure ExecuteQuery(Query: String; FileName: String);
    procedure SaveToHistoryFile(aTitle: String; aText: String);

    procedure ExtractDatabase;

    private

    function GenerateExtractDatabaseSQL(TablesList: TStringList) : String;

end;


var
  MainDataModule: TMainDataModule;

implementation

procedure TMainDataModule.DataSourceListTableDataChange(Sender: TObject; Field: TField);
begin

end;

procedure TMainDataModule.DataModuleCreate(Sender: TObject);
begin

end;

function TMainDataModule.GetReportsFolderRelativePath: string;
begin
     Result := './' + REPORTS_FOLDER_NAME;;
end;

function TMainDataModule.GetReportsFolderFullPath : string;
begin
     Result := GetCurrentDir + '\' + REPORTS_FOLDER_NAME;
end;

function TMainDataModule.GetExtractedBaseFolderRelativePath: string;
begin
     Result := './' + EXTRACTED_BASE_FOLDER_NAME;;
end;

function TMainDataModule.GetExtractedBaseFolderFullPath : string;
begin
     Result := GetCurrentDir + '\' + EXTRACTED_BASE_FOLDER_NAME;
end;

function TMainDataModule.GetHistoryFileFullPath : String;
var
  history_filename : string;
begin
     history_filename := HISTORY_FILE_NAME;
     history_filename := history_filename.Replace('./', '');
     Result := GetCurrentDir + '\' + history_filename;
end;

procedure TMainDataModule.ExecuteQuery(Query: String);
var
  ERROR_MESSAGE_TEMPLATE : String = 'Erro na Execução do Script, deseja abrir aquivo de histórico (%s)?';
  HISTORY_FILE_ERROR_TEMPLATE : String = '%s' + sLineBreak + '---------------------------' + sLineBreak + 'ERRO:' + sLineBreak + '%s';
begin
     SQLQuery.SQL.Clear;
     SQLQuery.SQL.AddText(Query);
     try
       SQLQuery.ExecSQL;
       SaveToHistoryFile('Executado com sucesso', Query);
     except
       On E :Exception do
          begin
            SQLTransaction.Rollback;
            SaveToHistoryFile('Erro na Execução da Consulta', Format(HISTORY_FILE_ERROR_TEMPLATE, [Query, E.Message]));
            if MessageDlg(MainDataModule.MESSAGE_TITLE, Format(ERROR_MESSAGE_TEMPLATE, [HISTORY_FILE_NAME]), mtError, [mbYes, mbNo], 0) = mrYes then
               OpenDocument(GetHistoryFileFullPath);
            raise;
          end;
     end;
end;

procedure TMainDataModule.ExecuteQuery(Query: String; FileName: String);
var
   ReportFullPath : RawByteString;
   ExportQuery : String;
begin
     ReportFullPath := GetReportsFolderFullPath + '\' + FileName + EXPORT_FILE_EXTENSION;
     Query := Query.Replace(';', '');
     ExportQuery := Format(EXPORT_SQL_TEMPLATE, [Query, ReportFullPath]);
     try
       ExecuteQuery(ExportQuery);
       OpenDocument(ReportFullPath);
     except
       MessageDlg(MainDataModule.MESSAGE_TITLE, 'Erro ao executar o Script. Sem relatórios para exibir', mtError, [mbOK], 0)
     end;
end;

procedure TMainDataModule.SaveToHistoryFile(aTitle: String; aText: String);
const
  TIMESTAMP_TEMPLATE : String = 'Horário: %s - %s';
var
  DataFile: TextFile;
begin
  AssignFile(DataFile, HISTORY_FILE_NAME);
  try
    Append(DataFile);
    WriteLn(DataFile, '/*----------------------------------------------');
    WriteLn(DataFile, aTitle);
    WriteLn(DataFile, Format(TIMESTAMP_TEMPLATE, [DateToStr(Date), TimeToStr(Time)]));
    WriteLn(DataFile, '----------------------------------------------*/');
    WriteLn(DataFile, aText);
    WriteLn(DataFile, '/*--------------------------------------------*/');
    WriteLn(DataFile, sLineBreak);
    CloseFile(DataFile);
  except
    ShowMessage('Erro ao salvar os dados');
  end;

end;

procedure TMainDataModule.ExtractDatabase;
var
  CurrentTableName : String;
  ExportFilePath : String;
  ExtractSQL : String;
begin

 while not SQLQueryListTable.Eof do
  begin
    SQLQuery.Clear;

    CurrentTableName := SQLQueryListTable.FieldByName('tablename').AsString;
    ExportFilePath := GetExtractedBaseFolderFullPath + '/' + CurrentTableName + EXPORT_FILE_EXTENSION;
    ExtractSQL := Format(EXTRACT_TABLE_SQL_TEMPLATE, [CurrentTableName, ExportFilePath]);

    SQLQuery.SQL.AddText(ExtractSQL);
    SQLQuery.ExecSQL;

    SQLQueryListTable.Next;
  end;

  MessageDlg(MainDataModule.MESSAGE_TITLE, 'Processo Concluído', mtInformation, [mbOK], 0)
end;

function TMainDataModule.GenerateExtractDatabaseSQL(TablesList: TStringList) : String;
begin
// TablesList.;
 Result := 'ABC'
end;

{$R *.lfm}

end.

