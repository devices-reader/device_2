unit get_time;

interface

procedure BoxGetTime;
procedure ShowGetTime;

implementation

uses SysUtils, support, soutput, timez, box;

const
  quGetTime:  querys = (Action: acGetTime; cwOut: 3+0+2; cwIn: 1+8+2; bNumber: 0);

procedure QueryGetTime;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(4);
  PushByte(0);
  Query(quGetTime, True);
end;

procedure BoxGetTime;
begin
  AddInfo('');
  AddInfo('');
  AddInfo('�����');
  QueryGetTime;
end;

procedure ShowGetTime;
var
  tiT:  times;
  i,j:  byte;
begin
  Stop;
  InitPop(1);

  with tiT do begin
    bSecond := FromBCD(PopByte);
    bMinute := FromBCD(PopByte);
    bHour   := FromBCD(PopByte);
    i       := PopByte;
    bDay    := FromBCD(PopByte);
    bMonth  := FromBCD(PopByte);
    bYear   := FromBCD(PopByte);
    j       := PopByte;    
  end;

  tiCurr := tiT;

  AddInfo('����� ��������:   ' + Times2Str(tiT));
  AddInfo('���� ������:      ' + GetWeekdayName(i));
  AddInfo('�������� �����:   ' + GetSeasonName(j));
  AddInfo('');
  AddInfo('����� ����������: ' + Times2Str(ToTimes(Now)));
  AddInfo('�������:          ' + DeltaTimes2Str(tiT));

  BoxRun;
end;

end.
