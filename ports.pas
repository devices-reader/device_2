unit ports;

interface

uses Classes, SysUtils;

function GetBaudSize(i: byte): longword;
function GetParityName(i: byte): string;

procedure LoadCmbBauds(Strings: TStrings);
procedure LoadCmbParitys(Strings: TStrings);

const
  BAUDS     = 9;
  PARITYS   = 5;

implementation

function GetBaudSize(i: byte): longword;
const
  mpdwBauds:    array[0..BAUDS-1] of longword =
  (300,600,1200,2400,4800,9600,19200,38400,57600);
begin
  Result := mpdwBauds[i];
end;

function GetParityName(i: byte): string;
const
  mpstParitys:  array[0..PARITYS-1] of string =
  ('none','even','odd','mark','space');
begin
  Result := mpstParitys[i];
end;

procedure LoadCmbBauds(Strings: TStrings);
var
  i:  word;
begin
  with Strings do begin
    Clear;
    for i := 0 to BAUDS-1 do Append(IntToStr(GetBaudSize(i)));
  end;
end;

procedure LoadCmbParitys(Strings: TStrings);
var
  i:  word;
begin
  with Strings do begin
    Clear;
    for i := 0 to PARITYS-1 do Append(GetParityName(i));
  end;
end;

end.
