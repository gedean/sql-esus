unit rest_api_datamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fphttpclient, fpjson, jsonparser;

type

  { TRestApiDataModule }

  TRestApiDataModule = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
  private

  public
    procedure test;
  end;

var
  RestApiDataModule: TRestApiDataModule;

implementation

{$R *.lfm}

{ TRestApiDataModule }

procedure TRestApiDataModule.DataModuleCreate(Sender: TObject);
begin

end;

procedure TRestApiDataModule.test;
begin

end;

end.

