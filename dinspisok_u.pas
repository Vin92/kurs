unit dinspisok_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, windows, spisok;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    ListBox1: TListBox;
    Memo1: TMemo;
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
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

var
  Form1: TForm1;
  fff:file of el;
  element:el;
  s:dSpisok;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
     system.assign(fff, ExtractFilePath(paramstr(0)) + 'media_baza.vin92');
     {$I-}
     reset(fff);
     {$I+}
     if ioresult<>0 then
     begin
          messagebox(0,PChar('Error open'),PChar('Vin92.software:)'),0);
     end
     else
     begin
          while not eof(fff) do
          begin
               read(fff, element);
               Form1.ListBox1.items.Add(systoutf8(element.name_file));
               s.add(systoutf8(element.name_file));
          end;
          system.close(fff);
     end;
end;

procedure TForm1.Button10Click(Sender: TObject);
var tmp:TData_dS;
    i:integer;
begin
     while Form1.ListBox1.items.Count <> 0 do
             Form1.ListBox1.items.Delete(0);
     s.goend();
     tmp:=s.tek_el();
     for i := 0 to s.count - 1 do
     begin
          tmp:=s.tek_el();
          Form1.ListBox1.items.Add(inttostr(s.count - i - 1) + ' | '+tmp.name_file);
          s.Next();
     end;
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
     s.add_d(form1.Edit1.Text);
end;

procedure TForm1.Button12Click(Sender: TObject);
begin
     s.add_p(form1.Edit1.Text);
end;

procedure TForm1.Button13Click(Sender: TObject);
var t:TData_dS;
begin
     t:=s.el[10];
     memo1.Lines.Add(t.name_file + ' index');
end;

procedure TForm1.Button2Click(Sender: TObject);
var t:TData_dS;
begin
     t:=s.NeNext();
     memo1.Lines.Add(t.name_file + ' NeNext');
end;

procedure TForm1.Button3Click(Sender: TObject);
var t:TData_dS;
begin
     t:=s.Next();
     memo1.Lines.Add(t.name_file + ' Next');
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
     Form1.ListBox1.items.Add(Form1.Edit1.Text);
     s.add(systoutf8(Form1.Edit1.Text));
end;

procedure TForm1.Button5Click(Sender: TObject);
var t:TData_dS;
begin
     t:=s.tek_el();
     memo1.Lines.Add(t.name_file + ' =');
end;

procedure TForm1.Button6Click(Sender: TObject);
var t:TData_dS;
begin
     t:=s.goend();
     memo1.Lines.Add(t.name_file + ' <<<<');
end;

procedure TForm1.Button7Click(Sender: TObject);
var t:TData_dS;
begin
     t:=s.gostart();
     memo1.Lines.Add(t.name_file + ' >>>>');
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
     s.del_tek();
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
     s.del_all();
end;

procedure TForm1.Edit2Change(Sender: TObject);
begin

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
     s:=dSpisok.create;
end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin

end;

end.

