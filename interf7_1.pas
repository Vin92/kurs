unit interf7_1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics;

var
  _picture,_plitka,_fon:TBitmap;

procedure new_bitmaps();

implementation


procedure new_bitmaps();
begin
     _plitka:=TBitmap.create;
     _fon :=TBitmap.Create;
     _picture:=TBitMap.Create;


end;

end.

