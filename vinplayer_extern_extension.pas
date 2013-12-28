unit vinplayer_extern_extension;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

var
  count_load_dlls:byte=0;

const extern_dll='libvpee.dll';

      function vpee_get_version(): PChar; stdcall; external extern_dll;
      function vpee_init(): byte; stdcall; external extern_dll;
      function GET_VERS(d:byte): PChar; stdcall; external extern_dll;
      function GET_DLL_NAME(d:byte): PChar; stdcall; external extern_dll;
      function EXECUTE(zn0:PChar;d:byte): PChar; stdcall; external extern_dll;
      function EXECUTE1(zn0:PChar;d:byte): PChar; stdcall; external extern_dll;
      function LOAD_LIB(zn0:PChar;d:byte): byte; stdcall; external extern_dll;
      function FREE_LIB(d:byte): byte; stdcall; external extern_dll;

implementation

end.

