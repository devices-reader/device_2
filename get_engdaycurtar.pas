unit get_engdaycurtar;

interface

procedure BoxGetEngDayCurTar;
procedure ShowGetEngDayCurTar;

var
  mpdwEngDayCurTar:   array[0..3,0..4] of longword; 

implementation

uses SysUtils, support, soutput, progress, box, realz, get_koeffs;

const
  quGetEngDayCurTar:  querys = (Action: acGetEngDayCurTar; cwOut: 2+2+2; cwIn: 1+16+2; bNumber: 0);

var
  bTar:            byte;

procedure QueryGetEngDayCurTar;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(5);
  PushByte($40);
  PushByte(bTar);
  Query(quGetEngDayCurTar, True);
end;

procedure ClearGetEngDayCurTar;
var
  i:  byte;
begin
  for i := 0 to 3 do
    mpdwEngDayCurTar[i][0] := 0;
end;

procedure BoxGetEngDayCurTar;
begin
  ClearGetEngDayCurTar;
  
  bTar := 1;
  QueryGetEngDayCurTar;
end;

procedure ShowGetEngDayCurTar;
var
  dwT:  longword;
  i,j:  byte;
  s:    string;
begin
  Stop;
  InitPop(1);

  for i := 0 to 3 do begin
    dwT := PopByte*$10000 + PopByte*$1000000 + PopByte + PopByte*$100;
    if dwT = $FFFFFFFF then dwT := 0;
    mpdwEngDayCurTar[i][bTar] := dwT;
    Inc(mpdwEngDayCurTar[i][0], mpdwEngDayCurTar[i][bTar]);
  end;  

  ShowProgress(bTar-1,4);
  
  Inc(bTar);
  if (bTar <= 4) then
    QueryGetEngDayCurTar
  else begin  
    AddInfo('');
    AddInfo('');
    AddInfo('Импульсы за текущие сутки (по тарифам)');

    s := PackStrR('',GetColWidth);
    for j := 1 to 4 do s := s + PackStrR('тариф '+IntToStr(j),GetColWidth);
    s := s + PackStrR('всего',GetColWidth);
    AddInfo(s);

    for i := 0 to 3 do begin
      s := PackStrR(GetCanalName(i),GetColWidth);
      for j := 1 to 4 do s := s + PackStrR(IntToStr(mpdwEngDayCurTar[i][j]),GetColWidth);
      s := s + PackStrR(IntToStr(mpdwEngDayCurTar[i][0]),GetColWidth);
      AddInfo(s);
    end;
    
    AddInfo('');
    AddInfo('Энергия за текущие сутки (по тарифам)');

    s := PackStrR('',GetColWidth);
    for j := 1 to 4 do s := s + PackStrR('тариф '+IntToStr(j),GetColWidth);
    s := s + PackStrR('всего',GetColWidth);
    AddInfo(s);

    for i := 0 to 3 do begin
      s := PackStrR(GetCanalName(i),GetColWidth);
      for j := 1 to 4 do s := s + Reals2StrR(mpdwEngDayCurTar[i][j]*kE2);
      s := s + Reals2StrR(mpdwEngDayCurTar[i][0]*kE2);
      AddInfo(s);
    end;
    
    BoxRun;
  end;    
end;

end.

