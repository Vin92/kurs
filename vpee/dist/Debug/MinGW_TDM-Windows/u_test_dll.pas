unit u_test_dll;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

const extern_dll='libvpee.dll';

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
    procedure RadioButton3Change(Sender: TObject);
    procedure RadioButton4Change(Sender: TObject);
    procedure RadioButton5Change(Sender: TObject);
    procedure RadioButton6Change(Sender: TObject);
    procedure RadioButton7Change(Sender: TObject);
    procedure RadioButton8Change(Sender: TObject);
    procedure RadioButton9Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  i:byte;

function vpee_get_version(): string; stdcall; external extern_dll;
function vpee_init(): byte; stdcall; external extern_dll;
function GET_VERS(d:byte): string; stdcall; external extern_dll;
function GET_DLL_NAME(d:byte): string; stdcall; external extern_dll;
function EXECUTE(zn0:PChar;d:byte): string; stdcall; external extern_dll;
function EXECUTE1(zn0:PChar;d:byte): string; stdcall; external extern_dll;
function LOAD_LIB(zn0:PChar;d:byte): byte; stdcall; external extern_dll;
function FREE_LIB(d:byte): byte; stdcall; external extern_dll;
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


{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
     vpee_init();
     label1.Caption:='Версия основной DLL: ' + pchar_to_str(vpee_get_version());
end;

procedure TForm1.RadioButton1Change(Sender: TObject);
begin
      i:=0;
end;

procedure TForm1.RadioButton2Change(Sender: TObject);
begin
      i:=1;
end;

procedure TForm1.RadioButton3Change(Sender: TObject);
begin
      i:=2;
end;

procedure TForm1.RadioButton4Change(Sender: TObject);
begin
      i:=3;
end;

procedure TForm1.RadioButton5Change(Sender: TObject);
begin
      i:=4;
end;

procedure TForm1.RadioButton6Change(Sender: TObject);
begin
      i:=5;
end;

procedure TForm1.RadioButton7Change(Sender: TObject);
begin
      i:=6;
end;

procedure TForm1.RadioButton8Change(Sender: TObject);
begin
      i:=7;
end;

procedure TForm1.RadioButton9Change(Sender: TObject);
begin
      i:=8;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
     label2.Caption:=inttostr(LOAD_LIB(PChar(form1.Edit1.Text),i));  //'C:\Users\user\Desktop\Pascal\player3_5_x64\test_dll\dist\Debug\MinGW_TDM-Windows\libtest_dll.dll'
     //C:\Users\user\Desktop\Pascal\player3_5_x64\ID3_tags\dist\Debug\MinGW_TDM-Windows\libID3_tags.dll
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
     label6.Caption:=inttostr(FREE_LIB(i));
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
     label7.Caption:=pchar_to_str(GET_DLL_NAME(i));
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
     label3.Caption:=pchar_to_str(GET_VERS(i));
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     label4.Caption:=pchar_to_str(EXECUTE(PChar(utf8tosys(form1.Edit2.Text)),i));
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
     label5.Caption:=pchar_to_str(EXECUTE1(PChar(form1.Edit3.Text),i));
end;

end.

