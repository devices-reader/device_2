unit get_engmontar;

interface

procedure BoxGetEngMonTar;
procedure ShowGetEngMonTar;

var
  mpdwEngMonTar:   array[0..3,0..4] of longword; 

implementation

uses SysUtils, support, soutput, progress, box, realz, get_koeffs;

const
  quGetEngMonTar: querys = (Action: acGetEngMonTar; cwOut: 2+2+2; cwIn: 1+16+2; bNumber: 0);

var
  bMon,bTar:      byte;

procedure QueryGetEngMonTar;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(5);
  PushByte($30 or bMon);
  PushByte(bTar);
  Query(quGetEngMonTar, True);
end;

procedure ClearGetEngMonTar;
var
  i:  byte;
begin
  for i := 0 to 3 do
    mpdwEngMonTar[i][0] := 0;
end;

procedure BoxGetEngMonTar;
begin
  ClearGetEngMonTar;
  
  bMon := 1;
  bTar := 1;
  QueryGetEngMonTar;
end;

procedure ShowGetEngMonTar;
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
    mpdwEngMonTar[i][bTar] := dwT;
    Inc(mpdwEngMonTar[i][0], mpdwEngMonTar[i][bTar]);
  end;  

  ShowProgress(bMon*4+bTar-1,12*4);
  
  Inc(bTar);
  if (bTar <= 4) then
    QueryGetEngMonTar
  else begin  
    AddInfo('');
    AddInfo('');
    AddInfo('Импульсы по месяцам (по тарифам): '+IntToStr(bMon));

    s := PackStrR('',GetColWidth);
    for j := 1 to 4 do s := s + PackStrR('тариф '+IntToStr(j),GetColWidth);
    s := s + PackStrR('всего',GetColWidth);
    AddInfo(s);

    for i := 0 to 3 do begin
      s := PackStrR(GetCanalName(i),GetColWidth);
      for j := 1 to 4 do s := s + PackStrR(IntToStr(mpdwEngMonTar[i][j]),GetColWidth);
      s := s + PackStrR(IntToStr(mpdwEngMonTar[i][0]),GetColWidth);
      AddInfo(s);
    end;
    
    AddInfo('');
    AddInfo('Энергия по месяцам (по тарифам): '+IntToStr(bMon));

    s := PackStrR('',GetColWidth);
    for j := 1 to 4 do s := s + PackStrR('тариф '+IntToStr(j),GetColWidth);
    s := s + PackStrR('всего',GetColWidth);
    AddInfo(s);

    for i := 0 to 3 do begin
      s := PackStrR(GetCanalName(i),GetColWidth);
      for j := 1 to 4 do s := s + Reals2StrR(mpdwEngMonTar[i][j]*kE2);
      s := s + Reals2StrR(mpdwEngMonTar[i][0]*kE2);
      AddInfo(s);
    end;
  
    bTar := 1;
    Inc(bMon);
    if (bMon <= 12) then begin
      ClearGetEngMonTar;
      QueryGetEngMonTar;
    end  
    else     
      BoxRun;
  end;    
end;

end.

