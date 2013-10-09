unit interf12;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls,  interf, player3_0u, bass;

type

  { TForm12 }

  TForm12 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    ListBox1: TListBox;
    TrackBar1: TTrackBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
    procedure ListBox1Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
  private
    { private declarations }
    procedure load_file;
  public
    { public declarations }
  end;

  vpt_text = record
    time:integer;
    stroka:string[254];
  end;

var
  Form12: TForm12;
  vpt_file_name:string; //Vip Player Text;
  vpt_file:File of vpt_text;
  //input_text:text;
  element:vpt_text;
  razm_f, item_index, count_index:integer;
  time_arr:array [0..100] of integer;

implementation

{$R *.lfm}

{ TForm12 }

procedure TForm12.load_file();
var i:integer;
begin
    count_index:=0;
    razm_f:=system.fileSize(vpt_file);
    if razm_f = 0 then
    begin
         soobchenie('vinPlayer', 'Файл пуст!!!', 500, false);
    end
    else
    begin
         //SetLength(time_arr,razm_f);
        i:=0;
         while not eof(vpt_file) do
         begin
              read(vpt_file,element);
              time_arr[i]:=element.time;
              form12.ListBox1.Items.Add(element.stroka);
              count_index+=1;
              i+=1;
         end;
         form12.TrackBar1.Position:=time_arr[0];
         form12.ListBox1.ItemIndex:=0;
    end;
end;

procedure TForm12.TrackBar1Change(Sender: TObject);
begin
    //soobchenie('vinPlayer', 'Точка: ' + inttostr(TrackBar1.position), 370, false);

end;

procedure TForm12.Button1Click(Sender: TObject);
begin
    per(TrackBar1.position);
end;

procedure TForm12.Button2Click(Sender: TObject);
var t:integer;
begin
  t:=TrackBar1.position;
  t-=1;
  if (t>0) and (t < 1000) then
   TrackBar1.position:=t;
    per(TrackBar1.position);
end;

procedure TForm12.Button3Click(Sender: TObject);
var t:integer;
begin
  t:=TrackBar1.position;
  t+=1;
  if (t>0) and (t < 1000) then
   TrackBar1.position:=t;
    per(TrackBar1.position);
end;

procedure TForm12.Button4Click(Sender: TObject);
begin
     form12.ListBox1.Items.Add(form12.Edit1.text);
     count_index+=1;
end;

procedure TForm12.Button5Click(Sender: TObject);
var i:integer;
begin
    if vpt_open then
    begin
         seek(vpt_file,0);
         for i := 0 to form12.ListBox1.Items.count - 1 do
         begin
             element.time:=time_arr[i];
             time_arr[i]:=0;
             element.stroka:=form12.listBox1.Items[i];
             write(vpt_file, element)
         end;
         truncate(vpt_file);
        system.close(vpt_file);
        soobchenie('vinPlayer', 'Сохранено: ' + SysToUtf8(vpt_file_name), 500, false);
        while form12.listBox1.Count <> 0 do form12.listBox1.Items.Delete(0);
        Button5.Enabled:=False;
        Button6.Enabled:=true;
        Button7.Enabled:=true;
        vpt_open:=false;
    end;
end;

procedure TForm12.Button6Click(Sender: TObject);
var t:string;
    i:integer;
begin
     razm_f:=0;
     item_index:=0;
     count_index:=0;
    t:= filewav;
    i:=length(t);
    delete(t, i-3, i);
    t+='.vpt';
    soobchenie('vinPlayer', 'Открыть: ' + SysToUtf8(t), 500, false);
    vpt_file_name:=t;
    system.assign(vpt_file, vpt_file_name);
    {$I-}
    reset(vpt_file);
    {$I+}
    if ioresult<>0 then
    begin
      rewrite(vpt_file);
    end;
    vpt_open:=true;
    load_file();
    Button5.Enabled:=true;
    Button6.Enabled:=false;
    Button7.Enabled:=false;
end;

procedure TForm12.Button7Click(Sender: TObject);
var t0:string;
    i:integer;
begin
     razm_f:=0;
     item_index:=0;
     count_index:=0;
    t0:= filewav;
    i:=length(t0);
    delete(t0, i-3, i);
    t0+='.vpt';
    soobchenie('vinPlayer', 'Открыть: ' + SysToUtf8(t0), 500, false);
    vpt_file_name:=t0;
    system.assign(vpt_file, vpt_file_name);
    rewrite(vpt_file);
    vpt_open:=true;
    Button5.Enabled:=true;
    Button6.Enabled:=false;
    Button7.Enabled:=false;
end;

procedure TForm12.Button8Click(Sender: TObject);
var t:real;
begin
    t:= BASS_ChannelBytes2Seconds( potok, BASS_ChannelGetPosition(potok,0))/BASS_ChannelBytes2Seconds(potok, BASS_ChannelGetLength(potok,0));
    //BASS_ChannelBytes2Seconds( potok, BASS_ChannelGetPosition(potok,0)
    //BASS_ChannelBytes2Seconds(potok, BASS_ChannelGetLength(potok,0)
    //soobchenie('vinPlayer', 'Точка' + inttostr(round(t*1000)), 500, false);
    form12.TrackBar1.Position:=round(t*1000);
    if form12.CheckBox1.Checked and (item_index < listBox1.Items.Count-1) then
    begin
         time_arr[item_index]:=form12.TrackBar1.Position;
         item_index += 1;
         form12.ListBox1.ItemIndex := item_index;
         soobchenie('vinPlayer', 'Точка: ' + inttostr(TrackBar1.position), 370, false);
         form12.TrackBar1.Position:=time_arr[item_index];
    end;
end;

procedure TForm12.FormCreate(Sender: TObject);
begin
     razm_f:=0;
     item_index:=0;
     count_index:=0;
end;

procedure TForm12.FormDropFiles(Sender: TObject;
  const FileNames: array of String);
var s:Tstrings;
    i:byte;
begin
     s:=TStringList.create;
     s.LoadFromFile(systoutf8(FileNames[0]));
     for i:= 0 to s.Count - 1 do
     begin
          form12.ListBox1.Items.Strings[i]:=systoutf8(s.Strings[i]);
     end;
end;


procedure TForm12.ListBox1Click(Sender: TObject);
begin
    time_arr[item_index]:=form12.TrackBar1.Position;
    item_index := form12.ListBox1.ItemIndex;
    form12.TrackBar1.Position:=time_arr[item_index];
    soobchenie('vinPlayer', 'Точка: ' + inttostr(TrackBar1.position), 370, false);
end;

end.

