unit get_setup2;

interface

procedure BoxGetSetup2;
procedure ShowGetSetup2;

implementation

uses SysUtils, support, soutput, timez, box, get_open2, setup2;

const
  quGetSetup2:  querys = (Action: acGetSetup2; cwOut: 3+8+2; cwIn: 1+1+2; bNumber: 0);

procedure QueryGetSetup2;
var
  ti: TDateTime;
  Year,Mon,Day,Hour,Min,Sec,MSec: word;
  i:  byte;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(12);

  ti := Now;
  DecodeTime(ti, Hour,Min,Sec,MSec);
  DecodeDate(ti, Year,Mon,Day);

  i := DayOfWeek(Now);
  case i of
    1: i := 7;
    2: i := 1;
    3: i := 2;
    4: i := 3;
    5: i := 4;
    6: i := 5;
    7: i := 6;
  end;
  
  PushByte(ToBCD(Sec));
  PushByte(ToBCD(Min));
  PushByte(ToBCD(Hour));
  PushByte(i);
  PushByte(ToBCD(Day));
  PushByte(ToBCD(Mon));
  PushByte(ToBCD(Year mod 100));
  PushByte(bSeason);

  AddInfo('время установки:  ' + Times2Str(ToTimes(ti)));
  AddInfo('день недели:      ' + GetWeekdayName(i));
  AddInfo('сезонное время:   ' + GetSeasonName(bSeason));
  
  Query(quGetSetup2, True);
end;

procedure BoxGetSetup2;
begin
  AddInfo('');
  AddInfo('');
  AddInfo('Установка времени');
  QueryGetSetup2;
end;

procedure ShowGetSetup2;
var
  i:    byte;
begin
  Stop;
  InitPop(1);

  i := PopByte;
  if i = 0 then
    InfBox('Установка времени - проведена успешно')
  else begin
    WrnBox('Ошибка установки времени - код '+IntToHex(i,2));  
  end;  
end;

end.

