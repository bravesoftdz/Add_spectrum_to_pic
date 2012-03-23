unit table_func_lib;
(*
version 0.72
изменения в 0.72
- позволяет на любом компьютере, независимо от региональных настроек, работать как с
точкой, так и с запятой в роли разделителя целой и дробной части

изменения в 0.71
- в явном виде возвращает ноль, если значение x вне области определения функции

изменения в 0.70
- процедура Draw смотрит минимальное и максимальное значения на графике, если они заданы
- в ней же вместо отрисовки по фактическому кол-ву пикселей по ширине, берется характерное значение для наших экранов - 1280 пикс.
- новый формат данных в документе, чтобы можно было указать порядок интерполяции, подписи к осям, имя графика,
описание, размерности и пр. Но надо оставить совместимость с прошлым форматом.
Секция [general]
title - название графика
Xname - подпись оси X
Yname - подпись оси Y
Xunit - размерность по X
Yunit - размерность по Y
order - порядок интерполяции
Секция [description]
В текстовом виде - комментарий к графику
Секция [data]
Пары x-y: собственно данные.

Комментарии - или ;, или //, или #
Можно пропускать строки

- исправлен глюк в update_spline, что только при порядке интерполяции 3 он сбрасывал флаг changed,
это среди прочего приводило к неправильной работе normalize. 


изменения в 0.63
исправлены серьезные ошибки:
- функция integrate проверяет переменную changed, если true, вызывает update_spline
- функция assign по умолчанию ставит changed=true, на случай, если исходная табл. функция еще не до конца построена
- в normalize, если максимум - ноль или меньше, нормализации не происходит
- наконец-то дописана процедура morepoints, но не в 16, а в 2 раза увел. количество точек

изменения в 0.62

введена булева переменная changed (private), она меняется на true, если поменялась
функция, но еще не была вызвана updatespline. Вызов updatespline в add_point убран.
Она вызывается из splinevalue, если функция поменялась. Таким образом, при добавлении
большого числа точек не будет происходить пересчета на каждой из них - только когда понадобится
знач. функции. Свойства minx,maxx,miny,maxy при обращении теперь вызывают функцию. Если были
изменения - вызывается updatespline

изменения в 0.61
добавлена процедура Clear - она стирает функцию, но оставляет привязку к графику

изменения в 0.6
убраны лишние переменные из addpoint

если пытаемся найти значение пустой функции, теперь выдается NAN

теперь класс table_func образован от TPersistent,
определена процедура assign, чтобы одному экземпляру класса
присвоить значение другого

поправлена функция AddPoint, в ней не был предусмотрен вариант, что
точка с такой же координатой X уже существует. Теперь в таком случае
старая точка заменяется новой.

добавлена функция перемножения двух table_func: multiply(by)
синтаксис:
dest.multiply(source)
что эквивалентно мнемонической записи
dest=dest*source

добавлена функция умножения на константу (перегруженная версия multiply
dest.multiply(100); - умножить на 100

добавлена функция взятия определенного интеграла
по всей области определения функции
value:=func.integrate;






изменения в 0.53:
добавлена перегруженная версия конструктора, чтобы загружать
функцию из файла одной строкой

добавлен параметр chart_series - ссылка на элемент TLineSeries,
процедура draw - чтобы автоматически нарисовать график.

изменения в 0.52:
добавлена функция addpoint(X,Y) - чтобы вставить в функцию новую точку
с автоматическим пересчетом сплайнов
и свойство enabled - оно становится true
только если есть хотя бы одна точка

изменения в 0.51:
- устранен глюк с access violation: в модуле update_spline
использовалась переменная-счетчик после цикла for, ее значение
было неустойчиво

- конструктор, со значением порядка интерполяции 3
по умолчанию (раньше назначался порядок 0, что редко бывает
нужно)

добавлено в 0.5:
интерполяция 0-го порядка (ступеньки)
1-го (соед. прямыми)
и 3-го (кубическими сплайнами)
порядок можно менять по ходу дела
добавлен параметр: мин. шаг, для оценки необходимого шага интегрирования и пр.
математических операций
добавлена функция нормализации по максимуму

*)

interface
uses SysUtils,math,TeEngine, Series, ExtCtrls, TeeProcs, Chart,classes;
type
  table_func=class(TPersistent)
    private
    ixmin,ixmax,iymin,iymax: Real;
    b,c,d :array of Real;  {a==Y}
    istep: Real;
    iOrder: Integer;
    changed: boolean;
    function splinevalue(xi:Real): Real;
    procedure update_spline();
    procedure update_order(new_value: Integer);
    function isen: Boolean;
    function get_step: Real;
    function get_xmin: Real;
    function get_xmax: Real;
    function get_ymin: Real;
    function get_ymax: Real;
    public
    X,Y: array of Real;
    chart_series: TLineSeries;
    title: string;
    Xname: string;
    Yname: string;
    Xunit: string;
    Yunit: string;
    description: string;


    property step: Real read get_step;
    property xmin: Real read get_xmin;
    property xmax: Real read get_xmax;
    property ymin: Real read get_ymin;
    property ymax: Real read get_ymax;
    property value[xi: Real]: Real read splinevalue; default;
    property order: Integer read iorder write update_order;
    function LoadFromFile(filename: string): Boolean;
    function OldLoadFromFile(filename: string): Boolean;
    procedure LoadConstant(new_Y:Real;new_xmin:Real;new_xmax:Real);
    procedure Clear;
    function SaveToFile(filename: string): Boolean;
    procedure normalize();
    procedure addpoint(Xn:Real;Yn:Real);
    property enabled: Boolean read isen;
    constructor Create; overload;
    constructor Create(filename: string); overload;
    procedure draw;
    procedure multiply(by: table_func); overload;
    procedure multiply(by: Real); overload;
    procedure assign(Source:TPersistent); override;
    function integrate: Real;
    procedure morepoints;
    end;
implementation

constructor table_func.Create;
begin
  inherited Create;
  iorder:=3;
  chart_series:=nil;
  changed:=false;
end;

constructor table_func.Create(filename: string);
begin
  inherited Create;
  iorder:=3;
  LoadFromFile(filename);
  chart_series:=nil;
end;

function table_func.isen: Boolean;
begin
  isen:=(Length(X)>0);
end;

function table_func.splinevalue(xi: Real): Real;
var i,j,k: Integer;
r: Real;
label found;
begin
  if changed then update_spline;

  if xi>xmax then begin
    splinevalue:=0;
    exit;
  end
  else if xi<xmin then begin
    splinevalue:=0;
    exit;
  end;
  

  {сначала двоичный поиск нужного отрезка сплайна}
  i:=0;
  j:=High(X);
  //цикл может не выполниться, если массив пустой (High(X)=-1)
  if j<i then begin
    splinevalue:=NAN;
    Exit;
  end;
  k:=0;
  while j>=i do begin
  k:=(i+j) shr 1;
  if xi<X[k] then j:=k-1
  else if xi>X[k] then i:=k+1 else goto found;
  end;
  if xi<X[k] then dec(k);
  if k<0 then begin splinevalue:=Y[0]; exit; end;
  found:
  r:=xi-X[k];
  splinevalue:=Y[k]+r*(b[k]+r*(c[k]+r*d[k]));
end;

procedure table_func.draw;
var i,w: Integer;
    t,st,t_xmin: Real;
begin
  if (chart_series<>nil) and isen then begin
//    w:=chart_series.ParentChart.ClientWidth;
    w:=1280;
    if chart_series.ParentChart.BottomAxis.Automatic then begin
      t_xmin:=xmin;
      st:=(xmax-t_xmin)/w;
    end
    else begin
      t_xmin:=chart_series.ParentChart.BottomAxis.Minimum;
      st:=(chart_series.ParentChart.BottomAxis.Maximum-t_xmin)/w;
    end;
    chart_series.Clear;
    for i:=0 to w do begin
      t:=t_xmin+st*i;
      chart_series.AddXY(t,splinevalue(t));
    end;
  end;
end;


procedure table_func.update_spline;
var i,j: Integer;
    h,alpha,l,mu,z: array of Real; {для вычисления сплайнов}
begin
    changed:=false;
    i:=Length(X);
    j:=i-1;
    Setlength(b,i);
    Setlength(c,i);
    Setlength(d,i);
//макс и мин значения
    ixmin:=X[0];
    ixmax:=ixmin;
    iymin:=Y[0];
    iymax:=iymin;
    for i:=1 to j do begin
      if X[i]<ixmin then ixmin:=X[i];
      if X[i]>ixmax then ixmax:=X[i];
      if Y[i]<iymin then iymin:=Y[i];
      if Y[i]>iymax then iymax:=Y[i];
    end;
    istep:=X[1]-X[0];
    for i:=2 to j do begin
      if (X[i]-X[i-1])<istep then istep:=X[i]-X[i-1];
    end;
//собственно сплайны
    for i:=0 to j do begin
      b[i]:=0;
      c[i]:=0;
      d[i]:=0;
    end;
    if iorder=0 then exit
    else begin
      SetLength(h,j+1);
      for i:=0 to j-1 do h[i]:=X[i+1]-X[i];
      if iorder=1 then begin
        for i:=0 to j-1 do b[i]:=(Y[i+1]-Y[i])/h[i];
        exit;
      end;
      Setlength(alpha,j+1);
      SetLength(l,j+1);
      SetLength(mu,j+1);
      SetLength(z,j+1);


      for i:=1 to j-1 do alpha[i]:=3/h[i]*(Y[i+1]-Y[i])-3/h[i-1]*(Y[i]-Y[i-1]);
      l[0]:=1;
      mu[0]:=0;
      z[0]:=0;
        for i:=1 to j-1 do begin
        l[i]:=2*(X[i+1]-X[i-1])-h[i-1]*mu[i-1];
        mu[i]:=h[i]/l[i];
        z[i]:=(alpha[i]-h[i-1]*z[i-1])/l[i];
      end;
      l[j]:=1;
      z[j]:=0;
      c[j]:=0;
      for i:=j-1 downto 0 do begin
        c[i]:=z[i]-mu[i]*c[i+1];
        b[i]:=(Y[i+1]-Y[i])/h[i]-h[i]*(c[i+1]+2*c[i])/3;
        d[i]:=(c[i+1]-c[i])/3/h[i];
      end;
    end;
end;

procedure table_func.update_order(new_value: Integer);
begin
iOrder:=new_value;
changed:=true;
end;

procedure table_func.addpoint(Xn:Real;Yn:Real);
var i,k,l: Integer;
begin
  l:=Length(X);
  i:=0;
  SetLength(X,l+1);
  SetLength(Y,l+1);
  X[l]:=Xn+1;
  while (Xn>X[i]) do inc(i);
  //i будет указывать на максимальный элемент, меньший Xn
  //проверим, а вдруг совпадает
  if Xn=X[i] then begin
    X[i]:=Xn;
    Y[i]:=Yn;
    SetLength(X,l);
    SetLength(Y,l);
    Exit;
  end;
  //теперь вставляем в нужное место
  k:=l-1;
  while k>=i do begin
  X[k+1]:=X[k];
  Y[k+1]:=Y[k];
  dec(k);
  end;
  X[i]:=Xn;
  Y[i]:=Yn;
  changed:=true;
end;

function table_func.LoadFromFile(filename: string): Boolean;
var F: TextFile;
    s0,s,t: string;
    i,j,k: Integer;
    section: (general,descr,data);
    separator: char;
    formatSettings : TFormatSettings;
begin
try
  GetLocaleFormatSettings($0800, formatSettings);
  separator:=formatsettings.DecimalSeparator;

  LoadFromFile:=false;
  assignFile(F,filename);
  Reset(F);
  Setlength(X,1);
  SetLength(Y,1);
  section:=data;
  i:=0;



  repeat
    ReadLn(F,s);
    //пропустим пробелы и табуляцию
    j:=1;
      while (j<=Length(s)) and ((s[j]=' ') or (s[j]=#9)) do inc(j);
    //и в конце строки тоже
    k:=Length(s);
      while (k>=j) and ((s[k]=' ') and (s[k]=#9)) do dec(k);
    t:=copy(s,j,k+1-j);
    s0:=uppercase(t);
    if (s0='[GENERAL]') then begin section:=general; continue; end;
    if (s0='[DESCRIPTION]') then begin section:=descr; continue; end;
    if (s0='[DATA]') then begin section:=data; continue; end;
    if section=general then begin
      k:=Length(t);
      s0:=copy(s0,1,6);
      if (s0='TITLE=') then begin title:=copy(t,7,k); continue; end;
      if (s0='XNAME=') then begin Xname:=copy(t,7,k); continue; end;
      if (s0='YNAME=') then begin Yname:=copy(t,7,k); continue; end;
      if (s0='XUNIT=') then begin Xunit:=copy(t,7,k); continue; end;
      if (s0='YUNIT=') then begin Yunit:=copy(t,7,k); continue; end;
      if (s0='ORDER=') then begin order:=StrToInt(copy(t,7,k)); continue; end;
    end;
    if section=descr then begin
      description:=concat(description,s);
    end;
    if section=data then begin
      if ((s[1]<>'/') or (s[2]<>'/')) and (s[1]<>'[') and (length(s)>2) then begin
      {skip spaces}
      j:=1;
      while (j<=Length(s)) and ((s[j]=' ') or (s[j]=#9)) do inc(j);
      {find end of number}
      k:=j;
      while (k<=Length(s)) and ((s[k]<>' ') and (s[k]<>#9)) do begin
        if (s[k]='.') or (s[k]=',') then s[k]:=separator;
        inc(k);
      end;
      {manage dynamic array in asimptotically fast way}
      if (High(X)<i) then begin
        Setlength(X,2*Length(X));
        SetLength(Y,2*Length(Y));
      end;
      {assigning values}
      X[i]:=StrToFloat(copy(s,j,k-j));
      {skip spaces}
      j:=k;
      while (j<=Length(s)) and ((s[j]=' ') or (s[j]=#9)) do inc(j);
      {find end of number}
      k:=j;
      while (k<=Length(s)) and ((s[k]<>' ') and (s[k]<>#9)) do begin
          if (s[k]='.') or (s[k]=',') then s[k]:=separator;
          inc(k);
      end;
      Y[i]:=StrToFloat(copy(s,j,k-j));
      inc(i);
    end;
  end;

  until eof(F);
    if i>0 then begin
    Setlength(X,i);
    SetLength(Y,i);
    {вычислим мин. и макс. значения}
    changed:=true;
    {Теперь определить макс/мин значения, посчитать коэф. сплайнов}
    LoadFromFile:=true;
    end
    else LoadFromFile:=false;
finally
Closefile(F);
end;
end;


function table_func.OldLoadFromFile(filename:string): Boolean;
var F: TextFile;
    s: string;
    i,j,k: Integer;

begin
try
  OldLoadFromFile:=false;
  assignFile(F,filename);
  Reset(F);
  Setlength(X,1);
  SetLength(Y,1);
  i:=0;
  repeat
    Readln(F,s);
    {check if this is commentary}
    if ((s[1]<>'/') or (s[2]<>'/')) and (s[1]<>'[') and (length(s)>2) then begin
      {skip spaces}
      j:=1;
      while (j<=Length(s)) and ((s[j]=' ') or (s[j]=#9)) do inc(j);
      {find end of number}
      k:=j;
      while (k<=Length(s)) and ((s[k]<>' ') and (s[k]<>#9)) do begin
        if s[k]='.' then s[k]:=',';
        inc(k);
      end;
      {manage dynamic array in asimptotically fast way}
      if (High(X)<i) then begin
        Setlength(X,2*Length(X));
        SetLength(Y,2*Length(Y));
      end;
      {assigning values}
      X[i]:=StrToFloat(copy(s,j,k-j));
      {skip spaces}
      j:=k;
      while (j<=Length(s)) and ((s[j]=' ') or (s[j]=#9)) do inc(j);
      {find end of number}
      k:=j;
      while (k<=Length(s)) and ((s[k]<>' ') and (s[k]<>#9)) do begin
          if s[k]='.' then s[k]:=',';
          inc(k);
      end;
      Y[i]:=StrToFloat(copy(s,j,k-j));
      inc(i);
    end;
  until eof(F);
  if i>0 then begin
    Setlength(X,i);
    SetLength(Y,i);
    {вычислим мин. и макс. значения}
    changed:=true;
    {Теперь определить макс/мин значения, посчитать коэф. сплайнов}
  OldLoadFromFile:=true;
  end
  else OldLoadFromFile:=false;
finally
Closefile(F);
end;
end;

function table_func.SaveToFile(filename: string): Boolean;
var F: TextFile;
    i: Integer;
    old_format: boolean;
begin
  try
  SaveToFile:=false;
  assignFile(F,filename);
  Rewrite(F);
  old_format:=true;
  if (title<>'') or (Xname<>'') or (Yname<>'') or (Xunit<>'') or (Yunit<>'') or (iorder<>3) then
    begin
      Writeln(F,'[general]');
      if (title<>'') then WriteLn(F,'title='+title);
      if (Xname<>'') then WriteLn(F,'Xname='+Xname);
      if (Yname<>'') then Writeln(F,'Yname='+Yname);
      if (Xunit<>'') then Writeln(F,'Xunit='+Xunit);
      if (Yunit<>'') then WriteLn(F,'Yunit='+Yunit);
      WriteLn(F,'order='+IntToStr(order));
      old_format:=false;
    end;
  if (description<>'') then
    begin
      Writeln(F,'[description]');
      Writeln(F,description);
      old_format:=false;
    end;
  if (old_format=false) then WriteLn(F,'[data]');


  for i:=0 to Length(X)-1 do begin
    Writeln(F,FloatToStr(X[i])+#9+FloatToStr(Y[i]));
  end;
  SaveToFile:=true;
  finally
  Closefile(F);
  end;
end;

procedure table_func.LoadConstant(new_Y:Real;new_xmin:Real;new_xmax:Real);
begin
    Setlength(X,1);
    SetLength(Y,1);
    Setlength(b,1);
    Setlength(c,1);
    Setlength(d,1);
    ixmin:=new_xmin;
    ixmax:=new_xmax;
    iymin:=new_Y;
    iymax:=iymin;
    X[0]:=ixmin;
    Y[0]:=iymin;
    b[0]:=0;
    c[0]:=0;
    d[0]:=0;
    istep:=ixmax-ixmin;
    changed:=false;
end;

procedure table_func.normalize;
var i: Integer;
    ym: Real;
begin
(*
  ym:=ymax;
  if ym>0 then begin
    for i:=0 to Length(Y)-1 do Y[i]:=Y[i]/ym;
    changed:=true;
  end;
*)
  if ymax>0 then begin
    for i:=0 to Length(Y)-1 do
      begin
    Y[i]:=Y[i]/ymax;
      end;
    changed:=true;
  end;


end;

procedure table_func.multiply(by: table_func);
var i,ls,ld: Integer;
    Yt: array of Real;
    abs_min,abs_max: Real;
begin

  //xmin, xmax и прочее переделает update_spline
  //нам надо лишь перемножить отдельные точки
  ls:=High(by.X);
  SetLength(Yt,ls+1);
  for i:=0 to ls do Yt[i]:=by.Y[i]*splinevalue(by.X[i]);

  ld:=High(X);
  for i:=0 to ld do Y[i]:=Y[i]*by[X[i]];

  for i:=0 to ls do addpoint(by.X[i],Yt[i]);
  changed:=true;

  //попробуем срезать область определения по мин.
  (*
  abs_min:=max(xmin,by.xmin);
  abs_max:=min(xmax,by.xmax);
  *)
end;

procedure table_func.multiply(by: Real);
var i,ld: Integer;
begin
  if changed then update_spline;
  ld:=High(Y);
  for i:=0 to ld do begin
     Y[i]:=Y[i]*by;
     b[i]:=b[i]*by;
     c[i]:=c[i]*by;
     d[i]:=d[i]*by;
  end;
  iymin:=iymin*by;
  iymax:=iymax*by;
end;


procedure table_func.assign(source: TPersistent);
var s: table_func;
begin
  if Source is table_func then
  begin
    s:=table_func(source);
    ixmin:=S.ixmin;
    ixmax:=s.ixmax;
    iymin:=s.iymin;
    iymax:=s.iymax;
    istep:=s.istep;
    iOrder:=s.iOrder;

    title:=s.title;
    XName:=s.Xname;
    YName:=s.Yname;
    XUnit:=s.Xunit;
    YUnit:=s.Yunit;
    description:=s.description;
    //chart_series НЕ ТРОГАЕМ! Копируем функцию, но не интерфейс
    X:=copy(s.X,0,MaxInt);
    Y:=copy(s.Y,0,MaxInt);
    b:=copy(s.b,0,MaxInt);
    c:=copy(s.c,0,MaxInt);
    d:=copy(s.d,0,MaxInt);
    changed:=true;
  end else
    inherited Assign(Source);
end;

function table_func.integrate: Real;
var i,l: Integer;
    tmp,dif: Real;
begin
    if changed then update_spline;
    tmp:=0;
    l:=High(X)-1;
    for i:=0 to l do begin
      dif:=X[i+1]-X[i];
      tmp:=tmp+dif*(Y[i]+dif*(b[i]/2+dif*(c[i]/3+dif*d[i]/4)));
    end;
    integrate:=tmp;
end;

procedure table_func.Clear;
begin
//очищаем функцию, но не интерфейс!
  SetLength(X,0);
  SetLength(Y,0);
  SetLength(b,0);
  SetLength(c,0);
  SetLength(d,0);
  ixmin:=0;
  ixmax:=0;
  iymin:=0;
  iymax:=0;
  istep:=0;
  title:='';
  Xname:='';
  Yname:='';
  Xunit:='';
  Yunit:='';
  description:='';
  changed:=false;
end;

procedure table_func.morepoints;
var i,j,k: Integer;
  Yt: array of Real;
begin
//увеличить в 2 раза количество точек
update_spline;
j:=Length(X)-1;
if j<=0 then exit;
i:=2*j; //конец массива
SetLength(Yt,j);
for k:=0 to j-1 do begin
  Yt[k]:=splinevalue((X[k]+X[k+1])/2);
end;

SetLength(X,i+1);
SetLength(Y,i+1);


for k:=j downto 1 do begin
  X[i]:=X[k];
  Y[i]:=Y[k];
  dec(i);
  X[i]:=(X[k]+X[k-1])/2;
  Y[i]:=Yt[k-1];
  dec(i);
end;
changed:=true;
end;

function table_func.get_step :Real;
begin
  if changed then update_spline;
  get_step:=istep;
end;

function table_func.get_xmin :Real;
begin
  if changed then update_spline;
  get_xmin:=ixmin;
end;

function table_func.get_xmax :Real;
begin
  if changed then update_spline;
  get_xmax:=ixmax;
end;

function table_func.get_ymin :Real;
begin
  if changed then update_spline;
  get_ymin:=iymin;
end;

function table_func.get_ymax :Real;
begin
  if changed then update_spline;
  get_ymax:=iymax;
end;

end.
