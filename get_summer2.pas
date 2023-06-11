unit get_summer2;

interface

procedure BoxGetSummer2;
procedure ShowGetSummer2;

implementation

uses SysUtils, support, soutput, timez, box;

const
  quGetSummer2:  querys = (Action: acGetSummer2; cwOut: 3+0+2; cwIn: 1+6+2; bNumber: 0);

procedure QueryGetSummer2;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(8);
  PushByte(7);
  Query(quGetSummer2, True);
end;

procedure BoxGetSummer2;
begin
  AddInfo('');
  AddInfo('');
  AddInfo('¬рем€ переходов на летнее/зимнее врем€');
  QueryGetSummer2;
end;

procedure ShowGetSummer2;
var
  a,b,c:  byte;
begin
  Stop;
  InitPop(1);

  a := FromBCD(PopByte);
  b := FromBCD(PopByte);
  c := FromBCD(PopByte);
  
  AddInfo('');
  AddInfo('ѕереход на летнее врем€');
  AddInfo('час:              ' + IntToStr(a));
  AddInfo('день недели:      ' + GetWeekdayName(b));
  AddInfo('мес€ц:            ' + IntToStr(c));
  
  a := FromBCD(PopByte);
  b := FromBCD(PopByte);
  c := FromBCD(PopByte);
  
  AddInfo('');
  AddInfo('ѕереход на зимнее врем€');
  AddInfo('час:              ' + IntToStr(a));
  AddInfo('день недели:      ' + GetWeekdayName(b));
  AddInfo('мес€ц:            ' + IntToStr(c));

  AddInfo('');
  AddInfo('„тение времени - проведено успешно');
end;

end.
