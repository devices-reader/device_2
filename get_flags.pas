unit get_flags;

interface

procedure BoxGetFlags;
procedure ShowGetFlags;

implementation

uses SysUtils, support, soutput, timez, box;

const
  quGetFlags:  querys = (Action: acGetFlags; cwOut: 3+0+2; cwIn: 1+2+2; bNumber: 0);

procedure QueryGetFlags;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(8);
  PushByte(9);
  Query(quGetFlags, True);
end;

procedure BoxGetFlags;
begin
  AddInfo('');
  AddInfo('');
  AddInfo('Конфигурация');
  QueryGetFlags;
end;

procedure ShowGetFlags;
var 
  i,j:  byte;
  s:    string;
begin
  Stop;
  InitPop(1);

  i := PopByte;
  j := PopByte;
  
  AddInfo('флаги: 0x' + IntToHex(i,2) + ' 0x' + IntToHex(j,2));
  
  if j and $08 = 0 then s := '0, да' else s := '1, нет';
  AddInfo('флаг 0x'+IntToHex(j,2)+'.3 = ' + s + ' - автоматическому переходу на летнее/зимнее время');

  BoxRun;  
end;

end.
