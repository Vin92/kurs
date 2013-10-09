unit interf;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, windows,interf2, interf10;

const
count=9; //число вершин в полигоне

type

  { TForm1 }

  TForm1 = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    //procedure Timer2Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1;
  mouse:TPoint;
  a,a1:byte;
  a0, x_sdvig:integer;
  points: array[1..count] of TPoint;
  CutRegion: LongWord;
  time, zn_timer2:integer;
  at,xt, yt, ayt:real;
  axt2, xt2:real;
  ns0, ns1, napr_bool, zakr_pan, panell_on:boolean;
  new_str2, new_str3:string;
  tm:boolean;

procedure soobchenie(str1, str2:string; t:integer; nbool:boolean);
procedure soobchenie_otr(var t:integer);
procedure soobchenie_on_off;
procedure otrisovka;
implementation

{$R *.lfm}


procedure soobchenie_on_off;
begin
    a+=a1-1;
    //x_sdvig:=-1;
    Form1.alphaBlendValue := a * 3;
    Form2.alphaBlendValue := a * 2;
    Form10.alphaBlendValue := a * 3;
    if a <= 0 then
    begin
        /////////Form1.Timer2.enabled:=false;
         tm:=false;
        panell_on := false;
        form2.visible:=false;
        form1.visible:=false;
        Form10.visible:=false;
    end;
    //if otl then vplayer.memo1.lines.Add('alphaBlendValue'+intToStr(a));
end;
procedure soobchenie_otr(var t:integer);
begin
    a1:=1;
    if a < 75 then a1 := 2;
    if (a > 0) and (a0 > t) then  a1:= 0;
    a0+=1;
    soobchenie_on_off;
    if zakr_pan then
    begin
         mouse.x:=screen.width-320;
         mouse.y:=screen.Height-150;
    end
    else
        getcursorpos(mouse);
    form1.left := mouse.x+6;
    form1.top := mouse.y+9;
    form2.left := mouse.x + (((screen.width div 2) - mouse.x) div 25);
    form2.top := mouse.y-25;
    if form1.Label2.width > 261 then
    begin
       //xt := form1.Label2.Left;
       if xt <= ((299 - form1.Label2.Width) div 2) then at += 0.01 else at -= 0.01;
       xt += at;
       form1.Label2.Left := round(xt);
    end;
    if not ns0 then
    begin
         if ((form1.label2.top < 50) and napr_bool) or ((form1.label2.top > -10) and (not napr_bool)) then
         begin
              ayt += 0.08;
              if napr_bool then
                  yt += (ayt * ayt)
              else yt -=(ayt * ayt);
         end
         else
         begin
              if napr_bool then
              begin
                  form1.label2.top := -10;//сверху вниз
                  yt:=-10;
              end
              else
              begin
                  form1.label2.top := 50;//снизу вверх
                  yt:=50;
              end;
              ns0 := true;
              form1.label2.Caption := new_str2;
              at:=0.0;
              form1.Label2.Left := 19;//300 - (form1.Label2.Width);
              xt := form1.Label2.Left;
         end;
    end
    else
    begin
         ayt := (20 - yt)/5;
         yt += ayt;
    end;
    //
    if not ns1 then
    begin
        if (((form1.Label1.Left)<360) and ( not napr_bool)) or (((form1.label1.Width+form1.Label1.Left)>(8{-form1.label1.Width})) and napr_bool) then
        begin
             axt2+=0.15;
             if  not napr_bool then
                  xt2 += (axt2 * axt2* axt2)
              else xt2 -=(axt2 * axt2* axt2);
        end
        else
        begin

              form1.label1.Caption := new_str3;
              if not napr_bool then
              begin
                   form1.label1.Left := 4 - form1.label1.Width;
                   xt2:=4 - form1.label1.Width;
              end
              else
              begin
                   form1.label1.Left := 360;
                   xt2:=360;
              end;
              ns1 := true;
        end;
    end
    else
    begin
         axt2:=(8-xt2)/5.4;
         xt2 += axt2;
    end;

    //
    form1.label2.top := round(yt);
    form1.label1.left := round(xt2);
end;
procedure soobchenie(str1, str2:string; t:integer; nbool:boolean);
begin
     napr_bool := nbool;//true - вниз, false - вверх
     if not tm then
     begin
         //////////////Form1.Timer2.enabled:=true;
         tm:=true;
         x_sdvig := 0;
         a:=1;
         a0:=0;
     end
     else
     begin
         a0:=76;
     end;
     form2.visible:=true;
     form1.visible:=true;
     Form10.visible:=true;
     /////////Form1.Timer2.enabled:=true;
     tm:=true;
     panell_on := true;
     //new_start:=false;
     //new_str2 := ' ';
     new_str2 := str2;
     //form1.Label1.caption := str1;
     new_str3 := str1;
     if form1.label2.Caption <> str2 then
     begin
          //at:=0.0;
          //form1.Label2.Left := 19;//300 - (form1.Label2.Width);
          //xt := form1.Label2.Left;
          ///////
          //new_start:=true;
          ns0:=false;
          //ns1:=false;
          //form1.label2.top:=-10;
          ///////
     end;
     if form1.label1.Caption <> str1 then
     begin
         ns1:=false;
     end;
     //form1.label2.Caption := str2;
     time:=t;
     soobchenie_otr(t);
end;

{ TForm1 }

//procedure TForm1.Timer2Timer(Sender: TObject);  //<---не используется
//begin
     //form1.timer2.interval := zn_timer2;
     //soobchenie_otr(time);
//end;

procedure otrisovka;
begin
     soobchenie_otr(time);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   points[1].X:=1; points[1].Y:=1; //1 точка
   points[2].X:=200; points[2].Y:=1; //2 точка
   points[3].X:=211; points[3].Y:=11; //3 точка
   points[4].X:=299; points[4].Y:=11; //4 точка
   points[5].X:=299; points[5].Y:=59; //5 точка
   points[6].X:=100; points[6].Y:=59; //6 точка
   points[7].X:=97; points[7].Y:=56; //7 точка
   points[8].X:=1; points[8].Y:=56; //8 точка
   points[9].X:=1; points[9].Y:=1; //9 точка
   CutRegion:=CreatePolygonRgn(points, count, ALTERNATE);
   SetWindowRgn(Handle, CutRegion, True);
   tm:=true;
end;


end.

