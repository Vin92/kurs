unit interf4;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls, windows;

const
count=11; //число вершин в полигоне

type

  { TForm4 }

  TForm4 = class(TForm)
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form4: TForm4; 

implementation

{$R *.lfm}

{ TForm4 }

procedure TForm4.FormCreate(Sender: TObject);
var
  points: array[1..count] of TPoint;
  CutRegion: LongWord;
begin
   form4.top:=-28;
   form4.left:=423;
   points[1].X:=5; points[1].Y:=0; //1 точка
   points[2].X:=644; points[2].Y:=0; //2 точка
   points[3].X:=644; points[3].Y:=28; //3 точка
   points[4].X:=639; points[4].Y:=33; //4 точка
   points[5].X:=639; points[5].Y:=52; //5 точка

   points[6].X:=117; points[6].Y:=52; //6 точка
   points[7].X:=114; points[7].Y:=49; //7 точка
   points[8].X:=0; points[8].Y:=49; //8 точка
   points[9].X:=0; points[9].Y:=33; //9 точка
   points[10].X:=5; points[10].Y:=28; //10 точка
   points[11].X:=5; points[11].Y:=0; //11 точка
   CutRegion:=CreatePolygonRgn(points, count, ALTERNATE);
   SetWindowRgn(Handle, CutRegion, True);
end;

end.

