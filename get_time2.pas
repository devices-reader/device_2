unit get_time2;

interface

procedure BoxGetTime2;
procedure ShowGetTime2;

implementation

uses SysUtils, support, soutput, timez, box, get_open2, setup2, get_flags2;

const
  quGetTime2:  querys = (Action: acGetTime2; cwOut: 3+0+2; cwIn: 1+8+2; bNumber: 0);

procedure QueryGetTime2;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(4);
  PushByte(0);
  Query(quGetTime2, True);
end;

procedure BoxGetTime2;
begin
  AddInfo('');
  AddInfo('');
  AddInfo('Время');
  QueryGetTime2;
end;

procedure ShowGetTime2;
var
  tiT:  times;
  i:    byte;
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
    bSeason := PopByte;    
  end;

  tiCurr := tiT;

  AddInfo('время счетчика:   ' + Times2Str(tiT));
  AddInfo('день недели:      ' + GetWeekdayName(i));
  AddInfo('сезонное время:   ' + GetSeasonName(bSeason));
  AddInfo('');
  AddInfo('время компьютера: ' + Times2Str(ToTimes(Now)));
  AddInfo('разница:          ' + DeltaTimes2Str(tiT));

  BoxGetFlags2;
end;

end.
