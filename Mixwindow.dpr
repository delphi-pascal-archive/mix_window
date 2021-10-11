program Mixwindow;

uses
  Forms,
  Mw in 'Mw.pas' {Form1};

{$D SCRNSAVE Random square windows}

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
