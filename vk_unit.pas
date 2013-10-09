unit VK_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, HTTPSend, ssl_openssl, interf;

type
    TgetCounters = record
      friends, messages, photos, videos, notes, gifts, events, groups:integer;
      end;

    load_vk_data = class(TThread)
   private
     { Private declarations }
     function load_http(s:string):TStrings;
     function pars_stroka(s0, s1:string):string;

     protected
     procedure Execute(); override;
   public
   end;



var
  access_token:string;
  VK_load:load_vk_data;
  vk_bool:boolean;
  vk_load_url:string;

procedure vk_load_audio_list();
procedure vk_load_user();
function vk_getCounters():TgetCounters;
procedure set_vk_bool(a:boolean);


implementation

procedure set_vk_bool(a:boolean);
begin
     vk_bool:=a;
end;

function load_vk_data.load_http(s:string):TStrings;
var st:TStrings;
begin
     st:=TStringList.create;
     HttpGetText(s, st);
     load_http:=st;
     st.free;
end;

procedure load_vk_data.Execute();
var s:TStrings;
begin
     s:=TStringList.create;
     if vk_bool then
     begin
          //Synchronize(@set_vk_bool(false));

          s:=load_http(vk_load_url);
          //Synchronize(@set_vk_bool(true));
     end;
     s.free;
end;

function pars_stroka(s0, s1:string):string;
var i, j, L:byte;
begin
     i:=pos('<'+s0+'>', s1);
     L:=length(s0);
     j:=pos('</'+s0+'>', s1);
     if (pos('</'+s0+'>', s1))<>0then
     begin
          pars_stroka:=copy(s1,i+2+L,i+4+L-j);
     end
     else
     begin
          pars_stroka:='-1';
     end;
end;

function vk_getCounters():TgetCounters;
var   s:TStrings;
      i:byte;
      mes, mest:string;
begin
     //получаем информацию о новых событиях
     VK_load:=load_vk_data.create(false);
     s:=TStringList.Create;
     //HttpGetText('https://api.vk.com/method/account.getCounters.xml?friends,messages,photos,videos,notes,gifts,events,groups&access_token='+access_token, s);
     vk_load_url:='https://api.vk.com/method/account.getCounters.xml?friends,messages,photos,videos,notes,gifts,events,groups&access_token='+access_token;

     for i:=0 to s.count - 1 do
     begin
          mest:=pars_stroka('messages',s[i]);
          if mest <> '-1' then mes:=mest;
     end;
     soobchenie('Отладка', 'Сообщений: "' + mes + '"' , 900, true);
     s.free;
end;

procedure vk_load_audio_list();
var
   Http:THTTPSend;
   i:byte;
   s:TStrings;
begin
      soobchenie('Отладка', 'Грузим аудио... Лопатами', 400, true);
     s:=TStringList.Create;
     HttpGetText('https://api.vk.com/method/audio.get.xml?oid=26187536&access_token='+access_token, s);
     //for i:=0 to 10 do
     //begin
           //vplayer.memo1.lines.Add(s[i]);
     //end;
     {Http:=THTTPSend.Create;
     if otl then  vplayer.memo1.lines.Add('запрос VK API');
     try
     if Http.HTTPMethod('GET','https://api.vk.com/method/audio.get?oid=26187536&access_token='+access_token) then
     begin
          Http.Document.SaveToFile(ExtractFilePath(paramstr(0)) + 'RijyBirthday.htm');
     end
     else
     begin
          if otl then  vplayer.memo1.lines.Add('ошибка');
     end;
     finally
            Http.Free;
     end;}
end;

procedure vk_load_user();
var
   Http:THTTPSend;
begin
     //HttpGetText('http://api.vk.com/method/users.get?uids=26187536&fields=nickname,screen_name&name_case=nom', vplayer.memo1.Lines)
     {if otl then soobchenie('Отладка', 'Грузим Usera... Лопатами', 400, true);
     Http:=THTTPSend.Create;
     if otl then  vplayer.memo1.lines.Add('запрос VK API');
     try
     if Http.HTTPMethod('GET','https://api.vk.com/method/users.get.xml?uids=26187536&fields=nickname,screen_name&name_case=nom') then
     begin
          Http.Document.SaveToFile(ExtractFilePath(paramstr(0)) + 'RijyBirthday.htm');
     end
     else
     begin
          if otl then  vplayer.memo1.lines.Add('ошибка');
     end;
     finally
            Http.Free;
     end; }
end;

begin

     vk_bool:=true;


end.

