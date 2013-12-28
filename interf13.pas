unit interf13;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls, windows, interf;

const
count=15; //число вершин в полигоне
type

  { TForm13 }

  TForm13 = class(TForm)
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure d_visiable();
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form13: TForm13;
  ch:integer;
  alfa:byte;
implementation

{$R *.lfm}

{ TForm13 }

procedure TForm13.d_visiable();
begin
     if not Form13.Timer1.Enabled then
     begin
          Form13.Visible:=true;
          ch:=0;
          alfa:=0;
          Form13.AlphaBlendValue:=1;
          Form13.Timer1.Enabled:=true;
     end;
end;

procedure TForm13.Timer1Timer(Sender: TObject);
begin
  ch+=1;
  if ch<240 then
  begin
      alfa+=1;
      Form13.AlphaBlendValue:=alfa;
  end;
  if (ch>540) then
  begin
      alfa-=1;
      Form13.AlphaBlendValue:=alfa;
  end;
  if Form13.AlphaBlendValue = 0 then
  begin
      Form13.Timer1.Enabled:=false;
      Form13.Visible:=false;
  end;
end;

procedure TForm13.FormCreate(Sender: TObject);
var
  points: array[1..count] of TPoint;
  CutRegion: LongWord;
begin
  image1.top:=0;
  image1.Left:=0;
  Form13.Width:=400;
  form13.Height:=568;
  form13.left:=(screen.Width div 2)-200;
  form13.top:= (screen.Height div 2)-284;

    points[1].X:=367; points[1].Y:=16; //1 точка
   points[2].X:=367; points[2].Y:=279; //2 точка
   points[3].X:=357; points[3].Y:=289; //3 точка
   points[4].X:=357; points[4].Y:=542; //4 точка
   points[5].X:=344; points[5].Y:=555; //5 точка

   points[6].X:=1; points[6].Y:=555; //6 точка
   points[7].X:=1; points[7].Y:=364; //7 точка
   points[8].X:=8; points[8].Y:=357; //8 точка
   points[9].X:=8; points[9].Y:=163; //9 точка
   points[10].X:=1; points[10].Y:=163; //10 точка
   points[11].X:=1; points[11].Y:=84; //11 точка
   points[12].X:=19; points[12].Y:=66; //12 точка
   points[13].X:=19; points[13].Y:=1; //13 точка
   points[14].X:=351; points[14].Y:=1; //14 точка
    points[15].X:=367; points[15].Y:=16; //15 точка
   CutRegion:=CreatePolygonRgn(points, count, ALTERNATE);
   SetWindowRgn(Handle, CutRegion, True);
end;

end.

