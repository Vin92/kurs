library pacal_dll;

{$mode objfpc}{$H+}

uses
  Classes
  { you can add units after this };

function dll_name():PChar; export;
begin
     result:=PChar('Жизнь');
end;

begin

end.

