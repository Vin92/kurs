unit B_ID3V1;

interface

uses
SysUtils, Classes;

type

// some standard definition
PID3V1Rec = ^TID3V1Rec;
TID3V1Rec = packed record
Tag: array[0..2] of Char;
Title: array[0..29] of Char;
Artist: array[0..29] of Char;
Album: array[0..29] of Char;
Year: array[0..3] of Char;
Comment: array[0..29] of Char;
Genre: Byte;

end;

const
 //genre.
  cID3V1FGenre: array[0..160] of string = ('Blues', 'Classic Rock', 'Country', 'Dance', 'Disco', 'Funk',
  'Grunge',
  'Hip-Hop',
  'Jazz',
  'Metal',
  'New Age',
  'Oldies',
  'Other',
  'Pop',
  'R&B',
  'Rap',
  'Reggae',
  'Rock',
  'Techno',
  'Industrial',
  'Alternative',
  'Ska',
  'Death Metal',
  'Pranks',
  'Soundtrack',
  'Euro-Techno',
  'Ambient',
  'Trip-Hop',
  'Vocal',
  'Jazz+Funk',
  'Fusion',
  'Trance',
  'Classical',
  'Instrumental',
  'Acid',
  'House',
  'Game',
  'Sound Clip',
  'Gospel',
  'Noise',
  'AlternRock',
  'Bass',
  'Soul',
  'Punk',
  'Space',
  'Meditative',
  'Instrumental Pop',
  'Instrumental Rock',
  'Ethnic',
  'Gothic',
  'Darkwave',
  'Techno-Industrial',
  'Electronic',
  'Pop-Folk',
  'Eurodance',
  'Dream',
  'Southern Rock',
  'Comedy',
  'Cult',
  'Gangsta',
  'Top 40',
  'Christian Rap',
  'Pop/Funk',
  'Jungle',
  'Native American',
  'Cabaret',
  'New Wave',
  'Psychadelic',
  'Rave',
  'Showtunes',
  'Trailer',
  'Lo-Fi',
  'Tribal',
  'Acid Punk',
  'Acid Jazz',
  'Polka',
  'Retro',
  'Musical',
  'Rock & Roll',
  'Hard Rock',

  { WinAmp Genre Codes }
  'Folk',
  'Folk-Rock',
  'National Folk',
  'Swing',
  'Fast Fusion',
  'Bebob',
  'Latin',
  'Revival',
  'Celtic',
  'Bluegrass',
  'Avantgarde',
  'Gothic Rock',
  'Progessive Rock',
  'Psychedelic Rock',
  'Symphonic Rock',
  'Slow Rock',
  'Big Band',
  'Chorus',
  'Easy Listening',
  'Acoustic',
  'Humour',
  'Speech',
  'Chanson',
  'Opera',
  'Chamber Music',
  'Sonata',
  'Symphony',
  'Booty Bass',
  'Primus',
  'Porn Groove',
  'Satire',
  'Slow Jam',
  'Club',
  'Tango',
  'Samba',
  'Folklore',
  'Ballad',
  'Power Ballad',
  'Rhythmic Soul',
  'Freestyle',
  'Duet',
  'Punk Rock',
  'Drum Solo',
  'A capella',
  'Euro-House',
  'Dance Hall',
  'Неизвестный стиль',
  'Неизвестный стиль',
  'Неизвестный стиль',
  'Неизвестный стиль',
  'Неизвестный стиль',
  'Неизвестный стиль',
  'Неизвестный стиль',
  'Неизвестный стиль',
  'Неизвестный стиль',
  'Неизвестный стиль',
  'Неизвестный стиль',
  'Неизвестный стиль',
  'Неизвестный стиль',
  'Неизвестный стиль',
  'Неизвестный стиль',
  'Неизвестный стиль',
  'Неизвестный стиль',
  'Неизвестный стиль',
  'Неизвестный стиль',
  'Неизвестный стиль',
  'Неизвестный стиль',
  'Неизвестный стиль',
  'Неизвестный стиль',
  'Неизвестный стиль',
  'Неизвестный стиль',
  'Неизвестный стиль',
  'Неизвестный стиль',
  'Неизвестный стиль',//153

  'Неизвестный стиль',
  'Неизвестный стиль',
  'Неизвестный стиль',
  'Неизвестный стиль',
  'Неизвестный стиль',
  'Неизвестный стиль',
  '--No info--'); ////put yourself the kind of genre see tag3 list post before


function BASSID3ToID3V1Rec(PC: PChar): TID3V1Rec;

implementation 

function BASSID3ToID3V1Rec(PC: PChar): TID3V1Rec; 

var 
TempID3V1: TID3V1Rec; // only for a better checking 

begin 
// fill the record with some dummy chars 
FillChar(Result, SizeOf(TID3V1Rec) - 1, '?');
// check to see if ther's something to map 
if (PC = nil) then Exit; 
// convert/copy to the record structure 
TempID3V1 := PID3V1Rec(PC)^; 
// check to see if it's really a ID3V1 Tag 
// else just give the dummy record back 
if SameText(TempID3V1.Tag, 'TAG') then Result := TempID3V1;
end; 
end.
