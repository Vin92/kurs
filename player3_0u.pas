unit player3_0u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, bass, bassflac, inifiles, interf, interf2, {tags,} scaner_vplayer,
  clipbrd, DateUtils, bassenc, mmsystem, B_ID3V1, interf13, HTTPSend, ssl_openssl,
  spisok, LMessages, u_id3_vin92;

type

  { Tvplayer }

  Tvplayer = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject{; var CloseAction: TCloseAction});
    procedure FormCreate(Sender: TObject);
    procedure FormShortCut(var Msg: TLMKey; var Handled: Boolean);
  private
    { private declarations }
  public
    { public declarations }
  end;
  /////////////////////////////////////////////////////////////////////////////
  vpt_text = record
    time:integer;
    stroka:string[254];
  end;
  /////////////////////////////////////////////////////////////////////////////
  potok_load = class(TThread)
   private
     procedure internet_vospr_end_load;
     { Private declarations }
     protected
     procedure Execute; override;
   public
   end;
  /////////////////////////////////////////////////////////////////////////////
  TID3Rec = record
               Title,Artist,Comment,Album,Genre,Year:string
              end;
  TFFTData  = array [0..128] of Single; //<----------------
  el=record
           put:string[255];
           name_file:string[100];
           col_powt : word;
           kopija, muzika:boolean;
           id3_inf:record
               name_id3:string[150];
               artist_id3:string[50];
               album_id3:string[50];
               god_id3:string[5];
               genre_id3:string[25]
           end;
           razmer:int64;
           time_izm:int64
   end;
  uk = ^el_sokr;
   el_sokr=record
               id_track:word;
               put:string[255];
               name_file:string[100];
               artist_id3:string[50];
               name_id3:string[150];
               razmerfile:int64;
               timeizm:int64;
               NextAdress:uk;
               NeNextAdress:uk
          end;

//////////////VK////////////////////////////////////////////////////////////////
   load_vk_data = class(TThread)
   private
     { Private declarations }
        mes, mes_zag:string;
        //vk_s:TStrings;
     //function load_http(s:string):TStrings;
     //function pars_stroka(s0, s1:string):string;
         procedure vk_getCounters(zn0, zn1:string; zn2:integer);
         function pars_stroka(s0, s1:string):string;
         procedure get_results();
         procedure vk_write_mes(id, text_mes:string);
         //function pars_mess(s0, s1:string):string;
         procedure vk_get_messag();
         //procedure disp_messg();
         function vk_get_user(s:string):string;
     protected
     procedure Execute(); override;
   public
   end;

   T_vk_load_audio = class(TTHread)
   private
          s:TStrings;
          stat_mes:string[100];
          audio_vk_object:TData_dS;
          procedure stat;
          procedure add_toTrack_list();
          procedure pars_audio_list();
   protected
     procedure Execute(); override;

   public

   end;

   TgetCounters = record
      friends, messages, photos, videos, notes, gifts, events, groups:integer;
      end;
////////////////////////////////////////////////////////////////////////////////


var
  vplayer: Tvplayer;
  filewav, errcode, name_rec_track, internet_name_track, urll{, nnn, nnn2, ist, ddfilewav, progress}:string;
  in_comm:string[50];
  filewavPChar:PChar;
  potok:HSTREAM;
  cv, b_play_stop, napr_prok:boolean;

  ttp0, ttp1, ttp2, ttp3, ttp4, tp,tl: Double;
  tp1: Int64;
  vol:Single;
  pb: BASS_DX8_PARAMEQ;
  fx,fx1: array[1..11] of integer;
  IniFile{, PlstFile}: TIniFile;
  id3tag:TID3Rec;
  bid3:pchar;//TAG_ID3;
  //переменные визуализации<------------------------
  FFTFata : TFFTData;
  //база
  ch_baza:int64;
  fff:file of el;
  element:el;
  perv_load_baza:boolean;
  //elbaza, elbazaStart, elbazaNeStart, next, neNext, elbaza_id_searh:uk;///////////////////////////////////////////////////////////
  spisok_baza, ochered_vospr, spisok_vospr:dSpisok;
  tek_source:byte;
  rejim_internet_vospr:byte=0;
  connecting_internet_vospr:byte=0;
  //
  n:shortint;
  hz:dword;
  shzapuskov, shzapisi:word;
  bool_internet, rec_mode:boolean;
  pload:potok_load;
  sht:word;
  {zn_timer1, }zn_timer3{, zn_timer4, nastr_zn_timer1}, nastr_zn_timer3{, nastr_zn_timer4, nastr_zn_timer2}:integer;
  otl:boolean;
  b_open_baza:boolean;
  /////
  vpt_open:boolean;
  vpt_open2:boolean;
  vpt_file_name:string; //Vin Player Text;
  vpt_file:File of vpt_text;
  vpt_element:vpt_text;
  count_vpt_strings:integer;
  vpt_strings:array [0..200] of string[250];
  vpt_time:array [0..200] of integer;

  global_time_vospr:int64;
  global_time_sec:word;

  access_token:string;
  vk_user_id:string[10];
  vk_dejstv:integer;
  vk_potok:load_vk_data;

  Counters:array [1..5] of integer;
  id, text_mes, vk_soure_list, vk_soure_list_count:string;
  vk_load_run:boolean;
  vk_loadAudio_potok:T_vk_load_audio;


  tek_id_track:int64;

  //отрезок АБ
  AB:boolean=false;
  tA, tB:int64;
  ///////

  ////параметры запуска
  audio_p:TStrings;
  ////


procedure tags_id3;
procedure init_player;
procedure exit_odnaco;
procedure vizual;
procedure Proc;
procedure eqvol;
procedure oshibki;
procedure vospr;
procedure play;
procedure stop;
procedure pause;
procedure per(p:word);
{procedure plLoadTrack;
procedure plLoad;
procedure plSaveTrack;
procedure plsave;
procedure plDelTrack;}
procedure help_cons();
procedure conf_vospr;
procedure loadconf;
procedure saveconf;
procedure vospr_next;
procedure vospr_neNext;
procedure dispose_baza;
procedure cmdparam;
procedure load_baza;
procedure sort_po_timeizm(n,m:int64;ni,mj:uk);
procedure sort_po_artist(n,m:int64;ni,mj:uk; napr:boolean);
procedure play_stop;
procedure Menu_sort_po_date;
procedure Menu_sort_po_isp(n:boolean);
procedure add_files_to_trasc_list(p:string);
function eq_yatanowka_znachenij(nom:byte; zn:integer):integer;
function set_vol(zn:single):single;
procedure reinit(n0:shortint;hz0:dword);
procedure chto_za_den;
procedure internet_vospr(url:string; rejim:byte=0);
procedure DoMeta();
procedure  recording_odnaco;
procedure play_id(num:word);
function booltostr(b:boolean):string;
procedure load_info_track(name_track:string; out o_put:string; out o_col_powt:word; out o_kopija, o_muzika:boolean; out o_name_id3:string; out o_artist_id3, o_album_id3, o_god_id3, o_genre_id3:string; out o_razmer, o_time_izm:int64);
procedure load_vpt;
procedure vptprint();
procedure copy_put_and_file;

//vk//
procedure vk_load_user();
procedure vk_load_audio_list();
//procedure vk_getCounters();
procedure vk_data(zn:integer);
procedure vk_create_mess();
procedure vk_get_messages();
procedure vk_get_send_messages();
procedure vk_reset_messages(b:boolean);
procedure vk_noread_messages();
function pars_stroka_2(s0, s1:string):string;
//////


implementation

{$R *.lfm}

////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                                  VK                                        //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
//Vk_audio//
procedure T_vk_load_audio.stat();
begin
      soobchenie('vinPlayer - VK', stat_mes, 1800, true);
end;

{<?xml version="1.0" encoding="utf-8"?>
<response list="true">
 <audio>
  <aid>220481732</aid>
  <owner_id>26187536</owner_id>
  <artist>The Chemical Brothers</artist>
  <title>Come With Us (FatBoy Slim Remix)</title>
  <duration>441</duration>
  <url>http://cs4643.vk.me/u32941045/audios/f606e7c513f6.mp3</url>
  <genre>22</genre>
 </audio>
 <audio>
  <aid>220440934</aid>
  <owner_id>26187536</owner_id>
  <artist>Elite Force</artist>
  <title>The Law Of Life (Original Mix)</title>
  <duration>419</duration>
  <url>http://cs5763.vk.me/u16619130/audios/fdaaf126e7db.mp3</url>
  <lyrics_id>19936097</lyrics_id>
  <genre>18</genre>
 </audio>
 <audio>
  <aid>220350265</aid>
  <owner_id>26187536</owner_id>
  <artist>Junior Jack</artist>
  <title>Da Hype (Original Mix) (2003)</title>
  <duration>453</duration>
  <url>http://cs5381.vk.me/u405503/audios/fc7342bfbb77.mp3</url>
  <lyrics_id>20652444</lyrics_id>
  <genre>5</genre>
 </audio>}

procedure T_vk_load_audio.add_toTrack_list();//audio_vk_object
begin
     if otl then vplayer.memo1.lines.Add('artist: ' + audio_vk_object.artist_id3 + ',  title: ' + audio_vk_object.name_id3 + ', audio_id: ' + audio_vk_object.audio_id + ', url: ' + audio_vk_object.url);

     audio_vk_object.put:='vk url:' + audio_vk_object.url;
     spisok_baza.add(audio_vk_object);
     ochered_vospr.add(audio_vk_object);
     spisok_vospr.add(audio_vk_object);
     //audio_vk_object.artist_id3:=;<artist>
     //audio_vk_object.audio_id:=;<aid>
     //audio_vk_object.name_id3:=;<title>
     //audio_vk_object.url:=;<url>
end;

procedure T_vk_load_audio.pars_audio_list();
var i:integer;
    in_block:boolean;
    tmp_str:string;
    tmp_i, tmp_i0:byte;
begin
     audio_vk_object.razmerfile:=0;
     audio_vk_object.source:=1;
     audio_vk_object.timeizm:=2;
     audio_vk_object.id_track:=0;
     audio_vk_object.name_file:='';

     for i:=s.Count -1 downto 0 do
     begin
          tmp_str:= ' ' + s[i];
          {if pos('<audio>',tmp_str) <> 0 then
          begin
               in_block:=true;
          end;
          if pos('</audio>',tmp_str) <> 0 then
          begin
               in_block:=false;
               Synchronize(@add_toTrack_list);
          end; }
          if pos('</audio>',tmp_str) <> 0 then
          begin
               in_block:=true;
          end;
          if pos('<audio>',tmp_str) <> 0 then
          begin
               in_block:=false;
               Synchronize(@add_toTrack_list);
          end;

          if in_block then
          begin
               tmp_i0:= pos('<artist>',tmp_str);
               if tmp_i0 <> 0 then
               begin
                    tmp_i:=pos('</artist>',tmp_str);
                    if tmp_i<>0 then
                       audio_vk_object.artist_id3:=copy(tmp_str, 8 + tmp_i0, tmp_i-8-tmp_i0);
               end;
               tmp_i0:=pos('<aid>',tmp_str);
               if tmp_i0 <> 0 then
               begin
                    tmp_i:=pos('</aid>',tmp_str);
                    if tmp_i<>0 then
                       audio_vk_object.audio_id:=copy(tmp_str, 5 + tmp_i0, tmp_i-5-tmp_i0);
               end;
               tmp_i0:=pos('<title>',tmp_str);
               if tmp_i0 <> 0 then
               begin
                    tmp_i:=pos('</title>',tmp_str);
                    if tmp_i<>0 then
                       audio_vk_object.name_id3:=copy(tmp_str, 7 + tmp_i0, tmp_i-7-tmp_i0);
               end;
               tmp_i0:=pos('<url>',tmp_str);
               if tmp_i0 <> 0 then
               begin
                    tmp_i:=pos('</url>',tmp_str);
                    if tmp_i<>0 then
                       audio_vk_object.url:=copy(tmp_str, 5 + tmp_i0, tmp_i-5-tmp_i0);
               end;
          end
          else
          begin
               audio_vk_object.artist_id3:='-No info-';
               audio_vk_object.audio_id:='-No info-';
               audio_vk_object.name_id3:='0';
               audio_vk_object.url:='пусто';
               audio_vk_object.put:='';
          end;

     end;

     //audio_vk_object.artist_id3:=;<artist>
     //audio_vk_object.audio_id:=;<aid>
     //audio_vk_object.name_id3:=;<title>
     //audio_vk_object.url:=;<url>
end;

procedure T_vk_load_audio.Execute();//vk_load_audio_list
var tmp, tmp1:String;

begin
      stat_mes:='Грузим музыку... Лопатами.';
      Synchronize(@stat);

      if vk_soure_list <> ' ' then
      begin
           tmp:=vk_soure_list;
           tmp1:=vk_soure_list_count;
           vk_soure_list:= ' ';
      end
      else
      begin
           tmp:=vk_user_id;
           tmp1:='25';
      end;
      s:=TStringList.Create;
      HttpGetText('https://api.vk.com/method/audio.get.xml?oid='+tmp+'&count='+tmp1+'&access_token='+access_token, s);//vplayer.memo1.Lines  26187536
      //HttpGetText('https://api.vk.com/method/audio.get.xml?oid=54116806&count=25&access_token='+access_token, s);//vplayer.memo1.Lines  54116806
      pars_audio_list();
      s.free;
      stat_mes:='Загрузка завершена.';
      Synchronize(@stat);
end;
//Vk_mess//
procedure vk_create_mess();
var i:byte;
begin

     id := inputbox('Пишем сообщение','Введите идентификатор пользователя','');
     text_mes := inputbox('Пишем сообщение','Напишите текст','');
     insert('_',text_mes, 0);
     while pos(' ', text_mes) <> 0 do
     begin
          i:=pos(' ', text_mes);
          delete(text_mes, i, 1);
          insert('%20', text_mes, i);
     end;
     delete(text_mes, 1,1);
     if (id <> '') and (text_mes <> '') then
     begin
          soobchenie('vinPlayer - VK', 'отправка сообщения пользователю: '+ id +' - ' + text_mes, 1800, true);
          vk_dejstv:=10;
          vk_potok := load_vk_data.Create(False);
     end;
end;


procedure vk_data(zn:integer);
begin
     vk_dejstv:=zn;
     vk_potok := load_vk_data.Create(False);
end;

procedure load_vk_data.Execute();
begin
     if not vk_load_run then
     begin
          vk_load_run:=true;
          case vk_dejstv of
               1: vk_getCounters('messages','Сообщений: ',1);
               2: vk_getCounters('events','Новости: ',2);
               3: vk_getCounters('photos','Фотографии: ',3);
               10:vk_write_mes(id, text_mes);
               15:vk_get_messag();
          end;
          vk_load_run:=false;
     end;
end;

procedure load_vk_data.vk_write_mes(id, text_mes:string);
var s:TStrings;
  rnd:integer;
begin
     randomize;
     rnd:=random(32000);
     s:=TStringList.Create;
     HttpGetText('https://api.vk.com/method/messages.send?uids=' + id + '&message=' + text_mes + '&guid=' + inttostr(rnd) + '&access_token='+access_token, s);

     if s.count <> 0 then
     begin
          mes := s[0];
     end
     else
     begin
         mes := 'Ошибка отправки сообщения';
     end;
     mes_zag:='vinPlayer - VK';
     Synchronize(@get_results);
     s.free;
end;

procedure load_vk_data.vk_get_messag();
var s_user_name, s_user_text, s:TStrings;
    {sss,}user_id, user_text, temp:string;
    i{,j}:byte;
begin
     s_user_text:=TStringList.Create;
     s_user_name:=TStringList.Create;
     s:=TStringList.Create;

     HttpGetText('https://api.vk.com/method/messages.get.xml?filters=1&access_token='+access_token, s);
     user_id:=' ';
     user_text:=' ';

     if s.count <> 0 then
     begin
          for i:=0 to s.count - 1 do
          begin
               temp:=pars_stroka('uid',s[i]);
               if (temp <> '-1') and (temp <> '-2') and (temp <> '-3') then
                  user_id:=temp;

               temp:=pars_stroka('body',s[i]);
               if (temp <> '-1') and (temp <> '-2') and (temp <> '-3') then
                  user_text:=temp;

               if pars_stroka('</message>',s[i]) = '-3' then
               begin
                    s_user_name.Add(vk_get_user(user_id));
                    s_user_text.Add(user_text);
               end;
          end;
     end;

     if s_user_name.count <> 0 then
     begin
          for i:=0 to s_user_name.count - 1 do
          begin
               mes_zag:='('+inttostr(i+1)+')От '+s_user_name[i];
               mes:=s_user_text[i];
               Synchronize(@get_results);
               sleep(10000);
          end;
     end;

     s_user_name.free;
     s_user_text.free;
     s.free;
end;

function load_vk_data.vk_get_user(s:string):string;
var str:TStrings;
    temp, temp2:string;
    i:byte;
begin
     str:=TStringList.Create;
     HttpGetText('https://api.vk.com/method/users.get.xml?uids='+s+'&name_case=gen', str);
     if str.count <> 0 then
     begin
          for i:=0 to str.count - 1 do
          begin
               temp := pars_stroka('first_name',str[i]);
               if temp <> '-1' then
               begin
                    temp2:=temp;
               end;

               temp := pars_stroka('last_name',str[i]);
               if temp <> '-1' then
               begin
                    temp2+=' ' + temp;
               end;
          end;
          vk_get_user:=temp2;
     end;

     str.free;
end;

function load_vk_data.pars_stroka(s0, s1:string):string;
var i, j, L:byte;
begin
     s1:=' ' + s1;
     if (pos('<message>', s1) <> 0) then
     begin
          pars_stroka:='-2';

     end
     else
     begin
          if (pos('</message>', s1) <> 0) then
          begin
               pars_stroka:='-3';
          end
          else
          begin
               i:=pos('<'+s0+'>', s1);
               L:=length(s0);
               j:=pos('</'+s0+'>', s1);
               if (pos('</'+s0+'>', s1))<>0then
               begin
                    pars_stroka:=copy(s1,i+2+L,j-i-2-L);
               end
               else
               begin
                    pars_stroka:='-1';
               end;
          end;
     end;
end;

procedure load_vk_data.get_results();
begin
     soobchenie(mes_zag, mes, 1400, true);

end;

procedure load_vk_data.vk_getCounters(zn0, zn1:string; zn2:integer);
var   s:TStrings;
      i:byte;
      tempS:string;
      temp_zn:integer;
      b:boolean;
begin
     //получаем информацию о новых событиях
     //VK_load:=load_vk_data.create(false);
     b:=true;
     s:=TStringList.Create;
     HttpGetText('https://api.vk.com/method/account.getCounters.xml?friends,messages,photos,videos,notes,gifts,events,groups&access_token='+access_token, s);
     //vk_load_url:='https://api.vk.com/method/account.getCounters.xml?friends,messages,photos,videos,notes,gifts,events,groups&access_token='+access_token;

     if s.count <> 0 then
     begin
          for i:=0 to s.count - 1 do
          begin
               tempS:=pars_stroka(zn0,s[i]);
               if tempS <> '-1' then
               begin
                    b:=false;
                    mes:=tempS;
               end;
          end;
          if b then
          begin
             mes:='';
             Counters[zn2]:=0;
          end;
     end;
     if mes <> '' then
     begin
          temp_zn:=strtoint(mes);
          if temp_zn<>Counters[zn2] then
          begin
               mes:=zn1 + mes;
               Counters[zn2] := temp_zn;
               mes_zag:='vinPlayer - VK';
               PlaySound('res/sig1v2.wav',0,SND_ASYNC);
               Synchronize(@get_results);
               if zn2 = 1 then
               begin
                    vk_get_messag();
               end;
          end;
     end;
     s.free;
end;

function pars_stroka_2(s0, s1:string):string;
var i, j, L:byte;
begin
     s1:=' ' + s1;
     if (pos('<message>', s1) <> 0) then
     begin
          pars_stroka_2:='-2';

     end
     else
     begin
          if (pos('</message>', s1) <> 0) then
          begin
               pars_stroka_2:='-3';
          end
          else
          begin
               i:=pos('<'+s0+'>', s1);
               L:=length(s0);
               j:=pos('</'+s0+'>', s1);
               if (pos('</'+s0+'>', s1))<>0then
               begin
                    pars_stroka_2:=copy(s1,i+2+L,j-i-2-L);
               end
               else
               begin
                    pars_stroka_2:='-1';
               end;
          end;
     end;
end;

procedure vk_noread_messages();
var i:word;
    s:TStrings;
begin
     s:=TStringList.Create;
     HttpGetText('https://api.vk.com/method/messages.get.xml?count=200&filters=1&access_token='+access_token, s);
     if s.count <> 0 then
     begin
          for i:=0 to s.count - 1 do
          begin
               vplayer.memo1.lines.add(s[i]);
          end;
     end;
     s.free;
end;

procedure vk_reset_messages(b:boolean);
var i, j:word;
    s, uid, mid:TStrings;
    temp, t_mid, t_uid:string;
begin
     s:=TStringList.Create;
     uid:=TStringList.Create;
     mid:=TStringList.Create;
     if not b then
        HttpGetText('https://api.vk.com/method/messages.get.xml?count=200&filters=1&access_token='+access_token, s)
     else
         HttpGetText('https://api.vk.com/method/messages.get.xml?count=200&access_token='+access_token, s);
     if s.count <> 0 then
     begin
          for i:=0 to s.count - 1 do
          begin
               temp:=pars_stroka_2('mid',s[i]);
               if (temp <> '-1') and (temp <> '-2') and (temp <> '-3') then
                  t_mid:=temp;

               temp:=pars_stroka_2('uid',s[i]);
               if (temp <> '-1') and (temp <> '-2') and (temp <> '-3') then
                  t_uid:=temp;

               if pars_stroka_2('</message>',s[i]) = '-3' then
               begin
                    uid.Add(t_uid);
                    mid.Add(t_mid);
               end;
          end;
     end;

     if mid.count <> 0 then
     begin
          for i:=0 to mid.count -1 do
          begin
                vplayer.memo1.lines.add('  ');
                vplayer.memo1.lines.add('--сообщение ' + inttostr(i) + '--');
                vplayer.memo1.lines.add('Идентификатор: ' + mid[i]);
                vplayer.memo1.lines.add('Отправитель: ' + uid[i]);
                vplayer.memo1.lines.add('Запрос api...');
                if not b then
                   HttpGetText('https://api.vk.com/method/messages.markAsRead.xml?mids='+mid[i]+'&uid='+uid[i]+'&access_token='+access_token, s)
                else
                    HttpGetText('https://api.vk.com/method/messages.markAsNew.xml?mids='+mid[i]+'&access_token='+access_token, s);
                if s.count <> 0 then
                begin
                     for j:=0 to s.count -1 do
                     begin
                          if pars_stroka_2('response', s[j]) = '1' then vplayer.memo1.lines.add('успешно');
                     end;
                end;
          end;
     end
     else
     begin
          vplayer.memo1.lines.add('Все сообщения прочитаны');
     end;
     s.free;
     mid.free;
     uid.free;
end;

procedure vk_get_messages();
begin
     HttpGetText('https://api.vk.com/method/messages.get.xml?count=200&access_token='+access_token, vplayer.memo1.lines);
end;

procedure vk_get_send_messages();
begin
     HttpGetText('https://api.vk.com/method/messages.get.xml?out=1&count=200&access_token='+access_token, vplayer.memo1.lines);
end;

procedure vk_load_audio_list();
var
   s:TStrings;
begin
      soobchenie('Отладка', 'Грузим аудио... Лопатами', 400, true);
     s:=TStringList.Create;
     HttpGetText('https://api.vk.com/method/audio.get.xml?oid=26187536&access_token='+access_token, s);//vplayer.memo1.Lines
     s.free;
end;

procedure vk_load_user();
begin
     HttpGetText('http://api.vk.com/method/users.get.xml?uids=26187536&fields=nickname,screen_name&name_case=nom', vplayer.memo1.Lines)
end;


////////////////////////////////////////////////////////////////////////////////
         //////////////////////////////////////////////////////
                      ///////////////////////////
                             ////////////

function booltostr(b:boolean):string;
begin
     booltostr:='Нет';
     if b then
       booltostr:='Да';
end;

procedure chto_za_den;
var Year, Month, Day:word;
    date:TDateTime;
begin
     date:=TdateTime(now);
     DecodeDate(date,Year,Month,Day);
     case Month of
          1:begin //январь
                 if Day = 1 then soobchenie('vinPlayer','С новым '+ inttostr(Year) + '-м годом!' , 500, false);
                 if Day = 7 then soobchenie('vinPlayer','С Рождеством Христовым!' , 500, false);
                 if Day = 13 then soobchenie('Сегодня -','День российской печати' , 500, false);
                 if Day = 21 then soobchenie('Сегодня -','День инженерных войск' , 500, false);
                 if Day = 25 then soobchenie('Сегодня -','Татьянин день (День российского студенчества)' , 500, false);
                 if Day = 27 then soobchenie('Сегодня -','День снятия блокады города Ленинграда (день воинской славы России)' , 500, false);

          end;
          2:begin //февраль
                 if Day = 2 then soobchenie('Сегодня - ','День разгрома советскими войсками немецко-фашистских войск в Сталинградской битве' , 500, false);

                 if Day = 9 then soobchenie('Сегодня - ','День работника гражданской авиации' , 500, false);
                 if Day = 23 then soobchenie('Сегодня - ','День защитника Отечества' , 500, false);


          end;
          3:begin//март
                 if Day = 8 then soobchenie('Сегодня - ','Международный женский день' , 500, false);
                 if Day = 23 then soobchenie('Сегодня - ','День работников гидрометеорологической службы России' , 500, false);

          end;
          4:begin//апрель
                 if Day = 12 then soobchenie('Сегодня - ','День космонавтики' , 500, false);
                 if Day = 15 then soobchenie('Сегодня - ','День специалиста по радиоэлектронной борьбе' , 500, false);


          end;
          5:begin//май
                 if Day = 1 then soobchenie('Сегодня - ','Праздник Весны и Труда' , 500, false);
                 if Day = 7 then soobchenie('Сегодня - ','День радио, праздник работников всех отраслей связи' , 500, false);
                 if Day = 9 then soobchenie('Сегодня - ','День Победы' , 500, false);
                 if Day = 24 then soobchenie('Сегодня - ','День славянской письменности и культуры' , 500, false);


          end;
          6:begin//июНь
                 if Day = 12 then soobchenie('Сегодня - ','День России' , 500, false);
                 if Day = 27 then soobchenie('Сегодня - ','День молодёжи' , 500, false);


          end;
          7:begin //июЛь
                 if Day = 8 then soobchenie('Сегодня - ','День семьи, любви и верности' , 500, false);


          end;
          8:begin //август
                 if Day = 27 then soobchenie('Сегодня - ','День российского кино' , 500, false);
                 if Day = 22 then soobchenie('Сегодня - ','22 августа' , 500, false);



          end;
          9:begin //сентябрь
                 if Day = 1 then soobchenie('Сегодня - ','День знаний' , 500, false);
                 if Day = 12 then soobchenie('Сегодня - ','День программиста если этот год високосный' , 500, false);
                 if Day = 13 then soobchenie('Сегодня - ','День программиста если этот год не високосный' , 500, false);


          end;
          10:begin //октябрь
                 if Day = 4 then soobchenie('Сегодня - ','День космических войск' , 500, false);
                 if Day = 5 then soobchenie('Сегодня - ','День учителя' , 500, false);


          end;
          11:begin//ноябрь
                 if Day = 4 then soobchenie('Сегодня - ','День народного единства' , 500, false);
                 if Day = 30 then soobchenie('Сегодня - ','Международный день защиты информации' , 500, false);


          end;
          12:begin
                  if Day = 31 then soobchenie('vinPlayer','С наступающим '+ inttostr(Year + 1) + '-м годом!' , 500, false);

          end;
     end;
end;

procedure tags_id3;
var
ID3: TID3V1Rec;
t0,t1,t2:string;
i,l:byte;
baza_el:TData_DS;
begin

    baza_el:= ochered_vospr.tek_el();
    tek_id_track:=baza_el.id_track;
   if (baza_el.name_file <> 'пусто') and not b_open_baza then
   begin
       //filewav:= elbaza^.put + elbaza^.name_file;
       t0:=utf8tosys(baza_el.artist_id3);
       t1:=utf8tosys(baza_el.name_id3);
   end
   else
   begin
        ID3:= BASSID3ToID3V1Rec( BASS_channelGetTags(potok, BASS_TAG_ID3));
        t0:=ID3.Artist;
        t1:=ID3.Title;
   end;
   t2:=filewav;


   if (t1 = '') or (t0 ='') then
   begin
        i:=length(t2);
        l:=i;
        if i <> 0 then
        begin
             while (t2[i] <> '-') and (t2[i] <> #150) and (i>0) do i-=1;
             t1:=copy(t2,i+1,l-i);
             if (i=0) then
             begin
                  i:= length(t2);
                  l:=i;
                  while (t2[i] <> '\') and (i<>0) do i-=1;
                  t1:=copy(t2,i+1,l-i);
                  t0:='--Нет данных--';
             end
             else
             begin
                  l:=i;
                  while (t2[i] <> '\') and (i<>0) do i-=1;
                  t0:=copy(t2,i+1,l-i - 1);
                  t0:=SysToUtf8(t0);
             end;
        end;
   end
   else
   begin
        while (t1[1] = ' ') and (length(t1) > 1) do delete(t1, 1, 1);
        while (t0[1] = ' ') and (length(t0) > 1) do delete(t0, 1, 1);

        if ((t1[1] = '?') or (t0[1] ='?')) or ((t1[1] = ' ') or (t0[1] =' ')) then
        begin
             i:=length(t2);
             l:=i;
             while (t2[i] <> '-') and (t2[i] <> #150) and (i<>0) do i-=1;
             t1:=copy(t2,i+1,l-i);
             if (i=0) then
             begin
                  i:= length(t2);
                  l:=i;
                  while (t2[i] <> '\') and (i<>0) do i-=1;
                  t1:=copy(t2,i+1,l-i);
                  t0:='--Нет данных--';
             end
             else
             begin
                  l:=i;
                  while (t2[i] <> '\') and (i<>0) do i-=1;
                  t0:=copy(t2,i+1,l-i - 1);
                  t0:=SysToUtf8(t0);
             end;

        end
        else
        begin
             t0:=SysToUtf8(t0);
        end;

        while (t1[1] = ' ') and (length(t1) > 1) do delete(t1, 1, 1);
        while (t0[1] = ' ') and (length(t0) > 1) do delete(t0, 1, 1);
   end;
   t1:=SysToUtf8(t1);
   id3tag.Artist :=t0; //string(TAGS_Read(potok, '%ARTI'));//ZuBy_GetTags(filewav, gtArtist));
   id3tag.title  := t1;// string(TAGS_Read(potok, '%TITL'));//string(bid3));// SysToUTF8(ZuBy_GetTags(filewav, gtTitle));
   id3tag.Album  := SysToUTF8(ID3.Album); //string(TAGS_Read(potok, '%ALBM'));// SysToUTF8(ZuBy_GetTags(filewav, gtAlbum));
   if (ID3.Genre > 160) or (ID3.Genre < 0) then
   begin
        ID3.Genre := 160;
   end;
   id3tag.Genre  := cID3V1FGenre[ID3.Genre];//string(TAGS_Read(potok, '%GNRE'));//cID3V1FGenre[ID3.Genre];// SysToUTF8(ZuBy_GetTags(filewav, gtGenre));
   id3tag.Year   :=  ID3.Year;//string(TAGS_Read(potok, '%YEAR'));// SysToUTF8(ZuBy_GetTags(filewav, gtYear));
   id3tag.Comment:= ID3.Comment;//string(TAGS_Read(potok, '%CMNT'));// SysToUTF8(ZuBy_GetTags(filewav, gtComment));
end;

procedure eqvol;
begin
   fx[1] := BASS_ChannelSetFX(potok, BASS_FX_DX8_PARAMEQ, 1);
   fx[2] := BASS_ChannelSetFX(potok, BASS_FX_DX8_PARAMEQ, 1);
   fx[3] := BASS_ChannelSetFX(potok, BASS_FX_DX8_PARAMEQ, 1);
   fx[4] := BASS_ChannelSetFX(potok, BASS_FX_DX8_PARAMEQ, 1);
   fx[5] := BASS_ChannelSetFX(potok, BASS_FX_DX8_PARAMEQ, 1);
   fx[6] := BASS_ChannelSetFX(potok, BASS_FX_DX8_PARAMEQ, 1);
   fx[7] := BASS_ChannelSetFX(potok, BASS_FX_DX8_PARAMEQ, 1);
   fx[8] := BASS_ChannelSetFX(potok, BASS_FX_DX8_PARAMEQ, 1);
   fx[9] := BASS_ChannelSetFX(potok, BASS_FX_DX8_PARAMEQ, 1);
   fx[10] := BASS_ChannelSetFX(potok, BASS_FX_DX8_PARAMEQ, 1);

    //настройка первого канала эквалайзера
    pb.fGain :=fx1[1];                 //усиление
    pb.fBandwidth := 20;//6                //ширина полосы пропускания
    pb.fCenter := 80;                  //частота регулирования
    BASS_FXSetParameters(fx[1], @pb);  //применение заданных настроек

    pb.fGain := fx1[2];
    pb.fBandwidth := 20;
    pb.fCenter := 170;
    BASS_FXSetParameters(fx[2], @pb);

    pb.fGain := fx1[3];
    pb.fBandwidth := 20;
    pb.fCenter := 310;
    BASS_FXSetParameters(fx[3], @pb);

    pb.fGain := fx1[4];
    pb.fBandwidth := 20;
    pb.fCenter := 600;
    BASS_FXSetParameters(fx[4], @pb);

    pb.fGain := fx1[5];
    pb.fBandwidth :=20;
    pb.fCenter := 1000;
    BASS_FXSetParameters(fx[5], @pb);

    pb.fGain := fx1[6];
    pb.fBandwidth := 20;
    pb.fCenter := 3000;
    BASS_FXSetParameters(fx[6], @pb);

    pb.fGain := fx1[7];
    pb.fBandwidth := 20;
    pb.fCenter := 6000;
    BASS_FXSetParameters(fx[7], @pb);

    pb.fGain := fx1[8];
    pb.fBandwidth := 20;
    pb.fCenter := 10000;
    BASS_FXSetParameters(fx[8], @pb);

    pb.fGain := fx1[9];
    pb.fBandwidth := 20;
    pb.fCenter := 12000;
    BASS_FXSetParameters(fx[9], @pb);

    pb.fGain := fx1[10];
    pb.fBandwidth := 20;
    pb.fCenter := 14000;
    BASS_FXSetParameters(fx[10], @pb);

end;

procedure oshibki;
begin
       case BASS_ErrorGetCode of
       //0:errcode:='Воспроизведение однако...';
       1:errcode:='---> memory error <---';
       2:errcode:='---> cant open the file <---';
       3:errcode:='---> cant find a free sound driver <---';
       4:errcode:='---> the sample buffer was lost <---';
       5:errcode:='---> invalid handle <---';
       6:errcode:='---> unsupported sample format <---';
       7:errcode:='---> invalid position <---';
       8:errcode:='---> BASS_Init has not been successfully called <---';
       9:errcode:='---> BASS_Start has not been successfully called <---';
       14:errcode:='---> already initialized/paused/whatever <---';
       18:errcode:='---> cant get a free channel <---';
       19:errcode:='---> an illegal type was specified <---';
       20:errcode:='---> an illegal parameter was specified <---';
       21:errcode:='---> no 3D support <---';
       22:errcode:='---> no EAX support <---';
       23:errcode:='---> illegal device number <---';
       24:errcode:='---> not playing <---';
       25:errcode:='---> illegal sample rate <---';
       27:errcode:='---> the stream is not a file stream <---';
       29:errcode:='---> no hardware voices available <---';
       31:errcode:='---> the MOD music has no sequence data <---';
       32:errcode:='---> no internet connection could be opened <---';
       33:errcode:='---> couldnt create the file <---';
       34:errcode:='---> effects are not enabled <---';
       37:errcode:='---> requested data is not available <---';
       38:errcode:='---> the channel is a "decoding channel" <---';
       39:errcode:='---> a sufficient DirectX version is not installed <---';
       40:errcode:='---> connection timedout <---';
       41:errcode:='---> unsupported file format <---';
       42:errcode:='---> unavailable speaker <---';
       43:errcode:='---> invalid BASS version (used by add-ons) <---';
       44:errcode:='---> codec is not available/supported <---';
       45:errcode:='---> the channel/file has ended <---';
       46:errcode:='---> the device is busy <---'
       else errcode:='---> error какой то... <---';
       end;
       if (BASS_ErrorGetCode = 0) then
       begin
            form2.label2.caption := ' ';
            form1.Image4.Top:=96;
            form1.Image4.Left:=0;
            form2.Image19.Top:=306;
            form2.Image19.Left:=0;
       end
       else
       begin
               form2.label2.caption := errcode;
               if BASS_ErrorGetCode <> 37 then
               begin
                    form1.Image4.Top:=0;
                    form1.Image4.Left:=0;
                    form2.Image19.Top:=0;
                    form2.Image19.Left:=0;
                    PlaySound('res/sig3.wav',0,SND_ASYNC);
               end
               else
               begin
                    form1.Image4.Top:=96;
                    form1.Image4.Left:=0;
                    form2.Image19.Top:=306;
                    form2.Image19.Left:=0;
               end;
       end;
end;


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                      Процедуры от интернет радио                           //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

procedure  recording_odnaco;
begin
    if rec_mode then
    begin //окончание записи

       BASS_Encode_Stop(potok);
       if otl then vplayer.memo1.lines.Add('Окончание записи');
       if RenameFile(ExtractFilePath(paramstr(0)) +'rec/' + '111.mp3', ExtractFilePath(paramstr(0)) + 'rec/' + name_rec_track)
  then soobchenie('vinPlayer - запись','Запись завершена', 400, false)
  else soobchenie('vinPlayer - запись','Запись завершена с ошибкой, проверь файл ''111.mp3''.', 400, false);
       //PlaySound('res/sig1v2.wav',0,SND_ASYNC);

       //form3.internet_radio_rec.caption:='Запись';
       rec_mode:=false;
    end
    else
    begin //начало записи
         if bool_internet then
         begin
              shzapisi += 1;
              name_rec_track := inttostr(shzapisi) + '_' + internet_name_track + '.mp3';
              soobchenie('vinPlayer - запись','Файл ' + name_rec_track, 400, false);
              BASS_Encode_Start(potok, PChar('lame.exe --alt-preset standard - ' +ExtractFilePath(paramstr(0)) +'rec/'+ '111.mp3' {+ ExtractFilePath(paramstr(0)) + inttostr(shzapisi) + '_' + internet_name_track + '.mp3'}), BASS_ENCODE_AUTOFREE {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF}, nil, nil);
              if otl then vplayer.memo1.lines.Add('lame.exe --alt-preset standard - ' +ExtractFilePath(paramstr(0)) +'rec/'+ '111.mp3');

              //form3.internet_radio_rec.caption:='Остановить запись';
              rec_mode:=true;
         end;
    end;

end;
procedure DoMeta();
var
  meta: PAnsiChar;
  p: Integer;
begin
  meta := BASS_ChannelGetTags(potok, BASS_TAG_META);
  if (meta <> nil) then
  begin
    p := Pos('StreamTitle=', String(AnsiString(meta)));
    if (p = 0) then
      Exit;
    p := p + 13;
    internet_name_track:=String(Copy(meta, p, Pos(';', String(meta)) - p - 1));
    soobchenie('vinPlayer - интернет',internet_name_track, 600, false);
  end;
end;


procedure potok_load.Execute;
begin

     connecting_internet_vospr:=1;
    potok := BASS_StreamCreateURL (PChar(urll),0,0,nil,nil);
     connecting_internet_vospr:=0;
    Synchronize(@internet_vospr_end_load);
end;

procedure internet_vospr(url:string; rejim:byte=0);
begin
     rejim_internet_vospr:=rejim;
     if rejim_internet_vospr=0 then
                                  PlaySound('res/sig1v2.wav',0,SND_ASYNC);
     urll:=url;
     stop;
     BASS_StreamFree(potok);
     if otl then vplayer.memo1.lines.Add('StreamFree');
     pload := potok_load.Create(False);
     soobchenie('vinPlayer - интернет','Буферизация... хз%', 900, false);
end;

procedure potok_load.internet_vospr_end_load;
begin
    if potok = 0 then soobchenie('vinPlayer - интернет','Ошибочка вышла...', 400, false)
    else
    begin
         if rejim_internet_vospr=0 then
                          bool_internet := true;
    eqvol;
    oshibki;
    play;
    end;
end;

////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//               Поиск в списке трека, по его номеру.                         //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
procedure play_id(num:word);
var  baza_el:TData_dS;
     b:boolean;
     //tmp:string;
begin
     b:=true;
     baza_el:=ochered_vospr.goend();
     while (num <> baza_el.id_track)and b do
     begin
          baza_el:=ochered_vospr.Next();
          //tmp:=baza_el.name_file;
          if baza_el.name_file = 'пусто' then
          begin
               b:=false;
               soobchenie('Ошибка','Внутренняя ошибка при работе с базой!!!', 500, false);
          end;
     end;
     if b then
     begin
          tek_source:=baza_el.source;
          if (baza_el.source = 0) or (baza_el.source=2) then
          begin
               filewav:= baza_el.put + baza_el.name_file;
               stop;
               filewavPChar:=PChar(filewav);
               vospr;
               napr_prok:=true;
               play;
          end;
          if baza_el.source = 1 then
          begin
               stop;
               //soobchenie('VK _Audio','Аудиозапись вк', 500, false);

               if connecting_internet_vospr=0 then
                  internet_vospr(baza_el.url, 1);
          end;
     end;
end;
{var tmp:TData_Ds;
begin
   tmp:=spisok_baza.NeNext();
     if tmp.name_file <> 'пусто' then
     begin
          filewav:= tmp.put + tmp.name_file;
          stop;
          filewavPChar:=PChar(filewav);
          vospr;
          napr_prok:=true;
          play;
     end;
end;  }
////////////////////////////////////////////////////////////////////////////////


procedure vospr;
begin
    AB:=false;
   bool_internet := false;
   BASS_StreamFree(potok);
   if otl then vplayer.memo1.lines.Add('StreamFree');
   if pos('.flac', filewav) <> 0 then
   begin
        potok := BASS_FLAC_StreamCreateFile(FALSE, filewavPChar, 0, 0, 0);
   end
   else
   begin
        potok := Bass_streamCreateFile(false,filewavPChar,0,0,0);
   end;
   if otl then vplayer.memo1.lines.Add('streamCreateFile: ' + filewav);
   tl := BASS_ChannelBytes2Seconds(potok, BASS_ChannelGetLength(potok,0));
   if otl then vplayer.memo1.lines.Add('BASS_ChannelBytes2Seconds(potok, BASS_ChannelGetLength(potok,0))');
   eqvol;
   vpt_open2:=false;
end;

procedure play_stop;
begin
    if b_play_stop then
    begin
       b_play_stop:=false;
       pause;
    end
    else
    begin
       b_play_stop:=true;
       play;
    end;
end;

procedure play;
begin
    b_play_stop:=true;
    BASS_ChannelSetAttribute(potok,BASS_ATTRIB_VOL, vol);
    if otl then vplayer.memo1.lines.Add('ChannelSetAttribute');
    Bass_channelPlay(potok, false);
    if otl then vplayer.memo1.lines.Add('channelPlay');
    tags_id3;
    if bool_internet then
    begin
      doMeta;
    end
    else
    begin
         if (id3tag.Artist = '' )and (id3tag.title = '') then
            soobchenie('Нет ID3', systoutf8(filewav), 600, napr_prok)
         else
             soobchenie(id3tag.Artist,id3tag.title, 500, napr_prok);
    end;
    napr_prok:=true;
    oshibki;
end;

procedure stop;
begin
    b_play_stop:=false;
    bool_internet := false;
    if rec_mode then recording_odnaco;
    BASS_ChannelStop(potok);
    if otl then vplayer.memo1.lines.Add('ChannelStop');
    BASS_StreamFree(potok);
    if otl then vplayer.memo1.lines.Add('StreamFree');
    potok := Bass_streamCreateFile(false,filewavPChar,0,0,0);
    if otl then vplayer.memo1.lines.Add('streamCreateFile');
    eqvol;
end;

procedure pause;
begin
    b_play_stop:=false;
    soobchenie('','Пауза', 250, false);
    BASS_ChannelPause(potok);
    if otl then vplayer.memo1.lines.Add('ChannelPause');
end;

procedure per(p:word);
begin
     BASS_ChannelSetPosition(potok, round((p / 1000) * BASS_ChannelGetLength(potok,0) ), 0);
     if otl then vplayer.memo1.lines.Add('ChannelSetPosition');
     if (id3tag.Artist = '' )and (id3tag.title = '') then
    soobchenie('Нет ID3', systoutf8(filewav), 600, true)
    else
    soobchenie(id3tag.Artist,id3tag.title, 500, true);
end;

procedure conf_vospr;
begin
     if cv then
     begin
          per(0);
          play();
     end
     else
     begin
          vospr_next;
     end;
end;

procedure loadconf;
begin
   if otl then vplayer.memo1.lines.Add('loadconf');
     IniFile:=TIniFile.Create(ExtractFilePath(paramstr(0)) + 'Config.ini');
     vol:=iniFile.readfloat('gromkost','zn',0.9);
     cv:=iniFile.readbool('povt','zn',false);
     fx1[1]:=iniFile.ReadInteger('eq','z80',0);
     fx1[2]:=iniFile.ReadInteger('eq','z170',0);
     fx1[3]:=iniFile.ReadInteger('eq','z310',0);
     fx1[4]:=iniFile.ReadInteger('eq','z600',0);
     fx1[5]:=iniFile.ReadInteger('eq','z1000',0);
     fx1[6]:=iniFile.ReadInteger('eq','z3000',0);
     fx1[7]:=iniFile.ReadInteger('eq','z6000',0);
     fx1[8]:=iniFile.ReadInteger('eq','z10000',0);
     fx1[9]:=iniFile.ReadInteger('eq','z12000',0);
     fx1[10]:=iniFile.ReadInteger('eq','z14000',0);
     n:=iniFile.ReadInteger('bass','ystr', -1);
     hz:=iniFile.ReadInteger('bass','hz',44100);
     zakr_pan:=iniFile.readbool('panel','zn',false);

     zn_timer3:=iniFile.ReadInteger('timer','t3',30);
     nastr_zn_timer3:=zn_timer3;

     shzapuskov:=iniFile.ReadInteger('vPlayer','sh',0);
     global_time_vospr:=iniFile.ReadInteger('vPlayer','time',0);

     access_token := iniFile.readstring('vPlayer','at', 'null');
     vk_user_id:=iniFile.readstring('vPlayer','ui', 'null');

end;

procedure saveconf;
begin
     shzapuskov += 1;
     iniFile.writefloat('gromkost','zn',vol);
     iniFile.WriteBool('povt','zn',cv);
     iniFile.WriteBool('panel','zn',zakr_pan);
     iniFile.WriteInteger('eq','z80',fx1[1]);
     iniFile.WriteInteger('eq','z170',fx1[2]);
     iniFile.WriteInteger('eq','z310',fx1[3]);
     iniFile.WriteInteger('eq','z600',fx1[4]);
     iniFile.WriteInteger('eq','z1000',fx1[5]);
     iniFile.WriteInteger('eq','z3000',fx1[6]);
     iniFile.WriteInteger('eq','z6000',fx1[7]);
     iniFile.WriteInteger('eq','z10000',fx1[8]);
     iniFile.WriteInteger('eq','z12000',fx1[9]);
     iniFile.WriteInteger('eq','z14000',fx1[10]);
     iniFile.WriteString('file','posl', string(filewav));
     if tek_source = 0 then
            iniFile.WriteInteger('file','nom', tek_id_track)
     else
            iniFile.WriteInteger('file','nom', 0);

     iniFile.WriteInteger('file','time',tp1);
     iniFile.writeInteger('bass','ystr',n);
     iniFile.writeInteger('bass','hz',hz);

     iniFile.WriteInteger('timer','t3',nastr_zn_timer3);
     iniFile.writeInteger('vPlayer','sh',shzapuskov);
     iniFile.writeInteger('vPlayer','time',global_time_vospr);

     iniFile.writestring('vPlayer','at', access_token);
     iniFile.writestring('vPlayer','ui', vk_user_id);
     IniFile.Free;
end;

procedure reinit(n0:shortint;hz0:dword);
begin
   n:=n0;
   hz:=hz0;
   exit_odnaco;
   BASS_Init(n, hz, 0, potok, nil);
   if otl then vplayer.memo1.lines.Add('Init');
   dispose_baza;
   init_player;
end;

procedure init_player;//(n:shortint,hz:dword);
begin

     randomize;
   vk_load_run:=false;
   vol := 0.5;
   global_time_sec:=40;
   napr_prok:=true;//начальное направление прокрутки
   bool_internet:=false;
   rec_mode:=false;
   b_open_baza:=false;
   shzapisi := 0;
   b_scan:=false;
   fx1[1] :=0;
   fx1[2] :=0;
   fx1[3] :=0;
   fx1[4] :=0;
   fx1[5] :=0;
   fx1[6] :=0;
   fx1[7] :=0;
   fx1[8] :=0;
   fx1[9] :=0;
   fx1[10] :=0;
   fx1[11] :=0;
   sht:=0;
   loadconf;//Загрузка настроек
   cmdparam;//получение параметров при запуске
   BASS_Init(n, hz, 0, potok, nil);
   if otl then vplayer.memo1.lines.Add('Init');
   load_baza;//Загрузка медиа базы
   //chto_za_den;
   case shzapuskov of
   0:soobchenie('vinPlayer','Здрасте!', 500, false);
   ///
   {0:soobchenie('vinPlayer','Привет Дарья!:)', 500, false);
   1:soobchenie('vinPlayer','Здравствуй Дарья!:)', 500, false);
   2:soobchenie('vinPlayer','Привет Дарья!:)', 500, false);
   3:soobchenie('vinPlayer','Привет Дарья!:)', 500, false); }

   ///
   10:soobchenie('vinPlayer','Десятый запуск!', 500, false);
   100:soobchenie('vinPlayer','Сотый запуск! Ура товарищи!!!', 500, false);
   end;
end;

procedure dispose_baza;
begin
   spisok_baza.del_all();
   ochered_vospr.del_all();
   spisok_vospr.del_all();
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//                          put:string[255];                                  //
//                          name_file:string[100];                            //
//                          col_powt : word;                                  //
//                          kopija, muzika:boolean;                           //
//                          id3_inf:record                                    //
//                                        name_id3:string[150];               //
//                                        artist_id3:string[50];              //
//                                        album_id3:string[50];               //
//                                        god_id3:string[5];                  //
//                                        genre_id3:string[25]                //
//                          end;                                              //
//                          razmer:int64;                                     //
//                          time_izm:int64                                    //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
procedure load_info_track(name_track:string;
                          out o_put:string;
                          out o_col_powt:word;
                          out o_kopija, o_muzika:boolean;
                          out o_name_id3:string;
                          out o_artist_id3, o_album_id3, o_god_id3, o_genre_id3:string;
                          out o_razmer, o_time_izm:int64);
var end_prov:boolean;
begin
     end_prov:=false;
     if not b_scan then
     begin
        assign(fff, ExtractFilePath(paramstr(0)) + 'media_baza.vin92');
        {$I-}
        reset(fff);
        {$I+}
        if ioresult=0 then
        begin
             while (not eof(fff)) and (not b_scan) and not end_prov do
             begin
                  read(fff, element);
                  if (not element.kopija) and (name_track = element.name_file) then
                  begin
                       o_put := element.put;
                       o_col_powt := element.col_powt;
                       o_kopija := element.kopija;
                       o_muzika := element.muzika;
                       o_name_id3 := element.id3_inf.name_id3;
                       o_artist_id3 := element.id3_inf.artist_id3;
                       o_album_id3 := element.id3_inf.album_id3;
                       o_god_id3 := element.id3_inf.god_id3;
                       o_genre_id3 := element.id3_inf.genre_id3;
                       o_razmer := element.razmer;
                       o_time_izm := element.time_izm;
                       end_prov:=true;
                  end;
             end;
             if not end_prov then
             begin
                  soobchenie('vinPlayer - ошибка','Файл не найден в базе!', 400, false);
                  o_put := '';
                  o_col_powt := 0;
                  o_kopija := false;
                  o_muzika := false;
                  o_name_id3 := '';
                  o_artist_id3 := '';
                  o_album_id3 := '';
                  o_god_id3 := '';
                  o_genre_id3 := '';
                  o_razmer := 0;
                  o_time_izm := 0;
             end;
             close(fff);
        end
        else
        begin
             soobchenie('vinPlayer - ошибка','Не могу открыть базу!', 400, false);
        end;
   end;
end;
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

procedure cmdparam;
var i:byte;
     tmp_str:string;
begin
     audio_p:=TStringList.Create;
     if paramCount <> 0 then
     begin
          for i:=1 to paramCount do
          begin
               tmp_str:=paramstr(i);
               if tmp_str[1]<>'-' then
               begin
                    audio_p.Add(paramstr(i));
               end
               else
               begin
                    soobchenie('vinPlayer','есть параметры для запуска!!!', 400, false);
                    case tmp_str of
                    '-console': vplayer.top:=30;



                    end;
               end;
          end;
     end;
     perv_load_baza:=true;
end;

procedure load_baza;
var {j,}i:word;
  b:boolean;
  soobch:string;
  baza_el:TData_dS;
  //_s:byte;
  _nom:int64;
  in_audio:boolean=false;
begin
   //////////
   //j:=0;
   b:=false;
   soobch:='Ошибка...';
   i:=0;//
   ch_baza:=0;
   if (not b_scan) and (not b_open_baza) then
   begin
        assign(fff, ExtractFilePath(paramstr(0)) + 'media_baza.vin92');
        {$I-}
        reset(fff);
        {$I+}
        if ioresult<>0 then
        begin
             rewrite(fff);
        end;
        while (not eof(fff)) and (not b_scan) do
        begin
             read(fff, element);
             if not element.kopija and element.muzika then
             begin
                  ch_baza += 1;
                  baza_el.name_file:=element.name_file;
                  baza_el.put:=element.put;
                  baza_el.razmerfile:=element.razmer;
                  baza_el.timeizm:=element.time_izm;
                  baza_el.artist_id3:=element.id3_inf.artist_id3;
                  baza_el.name_id3:=element.id3_inf.name_id3;

                  baza_el.audio_id:='0';
                  baza_el.source:=0;
                  baza_el.id_track:=ch_baza;
                  baza_el.url:='NULL';
                  spisok_baza.add(baza_el);
                  ochered_vospr.add(baza_el);
                  spisok_vospr.add(baza_el);
             end;
        end;
        close(fff);
   end;
   _nom := iniFile.ReadInteger('file','nom', 0);
   if _nom = 0 then
   begin
        ch_baza += 1;
        baza_el.name_file:='';
        baza_el.put:=iniFile.Readstring('file','posl','res/start.mp3');
        baza_el.razmerfile:=2;
        baza_el.timeizm:=maxInt;
        baza_el.artist_id3:='';
        baza_el.name_id3:='';

        baza_el.audio_id:='0';
        baza_el.source:=0;
        baza_el.id_track:=ch_baza;
        baza_el.url:='NULL';
        spisok_baza.add(baza_el);
        ochered_vospr.add(baza_el);
        spisok_vospr.add(baza_el);
   end;

   if perv_load_baza then
   begin
        if (audio_p.count <> 0) then
        begin
             in_audio:=true;
             for i:=0 to audio_p.count - 1 do
             begin
                  ch_baza += 1;
                  baza_el.name_file:='';
                  baza_el.put:=audio_p.Strings[i];
                  baza_el.razmerfile:=2;
                  baza_el.timeizm:=maxInt;
                  baza_el.artist_id3:='';
                  baza_el.name_id3:='';

                  baza_el.audio_id:='0';
                  baza_el.source:=2;
                  baza_el.id_track:=ch_baza;
                  baza_el.url:='NULL';
                  spisok_baza.add(baza_el);
                  ochered_vospr.add(baza_el);
                  spisok_vospr.add(baza_el);
             end;
             audio_p.free;
        end;
        perv_load_baza:=false;
   end;
   spisok_baza.goend();
   if (_nom=0) or in_audio then
   begin
         tek_source:=2;
         ochered_vospr.goend();
         spisok_vospr.goend();
         filewav:=baza_el.put;
         filewavPChar:=PChar(filewav);
         vospr;
         play;
   end
   else
   begin
        play_id(_nom);
   end;


   BASS_ChannelSetPosition(potok,inifile.ReadInteger('file','time',0), 0);
   if otl then vplayer.memo1.lines.Add('ChannelSetPosition');

   if b then soobchenie('vinPlayer',soobch, 9000, false) else chto_za_den;
end;

procedure add_files_to_trasc_list(p:string);
var baza_el:TData_dS;
begin
    ch_baza += 1;
    baza_el.name_file:='';
    baza_el.put:=p;
    baza_el.razmerfile:=2;
    baza_el.timeizm:=maxInt;
    baza_el.artist_id3:='';
    baza_el.name_id3:='';

    baza_el.audio_id:='0';
    baza_el.source:=2;
    baza_el.id_track:=ch_baza;
    baza_el.url:='NULL';
    //spisok_baza.add(baza_el);
    //spisok_baza.goend();

   ochered_vospr.add(baza_el);
   ochered_vospr.goend();
   spisok_vospr.add(baza_el);
   spisok_vospr.goend();
end;

procedure sort_po_artist(n,m:int64;ni,mj:uk;napr:boolean);
var i, j:int64;
  ei,ej,t:uk;
  mid:string[50];
begin
    i:=n;
    ei:=ni;
    j:=m;
    ej:=mj;
    mid:=ei^.artist_id3;
    repeat
    begin
        while ((ei^.artist_id3 > mid) and (not napr)) or ((ei^.artist_id3 < mid) and napr) do
        begin
             inc(i);
             ei:=ei^.neNextadress;
        end;
        while ((ej^.artist_id3 < mid) and (not napr)) or ((ej^.artist_id3 > mid) and  napr) do
        begin
             dec(j);
             ej:=ej^.Nextadress;
        end;
        if i <= j then
        begin
             new(t);
             t^.put:=ei^.put;
             t^.name_file:=ei^.name_file;
             t^.razmerfile:=ei^.razmerfile;
             t^.timeizm:=ei^.timeizm;
             t^.artist_id3:=ei^.artist_id3;
             t^.name_id3 := ei^.name_id3;
             ei^.put:=ej^.put;
             ei^.name_file:=ej^.name_file;
             ei^.razmerfile:=ej^.razmerfile;
             ei^.timeizm:=ej^.timeizm;
             ei^.artist_id3:=ej^.artist_id3;
             ei^.name_id3 := ej^.name_id3;
             ej^.put:=t^.put;
             ej^.name_file:=t^.name_file;
             ej^.razmerfile:=t^.razmerfile;
             ej^.timeizm:=t^.timeizm;
             ej^.artist_id3:=t^.artist_id3;
             ej^.name_id3 := t^.name_id3;
             dispose(t);
             inc(i);
             ei:=ei^.neNextadress;
             dec(j);
             ej:=ej^.Nextadress;
        end;
    end;
    until i > j;
    if n < j then sort_po_artist(n, j, ni, ej, napr);
    if i < m then sort_po_artist(i, m, ei, mj, napr);
end;

procedure sort_po_timeizm(n,m:int64;ni,mj:uk);
var i, j, mid:int64;
  ei,ej,t:uk;
begin
    i:=n;
    ei:=ni;
    j:=m;
    ej:=mj;
    mid:=ei^.timeizm;
    repeat
    begin
        while ei^.timeizm > mid do
        begin
             inc(i);
             ei:=ei^.neNextadress;
        end;
        while ej^.timeizm < mid do
        begin
             dec(j);
             ej:=ej^.Nextadress;
        end;
        if i <= j then
        begin
             new(t);
             t^.put:=ei^.put;
             t^.name_file:=ei^.name_file;
             t^.razmerfile:=ei^.razmerfile;
             t^.timeizm:=ei^.timeizm;
             t^.artist_id3:=ei^.artist_id3;
             t^.name_id3 := ei^.name_id3;
             ei^.put:=ej^.put;
             ei^.name_file:=ej^.name_file;
             ei^.razmerfile:=ej^.razmerfile;
             ei^.timeizm:=ej^.timeizm;
             ei^.artist_id3:=ej^.artist_id3;
             ei^.name_id3 := ej^.name_id3;
             ej^.put:=t^.put;
             ej^.name_file:=t^.name_file;
             ej^.razmerfile:=t^.razmerfile;
             ej^.timeizm:=t^.timeizm;
             ej^.artist_id3:=t^.artist_id3;
             ej^.name_id3 := t^.name_id3;
             dispose(t);
             inc(i);
             ei:=ei^.neNextadress;
             dec(j);
             ej:=ej^.Nextadress;
        end;
    end;
    until i > j;
    if n < j then sort_po_timeizm(n, j, ni, ej);
    if i < m then sort_po_timeizm(i, m, ei, mj);
end;

procedure exit_odnaco;
begin
  tp1:= BASS_ChannelGetPosition(potok,0);
   Bass_Stop(); //останавливаем проигрывание
   BASS_StreamFree(potok); // освобождаем звуковой канал
   Bass_Free;
   saveconf;//сохранение настроек
end;

procedure vospr_next;
var tmp:TData_Ds;
begin
     //tmp:=spisok_baza.Next();ochered_vospr


     //tmp:=ochered_vospr.el[tek_id_track-1];

     tmp:=ochered_vospr.Next();
     if tmp.name_file <> 'пусто' then
     begin
          if (tmp.source = 0) or (tmp.source=2) then
          begin
               tek_source:=tmp.source;
               filewav:= tmp.put + tmp.name_file;
               stop;
               filewavPChar:=PChar(filewav);
               vospr;
               napr_prok:=true;
               play;
          end;
          if tmp.source = 1 then
          begin
               stop;
               //soobchenie('VK _Audio','Аудиозапись вк', 500, false);

               if connecting_internet_vospr=0 then
                  internet_vospr(tmp.url, 1);
          end;
     end;
end;

procedure vospr_neNext;
var tmp:TData_Ds;
begin
     //tmp:=spisok_baza.NeNext();

     //tmp:=ochered_vospr.el[tek_id_track+1];

     tmp:=ochered_vospr.NeNext();
     if tmp.name_file <> 'пусто' then
     begin
          if (tmp.source = 0) or (tmp.source=2) then
          begin
               tek_source:=tmp.source;
               filewav:= tmp.put + tmp.name_file;
               stop;
               filewavPChar:=PChar(filewav);
               vospr;
               napr_prok:=true;
               play;
          end;
          if tmp.source = 1 then
          begin
               stop;
               //soobchenie('VK _Audio','Аудиозапись вк', 500, false);

               if connecting_internet_vospr=0 then
                  internet_vospr(tmp.url, 1);
          end;
    end;
end;

procedure vizual;
var i : byte;
  zn: array [1..16] of Single;
begin
   for i := 1 to 16 do
   begin
       zn[i] := ((FFTFata[1+(8*(i-1))] + FFTFata[2+(8*(i-1))] + FFTFata[3+(8*(i-1))] + FFTFata[4+(8*(i-1))] + FFTFata[5+(8*(i-1))] + FFTFata[6+(8*(i-1))] + FFTFata[7+(8*(i-1))] + FFTFata[8+(8*(i-1))]) / 8) * (-41);
   end;
   form2.image2.top := round(zn[1] * 2 + 44);
   form2.image3.top := round(zn[2] * 5 + 44);
   form2.image4.top := round(zn[3] * 7 + 44);
   form2.image5.top := round(zn[4] * 7 + 44);
   form2.image6.top := round(zn[5] * 7 + 44);
   form2.image7.top := round(zn[6] * 9 + 44);
   form2.image8.top := round(zn[7] * 9 + 44);
   form2.image9.top := round(zn[8] * 11 + 44);
   form2.image10.top := round(zn[9] * 11 + 44);
   form2.image11.top := round(zn[10] * 11 + 44);
   form2.image12.top := round(zn[11] * 12 + 44);
   form2.image13.top := round(zn[12] * 12 + 44);
   form2.image14.top := round(zn[13] * 12 + 44);
   form2.image15.top := round(zn[14] * 12 + 44);
   form2.image16.top := round(zn[15] * 13 + 44);
   form2.image17.top := round(zn[16] * 13 + 44);
end;


procedure Proc;
var  baza_el:TData_dS;
     id3_name, id3_artist_, id3_album:string;
begin
     soobchenie('Консоль', 'Команда "' + in_comm + '".', 400, true);
     case in_comm of
     '0':begin
              per(0);
              vplayer.memo1.lines.Add('per 0');
     end;
     '1':begin
              per(100);
              vplayer.memo1.lines.Add('per 1');
     end;
     '2':begin
              per(200);
              vplayer.memo1.lines.Add('per 2');
     end;
     '3':begin
              per(300);
              vplayer.memo1.lines.Add('per 3');
     end;
     '4':begin
              per(400);
              vplayer.memo1.lines.Add('per 4');
     end;
     '5':begin
              per(500);
              vplayer.memo1.lines.Add('per 5');
     end;
     '6':begin
              per(600);
              vplayer.memo1.lines.Add('per 6');
     end;
     '7':begin
              per(700);
              vplayer.memo1.lines.Add('per 7');
     end;
     '8':begin
              per(800);
              vplayer.memo1.lines.Add('per 8');
     end;
     '9':begin
              per(900);
              vplayer.memo1.lines.Add('per 9');
     end;
     'x':pause;
     'c':play;
     'v':stop;
     '-':begin
              vol-=0.04;
              vplayer.memo1.lines.Add('уменьшение громкости');
              BASS_ChannelSetAttribute(potok,BASS_ATTRIB_VOL, vol);
     end;
     '=':begin
              vol+=0.04;
              vplayer.memo1.lines.Add('увеличение громкости');
              BASS_ChannelSetAttribute(potok,BASS_ATTRIB_VOL, vol);
     end;
     'q':begin
              BASS_FXGetParameters(fx[1], @pb);
              fx1[1] +=1;
              pb.fgain := fx1[1];
              BASS_FXSetParameters(fx[1], @pb);
     end;
     'a':begin
              BASS_FXGetParameters(fx[1], @pb);
              fx1[1] -=1;
              pb.fgain := fx1[1];
              BASS_FXSetParameters(fx[1], @pb);
     end;
     'w':begin
              BASS_FXGetParameters(fx[2], @pb);
              fx1[2] +=1;
              pb.fgain := fx1[2];
              BASS_FXSetParameters(fx[2], @pb);
     end;
     's':begin
              BASS_FXGetParameters(fx[2], @pb);
              fx1[2] -=1;
              pb.fgain := fx1[2];
              BASS_FXSetParameters(fx[2], @pb);
     end;
     'e':begin
              BASS_FXGetParameters(fx[3], @pb);
              fx1[3] +=1;
              pb.fgain := fx1[3];
              BASS_FXSetParameters(fx[3], @pb);
     end;
     'd':begin
              BASS_FXGetParameters(fx[3], @pb);
              fx1[3] -=1;
              pb.fgain := fx1[3];
              BASS_FXSetParameters(fx[3], @pb);
     end;
     'r':begin
              BASS_FXGetParameters(fx[4], @pb);
              fx1[4] +=1;
              pb.fgain := fx1[4];
              BASS_FXSetParameters(fx[4], @pb);
     end;
     'f':begin
              BASS_FXGetParameters(fx[4], @pb);
              fx1[4] -=1;
              pb.fgain := fx1[4];
              BASS_FXSetParameters(fx[4], @pb);
     end;
     't':begin
              BASS_FXGetParameters(fx[5], @pb);
              fx1[5] +=1;
              pb.fgain := fx1[5];
              BASS_FXSetParameters(fx[5], @pb);
     end;
     'g':begin
              BASS_FXGetParameters(fx[5], @pb);
              fx1[5] -=1;
              pb.fgain := fx1[5];
              BASS_FXSetParameters(fx[5], @pb);
     end;
     'y':begin
              BASS_FXGetParameters(fx[6], @pb);
              fx1[6] +=1;
              pb.fgain := fx1[6];
              BASS_FXSetParameters(fx[6], @pb);
     end;
     'h':begin
              BASS_FXGetParameters(fx[6], @pb);
              fx1[6] -=1;
              pb.fgain := fx1[6];
              BASS_FXSetParameters(fx[6], @pb);
     end;
     'u':begin
              BASS_FXGetParameters(fx[7], @pb);
              fx1[7] +=1;
              pb.fgain := fx1[7];
              BASS_FXSetParameters(fx[7], @pb);
     end;
     'j':begin
              BASS_FXGetParameters(fx[7], @pb);
              fx1[7] -=1;
              pb.fgain := fx1[7];
              BASS_FXSetParameters(fx[7], @pb);
     end;
     'i':begin
              BASS_FXGetParameters(fx[8], @pb);
              fx1[8] +=1;
              pb.fgain := fx1[8];
              BASS_FXSetParameters(fx[8], @pb);
     end;
     'k':begin
              BASS_FXGetParameters(fx[8], @pb);
              fx1[8] -=1;
              pb.fgain := fx1[8];
              BASS_FXSetParameters(fx[8], @pb);
     end;
     'o':begin
              BASS_FXGetParameters(fx[9], @pb);
              fx1[9] +=1;
              pb.fgain := fx1[9];
              BASS_FXSetParameters(fx[9], @pb);
     end;
     'l':begin
              BASS_FXGetParameters(fx[9], @pb);
              fx1[9] -=1;
              pb.fgain := fx1[9];
              BASS_FXSetParameters(fx[9], @pb);
     end;
     'p':begin
              BASS_FXGetParameters(fx[10], @pb);
              fx1[10] +=1;
              pb.fgain := fx1[10];
              BASS_FXSetParameters(fx[10], @pb);
     end;
     ';':begin
              BASS_FXGetParameters(fx[10], @pb);
              fx1[10] -=1;
              pb.fgain := fx1[10];
              BASS_FXSetParameters(fx[10], @pb);
     end;
     '`':begin //повтор on/off
               if cv then
                  cv:=false
               else
                   cv := true;
     end;
           'z':begin  //предыдущий
                      vospr_neNext;
           end;
           'b':begin  //следующий
                      vospr_next;

               end;
           'S':begin
                   scanirovanie('e:');
                   //dispose_baza;
                   //load_baza;
               end;
           'L':begin
                   dispose_baza;
                   load_baza;
               end;
           'C':begin
                    //sort_po_timeizm(0,ch_baza - 1,elbazaStart,elbazaNeStart);
                    soobchenie('Облом','Заблокировано...', 400, false);
               end;
           'I':soobchenie('Облом','Заблокировано...', 400, false); //sort_po_artist(0,ch_baza - 1,elbazaStart,elbazaNeStart, false);
           '/':begin
               //form1.visible:=not form1.visible;
               end;
           'K':begin
                  clipboard.SetTextBuf(PAnsiChar(systoutf8(filewav)));
                  soobchenie('Отладка', 'Скопировано в буфер: "' + systoutf8(filewav) + '"', 400, true);
              //copyfile
              end;
           'Vin92':begin otl:=true; soobchenie('Отладка', 'Режим вывода всякого разного', 400, true); end;
           'hide':vplayer.top:=-800;
           'Vin92-off':otl:=false;
           'stop':begin otl:=false; soobchenie('Отладка', 'Закончили выводить всякое разное', 400, true); end;
           'exit': exit_odnaco;
           'help':begin help_cons(); soobchenie('Отладка', 'Что? Помощь понадобилась?', 400, true); end;
           'clear': while vplayer.memo1.lines.Count <> 0 do vplayer.Memo1.Lines.Delete(0);
           'vptload':load_vpt;
           'vptprint':vptprint();
           'vptstop': vpt_open2:=false;
           'vk_load_audio_list':vk_loadAudio_potok:=T_vk_load_audio.Create(False);
           'vk_load_user':vk_load_user();
           'vk_messages':vk_data(1);//vk_getCounters();
           'vk_events':vk_data(2);
           'vk_get_messages':vk_get_messages();
           'vk_get_send_messages':vk_get_send_messages();
           'get_messag':vk_data(15);
           'vk_reset_messages':vk_reset_messages(false);
           'vk_Ne_reset_messages':vk_reset_messages(true);
           'vk_noread_messages':vk_noread_messages();
           'spisok_end':spisok_baza.goend();
           'spisok_begin':spisok_baza.gostart();
           'spisok_del_tek':spisok_baza.del_tek();
           'GetTags':vplayer.memo1.lines.Add(string(BASS_ChannelGetTags(potok, 1)));
           'spisok_tek':
             begin
                  baza_el:=spisok_baza.tek_el();
                  vplayer.memo1.lines.Add('/----id track ' + inttostr(baza_el.id_track));
                  vplayer.memo1.lines.Add(systoutf8(baza_el.put + baza_el.name_file));
                  vplayer.memo1.lines.Add('id3: name:' + baza_el.name_id3 + ', isp:' + baza_el.artist_id3);
                  vplayer.memo1.lines.Add('time:' + inttostr(baza_el.timeizm) + ', razm:' + inttostr(baza_el.razmerfile));
                  vplayer.memo1.lines.Add('ist:' + inttostr(baza_el.source) + ', url:' + baza_el.url + ', id:' + baza_el.audio_id);

                  vplayer.memo1.lines.Add('/------');
             end;
           'vospr_tek':
             begin
                  baza_el:=spisok_vospr.tek_el();
                  vplayer.memo1.lines.Add('/----id track ' + inttostr(baza_el.id_track));
                  vplayer.memo1.lines.Add(systoutf8(baza_el.put + baza_el.name_file));
                  vplayer.memo1.lines.Add('id3: name:' + baza_el.name_id3 + ', isp:' + baza_el.artist_id3);
                  vplayer.memo1.lines.Add('time:' + inttostr(baza_el.timeizm) + ', razm:' + inttostr(baza_el.razmerfile));
                  vplayer.memo1.lines.Add('ist:' + inttostr(baza_el.source) + ', url:' + baza_el.url + ', id:' + baza_el.audio_id);

                  vplayer.memo1.lines.Add('/------');
             end;
           'ochered_tek':
             begin
                  baza_el:=ochered_vospr.tek_el();
                  vplayer.memo1.lines.Add('/----id track ' + inttostr(baza_el.id_track));
                  vplayer.memo1.lines.Add(systoutf8(baza_el.put + baza_el.name_file));
                  vplayer.memo1.lines.Add('id3: name:' + baza_el.name_id3 + ', isp:' + baza_el.artist_id3);
                  vplayer.memo1.lines.Add('time:' + inttostr(baza_el.timeizm) + ', razm:' + inttostr(baza_el.razmerfile));
                  vplayer.memo1.lines.Add('ist:' + inttostr(baza_el.source) + ', url:' + baza_el.url + ', id:' + baza_el.audio_id +', s:' + inttostr(baza_el.source));

                  vplayer.memo1.lines.Add('/------');
             end;
           'spisok_next':spisok_baza.Next();
           'spisok_nenext':spisok_baza.NeNext();
           'pogoda':soobchenie('Яндекс погода', 'Гатчина: Завтра +1, облачно', 400, true);
           'get_id3':
             begin
                  vplayer.memo1.lines.Add(inttostr(get_id3_tags(filewav, id3_name, id3_artist_, id3_album)));
                  vplayer.memo1.lines.Add('Название: "' + id3_name + '", Артист: "'+id3_artist_+'", Альбом"' + id3_album + '"');
             end;
           else soobchenie('Консоль', 'Что за "' + in_comm + '"?', 400, true);
           end;
           in_comm:='';
end;

procedure copy_put_and_file;
begin

     clipboard.SetTextBuf(PAnsiChar(systoutf8(filewav)));
     soobchenie('vinPlayer', 'Скопировано в буфер: "' + systoutf8(filewav) + '"', 400, true);
end;

procedure vptprint();
var i:integer;
begin
    for i:=0 to count_vpt_strings - 1 do
    begin
         vplayer.memo1.lines.Add(vpt_strings[i]);
    end;
end;

procedure load_vpt;
var t:string;
    i:integer;
begin

     if not vpt_open then
     begin
        count_vpt_strings:=0;
        t:= filewav;
        i:=length(t);
        delete(t, i-3, i);
        t+='.vpt';
        vpt_file_name:=t;
        system.assign(vpt_file, vpt_file_name);
        {$I-}
        reset(vpt_file);
        {$I+}
        if ioresult=0 then
        begin
            i:=0;
             if otl then vplayer.memo1.lines.Add('загрузка vpt');
             vpt_open2:=true;
             while not eof(vpt_file) do
             begin
                  read(vpt_file,vpt_element);
                  vpt_time[i]:=vpt_element.time;
                  vpt_strings[i]:=vpt_element.stroka;
                  //if otl then vplayer.memo1.lines.Add(vpt_strings[i]);
                  count_vpt_strings+=1;
                  i+=1;
             end;
             vpt_time[i]:=1000;
             vpt_strings[i]:=' ';
             close(vpt_file);
             soobchenie('vinPlayer', 'Открыт: ' + SysToUtf8(t), 500, false);
        end
        else
        begin
             if otl then vplayer.memo1.lines.Add('vpt не может быть открыт');
             soobchenie('vinPlayer', 'Текст не найден', 500, false);
        end;
     end
     else
     begin
         if otl then vplayer.memo1.lines.Add('vpt файл занят');
         soobchenie('vinPlayer', 'Текст не может быть открыт', 500, false);
     end;
end;

procedure help_cons();
begin
    vplayer.memo1.lines.Add('/-----HELP-----/');
    vplayer.memo1.lines.Add('');
    vplayer.memo1.lines.Add('переход: клавиши 0-9');
    vplayer.memo1.lines.Add('громкость -/=');
    vplayer.memo1.lines.Add('x-pause, c-play, v-stop');
    vplayer.memo1.lines.Add('q/a,w/s,e/d,r/f,t/g,y/h,u/j,i/k,o/l,p/; - экв');
    vplayer.memo1.lines.Add('` - повтор on/off ');
    vplayer.memo1.lines.Add('z/b - навигация');
    vplayer.memo1.lines.Add('S - сканирование (е:)');
    vplayer.memo1.lines.Add('L - перезагрузка базы');
    vplayer.memo1.lines.Add('C - сорт. по врем.');
    vplayer.memo1.lines.Add('I - сорт. по исп.');
    vplayer.memo1.lines.Add('K - копировать тек. путь в буфер обмена');
    vplayer.memo1.lines.Add('Vin92 - активировать log');
    vplayer.memo1.lines.Add('hide - спрятать консоль');
    vplayer.memo1.lines.Add('stop - остановить log');
    vplayer.memo1.lines.Add('clear - отчистить');
    vplayer.memo1.lines.Add('exit - выход');
    vplayer.memo1.lines.Add('vptprint - печать текста песни');
    vplayer.memo1.lines.Add('vptload - загрузка текста песни');
    vplayer.memo1.lines.Add('vptstop - остановка текста песни');
    vplayer.memo1.lines.Add('vk_load_audio_list - загрузит список аудио');
    vplayer.memo1.lines.Add('vk_load_user - загрузить информацию о пользователе');
    vplayer.memo1.lines.Add('vk_messages - проверить счётчик новых сообщений');
    vplayer.memo1.lines.Add('vk_events - проверить счётчик новых событий');
    vplayer.memo1.lines.Add('vk_get_messages - получить список принятых сообщений');
    vplayer.memo1.lines.Add('vk_get_send_messages - получить список отправленных сообщений');
    vplayer.memo1.lines.Add('get_messag - показать непрочитанные сообщения');
    vplayer.memo1.lines.Add('vk_reset_messages - сброс первых 200т непрочитанных сообщений');
    vplayer.memo1.lines.Add('vk_Ne_reset_messages - отметить как не прочитанные');
    vplayer.memo1.lines.Add('vk_noread_messages - список не прочитанных входящих сообщений');

    vplayer.memo1.lines.Add('------------------------------');
end;

function set_vol(zn:single):single;
begin
    BASS_ChannelSetAttribute(potok,BASS_ATTRIB_VOL, zn);
    vol:=zn;
    set_vol:=zn*100;
end;

function eq_yatanowka_znachenij(nom:byte; zn:integer):integer;
begin
     zn:=zn*(-1);
     BASS_FXGetParameters(fx[nom], @pb);
     fx1[nom] :=zn;
     pb.fgain := zn;
     BASS_FXSetParameters(fx[nom], @pb);
     eq_yatanowka_znachenij:=zn;
end;

procedure Menu_sort_po_date;
begin
     soobchenie('Облом','Заблокировано...', 400, false);
end;

procedure Menu_sort_po_isp(n:boolean);
begin
     soobchenie('Облом','Заблокировано...', 400, false);
end;

{ Tvplayer }

procedure Tvplayer.FormClose(Sender: TObject{; var CloseAction: TCloseAction});
begin
   exit_odnaco;
end;

procedure Tvplayer.FormCreate(Sender: TObject);
begin
   vplayer.top:=-800;
   otl:=false;
   spisok_baza:=dSpisok.create();
   ochered_vospr:=dSpisok.create();
   spisok_vospr:=dSpisok.create();
end;

procedure Tvplayer.FormShortCut(var Msg: TLMKey; var Handled: Boolean);  //обработка не очень горячих клавиш
begin
     //soobchenie('vinPlayer(0)', 'Вы что-то нажали:' + inttostr(Msg.CharCode), 500, false);
   if otl then
      memo1.lines.Add('|' + inttostr(Msg.CharCode) + '|');
   if (Msg.CharCode = 13) and (edit1.text<> '') then
   begin
      in_comm:=edit1.text;
      memo1.lines.Add('--> ' + edit1.text);
      Proc;
      edit1.text:= '';
   end;

   if (Msg.CharCode = 112) and otl then
   begin
      help_cons();
   end;

   if (Msg.CharCode = 179) then
   begin
      play_stop;
   end;

   if (Msg.CharCode = 178) then
   begin
      stop;
   end;

   if (Msg.CharCode = 177) then
   begin
      vospr_neNext;
   end;

   if (Msg.CharCode = 176) then
   begin
      vospr_Next;
   end;
end;

procedure Tvplayer.Button1Click(Sender: TObject);
begin
      //edit1.text:= edit1.text + ' ';
      in_comm:=edit1.text;
      memo1.lines.Add('--> ' + edit1.text);
      Proc;
      edit1.text:= '';
end;

procedure Tvplayer.Button2Click(Sender: TObject);
begin
   //while vplayer.memo1.lines.Count <> 0 do
         //vplayer.Memo1.Lines.Delete(0);
    vplayer.Memo1.Lines.Clear;
end;

end.

