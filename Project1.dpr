program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  USend in 'USend.pas' {FormSend};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Mooover';
  Application.CreateForm(TForm1, Form1);
  Application.ShowMainForm:=true;
  Application.Run;
end.
