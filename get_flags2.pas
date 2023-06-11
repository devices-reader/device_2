unit get_flags2;

interface

procedure BoxGetFlags2;
procedure ShowGetFlags2;

implementation

uses SysUtils, support, soutput, timez, box, get_summer2;

const
  quGetFlags2:  querys = (Action: acGetFlags2; cwOut: 3+0+2; cwIn: 1+2+2; bNumber: 0);

procedure QueryGetFlags2;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(8);
  PushByte(9);
  Query(quGetFlags2, True);
end;

procedure BoxGetFlags2;
begin
  AddInfo('');
  AddInfo('');
  AddInfo('Конфигурация');
  QueryGetFlags2;
end;

procedure ShowGetFlags2;
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
  
  BoxGetSummer2;
end;

end.
