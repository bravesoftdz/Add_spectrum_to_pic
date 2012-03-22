unit colorimetry_lib_0_04;
(* ������ 0.04

��������� � v. 0.04
- ��������� ������� color_from_WL (���� - �� ����� �����, �.� �� ������ ������������ �����)
� color_from_Spectrum (���� - �� ��������� �������)
- Add_CCT ���������� - ������ ��� ����������� ����������� ����� ������� ����. ������������� �� �����������
- gamma_func ����� ���������, ����� �����-�������� ����� ���� ������������ � ���������
- ��������� gamma - �� �� �����-���������, �� ��� ��������� �� 255 � ��������� � ���� Integer

��������� � v. 0.03
- ��������� ���������� sat � desat, ���������, ��� ��������
� �������������� ����. r,g,b � �� ������� ��������.
sat=1 �������� ���������� �� ����. �������,
������� �������� - ���������� ���. ���������.
desat=0 - ���. �������� ���������� �� 0
=1 - ������������ ������� ������, ����� ������� ����. �� ��������

- ��������� ������� Clear, ����� �������� ������� r,g,b
- ��������� �����-���������

��������� � v 0.02
- ��������� ��������� ������� r,g,b, ����� � ������ ������ ���������
�������� ������ � ����� ��� ������������� �������������
- ������� ��� ���������� ����� ����� (r,g,b) - ��� ���������� ��������,
��� �����. ������������������ ��������� �������� ����� �����, ���
�����. ��������� ��� �������� �����������.
- �������� canvas, XLeft,XRight,YTop,YBottom - ��� ��������� ���� ������ �� ������
�������� draw.



*)


interface

uses
table_func_lib,graphics,math,windows,chart,TeeProcs,Series;

type
RGBf=record
  R,G,B: Real;
end;
colorimetry_funcs=class
  private
    xt,yt,zt: table_func;
    function XYZ2RGB(x:Real;y:Real;z:Real): RGBf;
    function XYZ2RGB_no_limit(x:Real;y:Real;z:Real): RGBf;
  public
    rt,gt,bt :table_func;
    canvas: TCanvas;
    XLeft,XRight,YTop,YBottom :Integer;
    desat :Real; //��������� �� "��������" ������ ���� ��������
    //���������������
    sat: Real; //��������� �� ����������� ������� ������
    procedure draw;
    function gamma_func(x: Real): Real;
    function gamma(x:Real): Integer;
    function ColorFromCCT(T: Real) :TColor;
    function ColorFromWL(wl: Real) :TColor;
    function ColorFromSpectrum(sp: table_func) :TColor;
    procedure AddRGB(X: Real; r:Real; g:Real; b:Real);
    procedure AddMonochr(X:Real; lambda: Real);
    procedure AddCCT(X:Real; CCT: Real);
    procedure Clear;
    constructor Create;
    destructor Destroy; override;
end;

implementation

constructor colorimetry_funcs.Create;
begin
  inherited Create;
  xt:=table_func.Create('data/x_vs_lambda.txt');
  yt:=table_func.Create('data/y_vs_lambda.txt');
  zt:=table_func.Create('data/z_vs_lambda.txt');
  rt:=table_func.Create;
  bt:=table_func.Create;
  gt:=table_func.Create;
  desat:=0;
  sat:=1;
end;

destructor colorimetry_funcs.Destroy;
begin
  xt.Free;
  yt.Free;
  zt.Free;
  rt.Free;
  gt.Free;
  bt.Free;
  inherited Destroy;
end;

function colorimetry_funcs.gamma_func(x: Real):Real;
begin
  if x<0.0031308 then gamma_func:=x*12.92
  else gamma_func:=(1+0.055)*power(x,1/2.4)-0.055;
end;

function colorimetry_funcs.gamma(x: Real): Integer;
begin
  if x<0.0031308 then gamma:=Round(x*12.92*255)
  else gamma:=Round(((1+0.055)*power(x,1/2.4)-0.055)*255);
end;

function colorimetry_funcs.XYZ2RGB(x:Real;y:Real;z:Real): RGBf;
var t:Real;
begin
  t:=3.063*x-1.393*y-0.476*z;
  if t<0 then t:=0;
  XYZ2RGB.R:=t;
  t:=-0.969*x+1.876*y+0.042*z;
  if t<0 then t:=0;
  XYZ2RGB.G:=t;
  t:=0.068*x-0.229*y+1.069*z;
  if t<0 then t:=0;
  XYZ2RGB.B:=t;
end;

function colorimetry_funcs.XYZ2RGB_no_limit(x:Real;y:Real;z:Real): RGBf;
begin
  XYZ2RGB_no_limit.R:=3.063*x-1.393*y-0.476*z;
  XYZ2RGB_no_limit.G:=-0.969*x+1.876*y+0.042*z;
  XYZ2RGB_no_limit.B:=0.068*x-0.229*y+1.069*z;
end;

function colorimetry_funcs.ColorFromCCT(T: Real) :TColor;
var maxlength,xrel: Real;
  xi,yi,zi: Real;
  sum,val: Real;
  i: Integer;
  col: RGBf;
begin
  maxlength:=2896000/T;
  xi:=0;
  yi:=0;
  zi:=0;
  for i:=380 to 780 do begin
    xrel:=i/maxlength;
    val:=142.32*power(xrel,-5)/(exp(4.9651/xrel)-1);
    xi:=xi+val*xt[i];
    yi:=yi+val*yt[i];
    zi:=zi+val*zt[i];
  end;
  sum:=xi+yi+zi;
//  col:=XYZ2RGB(xi,yi,zi);
  xi:=xi/sum;
  yi:=yi/sum;
//��� ���������� �� ���������

  col:=XYZ2RGB(xi,yi,1-xi-yi);
  sum:=max(col.R,max(col.G,col.B));

//    sum:=col.R+col.G+col.B;

  ColorFromCCT:=RGB(Round(col.R/sum*255),Round(col.G/sum*255),Round(col.B/sum*255));

end;

function colorimetry_funcs.ColorFromWL(wl: Real) :TColor;
var temp: RGBf;
    m: Real;
begin
//� ��� �� �����, ��� ��� �� �����...
//���, �����: ������ �� ����� ����� (wavelength)
//�����, ������� �����
temp:=XYZ2RGB(xt[wl],yt[wl],zt[wl]);
//���, ��������: � ���� �������� �� ���� �����-������� � ���������� ���������/���������.
//�� �������
m:=max(temp.R,max(temp.G,temp.B));
ColorFromWL:=RGB(gamma(temp.R/m),gamma(temp.G/m),gamma(temp.B/m));
end;


function colorimetry_funcs.ColorFromSpectrum(sp: table_func) :TColor;
var temp: table_func;
    x,y,z,m: Real;
    t_rgb: rgbf;
begin
//�� ��������� ������� �������� ����
//������������� ���������� � ��������������� ������� �� table_func_lib
temp:=table_func.Create;
temp.assign(xt);
temp.multiply(sp);
x:=temp.integrate;

temp.Clear;
temp.assign(yt);
temp.multiply(sp);
y:=temp.integrate;

temp.Clear;
temp.assign(zt);
temp.multiply(sp);
z:=temp.integrate;
temp.Free;

m:=max(x,max(y,z));
t_rgb:=XYZ2RGB(x,y,z);
ColorFromSpectrum:=RGB(gamma(t_rgb.R/m),gamma(t_rgb.G/m),gamma(t_rgb.B/m));
end;

procedure colorimetry_funcs.AddRGB(X:Real; r:Real; g:Real; b:Real);
begin
  rt.addpoint(X,r);
  gt.addpoint(X,g);
  bt.addpoint(X,b);
end;

procedure colorimetry_funcs.AddMonochr(X: Real;lambda:Real);
var temp: RGBf;
begin
  temp:=XYZ2RGB_no_limit(xt[lambda],yt[lambda],zt[lambda]);
  rt.addpoint(X,temp.R);
  gt.addpoint(X,temp.G);
  bt.addpoint(X,temp.B);
end;

procedure colorimetry_funcs.AddCCT(X: Real;CCT:Real);
var maxlength,xrel: Real;
  xi,yi,zi: Real;
  val: Real;
  i: Integer;
  col: RGBf;
  multiplier: Real;
begin
  maxlength:=2896000/CCT;
  //����� ��� �������� �� 142.32 � �� 1.04e-11 ��/��^3. �� �����...
  multiplier:=power(CCT,5);
  xi:=0;
  yi:=0;
  zi:=0;
  for i:=380 to 780 do begin
    xrel:=i/maxlength;
    val:=multiplier*power(xrel,-5)/(exp(4.9651/xrel)-1);
    xi:=xi+val*xt[i];
    yi:=yi+val*yt[i];
    zi:=zi+val*zt[i];
  end;
//  sum:=xi+yi+zi;
//  xi:=xi/sum;
//  yi:=yi/sum;
  col:=XYZ2RGB_no_limit(xi,yi,zi);
//  col:=XYZ2RGB_no_limit(xi,yi,1-xi-yi);
  rt.addpoint(X,col.R);
  gt.addpoint(X,col.G);
  bt.addpoint(X,col.B);
end;

procedure colorimetry_funcs.draw;
var i,l: Integer;
    r0,g0,b0: Real;
    mi,ma: Real;
    arg: Real;
begin
  l:=XRight-XLeft;
  mi:=-min(rt.ymin,min(gt.ymin,bt.ymin))*desat;
  ma:=max(rt.ymax,max(gt.ymax,bt.ymax))*sat+mi;
  for i:=0 to l do begin
    arg:=rt.xmin+i*(rt.xmax-rt.xmin)/l;
    r0:=rt[arg]+mi;
    if r0<0 then r0:=0;
    g0:=gt[arg]+mi;
    if g0<0 then g0:=0;
    b0:=bt[arg]+mi;
    if b0<0 then b0:=0;
    r0:=gamma_func(r0/ma)*255;
    g0:=gamma_func(g0/ma)*255;
    b0:=gamma_func(b0/ma)*255;
    if r0>255 then begin g0:=g0*255/r0; b0:=b0*255/r0; r0:=255; end;
    if g0>255 then begin r0:=r0*255/g0; b0:=b0*255/g0; g0:=255; end;
    if b0>255 then begin r0:=r0*255/b0; g0:=g0*255/b0; b0:=255; end;

    canvas.Pen.Color:=RGB(round(r0),round(g0),round(b0));
    canvas.MoveTo(i+XLeft,YTop);
    canvas.LineTo(i+xleft,YBottom);
  end;
end;

procedure colorimetry_funcs.Clear;
begin
  rt.Clear;
  gt.Clear;
  bt.Clear;
end;


end.
