unit interf2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, windows;

const
count=10; //число вершин в полигоне
type

  { TForm2 }

  TForm2 = class(TForm)
    Image1: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;
    Image15: TImage;
    Image16: TImage;
    Image17: TImage;
    Image18: TImage;
    Image19: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form2: TForm2; 

implementation

{$R *.lfm}

{ TForm2 }

procedure TForm2.FormCreate(Sender: TObject);
var
  points: array[1..count] of TPoint;
  CutRegion: LongWord;

begin
    points[1].X:=5; points[1].Y:=85; //1 точка
   points[2].X:=160; points[2].Y:=85; //2 точка
   points[3].X:=125; points[3].Y:=119; //3 точка
   points[4].X:=5; points[4].Y:=119; //4 точка
   points[5].X:=5; points[5].Y:=85; //5 точка

   points[6].X:=290; points[6].Y:=14; //6 точка
   points[7].X:=290; points[7].Y:=55; //7 точка
   points[8].X:=159; points[8].Y:=55; //8 точка
   points[9].X:=200; points[9].Y:=14; //9 точка
   points[10].X:=290; points[10].Y:=14; //10 точка
   CutRegion:=CreatePolygonRgn(points, count, ALTERNATE);
   SetWindowRgn(Handle, CutRegion, True);
   form2.image3.picture := form2.image2.picture;
   form2.image4.picture := form2.image2.picture;
   form2.image5.picture := form2.image2.picture;
   form2.image6.picture := form2.image2.picture;
   form2.image7.picture := form2.image2.picture;
   form2.image8.picture := form2.image2.picture;
   form2.image9.picture := form2.image2.picture;
   form2.image10.picture := form2.image2.picture;
   form2.image11.picture := form2.image2.picture;
   form2.image12.picture := form2.image2.picture;
   form2.image13.picture := form2.image2.picture;
   form2.image14.picture := form2.image2.picture;
   form2.image15.picture := form2.image2.picture;
   form2.image16.picture := form2.image2.picture;
   form2.image17.picture := form2.image2.picture;
end;

end.

