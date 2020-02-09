unit main_datamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, BufDataset, pqconnection, sqldb, Dialogs, lclintf, db;

type

  { TMainDataModule }

  TMainDataModule = class(TDataModule)
    DatabaseConnection: TPQConnection;
    SQLQuery: TSQLQuery;
    SQLTransaction: TSQLTransaction;
  private

  public
    const
    REPORTS_FOLDER_NAME : RawByteString = 'Relatorios';
    HISTORY_FILE_NAME : RawByteString = './Historico_Consultas.txt';

    function GetReportsFolderRelativePath : String;
    function GetReportsFolderFullPath : String;
    procedure ExecuteQuery(Query: String);
    procedure ExecuteQuery(Query: String; FileName: String);
    procedure SaveToHistoryFile(aTitle: String; aText: String);
end;


var
  MainDataModule: TMainDataModule;

implementation

function TMainDataModule.GetReportsFolderRelativePath: string;
begin
     Result := './' + REPORTS_FOLDER_NAME;;
end;

function TMainDataModule.GetReportsFolderFullPath : string;
begin
     Result := GetCurrentDir + '\' + REPORTS_FOLDER_NAME;
end;

procedure TMainDataModule.ExecuteQuery(Query: String);
begin
     SQLQuery.SQL.Clear;
     SQLQuery.SQL.AddText(Query);
     try
       SQLQuery.ExecSQL;
     except
       on E: EPQDatabaseError do
          begin
            SQLTransaction.Rollback;
            SaveToHistoryFile('Erro na Execução da Consulta', Query);
          end;
     end;
end;

procedure TMainDataModule.ExecuteQuery(Query: String; FileName: String);
const
   EXPORT_SQL_TEMPLATE: String = 'COPY ( %s ) TO ''%s'' DELIMITER '';'' CSV HEADER ENCODING ''LATIN1'';';
   EXPORT_FILE_EXTENSION: String = '.csv';
var
   ReportFullPath : RawByteString;
   ExportQuery : String;
begin
     ReportFullPath := GetReportsFolderFullPath + '\' + FileName + EXPORT_FILE_EXTENSION;
     Query := Query.Replace(';', '');
     ExportQuery := Format(EXPORT_SQL_TEMPLATE, [Query, ReportFullPath]);
     ExecuteQuery(ExportQuery);
     OpenDocument(ReportFullPath)
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

{$R *.lfm}

end.

