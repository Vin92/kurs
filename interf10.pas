unit interf10;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  windows;

const
count=6; //число вершин в полигоне

type

  { TForm10 }

  TForm10 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form10: TForm10;

implementation

{$R *.lfm}

{ TForm10 }

procedure TForm10.FormCreate(Sender: TObject);
var
   points: array[1..count] of TPoint;
   CutRegion: LongWord;

begin
     form10.top:=0;
     form10.left:=0;
     points[1].X:=7; points[1].Y:=0; //1 точка
     points[2].X:=0; points[2].Y:=7; //2 точка
     points[3].X:=0; points[3].Y:=9; //3 точка
     points[4].X:=4; points[4].Y:=9; //4 точка
     points[5].X:=7; points[5].Y:=6; //5 точка
     points[6].X:=7; points[6].Y:=0; //6 точка
     CutRegion:=CreatePolygonRgn(points, count, ALTERNATE);
     SetWindowRgn(Handle, CutRegion, True);
end;

end.

