unit interf5;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls, windows;

type

  { TForm5 }

  TForm5 = class(TForm)
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 
const
   count=18; //число вершин в полигоне
var
  Form5: TForm5; 

implementation

{$R *.lfm}

{ TForm5 }

procedure TForm5.FormCreate(Sender: TObject);
var
  points: array[1..count] of TPoint;
  CutRegion: LongWord;
begin
   form5.top:=300;
   form5.left:=400;
   points[1].X:=1; points[1].Y:=1; //1 точка
   points[2].X:=571; points[2].Y:=1; //2 точка
   points[3].X:=571; points[3].Y:=171; //3 точка
   points[4].X:=1; points[4].Y:=171; //4 точка
   points[5].X:=1; points[5].Y:=1; //5 точка

   points[6].X:=16; points[6].Y:=16; //6 точка
   points[7].X:=556; points[7].Y:=16; //7 точка
   points[8].X:=556; points[8].Y:=156; //8 точка
   points[9].X:=458; points[9].Y:=156; //9 точка
   points[10].X:=458; points[10].Y:=146; //10 точка
   points[11].X:=546; points[11].Y:=146; //11 точка
   points[12].X:=546; points[12].Y:=26; //12 точка
   points[13].X:=26; points[13].Y:=26; //13 точка
   points[14].X:=26; points[14].Y:=146; //14 точка
   points[15].X:=114; points[15].Y:=146; //15 точка
   points[16].X:=114; points[16].Y:=156; //16 точка
   points[17].X:=16; points[17].Y:=156; //17 точка
   points[18].X:=16; points[18].Y:=16; //18 точка
   CutRegion:=CreatePolygonRgn(points, count, ALTERNATE);
   SetWindowRgn(Handle, CutRegion, True);
end;

end.

