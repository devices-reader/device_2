unit get_enable_season_time;

interface

procedure BoxGetEnableSeasonTime;
procedure ShowGetEnableSeasonTime;

implementation

uses SysUtils, support, soutput, timez, box, get_open2;

const
  quGetEnableSeasonTime:  querys = (Action: acGetEnableSeasonTime; cwOut: 3+1+2; cwIn: 1+1+2; bNumber: 0);

procedure QueryGetEnableSeasonTime;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte($18);
  PushByte(0);
  Query(quGetEnableSeasonTime, True);
end;

procedure BoxGetEnableSeasonTime;
begin
  AddInfo('');
  AddInfo('');
  AddInfo('Разрешение перехода на летнее/зимнее время');
  QueryGetEnableSeasonTime;
end;

procedure ShowGetEnableSeasonTime;
var
  i:    byte;
begin
  Stop;
  InitPop(1);

  i := PopByte;
  if i = 0 then
    InfBox('Разрешение перехода на летнее/зимнее время - проведено успешно')
  else
    WrnBox('Ошибка операции - код '+IntToHex(i,2));
end;

end.
