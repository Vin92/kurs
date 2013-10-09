program player3_5;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, laz_synapse, Classes, player3_0u, interf, dvig, interf2, interf3,
  interf4, scaner_vPlayer, progress_p, U_settings, search_drive, iinterf7,
  interf8, interf9, interf10, interf11, interf12;

{$R *.res}
//{$R manifest.rc}
//var
  //zn_timer1, zn_timer2, zn_timer3, zn_timer4:integer;
begin
  Application.Initialize;
  Application.CreateForm(Tvplayer, vplayer);
  Application.CreateForm(TForm10, Form10);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm6, Form6);
  Application.CreateForm(TForm7, Form7);
  Application.CreateForm(TForm8, Form8);
  Application.CreateForm(TForm9, Form9);
  Application.CreateForm(TForm11, Form11);
  Application.CreateForm(TForm12, Form12);
  Application.Run;
end.

