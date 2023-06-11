unit get_summer;

interface

procedure BoxGetSummer;
procedure ShowGetSummer;

implementation

uses SysUtils, support, soutput, timez, box;

const
  quGetSummer:  querys = (Action: acGetSummer; cwOut: 3+0+2; cwIn: 1+6+2; bNumber: 0);

procedure QueryGetSummer;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(8);
  PushByte(7);
  Query(quGetSummer, True);
end;

procedure BoxGetSummer;
begin
  AddInfo('');
  AddInfo('');
  AddInfo('¬рем€ переходов на летнее/зимнее врем€');
  QueryGetSummer;
end;

procedure ShowGetSummer;
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
  
  BoxRun;
end;

end.
