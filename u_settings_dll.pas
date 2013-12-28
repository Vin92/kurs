unit u_settings_dll;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  vinplayer_extern_extension, interf, player3_0u;

type

  { TForm14 }

  TForm14 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ListBox1: TListBox;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  private
    { private declarations }
    procedure set_labels(_ver, _name, _file:string);
  public
    { public declarations }
  end;

var
  Form14: TForm14;
  names_dll:TStrings;

procedure load_dll(name_f:string; otobraj:boolean=true);

implementation

{$R *.lfm}
procedure load_dll(name_f:string; otobraj:boolean=true);
var tmp_str:string;
begin
     LOAD_LIB(PChar(utf8tosys(name_f)),count_load_dlls);
     tmp_str:= string(GET_DLL_NAME(count_load_dlls));
     if tmp_str = 'ERROR' then
     begin
          soobchenie('vinPlayer - DLL', 'Что это? Я не могу это открыть!', 800, false);
          FREE_LIB(count_load_dlls);
     end
     else
     begin
          soobchenie('vinPlayer - DLL', 'DLL "'+tmp_str+'" подключена', 800, false);
          form14.ListBox1.Items.Add(tmp_str);
          names_dll.Add(name_f);
          count_load_dlls +=1;
     end;
end;

{ TForm14 }
procedure TForm14.set_labels(_ver, _name, _file:string);
begin
     form14.Label1.caption:='Версия: ' + _ver;
     form14.Label2.Caption:='Название: ' + _name;
     form14.Label3.Caption:='Файл: ' + _file;
end;

procedure TForm14.ListBox1Click(Sender: TObject);
var tmp:integer;
begin
     tmp:= form14.ListBox1.ItemIndex;
     if tmp< 0 then tmp:=0;
     case tmp of
     0:begin
            set_labels(string(vpee_get_version()),'Основная библиотека','libvpee.dll');
       end;
     else
       begin
            set_labels(string(GET_VERS(tmp-1)),string(GET_DLL_NAME(tmp-1)),names_dll.Strings[tmp-1]);
       end;
     end;
end;

procedure TForm14.Button3Click(Sender: TObject);
var j:word;
begin
     if OpenDialog1.Execute then
  begin
      for j:=0 to OpenDialog1.Files.Count-1 do
      begin
           load_dll(OpenDialog1.Files.Strings[j]);
      end;
  end;
end;

procedure TForm14.Button1Click(Sender: TObject);  //функция 1
var tmp:string;
begin
     if form14.Edit1.Text = 'file' then
        tmp:=filewav
     else
         tmp:= utf8tosys(form14.Edit1.Text);
     form14.label6.Caption:=string(EXECUTE(PChar(tmp),form14.ListBox1.ItemIndex-1));
end;

procedure TForm14.Button2Click(Sender: TObject);   //функция 2
var tmp:string;
begin
     if form14.Edit2.Text = 'file' then
        tmp:=filewav
     else
         tmp:= utf8tosys(form14.Edit2.Text);
     form14.label7.Caption:=string(EXECUTE1(PChar(tmp),form14.ListBox1.ItemIndex-1));
end;

procedure TForm14.FormCreate(Sender: TObject);
begin
     names_dll:=TStringList.Create;
end;

end.

