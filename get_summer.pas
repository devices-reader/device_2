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
  AddInfo('����� ��������� �� ������/������ �����');
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
  AddInfo('������� �� ������ �����');
  AddInfo('���:              ' + IntToStr(a));
  AddInfo('���� ������:      ' + GetWeekdayName(b));
  AddInfo('�����:            ' + IntToStr(c));
  
  a := FromBCD(PopByte);
  b := FromBCD(PopByte);
  c := FromBCD(PopByte);
  
  AddInfo('');
  AddInfo('������� �� ������ �����');
  AddInfo('���:              ' + IntToStr(a));
  AddInfo('���� ������:      ' + GetWeekdayName(b));
  AddInfo('�����:            ' + IntToStr(c));
  
  BoxRun;
end;

end.
