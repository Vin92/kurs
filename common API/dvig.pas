unit dvig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, windows;
var
    mouse:TPoint;
procedure ploj_okna(bx,by:boolean;var px,py:integer;x,y:integer);
procedure labir(var px, py:integer);
implementation

procedure ploj_okna(bx,by:boolean;var px,py:integer;x,y:integer);
begin
    if bx then px := x;
    if by then py := y;

end;

procedure labir(var px, py:integer);
var ogr_x,ogr_y:boolean;
    x,y:integer;
begin
    getcursorpos(mouse);
    x:= mouse.x;
    y:= mouse.y;
    ogr_y := (x > px) or (x < (px + 2));
    ogr_x := (y > py) or (y < (py + 2));
    ploj_okna(ogr_x or not ogr_y,ogr_y or not ogr_x,px,py,x,y);


end;

end.

