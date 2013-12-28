unit interf3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, Menus, StdCtrls, windows, player3_0u, interf4, interf, interf2, bass,
  scaner_vPlayer, progress_p, U_settings, iinterf7, interf9, interf11, interf12,
  types, vinPlayer_extern_extension, u_settings_dll, LMessages;

const
count=12; //число вершин в полигоне
chuvst=2; //чувствительность жестов
coun_menu_item=8;

type

  { TForm3 }

  TForm3 = class(TForm)
    BitBtn1: TBitBtn;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    internet_radio: TMenuItem;
    internet_radio_open: TMenuItem;
    internet_radio_rec: TMenuItem;
    Label1: TLabel;
    M_zan: TMenuItem;
    M_vk_load_list_param: TMenuItem;
    M_dll_settings: TMenuItem;
    M_vk_load_audio: TMenuItem;
    M_extern_dll: TMenuItem;
    M_version_osn_dll: TMenuItem;
    M_b: TMenuItem;
    M_vospr: TMenuItem;
    M_povt: TMenuItem;
    M_a: TMenuItem;
    M_disp_mess: TMenuItem;
    m_vk_mes_write: TMenuItem;
    M_vk_mess: TMenuItem;
    M_console: TMenuItem;
    M_dop: TMenuItem;
    M_vpt: TMenuItem;
    M_put: TMenuItem;
    M_red_vpt: TMenuItem;
    m_red_baza: TMenuItem;
    M_vk: TMenuItem;
    M_vk_in: TMenuItem;
    M_vk_sett: TMenuItem;
    M_scan_folder: TMenuItem;
    M_sort_po_isp_tuda: TMenuItem;
    M_open_file: TMenuItem;
    M_pokaz_list: TMenuItem;
    M_sort_po_date: TMenuItem;
    M_sort_po_isp: TMenuItem;
    M_music_baza: TMenuItem;
    M_sozd_baza: TMenuItem;
    M_reload_baza: TMenuItem;
    M_exit: TMenuItem;
    M_o_proge: TMenuItem;
    M_settings: TMenuItem;
    M_track_list: TMenuItem;
    OpenDialog1: TOpenDialog;
    PopupMenu1: TPopupMenu;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    Timer1: TTimer;
    Timer2: TTimer;
    TrayIcon1: TTrayIcon;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn1ContextPopup(Sender: TObject{; MousePos: TPoint;}
      {var Handled: Boolean});
    procedure FormClose(Sender: TObject{; var CloseAction: TCloseAction});
    procedure FormCreate(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
    procedure FormShortCut(var Msg: TLMKey; var Handled: Boolean);
    procedure Image2Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    {procedure Image11Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure Image7Click(Sender: TObject);
    procedure Image9Click(Sender: TObject);  }
    procedure internet_radioClick(Sender: TObject);
    procedure internet_radio_recClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure M_aClick(Sender: TObject);
    procedure M_bClick(Sender: TObject);
    procedure M_consoleClick(Sender: TObject);
    procedure M_disp_messClick(Sender: TObject);
    procedure M_dll_settingsClick(Sender: TObject);
    procedure M_exitClick(Sender: TObject);
    procedure M_music_bazaClick(Sender: TObject);
    procedure M_open_fileClick(Sender: TObject);
    procedure M_o_progeClick(Sender: TObject);
    procedure M_pokaz_listClick(Sender: TObject);
    procedure M_putClick(Sender: TObject);
    procedure m_red_bazaClick(Sender: TObject);
    procedure M_red_vptClick(Sender: TObject);
    procedure M_reload_bazaClick(Sender: TObject);
    procedure M_scan_folderClick(Sender: TObject);
    procedure M_settingsClick(Sender: TObject);
    procedure M_sort_po_dateClick(Sender: TObject);
    procedure M_sort_po_ispClick(Sender: TObject);
    procedure M_sort_po_isp_tudaClick(Sender: TObject);
    procedure M_sozd_bazaClick(Sender: TObject);
    procedure M_version_osn_dllClick(Sender: TObject);
    procedure M_vkClick(Sender: TObject);
    procedure M_vk_inClick(Sender: TObject);
    procedure M_vk_load_audioClick(Sender: TObject);
    procedure M_vk_load_list_paramClick(Sender: TObject);
    procedure m_vk_mes_writeClick(Sender: TObject);
    procedure M_vptClick(Sender: TObject);
    procedure M_zanClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    //procedure open_f;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form3: TForm3;
  mouse:TPoint;
  topF4, razm_jest:integer;
  menu_vibor:byte;
  ttt:integer;
  b0, b1, b2, b3, bvol, bm20, jest, start_vpt:boolean;
  perexod: array [0..5] of word;
  tvol:single;
  //vpt_i1:word;
  vpt_bool:boolean;
  vpt_temp_i:integer;
  m_vibor:byte;
  m_vib_beg, m_vib_beg_t, m_vib_vert, m_light_vert:real;
  rej_zan:boolean=false;

function pchar_to_str(zn0:string):string;

implementation

{$R *.lfm}

function pchar_to_str(zn0:string):string;
var
  i:byte;
  tmp:string;
begin
     tmp:='';
     i:=1;
     while zn0[i]<>#0 do
     begin
          tmp+=zn0[i];
          i+=1;
     end;
     pchar_to_str:=tmp;
end;

{ TForm3 }

procedure TForm3.FormCreate(Sender: TObject);
var
  points: array[1..count] of TPoint;
  CutRegion: LongWord;
begin
  start_vpt:=true;
  m_vib_beg:=-100.0;
  m_vib_beg_t:=-100.0;
  m_vibor:=0;
  m_vib_vert:=25;
  m_light_vert:=-3.3;
  image2.left:=-100;
  jest:=true;
  vpt_bool:=true;
  vpt_temp_i:=0;
  //vpt_i1:=0;
  ttt:=0;
  razm_jest:=1;
  b0:=false;
  b1:=false;
  b2:=false;
  b3:=false;
  bm20:=false;
  topF4 := -28;
   Form3.top := -4;
   form3.left := -21;
        {form3.Image2.top := 0;
        form3.Image2.left := 0;
        form3.Image3.top := 0;
        form3.Image3.left := 0;
        form3.Image4.top := 0;
        form3.Image4.left := 0;
        form3.Image5.top := 0;
        form3.Image5.left := 0;
        form3.Image6.top := 0;
        form3.Image6.left := 0;
        form3.Image7.top := 0;
        form3.Image7.left := 0;
        form3.Image8.top := 0;
        form3.Image8.left := 0;
        form3.Image9.top := 0;
        form3.Image9.left := 0;
        form3.Image10.top := 0;
        form3.Image10.left := 0;
        form3.Image11.top := 0;
        form3.Image11.left := 0;}
   points[1].X:=0; points[1].Y:=0; //1 точка
   points[2].X:=430; points[2].Y:=0; //2 точка
   points[3].X:=410; points[3].Y:=0;//3 точка
   points[4].X:=368; points[4].Y:=0;//4 точка
   points[5].X:=350; points[5].Y:=19;//5 точка
   points[6].X:=250; points[6].Y:=19;//6 точка
   points[7].X:=223; points[7].Y:=32; //7 точка
   points[8].X:=36; points[8].Y:=32; //8 точка
   points[9].X:=19; points[9].Y:=25; //9 точка
   points[10].X:=5; points[10].Y:=25; //10 точка
   points[11].X:=0; points[11].Y:=33; //11 точка
   points[12].X:=0; points[12].Y:=0; //12 точка
   CutRegion:=CreatePolygonRgn(points, count, ALTERNATE);
   SetWindowRgn(Handle, CutRegion, True);
   init_player;
   form3.timer1.interval := zn_timer3;
   //T1 := potok_proc.Create(False);
   {Здесь можно поэкспериментировать с приоритетами:}
   //T1.Priority := tpLowest;
   //DragAcceptFiles(Handle,True);
end;

procedure TForm3.FormDropFiles(Sender: TObject; const FileNames: array of String);
var i, j:integer;
  str_tmp, str_tmp_dll:string;
  vpt_file:boolean;
begin
     //kol:=Length(FileNames);
     vpt_file:=false;
     str_tmp:='';
     str_tmp_dll:='';
     j:=0;
     //soobchenie('vinPlayer +' + IntToStr(kol), 'Вы что-то уронили!', 500, false);
     for i:=0 to High(FileNames) do
     begin
          if otl then
          begin
               vplayer.memo1.lines.Add('сбросили: ' + FileNames[i]);
          end;
          if (pos('.mp3',utf8tosys(FileNames[i])) <> 0) or (pos('.ogg',utf8tosys(FileNames[i])) <> 0) or (pos('.wav',utf8tosys(FileNames[i])) <> 0)or (pos('.mp4',utf8tosys(FileNames[i])) <> 0) or (pos('.flac',utf8tosys(FileNames[i])) <> 0) or (pos('.MP4',utf8tosys(FileNames[i])) <> 0) or (pos('.MP3',utf8tosys(FileNames[i])) <> 0) or (pos('.OGG',utf8tosys(FileNames[i])) <> 0) or (pos('.WAV',utf8tosys(FileNames[i])) <> 0)  or (pos('.FLAC',utf8tosys(FileNames[i])) <> 0) then
          begin
               str_tmp:=utf8tosys(FileNames[i]);
               add_files_to_trasc_list(utf8tosys(FileNames[i]));
               vpt_file:=false;
          end;

          if pos('.vpt',utf8tosys(FileNames[i])) <> 0 then
          begin
               str_tmp:=utf8tosys(FileNames[i]);
               j:=length(str_tmp);
               delete(str_tmp, j-3, j);
               str_tmp+='.mp3';
               add_files_to_trasc_list(str_tmp);
               vpt_file:=true;
          end;

          if pos('.dll',utf8tosys(FileNames[i])) <> 0 then
          begin
               str_tmp_dll:=FileNames[i];
               load_dll(str_tmp_dll);
          end;

     end;
     if str_tmp <> '' then
     begin
          filewav := str_tmp;
          filewavPChar:=PChar(filewav);
          tek_source:=2;
          vospr;
          play;
          //kol_vo := DragQueryFile (Sender, )
          load_spisok(true);
     end
     else
     begin
          if str_tmp_dll = '' then
          begin
               soobchenie('vinPlayer', 'Вы что-то уронили!', 500, false);
          end;
     end;
     if vpt_file then load_vpt;
end;

procedure TForm3.FormShortCut(var Msg: TLMKey; var Handled: Boolean);
begin
     soobchenie('vinPlayer(3)', 'Вы что-то нажали:' + inttostr(Msg.CharCode), 500, false);
end;

procedure TForm3.Image2Click(Sender: TObject);
begin
   {
          1:m_vib_beg:=10;
          2:m_vib_beg:=56;
          3:m_vib_beg:=90;
          4:m_vib_beg:=128;
          5:m_vib_beg:=174;   }
  image3.Top:=8;
  m_vib_vert:=7.9;
  case m_vibor of
       1:begin
              vospr_neNext;
              image3.left:=10;
       end;
       2:begin
              pause;
              image3.left:=56;
       end;
       3:begin
              play;
              image3.left:=90;
       end;
       4:begin
              stop;
              soobchenie('','Воспроизведение остановлено', 150, false);
              image3.left:=128;
       end;
       5:begin
              vospr_next;
              image3.left:=174;
       end;
  end;
end;

procedure TForm3.Image4Click(Sender: TObject);
begin
     image3.Top:=8;
  m_vib_vert:=7.9;
  case m_vibor of
       1:begin
              vospr_neNext;
              image3.left:=10;
       end;
       2:begin
              pause;
              image3.left:=56;
       end;
       3:begin
              play;
              image3.left:=90;
       end;
       4:begin
              stop;
              soobchenie('','Воспроизведение остановлено', 150, false);
              image3.left:=128;
       end;
       5:begin
              vospr_next;
              image3.left:=174;
       end;
  end;
end;

procedure TForm3.BitBtn1ContextPopup(Sender: TObject{; MousePos: TPoint;
  var Handled: Boolean});
begin

end;

procedure TForm3.FormClose(Sender: TObject{; var CloseAction: TCloseAction});
begin
   //DragAcceptFiles(Handle,false);
end;

procedure TForm3.BitBtn1Click(Sender: TObject);
begin
    PopupMenu1.PopUp;
end;

{procedure TForm3.Image11Click(Sender: TObject);
begin

    form3.Image10.Visible:=true;
    form3.Image11.Visible:=false;
    stop;
    soobchenie('','Воспроизведение остановлено', 150, false);
end;

procedure TForm3.Image3Click(Sender: TObject);
begin
    form3.Image2.Visible:=true;
    form3.Image3.Visible:=false;
    vospr_next;
end;

procedure TForm3.Image5Click(Sender: TObject);
begin

    form3.Image4.Visible:=true;
    form3.Image5.Visible:=false;
    vospr_neNext;
end;

procedure TForm3.Image7Click(Sender: TObject);
begin

    form3.Image6.Visible:=true;
    form3.Image7.Visible:=false;
    pause;
end;

procedure TForm3.Image9Click(Sender: TObject);
begin

    form3.Image8.Visible:=true;
    form3.Image9.Visible:=false;
    play;
end;   }

procedure TForm3.internet_radioClick(Sender: TObject);
var url_odnaco:string;
begin
     url_odnaco := inputbox('Интернет радио','Введите URL потока','Сюда введите');
     if (url_odnaco <> 'Сюда введите') and (url_odnaco <> '') then
        internet_vospr(url_odnaco);

end;

procedure TForm3.internet_radio_recClick(Sender: TObject);
begin
  recording_odnaco;
  if rec_mode then
   form3.internet_radio_rec.caption:='Остановить запись'
  else
   form3.internet_radio_rec.caption:='Запись';

end;

procedure TForm3.Label1Click(Sender: TObject);
begin
    soobchenie('vinPlayer - время', label1.caption + ' - столько времени вы слушали музыку', 900, true);
end;

procedure TForm3.M_aClick(Sender: TObject);
begin
     soobchenie('vinPlayer - точка А', 'Установлена точка "А" ' + inttostr(round(BASS_ChannelBytes2Seconds(potok, BASS_ChannelGetPosition(potok,0)))) + 'c', 900, true);
     tA:= BASS_ChannelGetPosition(potok,0);
     AB:=false;
     form3.M_b.Enabled:=true;
end;

procedure TForm3.M_bClick(Sender: TObject);
var tmp:int64;
begin
     tmp:= BASS_ChannelGetPosition(potok,0);
     if tA > tmp then
     begin
          soobchenie('vinPlayer - ошибка', 'Точка "B" должна быть позже "A" ', 900, true);
          AB:=false;
     end
     else
     begin
     soobchenie('vinPlayer - точка B', 'Установлена точка "B" ' + inttostr(round(BASS_ChannelBytes2Seconds(potok, BASS_ChannelGetPosition(potok,0)))) + 'c', 900, true);
         tB:=tmp;
         AB:=true;
               BASS_ChannelSetPosition(potok,tA,0);
     end;
     form3.M_b.Enabled:=false;
end;

procedure TForm3.M_consoleClick(Sender: TObject);
begin
     vplayer.top:=30;
end;

procedure TForm3.M_disp_messClick(Sender: TObject);
begin
  vk_data(15);
  if not vk_load_run then
     soobchenie('vinPlayer', 'Щас загрузим...', 900, true)
  else
     soobchenie('vinPlayer', 'Щас что-то грузится', 900, true)
end;

procedure TForm3.M_dll_settingsClick(Sender: TObject);
begin
     Form14.visible:=true;
end;

procedure TForm3.M_exitClick(Sender: TObject);
begin
  //close;
    exit_odnaco;
    Application.Terminate;
end;

procedure TForm3.M_music_bazaClick(Sender: TObject);
begin

end;

procedure TForm3.M_open_fileClick(Sender: TObject);
//begin
  //TForm3.open_f;
//;

//procedure TForm3.open_f;
var j:word;
begin
  if OpenDialog1.Execute then
  begin
      for j:=0 to OpenDialog1.Files.Count-1 do
      begin
          add_files_to_trasc_list(utf8tosys((OpenDialog1.Files.Strings[j])));
      end;
      filewav := utf8tosys(OpenDialog1.Files.Strings[j]);
      filewavPChar:=PChar(filewav);
      tek_source:=2;
      vospr;
      play;


     load_spisok(true);
      //OpenDialog1.free;
  end;
end;


procedure TForm3.M_o_progeClick(Sender: TObject);
begin
     form9.Visible:=true;
end;

procedure TForm3.M_pokaz_listClick(Sender: TObject);
begin
     pok;
end;

procedure TForm3.M_putClick(Sender: TObject);
begin
     copy_put_and_file;
end;

procedure TForm3.m_red_bazaClick(Sender: TObject);
begin
     form11.visible:=true;
end;

procedure TForm3.M_red_vptClick(Sender: TObject);
begin
     form12.visible:=true;
end;

procedure TForm3.M_reload_bazaClick(Sender: TObject);
begin
     dispose_baza;
     load_baza;
end;

procedure TForm3.M_scan_folderClick(Sender: TObject);   //Сканирование каталога
var dir:string;
begin
  if not b_scan then
  begin
    if SelectDirectoryDialog1.Execute then
    begin
         //dir:= SelectDirectoryDialog1.Files.Text;
         dir := utf8tosys(selectdirectorydialog1.FileName);
         if dir <> '' then  scanirovanie(dir);
         //soobchenie('vinPlayer', dir, 370, false)
    end;
  end
  else soobchenie('vinPlayer', 'Дождитесь окончания сканирования', 900, true);

end;

procedure TForm3.M_settingsClick(Sender: TObject);
begin
    form6.visible:=true;
end;

procedure TForm3.M_sort_po_dateClick(Sender: TObject);
begin
  Menu_sort_po_date;
end;

procedure TForm3.M_sort_po_ispClick(Sender: TObject);//обратно
begin
  Menu_sort_po_isp(false);
end;

procedure TForm3.M_sort_po_isp_tudaClick(Sender: TObject);//туда
begin
    Menu_sort_po_isp(true);
end;

procedure TForm3.M_sozd_bazaClick(Sender: TObject);
begin
  //scanirovanie('e:');
  if not b_scan then
  begin
  scanirovanie('');
  end
  else soobchenie('vinPlayer', 'Дождитесь окончания сканирования', 900, true);
end;

procedure TForm3.M_version_osn_dllClick(Sender: TObject);
var tmp:string;
begin
      tmp:= pchar_to_str(vpee_get_version());
     soobchenie('Дополнения','Версия основной библиотеки: '+tmp+'.', 900, false);
end;

procedure TForm3.M_vkClick(Sender: TObject);
begin

end;

procedure TForm3.M_vk_inClick(Sender: TObject); //вход вк
var code:string;
begin
     if otl then  vplayer.memo1.lines.Add('VK - вход');
     soobchenie('vinPlayer', 'Разрешите доступ и скопируйте URL из адресной строки.', 900, true);
       ShellExecute(Handle, 'open', PChar('https://oauth.vk.com/authorize?client_id=3445588&redirect_uri=https://oauth.vk.com/blank.html&scope=friends,audio,groups,messages,offline&display=popup&response_type=token'), nil, nil, SW_SHOW );
       code := inputbox('Вход в ВК','Разрешите доступ и вставьте сюда URL из адресной строки браузера','Сюда вставьте');
     if (code <> 'Сюда вставьте') and (code <> '') then
     begin
          if pos('access_token', code) <> 0 then
          begin
               delete(code, 1, pos('access_token', code) + 12);
               delete(code, 86, length(code));
               vplayer.memo1.lines.Add('VK = ' + code);
               access_token:=code;
          end;
     end;
end;

procedure TForm3.M_vk_load_audioClick(Sender: TObject);
begin
     vk_loadAudio_potok:=T_vk_load_audio.Create(False);
end;

procedure TForm3.M_vk_load_list_paramClick(Sender: TObject);
var code:string;
begin
     //////////vk_soure_list, vk_soure_list_count:string;

     code := inputbox('Загрузить список воспроизведения.','Введите id группы или пользователя','Сюда введите');
     if (code <> 'Сюда введите') and (code <> '') then
     begin
          vk_soure_list:=code;
          code := inputbox('Загрузить список воспроизведения.','Введите количество аудиозаписей','25');
          if (code <> '25') and (code <> '') then
          begin
               vk_soure_list_count:=code;
               vk_loadAudio_potok:=T_vk_load_audio.Create(False);
          end;
     end;
end;

procedure TForm3.m_vk_mes_writeClick(Sender: TObject);
begin
     vk_create_mess();
end;

procedure TForm3.M_vptClick(Sender: TObject); //текст песни
begin
     load_vpt;
end;

procedure TForm3.M_zanClick(Sender: TObject);
begin
     if not rej_zan then
     begin
          Form3.Visible:=false;
          vplayer.Visible:=false;
          rej_zan:=true;
          Form3.M_zan.Caption:='Вылезти';
          case round(random()*2) of
               0: soobchenie('vinPlayer', 'Тсс... меня тут нет.', 800, false);
               1: soobchenie('vinPlayer', 'Я буду рядом..', 800, false);
               2: soobchenie('vinPlayer', 'Исчез', 800, false);



          end;
     end
     else
     begin
          Form3.Visible:=true;
          vplayer.Visible:=true;
          rej_zan:=false;
          Form3.M_zan.Caption:='Заныкаться';
     end;
end;


procedure TForm3.Timer1Timer(Sender: TObject);
var j, vpt_i{,vpt_i0}:word;
    vpt_temp:real;
begin
  //form3.timer1.interval := zn_timer3;

  getcursorpos(mouse);
  otrisovka;//информационное окно
  //Proc;//основной модуль
  //////////////////////////////////////////
  //вызов визуализации
     if b_scan then form2.label2.caption := 'Обновление базы.';
     tp:= BASS_ChannelBytes2Seconds(potok, BASS_ChannelGetPosition(potok,0));
     if tl=0 then tl:=1;
     play_progress:=tp/tl;
     if panell_on and not bool_internet then   ///
     begin
          BASS_ChannelGetData(potok, @FFTFata, BASS_DATA_FFT256);
          vizual;
          form2.label1.caption := poloj_vospr(true,BASS_ChannelBytes2Seconds( potok, BASS_ChannelGetPosition(potok,0)),BASS_ChannelBytes2Seconds(potok, BASS_ChannelGetLength(potok,0)));
     end;
     //if (tl > 3) and (tl <= tp + 0.4) and not bool_internet then conf_vospr;
     //if b_play_stop then
     //begin
          //if (ttp4 = tp) and (not bool_internet) and (tl > 3) then conf_vospr;
          //ttp4:=ttp3;
          //ttp3:=ttp2;
          //ttp2:=ttp1;
          //ttp1:=ttp0;
          //ttp0:=tp;
     //end;
     /////////////////////////////////////
     if AB then
     begin
          if tp>BASS_ChannelBytes2Seconds(potok,tB) then
          begin
               BASS_ChannelSetPosition(potok,tA,0);
          end;
     end;

     if vpt_open2 and (count_vpt_strings <> 0) then
     begin
         vpt_temp:=BASS_ChannelBytes2Seconds(potok, BASS_ChannelGetPosition(potok,0))/BASS_ChannelBytes2Seconds(potok, BASS_ChannelGetLength(potok,0))*1000;
         for vpt_i:=0 to count_vpt_strings - 1 do
         begin
             //if (vpt_time[vpt_i] < vpt_temp) and (vpt_temp < vpt_time[vpt_i+1]) then vpt_i0:=vpt_i;
             if (vpt_time[vpt_i] - 1 = round(vpt_temp)) and (vpt_time[vpt_i] <> 0)  then
             begin
                  if vpt_temp_i <> vpt_i then
                  begin
                       vpt_temp_i := vpt_i;
                       vpt_bool:=true;
                  end;
                  if vpt_bool then
                  begin
                       if otl then vplayer.memo1.lines.Add('vpt: ' + inttostr(vpt_i) + ' | ' + vpt_strings[vpt_i] + ' || ' + inttostr(round(vpt_temp)));
                       //soobchenie('vinPlayer', vpt_strings[vpt_i], 800, false);
                       vpt_bool:=false;
                  end;
                  soobchenie('vinPlayer', vpt_strings[vpt_temp_i], 800, false);
             end;
         end;
         {if (vpt_i1<vpt_i0) then vpt_bool:=true;
         if (vpt_time[0] < vpt_temp) then
         begin
              vpt_bool:=false;
              vpt_i0:=0;
         end;
         if  vpt_bool then
         begin
              if otl then vplayer.memo1.lines.Add('vpt: ' + inttostr(vpt_i0) + ' | ' + vpt_strings[vpt_i0] + ' || ' + inttostr(round(vpt_temp)));
              soobchenie('vinPlayer', vpt_strings[vpt_i0], 800, false);
              vpt_i1:=vpt_i0;
              vpt_bool:=false;
         end; }
     end;


  obnForm7;//список
  ///управление жестами---------------------------------------------------------
  if (mouse.x = screen.Width-1) and (mouse.y = 0) then
  begin
     ttt:=-15;
     soobchenie('vinPlayer', 'Жесты активированы', 500, false);
     jest:=true;
     if otl then vplayer.memo1.lines.Add('mouse control activated');
  end;
  if (ttt< 440) then
  begin
      if ttt = 400 then
      begin
         if otl then vplayer.memo1.lines.Add('mouse control off');
         jest:=false;
         if bool_internet then
         begin
              DoMeta;
         end
         else
         begin
              if (id3tag.Artist = '' )and (id3tag.title = '') then
                 soobchenie('Нет ID3', filewav, 200, true)
              else
                  soobchenie(id3tag.Artist,id3tag.title, 200, true);
      end;
      end;
      ttt+=1;
      //if otl then vplayer.memo1.lines.Add('time mouse control:'+inttostr(ttt));
      if (mouse.y <= razm_jest) {and (mouse.x > 2) and (mouse.x < screen.Width - 4)} then
      begin
          perexod[5] := perexod[4];
          perexod[4] := perexod[3];
          perexod[3] := perexod[2];
          perexod[2] := perexod[1];
          perexod[1] := perexod[0];
          perexod[0] := round((mouse.x / (screen.Width)) * 1000);
          if otl then vplayer.memo1.lines.Add('perexod'+intToStr(perexod[0])+','+intToStr(perexod[1])+','+intToStr(perexod[2])+','+intToStr(perexod[3])+','+intToStr(perexod[4])+','+intToStr(perexod[5]));
          if not bm20 and not bool_internet and not b2 and ((perexod[0] + chuvst) < perexod[1]) and ((perexod[1] + chuvst)< perexod[2]) and ((perexod[2] + chuvst) < perexod[3]) and ((perexod[3] + chuvst)< perexod[4]) and ((perexod[4] + chuvst) < perexod[5]) then
          begin
              b0:=true;
              ttt:=0;
              b3 := true;
              if otl then vplayer.memo1.lines.Add('b0:=true; b3 := true;');
          end;
          if not bm20 and not bool_internet and not b2 and (perexod[0] > (perexod[1] + chuvst)) and (perexod[1] > (perexod[2] + chuvst)) and (perexod[2] > (perexod[3] + chuvst)) and (perexod[3] > (perexod[4] + chuvst)) and (perexod[4] > (perexod[5] + chuvst)) then
          begin
               b1:=true;
               ttt:=0;
               b3 := false;
               if otl then vplayer.memo1.lines.Add('b0:=true; b3 := false;');
          end;
          if not bm20 and not bool_internet and (ttt > 0) and (not b0) and (not b1) and (perexod[1] = perexod[0]) and (perexod[0] <> perexod[5]) then
          begin
               per(perexod[0]);
               ttt:=-7;
               //vpt_bool:=true;
               if otl then vplayer.memo1.lines.Add('per(perexod[0]) = ' + inttoStr(perexod[0]));
          end;
          if not bm20 and (b0 and b1 and b3 and (perexod[3] <> perexod[0])) or (bool_internet and (perexod[3] <> perexod[0]) and (perexod[1] <> 0) and (perexod[0] <> 0)) then
          begin
              tvol:=vol;
              vol := vol - (perexod[1] - perexod[0])/140;
              if (vol < 0) then vol := 0.0;
              if (vol > 1) then vol := 1.0;
              if tvol > vol then soobchenie('vinPlayer','Громкость: ' + inttostr(round(set_vol(vol))), 400, false);
              if tvol < vol then soobchenie('vinPlayer','Громкость: ' + inttostr(round(set_vol(vol))), 400, true);
              if otl then vplayer.memo1.lines.Add('set_vol '+ inttostr(round(vol*100)));
              ttt:=0;
              b2 := true;
          end;
          //////////////
          if not bm20 and b0 and b1 and not b2 then
          begin
               if (ttt>60) then
               begin
                    soobchenie('vinPlayer', 'Жесты 2.0 активированы!', 900, true);
                    bm20:=true;
                    razm_jest:=20;
                    ttt:=61;
                    if otl then vplayer.memo1.lines.Add('bm20:=true;');
               end;
          end;

          if bm20 then
          begin
                 ttt:=61;
                 //soobchenie('vinPlayer', 'вход в меню', 900, true);
                 //screen.Width    mouse.x
                 ///////////////////////////////////////////--------------
                 if ((screen.Width/coun_menu_item) > mouse.x) then
                 begin
                    soobchenie('vinPlayer', 'Открыть файл', 900, true);
                    menu_vibor:=1;
                 end
                 else
                 begin
                 ///////////////////////////////////////////--------------
                 if ((screen.Width/coun_menu_item*2) > mouse.x) then
                 begin
                    soobchenie('vinPlayer', 'Обновить базу', 900, true);
                    menu_vibor:=2;
                 end
                 else
                 begin
                 ///////////////////////////////////////////--------------
                 if ((screen.Width/coun_menu_item*3) > mouse.x) then
                 begin
                    soobchenie('vinPlayer', 'Перезагрузить базу', 900, true);
                    menu_vibor:=3;
                 end
                 else
                 begin
                 ///////////////////////////////////////////--------------
                 if ((screen.Width/coun_menu_item*4) > mouse.x) then
                 begin
                    soobchenie('vinPlayer', 'отключить жесты', 900, true);
                    menu_vibor:=4;
                 end
                 else
                 begin

                 ///////////////////////////////////////////--------------
                 if ((screen.Width/coun_menu_item*5) > mouse.x) then
                 begin
                    soobchenie('vinPlayer', 'Список воспроизведения', 900, true);
                    menu_vibor:=5;
                 end
                 else
                 begin

                 ///////////////////////////////////////////--------------
                 if ((screen.Width/coun_menu_item*6) > mouse.x) then
                 begin
                    soobchenie('vinPlayer', 'Настройки', 900, true);
                    menu_vibor:=6;
                 end
                 else
                 begin

                 if ((screen.Width/coun_menu_item*7) > mouse.x) then
                 begin
                    soobchenie('vinPlayer', 'Редактор текста песни', 900, true);
                    menu_vibor:=7;
                 end
                 else
                 begin
                     soobchenie('vinPlayer', 'Выход', 900, true);
                     menu_vibor:=8;
                 end;
                 ///////////////////////////////////////////--------------
                 end;
                 ///////////////////////////////////////////----------------
                 end;
                 ///////////////////////////////////////////----------------
                 end;
                 ///////////////////////////////////////////----------------
                 end;
                 ///////////////////////////////////////////----------------
                 end;
                 ///////////////////////////////////////////----------------
                 end;
                 ///////////////////////////////////////////----------------
          end;

          /////////////////

      end
      else
      begin
          if not bm20 and b0 and b1 and not b2 then
          begin
               play_stop;
               b0:=false;
               b1:=false;
          end;
          if not bm20 and b0 and not b2 then vospr_next;
          if not bm20 and b1 and not b2 then vospr_nenext;
          b0:=false;
          b1:=false;
          b2:=false;
          b3:=false;

          if bm20 then
          begin
               soobchenie('vinPlayer', 'exit меню 2.0', 900, true);
               bm20:=false;
               case menu_vibor of
               1:begin
                      /////////////
                      if OpenDialog1.Execute then
                      begin
                           for j:=0 to OpenDialog1.Files.Count-1 do
                           begin
                                add_files_to_trasc_list(utf8tosys((OpenDialog1.Files.Strings[j])));
                           end;
                           filewav := utf8tosys(OpenDialog1.Files.Strings[j]);
                           filewavPChar:=PChar(filewav);
                           vospr;
                           play;
                           //OpenDialog1.free;
                      end;
               //////////////////
               end;
               2:scanirovanie('');
               3:begin
                      dispose_baza;
                      load_baza;
                 end;
               5:begin
                      pok;
                      //form7.FocusControl(Handle);
                 end;
               6:begin
                      form6.visible:=true;
                      //SetForegroundWindow(form6);
                 end;
               7:begin
                      form12.visible:=true;
                      //SetForegroundWindow(form6);
                 end;
               8:begin
                      exit_odnaco;
                      Application.Terminate;
                 end;
               end;
               menu_vibor:=0;
          end;
          razm_jest:=1;
          Form6.TrackBar11.position := round(vol * 100);
          form6.label12.Caption := 'Громкость: ' + inttostr(round(vol * 100));
          perexod[5] := 0;
          perexod[4] := 0;
          perexod[3] := 0;
          perexod[2] := 0;
          perexod[1] := 0;
          perexod[0] := 0;
      end;
  end;
  //----------------------------------------------------------------------------

  if (mouse.y = 0) and (mouse.x = 0) then
  begin
      if bool_internet then
      begin
           DoMeta;
      end
      else
      begin
           if (id3tag.Artist = '' )and (id3tag.title = '') then
              soobchenie('Нет ID3', filewav, 900, true)
           else
               soobchenie(id3tag.Artist,id3tag.title, 900, true);
      end;
  end;


  if mouse.y < 33 then
  begin
    if (mouse.x > 190 - 21)  and (mouse.x < 234  - 21) then///next
    begin
         m_vibor := 5;
    end;
    if (mouse.x > 150 - 21)  and (mouse.x < 190  - 21) then///stop;
    begin
         m_vibor := 4;

    end;
    if (mouse.x > 111 - 21)  and (mouse.x < 150  - 21) then///play
    begin
         m_vibor := 3;

    end;
    if (mouse.x > 74 - 21)  and (mouse.x < 111  - 21) then///pause
    begin
         m_vibor := 2;
    end;
    if (mouse.x > 30 - 21)  and (mouse.x < 74  - 21) then///neNext
    begin
         m_vibor := 1;
    end;
    if (mouse.x > 423)  and (mouse.x < 1067 ) and (form4.top < 0) and (mouse.y < (52 + form4.top))then
    begin
        topF4+=1;
        form4.top:=topF4;
    end;

  end
  else
  begin
        if form4.top > -28 then
         begin
            topF4-=1;
            form4.top:=topF4;
        end;
        m_vibor := 0;
  end;
  ////////перемещение выбора

  //m_vib_beg, m_vib_beg_t
     case m_vibor of
          0:m_vib_beg:=-100;
          1:m_vib_beg:=10;
          2:m_vib_beg:=56;
          3:m_vib_beg:=90;
          4:m_vib_beg:=128;
          5:m_vib_beg:=174;
     end;
     if m_vib_beg_t <> m_vib_beg then
     begin
          m_vib_beg_t+=(m_vib_beg-m_vib_beg_t)/5;
          image2.left:=round(m_vib_beg_t);
     end;
     if m_vib_vert < 30.0 then
     begin
         m_vib_vert += 0.3;
         image3.top:=round(m_vib_vert);
     end;
     if jest then
     begin
         if m_light_vert <-3.3 then
         begin
              m_light_vert += 0.3;
              image4.top:=round(m_light_vert);
         end;
     end
     else
     begin

         if m_light_vert > -10 then
         begin
              m_light_vert -= 0.3;
              image4.top:=round(m_light_vert);
         end;
     end;
end;

procedure TForm3.Timer2Timer(Sender: TObject);
var sec, min:int64;
    hour, day:word;
begin

     if b_play_stop then
     begin
          if (ttp0 = tp) and (not bool_internet) and (tl > 3) then conf_vospr;
          ttp4:=ttp3;
          ttp3:=ttp2;
          ttp2:=ttp1;
          ttp1:=ttp0;
          ttp0:=tp;
     end;



     global_time_sec+=1;
     if 'null' <> access_token then
     begin
          case global_time_sec of
               30:vk_data(1);
               60:vk_data(1);
               90:vk_data(1);
               120:vk_data(1);
               150:vk_data(1);
               180:vk_data(1);
               210:vk_data(1);
               240:vk_data(1);
               270:vk_data(1);
               300:vk_data(1);
               330:vk_data(1);
               360:vk_data(1);
               390:vk_data(1);
               420:vk_data(1);
               450:vk_data(1);
               480:vk_data(1);
               510:vk_data(1);
               540:vk_data(1);
               570:vk_data(1);
               599:vk_data(1);
               80:vk_data(2);
               310:vk_data(2);
               95:vk_data(3);
          end;
     end;
     if global_time_sec= 600 then
     begin
          global_time_sec:=0;
          iniFile.writeInteger('vPlayer','time',global_time_vospr);
     end;

  if b_play_stop then
  begin

       Form3.top := -4;
       form3.left := -21;

     if (global_time_vospr = 10) and start_vpt then
     begin
         start_vpt:=false;
         load_vpt;
     end;

     global_time_vospr+=1;
     min:=global_time_vospr div 60;
     sec:=global_time_vospr - min*60;

     hour:=min div 60;
     min:=min - hour*60;

     day:=hour div 24;
     hour := hour - day*24;
     label1.caption:=inttostr(day) + ':' + inttostr(hour) + ':' + inttostr(min) + ':' + inttostr(sec);
  end;
end;

end.

