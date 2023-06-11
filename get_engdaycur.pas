unit get_engdaycur;

interface

procedure BoxGetEngDayCur;
procedure ShowGetEngDayCur;

var
  mpdwEngDayCur:   array[0..3] of longword; 

implementation

uses SysUtils, support, soutput, progress, kernel, box, realz, timez, calendar, get_koeffs;

const
  quGetEngDayCur:  querys = (Action: acGetEngDayCur; cwOut: 2+2+2; cwIn: 1+16+2; bNumber: 0);

procedure QueryGetEngDayCur;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(5);
  PushByte($40);
  PushByte(0);
  Query(quGetEngDayCur, True);
end;

procedure BoxGetEngDayCur;
begin
  QueryGetEngDayCur;
end;

procedure ShowGetEngDayCur;
var
  dwT:  longword;
  i:    byte;
  s:    string;
begin
  Stop;
  InitPop(1);

  for i := 0 to 3 do begin
    dwT := PopByte*$10000 + PopByte*$1000000 + PopByte + PopByte*$100;
    if dwT = $FFFFFFFF then dwT := 0;
    mpdwEngDayCur[i] := dwT;
  end;  
  
  AddInfo('');
  AddInfo('');
  AddInfo('»мпульсы за текущие сутки');

  s := PackStrR('',GetColWidth);
  s := s + PackStrR('всего',GetColWidth);
  AddInfo(s);

  for i := 0 to 3 do begin
    s := PackStrR(GetCanalName(i),GetColWidth);
    s := s + PackStrR(IntToStr(mpdwEngDayCur[i]),GetColWidth);
    AddInfo(s);
  end;
    
  AddInfo('');
  AddInfo('Ёнерги€ за текущие сутки');

  s := PackStrR('',GetColWidth);
  s := s + PackStrR('всего',GetColWidth);
  AddInfo(s);

  for i := 0 to 3 do begin
    s := PackStrR(GetCanalName(i),GetColWidth);
    s := s + Reals2StrR(mpdwEngDayCur[i]*kE2);
    AddInfo(s);
  end;
    
  BoxRun;
end;

end.

