unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtDlgs, StdCtrls, ExtCtrls, colorimetry_lib_0_04,
  table_func_lib, Buttons,unit2,graphicEx,Clipbrd;
type
  TForm1 = class(TForm)
    Button1: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    GroupBox2: TGroupBox;
    txtLMin: TLabeledEdit;
    txtLMax: TLabeledEdit;
    chkLLog: TCheckBox;
    GroupBox3: TGroupBox;
    txtMinT: TLabeledEdit;
    txtMaxT: TLabeledEdit;
    chkTLog: TCheckBox;
    BtnBegin: TSpeedButton;
    BtnEnd: TSpeedButton;
    Button2: TButton;
    GroupBox4: TGroupBox;
    txtDesat: TLabeledEdit;
    txtSat: TLabeledEdit;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    Button3: TButton;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    OpenDialog1: TOpenDialog;
    BitBtn1: TBitBtn;
    btnClipBoard: TButton;
    Timer1: TTimer;
    SaveDialog1: TSaveDialog;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure btnClipBoardClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  btmp: TBitmap;
  opened: boolean;
  point1,point2 :boolean;
  Xleft,Xright,Yl,Yr,w :Integer;
  sp: colorimetry_funcs;
  the_law: table_func;
implementation

{$R *.dfm}
procedure reset_image;
begin
  with form1 do begin
    image1.Picture.Bitmap.Assign(btmp);
//    image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
    ScrollBox1.VertScrollBar.Range:=image1.picture.Height;
    ScrollBox1.HorzScrollBar.Range:=image1.picture.Width;
    image1.Width:=image1.Picture.Width;
    image1.Height:=image1.Picture.Height;
  end;
end;

procedure draw_sp;
var i: Integer;
  mi,k :Real;
  
begin
  if (point1 and point2) then begin
    sp.Clear;
    reset_image;
    if form1.RadioButton1.Checked then begin
      mi:=StrToFloat(form1.txtLMin.Text);
      k:=StrToFloat(form1.txtLMax.Text);
      k:=(k-mi)/1000;
      for i:=0 to 1000 do sp.AddMonochr(i,mi+i*k);
    end
    else begin
      if form1.chkTLog.Checked then begin
        mi:=ln(StrToFloat(form1.txtMinT.Text));
        k:=ln(StrToFloat(form1.txtMaxT.Text));
        k:=(k-mi)/1000;
        for i:=0 to 1000 do sp.AddCCT(i,exp(mi+i*k));
      end
      else begin
        if form1.CheckBox1.Checked then begin
          mi:=StrToFloat(form1.txtMinT.Text);
          k:=StrToFloat(form1.txtMaxT.Text);
          k:=(k-mi)/1000;
          for i:=0 to 1000 do sp.AddCCT(i,the_law[mi+i*k]);
        end
        else begin
          mi:=StrToFloat(form1.txtMinT.Text);
          k:=StrToFloat(form1.txtMaxT.Text);
          k:=(k-mi)/1000;
          for i:=0 to 1000 do sp.AddCCT(i,mi+i*k);
        end;
      end;
    end;
    sp.XLeft:=XLeft;
    sp.XRight:=XRight;
    sp.YTop:=Yl;
    sp.YBottom:=Yr;
    sp.canvas:=form1.image1.canvas;
    sp.sat:=StrToFloat(form1.txtSat.Text);
    sp.desat:=StrToFloat(form1.txtDesat.Text);
    sp.draw;
  end;


end;



procedure TForm1.Button1Click(Sender: TObject);
var pic: TPicture;
begin
  if OpenPictureDialog1.Execute then begin
    pic:=TPicture.Create;
    pic.LoadFromFile(OpenPictureDialog1.FileName);
    btmp.Height:=pic.Height;
    btmp.Width:=pic.Width;
    btmp.Canvas.Draw(0,0,pic.Graphic);
    pic.Free;

    reset_image;

    opened:=true;
    btnBegin.Down:=true;
    point1:=false;
    point2:=false;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  opened:=false;
  point1:=false;
  point2:=false;
  sp:=colorimetry_funcs.Create;
  the_law:=table_func.Create;
  btmp:=TBitmap.Create;
//  sp.canvas:=image1.Canvas;
end;

procedure TForm1.RadioButton1Click(Sender: TObject);
begin
  txtMinT.Enabled:=false;
  txtMaxT.Enabled:=false;
  chkTLog.Enabled:=false;
  txtLMin.Enabled:=true;
  txtLMax.Enabled:=true;
  chkLLog.Enabled:=true;
end;

procedure TForm1.RadioButton2Click(Sender: TObject);
begin
  txtMinT.Enabled:=true;
  txtMaxT.Enabled:=true;
  chkTLog.Enabled:=true;
  txtLMin.Enabled:=false;
  txtLMax.Enabled:=false;
  chkLLog.Enabled:=false;
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if BtnBegin.Down then begin
     XLeft:=X;
     Yl:=Y;
     BtnEnd.Down:=true;
     point1:=true;
     draw_sp;
  end
  else begin
    XRight:=X;
    Yr:=Y;
    point2:=true;
    draw_sp;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
sp.Free;
the_law.Free;
btmp.Free;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  draw_sp;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if SaveDialog1.Execute then begin
//    if SavePictureDialog1.FilterIndex=1 then
      image1.Picture.SaveToFile(SaveDialog1.FileName);
//    else
//      SavePictureDialog1.Filter
  end;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then begin
    if OpenDialog1.Execute then begin
      the_law.LoadFromFile(OpenDialog1.FileName);
      label1.Caption:=OpenDialog1.FileName;
    end
    else checkbox1.Checked:=false;
  end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  Form2.ShowModal;
end;

procedure TForm1.btnClipBoardClick(Sender: TObject);
begin
  btmp.Assign(Clipboard);
  reset_image;
  BtnBegin.Down:=true;
  point1:=false;
  point2:=false;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
    BtnClipBoard.Enabled:=Clipboard.HasFormat(CF_BITMAP);
end;

end.
