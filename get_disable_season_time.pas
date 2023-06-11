unit get_disable_season_time;

interface

procedure BoxGetDisableSeasonTime;
procedure ShowGetDisableSeasonTime;

implementation

uses SysUtils, support, soutput, timez, box, get_open2;

const
  quGetDisableSeasonTime:  querys = (Action: acGetDisableSeasonTime; cwOut: 3+1+2; cwIn: 1+1+2; bNumber: 0);

procedure QueryGetDisableSeasonTime;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte($18);
  PushByte(1);
  Query(quGetDisableSeasonTime, True);
end;

procedure BoxGetDisableSeasonTime;
begin
  AddInfo('');
  AddInfo('');
  AddInfo('������ �������� �� ������/������ �����');
  QueryGetDisableSeasonTime;
end;

procedure ShowGetDisableSeasonTime;
var
  i:    byte;
begin
  Stop;
  InitPop(1);

  i := PopByte;
  if i = 0 then 
    InfBox('������ �������� �� ������/������ ����� - ��������� �������')
  else
    WrnBox('������ �������� - ��� '+IntToHex(i,2));
end;

end.
