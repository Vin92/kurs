unit search_drive;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, windows;
function ssss(i:integer):string;
implementation

function ssss(i:integer):string;
var    C: string;
    DType: Integer;
    //DriveString: string;
begin
     { Loop from A..Z to determine available drives }

                C := chr(i) + ':\';
                DType := GetDriveType(PChar(C));
                case DType of
                {0: DriveString := C + ' The drive type cannot be determined.';
                1: DriveString := C + ' The root directory does not exist.';
                DRIVE_REMOVABLE: DriveString :=
                                 C + ' The drive can be removed from the drive.';
                DRIVE_FIXED: DriveString :=
                             C + ' The disk cannot be removed from the drive.';
                DRIVE_REMOTE: DriveString :=
                              C + ' The drive is a remote (network) drive.';
                DRIVE_CDROM: DriveString := C + ' The drive is a CD-ROM drive.';}
                //DRIVE_RAMDISK: DriveString := C + ' The drive is a RAM disk.';
                DRIVE_FIXED:
                              begin
                                 ssss:=c;
                              end;
                else ssss:='err';
                end;
                // Only add drive types that can be determined.
                {if not ((DType = 0) or (DType = 1)) then
                //lbDrives.Items.AddObject(DriveString, Pointer(i));
                sttext := 'Диск: ' + c ;
                Synchronize(@Showstatus);
                end; }
end;
end.

