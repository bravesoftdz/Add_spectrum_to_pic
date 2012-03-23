program AddSpectrum2Pic;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {Form2},
  MZLib in '..\GraphicEx\MZLib.pas',
  GraphicColor in '..\GraphicEx\GraphicColor.pas',
  GraphicCompression in '..\GraphicEx\GraphicCompression.pas',
  GraphicEx in '..\GraphicEx\GraphicEx.pas',
  GraphicStrings in '..\GraphicEx\GraphicStrings.pas',
  JPG in '..\GraphicEx\JPG.pas',
  table_func_lib in 'table_func_lib.pas',
  colorimetry_lib in 'colorimetry_lib.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Add Spectrum to Pic';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
