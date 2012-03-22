unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,ShellApi;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Image1: TImage;
    Label5: TLabel;
    procedure Label5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Label5Click(Sender: TObject);
begin
  ShellExecute(handle, 'open', 'mailto:nabbla@yandex.ru', nil, nil, SW_SHOW);
end;

end.
