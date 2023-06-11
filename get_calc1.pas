unit get_calc1;

interface

procedure BoxGetCalc1;
procedure ShowGetCalc1;

implementation

uses SysUtils, support, soutput, realz, box, get_koeffs, get_engabstar, get_engdaycurtar;

const
  quGetCalc1:  querys = (Action: acGetCalc1; cwOut: 3+0+2; cwIn: 1+8+2; bNumber: 0);

procedure QueryGetCalc1;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(4);
  PushByte(0);
  Query(quGetCalc1, True);
end;

procedure BoxGetCalc1;
begin
  QueryGetCalc1;
end;

procedure ShowGetCalc1;
var
  dwA,dwB:  longword;
  s:    string;
  i,j:  byte;
begin
  Stop;

  AddInfo('');
  AddInfo('');
  AddInfo('»мпульсы на начало текущих суток (по тарифам) - расчет');

  s := PackStrR('',GetColWidth);
  for j := 1 to 4 do s := s + PackStrR('тариф '+IntToStr(j),GetColWidth);
  s := s + PackStrR('всего',GetColWidth);
  AddInfo(s);

  for i := 0 to 3 do begin
    s := PackStrR(GetCanalName(i),GetColWidth);
    dwB := 0;
    for j := 1 to 4 do begin
      dwA := mpdwEngAbsTar[i][j] - mpdwEngDayCurTar[i][j];
      Inc(dwB,dwA);
      s := s + PackStrR(IntToStr(dwA),GetColWidth);
    end;
    s := s + PackStrR(IntToStr(dwB),GetColWidth);
    AddInfo(s);
  end;
    
  AddInfo('');
  AddInfo('—четчики на начало текущих суток (по тарифам) - расчет');

  s := PackStrR('',GetColWidth);
  for j := 1 to 4 do s := s + PackStrR('тариф '+IntToStr(j),GetColWidth);
  s := s + PackStrR('всего',GetColWidth);
  AddInfo(s);

  for i := 0 to 3 do begin
    dwB := 0;
    s := PackStrR(GetCanalName(i),GetColWidth);
    for j := 1 to 4 do begin
      dwA := mpdwEngAbsTar[i][j] - mpdwEngDayCurTar[i][j];
      Inc(dwB,dwA);
      s := s + Reals2StrR(dwA*kE2);
    end;  
    s := s + Reals2StrR(dwB*kE2);
    AddInfo(s);
  end;
  
  BoxRun;
end;

end.
