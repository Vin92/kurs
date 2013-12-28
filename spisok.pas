unit spisok;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
    TData_dS = record
               name_file:string[150];
               put:string[200];
               source:byte;
               url:string[200];
               audio_id:string[30];
               id_track:int64;
               artist_id3:string[50];
               name_id3:string[150];
               razmerfile:int64;
               timeizm:int64;
    end;

    uk = ^el_dSpisok;
    el_dSpisok = record
            _sled, _pred:uk;
            data:TData_dS;
    end;

    dSpisok = class (TPersistent)
            private
            _begin, _end, tek:uk;
            index:word;
            _count:integer;
            //el:el_dSpisok;
            protected

            function Get(_Index: word): TData_dS;
            procedure Put(_Index: word; const Data: TData_dS);



            public
            constructor create();
            procedure add(nf:string);
            procedure add_d(nf:string);
            procedure add_p(nf:string);
            procedure add(d:TData_dS);
            procedure add_d(d:TData_dS);
            procedure add_p(d:TData_dS);
            function Next():TData_dS;
            function NeNext():TData_dS;
            function tek_el():TData_dS;
            property el[_Index:word]:TData_dS read Get write Put; default;
            function gostart():TData_dS;
            function goend():TData_dS;
            function count():integer;
            procedure del_tek();
            procedure del_all();
    end;

implementation


function dSpisok.Get(_Index: word): TData_dS;
var tmp:TData_dS;
    search:boolean;
    i:word=0;
begin
     goend();
     if _index<>0 then
     begin
          search:=true;
          while (tek<> _begin) and search do
          begin
               Next();
               i+=1;
               if i = _index then search:=false;
          end;
     end;
     tmp:=tek_el();
     Get:=tmp;
end;

procedure dSpisok.Put(_Index: word; const Data: TData_dS);
begin
     {goend();
     if _index<>0 then
     begin
          search:=true;
          while (tek<> _begin) and search do
          begin
               Next();
               i+=1;
               if i = _index then search:=false;
          end;
     end;
     tmp:=tek_el();
     Get:=tmp;}

end;

procedure dSpisok.add(d:TData_dS);
var temp_uk:uk;
begin
    if (_begin = nil) then
    begin
         new(tek);
         _begin:=tek;
         _end:=tek;
         tek^._sled:=nil;
         tek^._pred:=nil;
         d.id_track:=_count;
         tek^.data:=d;
    end
    else
    begin
         new(temp_uk);
         temp_uk^._pred:=_end;
         _end^._sled:=temp_uk;
         _end:=temp_uk;
         //tek:=temp_uk;
         d.id_track:=index;
         temp_uk^.data:=d;
    end;
    index+=1;
    _count+=1;
end;

procedure dSpisok.add_d(d:TData_dS);
var new_el:uk;
    tmp:uk;
begin
     if _begin = nil then
     begin
          add(d);
     end
     else
     begin
          new(new_el);
          if tek = _begin then
          begin
               _begin^._pred:=new_el;
               _begin:=new_el;
               _begin^._sled:=tek;
               tek:=new_el;
          end
          else
          begin
               tmp:=tek^._pred;
               tek^._pred:=new_el;
               new_el^._sled:=tek;
               tmp^._sled:=new_el;
               new_el^._pred:=tmp;
               tek:=new_el;
          end;
          d.id_track:=index;
          tek^.data:=d;
          _count+=1;
          index+=1;
     end;
end;

procedure dSpisok.add_p(d:TData_dS);
var new_el:uk;
    tmp:uk;
begin
     if (_begin = nil) or (tek = _end) then
     begin
          add(d);
     end
     else
     begin
          new(new_el);
          tmp:=tek^._sled;
          tek^._sled:=new_el;
          new_el^._pred:=tek;
          tmp^._pred:=new_el;
          new_el^._sled:=tmp;
          tek:=new_el;
          d.id_track:=index;
          tek^.data:=d;
          _count+=1;
          index+=1;
     end;
end;

procedure dSpisok.add_d(nf:string);
var new_el:uk;
    tmp:uk;
begin
     if _begin = nil then
     begin
          add(nf);
     end
     else
     begin
          new(new_el);
          if tek = _begin then
          begin
               _begin^._pred:=new_el;
               _begin:=new_el;
               _begin^._sled:=tek;
               tek:=new_el;
          end
          else
          begin
               tmp:=tek^._pred;
               tek^._pred:=new_el;
               new_el^._sled:=tek;
               tmp^._sled:=new_el;
               new_el^._pred:=tmp;
               tek:=new_el;
          end;
          tek^.data.name_file:=nf;
          _count+=1;
     end;
end;

procedure dSpisok.add_p(nf:string);
var new_el:uk;
    tmp:uk;
begin
     if (_begin = nil) or (tek = _end) then
     begin
          add(nf);
     end
     else
     begin
          new(new_el);
          tmp:=tek^._sled;
          tek^._sled:=new_el;
          new_el^._pred:=tek;
          tmp^._pred:=new_el;
          new_el^._sled:=tmp;
          tek:=new_el;
          tek^.data.name_file:=nf;
          _count+=1;
     end;
end;

function dSpisok.count():integer;
begin
     count:=_count;
end;

procedure dSpisok.del_all();
begin
     tek:=_begin;
     while tek<>_end do
     begin
          _begin:=tek^._sled;
          dispose(tek);
          tek:=_begin;
     end;
     dispose(tek);
     tek:=nil;
     _begin:=nil;
     _end:=nil;
     _count:=0;
     index:=0;
end;

procedure dSpisok.del_tek();
var tmp_sled, tmp_pred:uk;
begin
     if _count <> 0 then
     begin
          if tek=_begin then
          begin
               if tek=_end then
               begin
                    dispose(tek);
                    tek:=nil;
                    _begin:=nil;
                    _end:=nil;
               end
               else
               begin
                    tmp_sled:=tek^._sled;
                    tmp_sled^._pred:=nil;
                    _begin:=tmp_sled;
                    dispose(tek);
                    tek:=_begin;
               end;
          end
          else
          begin
               if tek=_end then
               begin
                    tmp_pred:=tek^._pred;
                    tmp_pred^._sled:=nil;
                    _end:=tmp_pred;
                    dispose(tek);
                    tek:=_end;
               end
               else
               begin
                    tmp_sled:=tek^._sled;
                    tmp_pred:=tek^._pred;
                    tmp_sled^._pred:=tmp_pred;
                    tmp_pred^._sled:=tmp_sled;
                    dispose(tek);
                    tek:=tmp_sled;
               end;
          end;
          _count-=1;
     end;
end;

function dSpisok.NeNext():TData_dS;
begin
     if tek <> _end then
     begin
          tek:=tek^._sled;
          NeNext:=tek^.data;
     end
     else
     NeNext.name_file:='пусто';
end;

function dSpisok.tek_el():TData_dS;
begin
     if tek <> nil then
     begin
          tek_el:=tek^.data;
     end
     else
     tek_el.name_file:='пусто';
end;

function dSpisok.Next():TData_dS;
begin
     if tek <> _begin then
     begin
          tek:=tek^._pred;
          Next:=tek^.data;
     end
     else
     Next.name_file:='пусто';
end;

function dSpisok.gostart():TData_dS;
begin
     tek:=_begin;
     if tek <> nil then
     begin
          gostart:=tek^.data;
     end
     else
     gostart.name_file:='пусто';
end;

function dSpisok.goend():TData_dS;
begin
     tek:=_end;
     if tek <> nil then
     begin
          goend:=tek^.data;
     end
     else
     goend.name_file:='пусто';
end;

constructor dSpisok.create();
begin
    _begin:=nil;
    _end:=nil;
    tek:=nil;
    index:=0;
    _count:=0;
end;

procedure dSpisok.add(nf:string);
var temp_uk:uk;
begin
    index+=1;
    if (_begin = nil) then
    begin
         new(tek);
         _begin:=tek;
         _end:=tek;
         tek^._sled:=nil;
         tek^._pred:=nil;
         tek^.data.name_file:=nf;
    end
    else
    begin
         new(temp_uk);
         temp_uk^._pred:=_end;
         _end^._sled:=temp_uk;
         _end:=temp_uk;
         //tek:=temp_uk;
         temp_uk^.data.name_file:=nf;
    end;
    _count+=1;
end;

end.

