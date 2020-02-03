unit MainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ActnList, main_datamodule, lclintf;

type

  { TApplicationMainForm }

  TApplicationMainForm = class(TForm)
    ActionExecQuery: TAction;
    ActionList1: TActionList;
    Button1: TButton;
    procedure ActionExecQueryExecute(Sender: TObject);
  private

  public

  end;

var
  ApplicationMainForm: TApplicationMainForm;

implementation

{$R *.lfm}

{ TApplicationMainForm }

procedure TApplicationMainForm.ActionExecQueryExecute(Sender: TObject);
begin
  MainDataModule.SQLQuery1.ExecSQL;
  OpenDocument('C:\RELATORIOS_ESUS\CADASTRO_CIDADAO_DUPLICADO.csv')
end;

end.

