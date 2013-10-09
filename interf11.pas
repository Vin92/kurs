unit interf11;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, interf, player3_0u;

type

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

  { TForm11 }

  TForm11 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ListBox1: TListBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject{; var CloseAction: TCloseAction});
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

procedure open_baza_r;
procedure load_baza_r;
procedure close_baza_r;

var
  Form11: TForm11;
  fff:file of el;
  element:el;
  i:word;

implementation

{$R *.lfm}

procedure load_baza_r;
begin
    while not eof(fff) do
    begin
         read(fff, element);  //    element.name_file
         Form11.ListBox1.Items.Add(sysToUtf8(element.name_file));
    end;
end;

procedure open_baza_r;
begin

    assign(fff,ExtractFilePath(paramstr(0)) + 'media_baza.vin92');
    {$I-}
    reset(fff);
    {$I+}
    if ioresult<>0 then
    begin
      soobchenie('Редактор базы - vinPlayer', 'Не удалось открыть базу!', 900, false);
    end
    else
    begin
      soobchenie('Редактор базы - vinPlayer', 'База открыта!', 900, false);
      b_open_baza:=true;
      load_baza_r;
      form11.button1.caption := 'Закрыть';
    end;
end;

procedure close_baza_r;
begin
    if b_open_baza then
    begin
         Form11.ListBox1.Items.Clear();
         close(fff);
         b_open_baza:=false;
         form11.button1.caption := 'Загрузить';
    end;
end;

{ TForm11 }

procedure TForm11.FormCreate(Sender: TObject);
begin
     b_open_baza:=false;
end;

procedure TForm11.ListBox1Click(Sender: TObject);
begin
     i:= form11.listbox1.ItemIndex;
     seek(fff, i);
     read(fff, element);
     edit4.text := systoutf8(element.name_file);
     label5.caption := systoUtf8(element.put);
     soobchenie('Выбран:', element.id3_inf.artist_id3 + ' - ' + element.id3_inf.name_id3, 400, true);
     edit1.Text := element.id3_inf.artist_id3;
     edit2.text := element.id3_inf.name_id3;
     edit3.Text := element.id3_inf.album_id3;
     checkBox1.Checked:=element.kopija;
     checkbox2.checked := element.muzika;
     filewav := element.put+element.name_file;
     filewavPChar:=PChar(filewav);
     vospr;
     play;
end;

procedure TForm11.Button1Click(Sender: TObject);
begin
    if b_open_baza then
    begin
         close_baza_r;
    end
    else
    begin
         open_baza_r;
    end;
end;

procedure TForm11.Button2Click(Sender: TObject);
begin
     seek(fff, i);
     element.id3_inf.artist_id3 := edit1.Text;
     element.id3_inf.name_id3 := edit2.text;
     element.id3_inf.album_id3 := edit3.Text;
     element.kopija := checkBox1.Checked;
     element.muzika := checkbox2.checked;
     write(fff, element);
end;

procedure TForm11.Button3Click(Sender: TObject);
begin
  add_files_to_trasc_list(element.put+element.name_file);
    //filewav := element.put+element.name_file;
    //filewavPChar:=PChar(filewav);
    //vospr;
    //play;
end;

procedure TForm11.FormClose(Sender: TObject{; var CloseAction: TCloseAction});
begin
      close_baza_r;
end;

end.

