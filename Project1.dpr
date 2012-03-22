program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  colorimetry_lib_0_04 in 'colorimetry_lib_0_04.pas',
  Unit2 in 'Unit2.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Add Spectrum to Pic';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
