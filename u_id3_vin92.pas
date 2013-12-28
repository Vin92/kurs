unit u_id3_vin92;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, vinplayer_extern_extension;


function get_id3_tags(var name_file, name, artist, album:string):integer;
function pars_xml(zn0, zn1:string):string;

implementation
{
      function GET_DLL_NAME(d:byte): PChar; stdcall; external extern_dll;
      function EXECUTE(zn0:PChar;d:byte): PChar; stdcall; external extern_dll;}

function get_id3_tags(var name_file, name, artist, album:string):integer;
var i:byte=1;
    rez:String;
    search_id3:boolean=false;
begin
     while (i<=count_load_dlls) and not search_id3 do
     begin
          if (String(GET_DLL_NAME(i-1))= 'ID3 тег') then
          begin
               search_id3:=true;
          end;

          i+=1;
     end;
     rez:=String(EXECUTE(PChar(name_file),i-2));

     if (not search_id3) then
     begin
          result:=1;
     end
     else
     begin//<Name>Drop The Other</Name><Artist>Emika</Artist><Album>Drop The Other</Album>
          name:=pars_xml('Name',rez);
          artist:=pars_xml('Artist',rez);
          album:=pars_xml('Album',rez);
          result:=0;
     end;
end;


function pars_xml(zn0, zn1:string):string;
var i0, i1:byte;
    _zn0:string;
begin
     _zn0:='</' + zn0 + '>';
     zn0:='<' + zn0 + '>';
     i0:=pos(zn0,zn1);
     if i0 <> 0 then
     begin
          i1:=pos(_zn0,zn1);
          if i1<>0 then
                  result:=copy(zn1, length(zn0) + i0, i1-length(zn0)-i0);
     end;
end;

end.

