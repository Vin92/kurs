unit scaner_vPlayer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, interf, interf2, {tags,} search_drive, mmsystem, B_ID3V1, bass;

type
   //Event = procedure(St1: String) of Object;
   search_uk = ^search_el;
   search_el = record
                     d:string[100];
                     adress:search_uk
               end;
   uk = ^el_sokr;
   el_sokr=record
               put:string[255];
               name_file:string[100];
               //name_id3:string[150];
               //artist_id3:string[50];
               kopija, muzika:boolean;
               razmerfile:int64;
               timeizm:int64;
               adress:uk
          end;
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
  sTID3Rec = record
               Title,Artist,Comment,Album,Genre,Year:string
              end;
  potok_proc = class(TThread)
   private
     sttext:string;
     //FOnShowStatus: Event;
     procedure ShowStatus;
     procedure ShowStatus2;
     { Private declarations }
   protected
     procedure poiscfajlov(put, fajl:string);
     procedure searchList(put:string);
     procedure scan_tag(f:string);
     procedure poiscpapok(put, fajl:string);
     procedure openfile;
     procedure closefile;
     procedure obrab_baza;
     procedure obrab_baza_2;
     procedure load_baza;
     function search_mask(s:string;p:boolean):boolean;
     procedure load_search_list;
     procedure dispose_search_list;
     //procedure start_scan0;
     procedure start_scan{(put:string)};
     procedure Execute; override;
   public
     //property OnShowStatus: Event read FOnShowStatus write FOnShowStatus;
   end;

var
  fff:file of el;
  element:el;
  //els:el_sokr;
  tex, fs:text;
  yc, maska:boolean;
  s,p, m, s1, p1, m1:uk;
  search_s1, search_p1, search_m1:search_uk;
  sh, shp:word;
  thread1:integer;
  id1:longword;
  put0, put_g:string;
  T1 :potok_proc;
  kol, kol0:longInt;
  b_scan:boolean;
  mediafile:HSTREAM;
  sid3tag:sTID3Rec;

{procedure poiscfajlov(put, fajl:string);
procedure searchList(put:string);
procedure poiscpapok(put, fajl:string);
procedure openfile;
procedure closefile;
procedure obrab_baza;
procedure load_baza;
procedure start_scan0;
procedure start_scan(put1:string); }
//procedure start_scan(put:string);

procedure scanirovanie(p: string);

implementation

procedure potok_proc.scan_tag(f:string);
var
ID3: TID3V1Rec;
t0,t1,t2, t3, t4, t5, t6:string;
i,l:byte;
begin
     ID3:= BASSID3ToID3V1Rec( BASS_channelGetTags(mediafile, BASS_TAG_ID3) );
//Showmessage(
//'Title : ' +
//'Artist : ' +
//'Year : ' +
//'Comment : ' +
//'Genre : ' +
//);
   //bid3:=BASS_ChannelGetTags(potok, BASS_TAG_ID3);
   t0:=ID3.Artist;
   t1:=ID3.Title;
   t2:=f;
   if (t1 = '') or (t0 ='') then
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
   sid3tag.Artist := t0;//ZuBy_GetTags(filewav, gtArtist));
   sid3tag.title := t1;//string(bid3));// SysToUTF8(ZuBy_GetTags(filewav, gtTitle));
   t3 := SysToUTF8(ID3.Album);
   if t3='' then
   begin
        sid3tag.Album := '--No info--';
   end
   else
   begin
        if t3[1]='?' then
        begin
             sid3tag.Album := '--No info--';
        end
        else
        begin
             sid3tag.Album := t3;
        end;
   end;
   //
   if (ID3.Genre > 160) or (ID3.Genre < 0) then
   begin
        ID3.Genre := 160;
   end;
   t4 := cID3V1FGenre[ID3.Genre];
   if t4='' then
   begin
        sid3tag.Genre := '--No info--';
   end
   else
   begin
        if t4[1]='?' then
        begin
             sid3tag.Genre := '--No info--';
        end
        else
        begin
             sid3tag.Genre := t4;
        end;
   end;
   //

   t5 := ID3.Year;
   if t5='' then
   begin
        sid3tag.Year := '--No info--';
   end
   else
   begin
        if t5[1]='?' then
        begin
             sid3tag.Year := '--No info--';
        end
        else
        begin
             sid3tag.Year := t5;
        end;
   end;
   //
   t6 := SysToUTF8(ID3.Comment);
   if t6='' then
   begin
        sid3tag.Comment := '--No info--';
   end
   else
   begin
        if t6[1]='?' then
        begin
             sid3tag.Comment := '--No info--';
        end
        else
        begin
             sid3tag.Comment := t6;
        end;
   end;
   //
end;

procedure potok_proc.ShowStatus;
  // этот метод запущен главным потоком и поэтому может получить доступ ко всем элементам графического интерфейса.
  begin
    {if Assigned(FOnShowStatus) then
    begin}
      //FOnShowStatus(sttext);
      b_scan:=true;
      soobchenie('vinPlayer - обработка базы',sttext, 400, true);
    //end;
end;

procedure potok_proc.ShowStatus2;
  // этот метод запущен главным потоком и поэтому может получить доступ ко всем элементам графического интерфейса.
  begin
    {if Assigned(FOnShowStatus) then
    begin}
      //FOnShowStatus(sttext);
      //soobchenie('vPlayer - обработка базы',sttext, 400, true);
      //form2.label2.caption := 'Обновление базы!!!';
      b_scan:=false;
      form2.label2.caption := ' ';
    //end;
end;

procedure potok_proc.poiscfajlov(put, fajl:string);
var
    searchResult : TSearchRec;
begin
     if FindFirst(put + fajl, faAnyFile, searchResult) = 0 then
     begin
          repeat
                if ((searchResult.attr and faDirectory)  <> faDirectory) and (searchResult.Name <> '.') and (searchResult.Name <> '..')  then
                begin

                     new(p);
                     p^.put:= put;
                     p^.name_file := searchResult.Name;
                     p^.razmerfile := searchResult.size;
                     p^.timeizm := searchResult.time;
                     //form1.memo1.lines.Add('файл ' + sysToUtf8(searchResult.Name));
                     //writeln(tex, put + searchResult.Name);
                     p^.adress := s;
                     s:=p;
                     sh+=1;
                     //form1.memo2.lines[0] := ();
                     ///---form2.label1.caption :='сканирование. ' + inttostr(sh) + ' найдено.'
                     //form1.memo1.lines.Add('файл ' + p^.name_file);

                end;
          until FindNext(searchResult) <> 0;
          FindClose(searchResult);
     end;
end;

procedure potok_proc.poiscpapok(put, fajl:string);
var
  searchResult : TSearchRec;
begin
     if FindFirst(put + fajl, faDirectory, searchResult) = 0 then
     begin
          repeat
                if ((searchResult.attr and faDirectory)  = faDirectory) and (searchResult.Name <> '.') and (searchResult.Name <> '..') and search_mask(searchResult.Name, false) then
                begin

                     //sttext := 'Сканирование: ' + put + searchResult.Name + '/' ;
                     //Synchronize(@Showstatus);
                     searchList(put + searchResult.Name + '\');
                     poiscpapok(put + searchResult.Name + '\', fajl);
                end;
          until FindNext(searchResult) <> 0;
          FindClose(searchResult);
     end;
end;

function potok_proc.search_mask(s:string;p:boolean):boolean;
begin
    if p then
    begin
         search_p1 := search_m1;
         search_mask := true;
         while (search_p1<>nil) and search_mask and maska do
         begin
              //search_mask := search_mask and (s <> search_p1^.d);
              search_mask := search_mask and (pos('\' + search_p1^.d + '\', s) = 0);
              search_p1:=search_p1^.adress;
         end;
    end
    else
    begin
         search_mask := true;
         search_mask := search_mask and (s <> 'Windows');
         search_mask := search_mask and (s <> 'Program Files');
         search_mask := search_mask and (s <> 'Program Files (x86)');
         search_mask := search_mask and (s <> 'ProgramData');
         search_mask := search_mask and (s <> 'Games');
         search_mask := search_mask and (s <> 'files_recovery_dick');
         search_mask := search_mask and (s <> 'bin');
         search_mask := search_mask and (s <> 'data');
         search_mask := search_mask and (s <> 'res');
         search_p1 := search_m1;
         while (search_p1<>nil) and search_mask and maska do
         begin
              search_mask := search_mask and (s <> search_p1^.d);
              search_p1:=search_p1^.adress;
         end;
    end;
end;

procedure potok_proc.searchList(put:string);
begin
    poiscfajlov(put, '*.mp3');
    //poiscfajlov(put, '*.wav');
    //poiscfajlov(put, '*.mp4');
    poiscfajlov(put, '*.ogg');
    poiscfajlov(put, '*.flac');
end;

procedure potok_proc.load_baza;
begin
    s1:=nil;
    sh:=0;
    kol0:=0;
   while not eof(fff) do
   begin
        new(p1);
        read(fff, element);
        p1^.name_file := element.name_file;
        p1^.razmerfile := element.razmer;
        p1^.adress := s1;
        s1:=p1;
        sh+=1;
        if not element.kopija then kol0+=1;
   end;
   m1:=p1;
end;

procedure potok_proc.load_search_list;
begin
    search_s1:=nil;
    search_p1:=nil;
    //sh:=0;
    while not eof(fs) do
    begin
        new(search_p1);
        readln(fs, search_p1^.d);
        search_p1^.adress := search_s1;
        search_s1 := search_p1;
   end;
   search_m1 := search_p1;
end;

procedure potok_proc.dispose_search_list;
begin
     search_p1 := search_m1;
     while search_p1<>nil do
     begin
          search_s1:=search_p1^.adress;
          dispose(search_p1);
          search_p1:=search_s1;
     end;
end;

procedure potok_proc.Execute;
 begin

     {Synchronize(@}start_scan{('e:')};
     Synchronize(@ShowStatus2);
 end;

procedure potok_proc.obrab_baza_2;
var
    //element2:el;
    p0,p10, t:longint;
begin     //FileExists(путь) булево значение
        p0:=0;
        p10:=0;
        seek(fff, 0);
        while not eof(fff) do
        begin
            read(fff, element);
            if FileExists(element.put + element.name_file) and search_mask(element.put,true) then ///////////////
            begin
		seek(fff,p10);
                element.kopija:=false;
		write(fff, element);
                p10+=1;
            end;
            p0+=1;
            seek(fff,p0);
        end;
        seek(fff,p10);
        truncate(fff);
        //// ///////////
        seek(fff,0);
        s1:=nil;
        sh:=0;
        while not eof(fff) do
        begin
             read(fff, element);
             new(p1);
             p1^.name_file := element.name_file;
             //p1^.razmerfile := element.razmer;
             //p1^.artist_id3:= element.id3_inf.artist_id3;
             //p1^.name_id3:=element.id3_inf.name_id3;
             p1^.kopija:=element.kopija;
             p1^.adress := s1;
             s1:=p1;
             sh+=1;
        end;
        m1:=p1;
        //--------------поиск копий---------------------------------------------
        p0:=0;
        kol:=0;
        p10:=0;
        while p1 <> nil do
        begin
            s1 := p1^.adress;
            p10:=p0 + 1;
            while s1<>nil do
            begin
                 if (s1^.name_file = p1^.name_file) {or ((s1^.artist_id3 = p1^.artist_id3) and (s1^.name_id3 = p1^.name_id3))} then
                 begin
                     t:= sh - p10 - 1;
                     seek(fff, t);
                     read(fff, element);
                     seek(fff, t);
                     element.kopija:=true;
                     write(fff, element);
                 end;
                 s1:=s1^.adress;
                 p10+=1;
            end;
            p1:=p1^.adress;
            p0+=1;
        end;
        //---------------------------------------------------------------------
        //----------отчистка ресурсов------------------------------------------
        p1:=m1;
        while p1<>nil do
        begin
            s1:=p1^.adress;
            dispose(p1);
            p1:=s1;
        end;
        //---------------------------------------------------------------------
        seek(fff,0);
        kol:=0;
        while not eof(fff) do
        begin
            read(fff,element);
            if not element.kopija then kol+=1;
        end;
        ///////////////
        {
        p0:=0;
        p1:=0;
        kol:=0;
        while not eof(fff) do
        begin
             //p4:=FileSize(fff);
             read(fff, element2);
             p0+=1;
             p1 := p0;
             p3 := p0;
             if not element2.kopija then
             begin
                  kol+=1;
                  while not eof(fff) do
                  begin
                       read(fff, element);
                       p3 += 1;
                  //if p = p2 then p4-=1;
                       if (element.name_file = element2.name_file)  then //writeln('совпадение ', p);
                       begin
                            p3 -= 1;
                            seek(fff, p3);
                            element.kopija:=true;
                            p3 += 1;
                            write(fff, element);
                            //if (p3 <> p1) then
                            //begin
                                 //seek(fff,p1);
			         //write(fff, element);
                            //end;
                            //p1+=1;
                       end;
                       //seek(fff,p3);
                  end;
                  //t:= p4 - (p3 - p1);
                  //seek(fff,p1);
                  //truncate(fff);
                  seek(fff,p0);
             end;
        end;}

end;

procedure potok_proc.start_scan{(put:string)}; ////////////////////////
var
    C: string;
    i:integer;
begin
    //put:=put_g;
    PlaySound('res\sig5.wav',0,SND_ASYNC);
    openfile;
    s:=nil;
    sh:=0;
    shp:=0;
    load_search_list;//загруска списка НЕ поиска
    sttext := 'Поиск медиа файлов...';
    Synchronize(@Showstatus);
    if put_g = '' then
    ////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////
    begin
          maska:=true;
          for i := 65 to 90 do
          begin
               c:=ssss(i);
               if c <> 'err' then
               begin
                    sttext := 'Сканирование диска: ' + c ;
                    Synchronize(@Showstatus);
                    searchList(C);
                    poiscpapok(C, '*');
               end;
          end;
    ////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////
    //soobchenie('Сканирование','Поиск медиа файлов', 200);
    end
    else
    begin
         maska:=false;
         //if (pos('\',put_g)=0)then
         put_g+='\';
         sttext := 'Поиск в: ' + put_g ;
         Synchronize(@Showstatus);
         searchList(put_g);
         poiscpapok(put_g, '*');
    end;
    sttext := 'Найдено ' + inttostr(sh) + '.';
    Synchronize(@Showstatus);
    //soobchenie('Сканирование','Найдено ' + inttostr(sh) + '.', 500);
    //form1.memo1.lines.Add('Поиск завершён');
    //form1.memo1.lines.Add('Загрузка базы');
    load_baza;
    sttext := 'База загружена. Найдено ' + inttostr(sh) + '.';
    Synchronize(@Showstatus);
    //soobchenie('','База загружена. Найдено ' + inttostr(sh) + '.', 500);
    m:=p;
    obrab_baza;
    obrab_baza_2;
    closefile;
    sttext := 'База обновлена(+'+ intToStr(kol-kol0) +'). Всего: ' + intToStr(kol) + '.';
    Synchronize(@Showstatus);
    dispose_search_list;
    PlaySound('res\sig6.wav',0,SND_ASYNC);
    //CloseHandle(tr);
    //CloseHandle(id1);
         //sttext := 'Поиск в: ' + put_g ;
         //Synchronize(@Showstatus);
end;

procedure scanirovanie(p: string);
begin
   put_g:=p;
   T1 := potok_proc.Create(False);
   T1.Priority := tpLower;
end;


{procedure start_scan(put1:string);
begin
   put0:=put1;
    //tr:=beginthread(nil,0,addr(start_scan0),nil,0,id);
    CreateThread(nil, 0, @start_scan0, nil, 0, id1);
    //thread1 := BeginThread(nil, 0,addr(start_scan0), nil, 0, id1);
end;}

procedure potok_proc.obrab_baza;
var
  b:boolean;
  nnn:string;
begin
    p:=m;
    while p <> nil do
    begin
      ///////writeln(p^.cod:5);
      //seek(fff, 0);
      b:=true;
      //seek(fff, 0);
      p1:=m1;
      while (p1 <> nil) and b do
      begin
          //read(fff, element);
          //form1.memo1.lines.Add('файл ' + p^.name_file);

          if (p1^.name_file = p^.name_file) and (p^.razmerfile = p1^.razmerfile) then
             b := false;
          p1:=p1^.adress;
      end;
      if b then
      begin
           nnn:=p^.put + p^.name_file;
           mediafile := Bass_streamCreateFile(false,PChar(nnn),0,0,0);
           scan_tag(nnn);
           element.put := p^.put;
           element.name_file := p^.name_file;
           element.col_powt := 0;
           element.id3_inf.name_id3 := sid3tag.title; //SysToUTF8(ZuBy_GetTags(element.put + element.name_file, gtTitle));
           element.id3_inf.artist_id3 := sid3tag.Artist;//SysToUTF8(ZuBy_GetTags(element.put + element.name_file, gtArtist));
           element.id3_inf.album_id3  := sid3tag.Album;//SysToUTF8(ZuBy_GetTags(element.put + element.name_file, gtAlbum));
           element.id3_inf.god_id3 := sid3tag.Year;//SysToUTF8(ZuBy_GetTags(element.put + element.name_file, gtYear));
           element.id3_inf.genre_id3 :=sid3tag.Genre;//SysToUTF8(ZuBy_GetTags(element.put + element.name_file, gtGenre));
           element.razmer := p^.razmerfile;
           element.time_izm := p^.timeizm;
           element.kopija:=false;
           element.muzika:=true;
           //pf:= filesize(fff) - 1;
           //seek(fff, pf);
           write(fff, element);
           //writeln(tex, 'добавлен трек ' + element.id3_inf.artist_id3 + ' - ' + element.id3_inf.name_id3);
           writeln(tex, systoutf8(p^.put + p^.name_file));
           BASS_StreamFree(mediafile);
           //form1.memo1.lines.Add('добавлен трек ' + element.id3_inf.artist_id3 + ' - ' + element.id3_inf.name_id3);
      end;
      //else
      //begin
         //if p1^.put <> p^.put then p1^.put := p^.put;
      //end;
      s:=p;
      p:=p^.adress;
      dispose(s);
      shp+=1;
      /////-----form2.label1.caption := poloj_vospr(false, real(shp), real(sh));
      //str((shp / sh * 100):5:2, nnn);
      //form1.memo2.lines[2] := ('------------' + nnn + '%---------------');
    end;
end;

procedure potok_proc.openfile;
begin
    assign(fff,ExtractFilePath(paramstr(0)) + 'media_baza.vin92');
    {$I-}
    reset(fff);
    {$I+}
    if ioresult<>0 then
    begin
      rewrite(fff);
    end;
    assign(tex, ExtractFilePath(paramstr(0)) + 'scan_media_file.txt');
    rewrite(tex);
    //////
    assign(fs, ExtractFilePath(paramstr(0)) + 'not_search_list.txt');
    {$I-}
    reset(fs);
    {$I+}
    if ioresult<>0 then
    begin
      rewrite(fs);
      close(fs);
      {$I-}
      reset(fs);
      {$I+}
      if ioresult<>0 then
      begin
           rewrite(fs);
      //messagebox(0,'vPlayer','Файл ''not_search_list.txt'' был повреждён!',0);
      end;
      //messagebox(0,'vPlayer','Файл ''not_search_list.txt'' был повреждён!',0);
    end;
    //////
end;



procedure potok_proc.closefile;
begin

    close(fff);
    close(tex);
    close(fs);
end;

end.

