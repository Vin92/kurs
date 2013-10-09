unit progress_p;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, interf, forms, interf10;


function poloj_vospr(b:boolean; t,tp:real):string;

implementation

function poloj_vospr(b:boolean; t,tp:real):string;
var ps,pm:real;
  nnn, nnn2:string;
begin
    //t:= BASS_ChannelBytes2Seconds(potok, BASS_ChannelGetPosition(potok,0));
   if b then
   begin
    ps:= (round(t*100) mod 6000)/100;
    pm:= round(t) div 60;
    str(ps:5:2, nnn);
    str(pm:3:0, nnn2);
    poloj_vospr:=nnn2 + ':' + nnn;
    //tp:=BASS_ChannelBytes2Seconds(potok, BASS_ChannelGetLength(potok,0));
    ps:= (round(tp) mod 60);
    pm:= round(tp) div 60;
    str(ps:2:0, nnn);
    str(pm:3:0, nnn2);
    poloj_vospr +=' /' + nnn2 + ':' + nnn;
   end
   else
      poloj_vospr:=' ';
    pm:=(t/tp);
    str(pm*100:3:1, nnn2);
    form1.Label3.Caption := nnn2 + '%';
    form1.Label3.left := round(pm*275);
    form1.image2.left := round(pm*299-301);
    form10.left:= round(pm*screen.width)-7;
end;
end.

