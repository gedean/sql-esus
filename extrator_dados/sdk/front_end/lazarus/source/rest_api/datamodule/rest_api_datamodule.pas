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
    procedure Testa;
  end;

var
  RestApiDataModule: TRestApiDataModule;

implementation

{$R *.lfm}

{ TRestApiDataModule }

procedure TRestApiDataModule.Testa;
begin

end;

end.

