unit U_settings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, StdCtrls, Buttons, player3_0u, bass;

type

  { TForm6 }

  TForm6 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Button1: TButton;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Image1: TImage;
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
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    TrackBar1: TTrackBar;
    TrackBar10: TTrackBar;
    TrackBar11: TTrackBar;
    TrackBar2: TTrackBar;
    TrackBar3: TTrackBar;
    TrackBar4: TTrackBar;
    TrackBar5: TTrackBar;
    TrackBar6: TTrackBar;
    TrackBar7: TTrackBar;
    TrackBar8: TTrackBar;
    TrackBar9: TTrackBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure TrackBar10Change(Sender: TObject);
    procedure TrackBar11Change(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure TrackBar3Change(Sender: TObject);
    procedure TrackBar4Change(Sender: TObject);
    procedure TrackBar5Change(Sender: TObject);
    procedure TrackBar6Change(Sender: TObject);
    procedure TrackBar7Change(Sender: TObject);
    procedure TrackBar8Change(Sender: TObject);
    procedure TrackBar9Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form6: TForm6; 

implementation

{$R *.lfm}

{ TForm6 }

procedure TForm6.TrackBar1Change(Sender: TObject);
begin
   form6.label2.caption := inttostr(eq_yatanowka_znachenij(1, Form6.TrackBar1.position));
end;

procedure TForm6.TrackBar10Change(Sender: TObject);
begin
   form6.label11.caption :=inttostr(eq_yatanowka_znachenij(10,  Form6.TrackBar10.position));
end;

procedure TForm6.TrackBar11Change(Sender: TObject);
begin
  form6.label12.Caption := 'Громкость: ' + inttostr(round(set_vol(Form6.TrackBar11.position / 100)));
end;

procedure TForm6.FormCreate(Sender: TObject);
begin
  Form6.TrackBar1.position := fx1[1]*(-1);
  Form6.TrackBar2.position := fx1[2]*(-1);
  Form6.TrackBar3.position := fx1[3]*(-1);
  Form6.TrackBar4.position := fx1[4]*(-1);
  Form6.TrackBar5.position := fx1[5]*(-1);
  Form6.TrackBar6.position := fx1[6]*(-1);
  Form6.TrackBar7.position := fx1[7]*(-1);
  Form6.TrackBar8.position := fx1[8]*(-1);
  Form6.TrackBar9.position := fx1[9]*(-1);
  Form6.TrackBar10.position := fx1[10]*(-1);
  form6.label2.caption := inttostr(fx1[1]);
  form6.label3.caption := inttostr(fx1[2]);
  form6.label4.caption := inttostr(fx1[3]);
  form6.label5.caption := inttostr(fx1[4]);
  form6.label6.caption := inttostr(fx1[5]);
  form6.label7.caption := inttostr(fx1[6]);
  form6.label8.caption := inttostr(fx1[7]);
  form6.label9.caption := inttostr(fx1[8]);
  form6.label10.caption := inttostr(fx1[9]);
  form6.label11.caption := inttostr(fx1[10]);
  Form6.TrackBar11.position := round(vol * 100);
  form6.label12.Caption := 'Громкость: ' + inttostr(round(vol * 100));
  form6.CheckBox1.Checked:=cv;
end;

procedure TForm6.Label1Click(Sender: TObject);
begin

end;

procedure TForm6.BitBtn1Click(Sender: TObject); //закрытие настроек
begin
   form6.visible := false;
   //saveconf; //тут нужно будет покапаться позднее
end;

procedure TForm6.BitBtn2Click(Sender: TObject);//реинициализация настроек
var hz:dword;
begin
    case form6.combobox1.itemIndex of
    1:hz:=96000;
    2:hz:=48000;
    3:hz:=44100;
    4:hz:=32000;
    5:hz:=22050;
    6:hz:=16000;
    7:hz:=11025;
    8:hz:=8000;
    else hz:=48000;
    end;
    //BASS_Init({strToInt(form6.Edit1.text)}-1, 44100, 0, potok, nil);
    reinit(0,hz);
    reinit(strToInt(form6.Edit1.text),hz);
    //plLoad;
end;

procedure TForm6.Button1Click(Sender: TObject);
begin
  vplayer.top:=30;
end;

procedure TForm6.CheckBox1Change(Sender: TObject);
begin
     //if cv then
     //begin
       //cv:=false;
     //end
     //else
       //cv:=true;
     cv := form6.CheckBox1.Checked;
end;

procedure TForm6.TrackBar2Change(Sender: TObject);
begin
    form6.label3.caption := inttostr(eq_yatanowka_znachenij(2,  Form6.TrackBar2.position));
end;

procedure TForm6.TrackBar3Change(Sender: TObject);
begin
    form6.label4.caption := inttostr(eq_yatanowka_znachenij(3,  Form6.TrackBar3.position));
end;

procedure TForm6.TrackBar4Change(Sender: TObject);
begin
   form6.label5.caption := inttostr(eq_yatanowka_znachenij(4,  Form6.TrackBar4.position));
end;

procedure TForm6.TrackBar5Change(Sender: TObject);
begin
    form6.label6.caption := inttostr(eq_yatanowka_znachenij(5,  Form6.TrackBar5.position));
end;

procedure TForm6.TrackBar6Change(Sender: TObject);
begin
   form6.label7.caption := inttostr(eq_yatanowka_znachenij(6,  Form6.TrackBar6.position));
end;

procedure TForm6.TrackBar7Change(Sender: TObject);
begin
   form6.label8.caption := inttostr(eq_yatanowka_znachenij(7,  Form6.TrackBar7.position));
end;

procedure TForm6.TrackBar8Change(Sender: TObject);
begin
   form6.label9.caption := inttostr(eq_yatanowka_znachenij(8,  Form6.TrackBar8.position));
end;

procedure TForm6.TrackBar9Change(Sender: TObject);
begin
   form6.label10.caption := inttostr(eq_yatanowka_znachenij(9,  Form6.TrackBar9.position));
end;

end.

