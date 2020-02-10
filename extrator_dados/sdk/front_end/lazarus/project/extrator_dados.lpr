program extrator_dados;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, MainForm, main_datamodule;

begin
  RequireDerivedFormResource:=True;
  Application.Title:='Extrator de Dados E-SUS 0.0.1';
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TMainDataModule, MainDataModule);
  Application.CreateForm(TApplicationMainForm, ApplicationMainForm);
  Application.Run;
end.

