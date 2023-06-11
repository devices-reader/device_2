unit get_calc2;

interface

procedure BoxGetCalc2;
procedure ShowGetCalc2;

implementation

uses SysUtils, support, soutput, box, kernel, realz, timez, calendar, get_koeffs, get_engabs, get_engdaycur, get_engmon;

const
  quGetCalc2:  querys = (Action: acGetCalc2; cwOut: 3+0+2; cwIn: 1+8+2; bNumber: 0);

procedure QueryGetCalc2;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(4);
  PushByte(0);
  Query(quGetCalc2, True);
end;

procedure BoxGetCalc2;
begin
  QueryGetCalc2;
end;

function GetCalc2(i: byte; j: byte): longword;
var
  a,b,c:  byte;
begin
  a := ((12+tiCurr.bMonth-j) mod 12)+1;
  if a = 1 then 
    Result := mpdwEngAbs[i] - mpdwEngDayCur[i]
  else begin
    Result := mpdwEngAbs[i];
    b := a - 1; 
    for c := 1 to b do Result := Result - mpdwEngMon[i, ((12+tiCurr.bMonth-c) mod 12)+1]; 
  end;
end;

procedure ShowGetCalc2;
var
  i,j:  byte;
  s:    string;
begin
  Stop;

  AddInfo('');
  AddInfo('');
  AddInfo('»мпульсы по мес€цам - расчет');

  s := PackStrR('',GetColWidth);
  for j := 1 to 12 do s := s + PackStrR(Times2StrMon(MonIndexToDate(DateToMonIndex(tiCurr)-((12+tiCurr.bMonth-j) mod 12))),GetColWidth);
  AddInfo(s);    
  s := PackStrR('',GetColWidth);
  for j := 1 to 12 do s := s + PackStrR('мес€ц '+IntToStr(j),GetColWidth);
  AddInfo(s);

  for i := 0 to 3 do begin
    s := PackStrR(GetCanalName(i),GetColWidth);
      for j := 1 to MONTHS do s := s + PackStrR(IntToStr(GetCalc2(i,j)),GetColWidth);
    AddInfo(s);
  end;  
  
  AddInfo('');
  AddInfo('—четчики по мес€цам - расчет');

  s := PackStrR('',GetColWidth);
  for j := 1 to 12 do s := s + PackStrR(Times2StrMon(MonIndexToDate(DateToMonIndex(tiCurr)-((12+tiCurr.bMonth-j) mod 12))),GetColWidth);
  AddInfo(s);    
  s := PackStrR('',GetColWidth);
  for j := 1 to 12 do s := s + PackStrR('мес€ц '+IntToStr(j),GetColWidth);
  AddInfo(s);

  for i := 0 to 3 do begin
    s := PackStrR(GetCanalName(i),GetColWidth);
      for j := 1 to MONTHS do s := s + Reals2StrR(GetCalc2(i,j)*kE2);
    AddInfo(s);
  end;  

  AddInfo('');
  AddInfo('* счетчики за текущий мес€ц - на начало текущих суток, счетчики по остальным мес€цам - на конец мес€ца');
  
  BoxRun;
end;

end.
