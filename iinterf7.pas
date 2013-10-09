unit iinterf7;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Menus, {CheckLst,} windows, player3_0u, interf, {interf8,} types,
  spisok;

const
count=9; //число вершин в полигоне

type

  { TForm7 }

  TForm7 = class(TForm)
    Bevel1: TBevel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Image1: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image2: TImage;
    Image24: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MenuItem1: TMenuItem;
    PopupMenu1: TPopupMenu;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image13MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image13MouseUp(Sender: TObject{; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer});
    procedure Image2MouseDown(Sender: TObject; {Button: TMouseButton;
      Shift: TShiftState;} X, Y: Integer);
    procedure Image2MouseUp(Sender: TObject; {Button: TMouseButton;
      Shift: TShiftState;} X, Y: Integer);
    procedure Image2MouseWheelDown(Sender: TObject {;Shift: TShiftState; }
      {MousePos: TPoint}{; var Handled: Boolean});
    procedure MenuItem1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form7: TForm7;
  //tm1:boolean;
  move_pl, dejstv:array[1..10] of byte;
  obnov_line:array[0..10] of byte;
  nach_pl, tek_razn:integer;
  mouse:TPoint;
  mousex_stab_r1, yskor:array [1..10] of real;
  mousex_stab, poloj_x, pl_kadr:array [1..10] of integer;
  identificator_track, new_identificator_track:array [1..10] of int64;
  play_progress:real;
  line_1, old_line_1:array [1..10] of string[48];
  line_2, old_line_2:array [1..10] of string[71];
  napr_obn:boolean;
  speed_stab:real=5.0;//1.5; //5
  speed_yskor:real=3.5;//23.0;   //3.5
  sh_kadr:byte=0;
  pl_down:byte=0;

procedure pok;
procedure obnForm7;
procedure obnForm7t;
procedure load_spisok(n:boolean);
procedure serch_and_load_spisok;
procedure draw;

function name_f(z1:string):string;

implementation

{$R *.lfm}

{ TForm7 }

function name_f(z1:string):string;
var i:byte;
begin
     i:=1;
     while i<>0 do
     begin
          i:=pos('\', z1);
          delete(z1, 1, i);
     end;
     name_f:=z1;
end;

procedure pok;
begin
     form7.visible:=not form7.visible;
     form7.top:=45;

     serch_and_load_spisok;    //load_spisok(false);
end;



procedure TForm7.FormCreate(Sender: TObject);
begin
     move_pl[1]:=0;
     move_pl[2]:=0;
     move_pl[3]:=0;
     move_pl[4]:=0;
     move_pl[5]:=0;
     move_pl[6]:=0;
     move_pl[7]:=0;
     move_pl[8]:=0;
     move_pl[9]:=0;
     move_pl[10]:=0;
     nach_pl:=38;
     tek_razn:=0;
     mousex_stab[1]:=nach_pl;
     mousex_stab[2]:=nach_pl;
     mousex_stab[3]:=nach_pl;
     mousex_stab[4]:=nach_pl;
     mousex_stab[5]:=nach_pl;
     mousex_stab[6]:=nach_pl;
     mousex_stab[7]:=nach_pl;
     mousex_stab[8]:=nach_pl;
     mousex_stab[9]:=nach_pl;
     mousex_stab[10]:=nach_pl;
     mousex_stab_r1[1]:=38.0;
     mousex_stab_r1[2]:=38.0;
     mousex_stab_r1[3]:=38.0;
     mousex_stab_r1[4]:=38.0;
     mousex_stab_r1[5]:=38.0;
     mousex_stab_r1[6]:=38.0;
     mousex_stab_r1[7]:=38.0;
     mousex_stab_r1[8]:=38.0;
     mousex_stab_r1[9]:=38.0;
     mousex_stab_r1[10]:=38.0;
     poloj_x[1]:=nach_pl;
     poloj_x[2]:=nach_pl;
     poloj_x[3]:=nach_pl;
     poloj_x[4]:=nach_pl;
     poloj_x[5]:=nach_pl;
     poloj_x[6]:=nach_pl;
     poloj_x[7]:=nach_pl;
     poloj_x[8]:=nach_pl;
     poloj_x[9]:=nach_pl;
     poloj_x[10]:=nach_pl;
     identificator_track[1]:=0;
     identificator_track[2]:=0;
     identificator_track[3]:=0;
     identificator_track[4]:=0;
     identificator_track[5]:=0;
     identificator_track[6]:=0;
     identificator_track[7]:=0;
     identificator_track[8]:=0;
     identificator_track[9]:=0;
     identificator_track[10]:=0;
     new_identificator_track[1]:=1;
     new_identificator_track[2]:=1;
     new_identificator_track[3]:=1;
     new_identificator_track[4]:=1;
     new_identificator_track[5]:=1;
     new_identificator_track[6]:=1;
     new_identificator_track[7]:=1;
     new_identificator_track[8]:=1;
     new_identificator_track[9]:=1;
     new_identificator_track[10]:=1;
     dejstv[1]:=0;
     dejstv[2]:=0;
     dejstv[3]:=0;
     dejstv[4]:=0;
     dejstv[5]:=0;
     dejstv[6]:=0;
     dejstv[7]:=0;
     dejstv[8]:=0;
     dejstv[9]:=0;
     dejstv[10]:=0;
     obnov_line[0]:=2;
     obnov_line[1]:=0;
     obnov_line[2]:=0;
     obnov_line[3]:=0;
     obnov_line[4]:=0;
     obnov_line[5]:=0;
     obnov_line[6]:=0;
     obnov_line[7]:=0;
     obnov_line[8]:=0;
     obnov_line[9]:=0;
     obnov_line[10]:=0;
     image24.top:=0;
     image24.left:=330;
     Image13.top:=0;
     Image13.left:=0;
     form7.Left:=0;
     {pl_kadr[1]:=550;
     pl_kadr[2]:=550;
     pl_kadr[3]:=550;
     pl_kadr[4]:=550;
     pl_kadr[5]:=550;
     pl_kadr[6]:=550;
     pl_kadr[7]:=550;
     pl_kadr[8]:=550;
     pl_kadr[9]:=550;
     pl_kadr[10]:=550;  }
end;

procedure TForm7.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     soobchenie('Отладка','Нажата мышь в позиции X: ' + inttostr(X) + ', Y: ' + inttostr(Y), 400, false);
end;

procedure TForm7.Image13MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     // pl_down
     //soobchenie('Отладка','Нажата мышь в позиции X: ' + inttostr(X) + ', Y: ' + inttostr(Y), 400, false);
     if (Y > 48) and (Y<104) then //1
     begin
          pl_down:=1;
          move_pl[1]:=100;
          tek_razn:=X - Form7.Image2.left;
     end;

     if (Y > 104) and (Y<160) then //2
     begin
          pl_down:=2;
          move_pl[2]:=100;
          tek_razn:=X - Form7.Image3.left;
     end;

     if (Y > 160) and (Y<216) then //3
     begin
          pl_down:=3;
          move_pl[3]:=100;
          tek_razn:=X - Form7.Image4.left;
     end;

     if (Y > 216) and (Y<272) then //4
     begin
          pl_down:=4;
          move_pl[4]:=100;
          tek_razn:=X - Form7.Image5.left;
     end;

     if (Y > 272) and (Y<328) then //5
     begin
          pl_down:=5;
          move_pl[5]:=100;
          tek_razn:=X - Form7.Image6.left;
     end;

     if (Y > 328) and (Y<384) then //6
     begin
          pl_down:=6;
          move_pl[6]:=100;
          tek_razn:=X - Form7.Image7.left;
     end;

     if (Y > 384) and (Y<440) then //7
     begin
          pl_down:=7;
          move_pl[7]:=100;
          tek_razn:=X - Form7.Image8.left;
     end;

     if (Y > 440) and (Y<496) then //8
     begin
          pl_down:=8;
          move_pl[8]:=100;
          tek_razn:=X - Form7.Image9.left;
     end;

     if (Y > 496) and (Y<552) then //9
     begin
          pl_down:=9;
          move_pl[9]:=100;
          tek_razn:=X - Form7.Image10.left;
     end;

     if (Y > 552) and (Y<608) then //10
     begin
          pl_down:=10;
          move_pl[10]:=100;
          tek_razn:=X - Form7.Image11.left;
     end;

     //tek_razn:=X;//mouse.X - Form7.Image2.left;
end;

procedure TForm7.Image13MouseUp(Sender: TObject{; Button: TMouseButton;//позиция 1
  Shift: TShiftState; X, Y: Integer});
begin
     case pl_down of
     1:move_pl[1]:=0;
     2:move_pl[2]:=0;
     3:move_pl[3]:=0;
     4:move_pl[4]:=0;
     5:move_pl[5]:=0;
     6:move_pl[6]:=0;
     7:move_pl[7]:=0;
     8:move_pl[8]:=0;
     9:move_pl[9]:=0;
     10:move_pl[10]:=0;
     end;

end;

procedure TForm7.Image2MouseDown(Sender: TObject; {Button: TMouseButton;
  Shift: TShiftState;} X, Y: Integer);
begin
     soobchenie('Отладка','Нажата мышь в позиции X: ' + inttostr(X) + ', Y: ' + inttostr(Y), 400, false);
end;

procedure TForm7.Image2MouseUp(Sender: TObject;{ Button: TMouseButton;
  Shift: TShiftState;} X, Y: Integer);
begin
     soobchenie('Отладка','Отпущена мышь в позиции X: ' + inttostr(X) + ', Y: ' + inttostr(Y), 400, false);
end;

procedure TForm7.Image2MouseWheelDown(Sender: TObject{; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean});
begin
end;

procedure TForm7.MenuItem1Click(Sender: TObject);
begin

end;

procedure TForm7.Button1Click(Sender: TObject);//вверх
begin
     load_spisok(true);
end;

procedure TForm7.Button2Click(Sender: TObject);//вниз
begin
     load_spisok(false);
end;

procedure TForm7.Button3Click(Sender: TObject);//воспроизведение выбора
begin
     serch_and_load_spisok;    //load_spisok(false);
end;

procedure serch_and_load_spisok;
var  baza_el:TData_dS;
  b:boolean=true;
begin
     baza_el:=spisok_vospr.goend();
     while (tek_id_track <> baza_el.id_track)and b do
     begin
          baza_el:=spisok_vospr.Next();
          //tmp:=baza_el.name_file;
          if baza_el.name_file = 'пусто' then
          begin
               soobchenie('Ошибка','Внутренняя ошибка при работе с базой!!!', 500, false);
               spisok_vospr.goend();
               b:=false;
          end;
     end;
     load_spisok(false);
end;

procedure load_spisok(n:boolean);
var  baza_el:TData_dS;
     i:byte;
begin
     if n then
     begin
          for i:=1 to 20 do
          begin
               baza_el:=spisok_vospr.tek_el();
               if baza_el.name_file <> 'пусто' then
               begin
                    baza_el:=spisok_vospr.NeNext();
               end;
          end;
     end;
     baza_el:=spisok_vospr.tek_el();
     for i:=1 to 10 do
     begin

          if baza_el.name_file = 'пусто' then
          begin

               line_1[i]:='пусто';
               line_2[i]:='';
               new_identificator_track[i]:=-1;
          end
          else
          begin
               line_1[i]:=baza_el.artist_id3 + ' - ' + baza_el.name_id3;
               line_2[i]:=systoutf8(baza_el.put) + systoutf8(baza_el.name_file);
               if (line_1[i] = ' - ') then line_1[i]:=name_f(systoutf8(baza_el.put));
               new_identificator_track[i]:=baza_el.id_track;
          end;
          baza_el:=spisok_vospr.Next();
     end;
     napr_obn:=not n;
end;

procedure TForm7.Button4Click(Sender: TObject);

begin
end;

procedure TForm7.Button5Click(Sender: TObject);//отчистка списка
begin
     spisok_vospr.del_all();
     ochered_vospr.del_all();
end;

procedure TForm7.Timer1Timer(Sender: TObject);
begin

end;

procedure obnForm7;
begin
     if form7.visible then obnForm7t;
end;

procedure obnForm7t;
var tmp_move_pl, i, j:byte;
    tmp_poloj_x:integer;
    tmp_obn:real;
    //play_spisok:boolean;
begin
     getcursorpos(mouse);
     //mousex_stab_r2:=mouse.X;

     for i:=1 to 10 do
     begin
          if ((identificator_track[i]<>new_identificator_track[i]) or(old_line_1[i]<>line_1[i]) or (old_line_2[i]<>line_2[i])) and (obnov_line[i]=0) and ((obnov_line[i-1]=2) or (obnov_line[i-1]=3)) then
          begin
               obnov_line[i]:=1;
               dejstv[i]:=0;
               move_pl[i]:=200;
               yskor[i]:=0;
          end;

          if (obnov_line[i]=1) or (obnov_line[i]=2) or (obnov_line[i]=3) then
          begin
               if napr_obn then
               begin
                    yskor[i] +=speed_yskor;
                    mousex_stab_r1[i]-=round(yskor[i]);
                    if (mousex_stab[i] < -50) then obnov_line[i]:=2;
                    if (mousex_stab[i] < -350) then
                    begin
                         {Form7.label1.caption:=line_1[1];
                         Form7.label2.caption:=line_2[1]; }
                         old_line_1[i]:=line_1[i];
                         old_line_2[i]:=line_2[i];
                         identificator_track[i]:=new_identificator_track[i];
                         obnov_line[i]:=3;
                         dejstv[i]:=0;
                         move_pl[i]:=2;
                         mousex_stab_r1[i]:=550;
                    end;
                    if (obnov_line[i]=3) and (mousex_stab_r1[i]<58.0) then
                    begin
                         //poloj_x[1]:=38;
                         obnov_line[i]:=0;
                    end;
               end
               else
               begin
                    yskor[i] -=speed_yskor;
                    mousex_stab_r1[i]-=round(yskor[i]);
                    if (mousex_stab[i] > 126) then obnov_line[i]:=2;
                    if (mousex_stab[i] > 550) then
                    begin
                         {Form7.label1.caption:=line_1[1];
                         Form7.label2.caption:=line_2[1];}
                         old_line_1[i]:=line_1[i];
                         old_line_2[i]:=line_2[i];
                         identificator_track[i]:=new_identificator_track[i];
                         obnov_line[i]:=3;
                         dejstv[i]:=0;
                         move_pl[i]:=2;
                         mousex_stab_r1[i]:=-350;
                    end;
                    if (obnov_line[i]=3) and (mousex_stab_r1[i]>18.0) then
                    begin
                         //poloj_x[1]:=38;
                         obnov_line[i]:=0;
                    end;
               end;
          end;
     end;


     if move_pl[1]=100 then
     begin
          poloj_x[1]:=mouse.X - tek_razn;
     end;

     if obnov_line[1]=0 then
     begin
          tmp_obn:=mousex_stab_r1[1] - poloj_x[1];
          //if tmp_obn > 0.00001 then
          mousex_stab_r1[1] -= (tmp_obn)/speed_stab;
     end
     else
     begin
          Form7.label1.caption:=old_line_1[1];
          Form7.label2.caption:=old_line_2[1];
     end;
     mousex_stab[1]:=round(mousex_stab_r1[1]);

     if move_pl[2]=100 then
     begin
          poloj_x[2]:=mouse.X - tek_razn;
     end;
     if obnov_line[2]=0 then
     begin
          tmp_obn:=mousex_stab_r1[2] - poloj_x[2];
          //if tmp_obn > 0.00001 then
          mousex_stab_r1[2] -= (tmp_obn)/speed_stab;
     end
     else
     begin
          Form7.label3.caption:=old_line_1[2];
          Form7.label4.caption:=old_line_2[2];
     end;
     mousex_stab[2]:=round(mousex_stab_r1[2]);
     if move_pl[3]=100 then
     begin
          poloj_x[3]:=mouse.X - tek_razn;
     end;
     if obnov_line[3]=0 then
     begin
          tmp_obn:=mousex_stab_r1[3] - poloj_x[3];
          //if tmp_obn > 0.00001 then
          mousex_stab_r1[3] -= (tmp_obn)/speed_stab;
     end
     else
     begin
          Form7.label5.caption:=old_line_1[3];
          Form7.label6.caption:=old_line_2[3];
     end;
     mousex_stab[3]:=round(mousex_stab_r1[3]);
     if move_pl[4]=100 then
     begin
          poloj_x[4]:=mouse.X - tek_razn;
     end;
     if obnov_line[4]=0 then
     begin
          tmp_obn:=mousex_stab_r1[4] - poloj_x[4];
          //if tmp_obn > 0.00001 then
          mousex_stab_r1[4] -= (tmp_obn)/speed_stab;
     end
     else
     begin
          Form7.label7.caption:=old_line_1[4];
          Form7.label8.caption:=old_line_2[4];
     end;
     mousex_stab[4]:=round(mousex_stab_r1[4]);

     if move_pl[5]=100 then
     begin
          poloj_x[5]:=mouse.X - tek_razn;
     end;
     if obnov_line[5]=0 then
     begin
          tmp_obn:=mousex_stab_r1[5] - poloj_x[5];
          //if tmp_obn > 0.00001 then
          mousex_stab_r1[5] -= (tmp_obn)/speed_stab;
     end
     else
     begin
          Form7.label9.caption:=old_line_1[5];
          Form7.label10.caption:=old_line_2[5];
     end;
     mousex_stab[5]:=round(mousex_stab_r1[5]);
     if move_pl[6]=100 then
     begin
          poloj_x[6]:=mouse.X - tek_razn;
     end;
     if obnov_line[6]=0 then
     begin
          tmp_obn:= mousex_stab_r1[6] - poloj_x[6];
          //if tmp_obn > 0.00001 then
          mousex_stab_r1[6] -= (tmp_obn)/speed_stab;
     end
     else
     begin
          Form7.label11.caption:=old_line_1[6];
          Form7.label12.caption:=old_line_2[6];
     end;
     mousex_stab[6]:=round(mousex_stab_r1[6]);
     if move_pl[7]=100 then
     begin
          poloj_x[7]:=mouse.X - tek_razn;
     end;
     if obnov_line[7]=0 then
     begin
          tmp_obn:=mousex_stab_r1[7] - poloj_x[7];
          //if tmp_obn > 0.00001 then
          mousex_stab_r1[7] -= (tmp_obn)/speed_stab;
     end
     else
     begin
          Form7.label13.caption:=old_line_1[7];
          Form7.label14.caption:=old_line_2[7];
     end;
     mousex_stab[7]:=round(mousex_stab_r1[7]);
     if move_pl[8]=100 then
     begin
          poloj_x[8]:=mouse.X - tek_razn;
     end;
     if obnov_line[8]=0 then
     begin
          tmp_obn:=mousex_stab_r1[8] - poloj_x[8];
          //if tmp_obn > 0.00001 then
          mousex_stab_r1[8] -= (tmp_obn)/speed_stab;
     end
     else
     begin
          Form7.label15.caption:=old_line_1[8];
          Form7.label16.caption:=old_line_2[8];
     end;
     mousex_stab[8]:=round(mousex_stab_r1[8]);
     if move_pl[9]=100 then
     begin
          poloj_x[9]:=mouse.X - tek_razn;
     end;
     if obnov_line[9]=0 then
     begin
          tmp_obn:= mousex_stab_r1[9] - poloj_x[9];
          //if tmp_obn > 0.00001 then
          mousex_stab_r1[9] -= (tmp_obn)/speed_stab;
     end
     else
     begin
          Form7.label17.caption:=old_line_1[9];
          Form7.label18.caption:=old_line_2[9];
     end;
     mousex_stab[9]:=round(mousex_stab_r1[9]);
     if move_pl[10]=100 then
     begin
          poloj_x[10]:=mouse.X - tek_razn;
     end;
     if obnov_line[10]=0 then
     begin
          tmp_obn:= mousex_stab_r1[10] - poloj_x[10];
          //if tmp_obn > 0.00001 then
          mousex_stab_r1[10] -= (tmp_obn)/speed_stab;
     end
     else
     begin
          Form7.label19.caption:=old_line_1[10];
          Form7.label20.caption:=old_line_2[10];
     end;
     mousex_stab[10]:=round(mousex_stab_r1[10]);

     //play_spisok:=true;
     for i:=1 to 10 do
     begin
          tmp_move_pl:=move_pl[i];
          tmp_poloj_x:=poloj_x[i];
          if (tmp_poloj_x>40) and {(tmp_poloj_x<58)}(dejstv[i] <> 1) and (tmp_move_pl<>1) and ((tmp_move_pl<>100) {or (tmp_move_pl=0)}) and (move_pl[i]<>10) and (move_pl[i]<>11) and (obnov_line[i]=0) then begin move_pl[i]:=1; dejstv[i]:=1; end;
          if (tmp_poloj_x<=40) and (tmp_poloj_x>-250) and (tmp_move_pl<>100) and (tmp_move_pl<> 2) then begin move_pl[i]:=2; dejstv[i]:=0; end;
          if (tmp_poloj_x<=-250) and (tmp_move_pl<>100) and (tmp_move_pl<> 3) then begin move_pl[i]:=3; dejstv[i]:=0; end;
          if (move_pl[i]=0) and (dejstv[i]=1) then
          begin
               //poloj_x[i]:=38;
               //dejstv[i]:=0;
               move_pl[i]:=11;
               play_progress:=(poloj_x[i] - nach_pl - 20)/328.0;
               if play_progress < 0.001 then play_progress:=0.001;
               if play_progress > 0.999 then play_progress:=0.001;
               if otl then vplayer.memo1.lines.Add('play_progress ' + inttostr(round(play_progress*1000.0)));
               per(round(play_progress*1000.0));

               //stop;
          end;

          if move_pl[i]=1 then
          begin
               move_pl[i]:=10;//
               poloj_x[i]:=58;
               for j:=1 to 10 do
               begin
                   if (j <> i) and ((move_pl[j] = 1) or (move_pl[j] = 11) or (dejstv[j] = 1)) then
                   begin
                        poloj_x[j]:=38;
                        dejstv[j]:=0;
                   end;
               end;
          end;
          if move_pl[i]=2 then
          begin
               poloj_x[i]:=38;
               dejstv[i]:=0;
               //stop;
          end;
          if move_pl[i]=3 then
          begin
               poloj_x[i]:=-290;
               dejstv[i]:=0;
          end;
          if move_pl[i]=10 then
          begin
               move_pl[i]:=11;
               play_progress:=0;
               play_id(identificator_track[i]);
               dejstv[i]:=1;
          end;
          if (move_pl[i]=11) and (dejstv[i]=1) and (tek_id_track = identificator_track[i]) then
          begin
               //play_spisok:=false;
               poloj_x[i]:=nach_pl + 20 + round(328.0*play_progress);
          end;

          if (tek_id_track = identificator_track[i]) and (dejstv[i]<>1) then
          begin
               move_pl[i]:=11;
               dejstv[i]:=1;
               poloj_x[i]:=nach_pl + 20 + round(328.0*play_progress);
               for j:=1 to 10 do
               begin
                   if (j <> i) and ((move_pl[j] = 1) or (move_pl[j] = 11) or (dejstv[j] = 1)) then
                   begin
                        poloj_x[j]:=38;
                        dejstv[j]:=0;
                   end;
               end;
          end;
     end;
     //sh_kadr+=1;
     //if sh_kadr >3 then
     //begin
          //sh_kadr:=0;
          draw;
     //end;
     //if play_spisok then pause;
     {if otl then
     begin
          Form7.label1.Caption:=inttostr(move_pl[1]) + ' ' + inttostr(dejstv[1])  + ' ' + inttostr(identificator_track[1]);
          Form7.label2.Caption:=inttostr(tek_id_track);
          Form7.label3.Caption:=inttostr(move_pl[2]) + ' ' + inttostr(dejstv[2])  + ' ' + inttostr(identificator_track[2]);
          Form7.label5.Caption:=inttostr(move_pl[3]) + ' ' + inttostr(dejstv[3])  + ' ' + inttostr(identificator_track[3]);
          Form7.label7.Caption:=inttostr(move_pl[4]) + ' ' + inttostr(dejstv[4])  + ' ' + inttostr(identificator_track[4]);
          Form7.label9.Caption:=inttostr(move_pl[5]) + ' ' + inttostr(dejstv[5])  + ' ' + inttostr(identificator_track[5]);
          Form7.label11.Caption:=inttostr(move_pl[6]) + ' ' + inttostr(dejstv[6])  + ' ' + inttostr(identificator_track[6]);
          Form7.label13.Caption:=inttostr(move_pl[7]) + ' ' + inttostr(dejstv[7])  + ' ' + inttostr(identificator_track[7]);
          Form7.label15.Caption:=inttostr(move_pl[8]) + ' ' + inttostr(dejstv[8])  + ' ' + inttostr(identificator_track[8]);
          Form7.label17.Caption:=inttostr(move_pl[9]) + ' ' + inttostr(dejstv[9])  + ' ' + inttostr(identificator_track[9]);
          Form7.label19.Caption:=inttostr(move_pl[10]) + ' ' + inttostr(dejstv[10])  + ' ' + inttostr(identificator_track[10]);
     end; }
end;

procedure draw;
begin
     if mousex_stab[1]<> Form7.Image2.left then
     begin
          Form7.Image2.left:=mousex_stab[1];
          Form7.label1.left:=Form7.Image2.left + 10;
          Form7.label2.left:=Form7.Image2.left + 50;
     end;

     if mousex_stab[2]<> Form7.Image3.left then
     begin
          Form7.Image3.left:=mousex_stab[2];
          Form7.label3.left:=Form7.Image3.left + 10;
          Form7.label4.left:=Form7.Image3.left + 50;
     end;

     if mousex_stab[3]<> Form7.Image4.left then
     begin
          Form7.Image4.left:=mousex_stab[3];
          Form7.label5.left:=Form7.Image4.left + 10;
          Form7.label6.left:=Form7.Image4.left + 50;
     end;

     if mousex_stab[4]<> Form7.Image5.left then
     begin
          Form7.Image5.left:=mousex_stab[4];
          Form7.label7.left:=Form7.Image5.left + 10;
          Form7.label8.left:=Form7.Image5.left + 50;
     end;

     if mousex_stab[5]<> Form7.Image6.left then
     begin
          Form7.Image6.left:=mousex_stab[5];
          Form7.label9.left:=Form7.Image6.left + 10;
          Form7.label10.left:=Form7.Image6.left + 50;
     end;

     if mousex_stab[6]<> Form7.Image7.left then
     begin
          Form7.Image7.left:=mousex_stab[6];
          Form7.label11.left:=Form7.Image7.left + 10;
          Form7.label12.left:=Form7.Image7.left + 50;
     end;

     if mousex_stab[7]<> Form7.Image8.left then
     begin
          Form7.Image8.left:=mousex_stab[7];
          Form7.label13.left:=Form7.Image8.left + 10;
          Form7.label14.left:=Form7.Image8.left + 50;
     end;

     if mousex_stab[8]<> Form7.Image9.left then
     begin
          Form7.Image9.left:=mousex_stab[8];
          Form7.label15.left:=Form7.Image9.left + 10;
          Form7.label16.left:=Form7.Image9.left + 50;
     end;

     if mousex_stab[9]<> Form7.Image10.left then
     begin
          Form7.Image10.left:=mousex_stab[9];
          Form7.label17.left:=Form7.Image10.left + 10;
          Form7.label18.left:=Form7.Image10.left + 50;
     end;

     if mousex_stab[10]<> Form7.Image11.left then
     begin
          Form7.Image11.left:=mousex_stab[10];
          Form7.label19.left:=Form7.Image11.left + 10;
          Form7.label20.left:=Form7.Image11.left + 50;
     end;

end;

end.

