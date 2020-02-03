unit main_datamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, BufDataset, pqconnection, sqldb;

type

  { TMainDataModule }

  TMainDataModule = class(TDataModule)
    EsusConnection: TPQConnection;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
  private

  public


  end;

var
  MainDataModule: TMainDataModule;

implementation

{$R *.lfm}



end.

