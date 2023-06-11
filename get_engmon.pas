unit get_engmon;

interface

uses kernel;

procedure BoxGetEngMon;
procedure ShowGetEngMon;

var
  mpdwEngMon:   array[0..3,1..MONTHS] of longword; 
  mpfEngMon:    array[0..3,1..MONTHS] of boolean; 

implementation

uses SysUtils, support, soutput, progress, box, realz, timez, calendar, get_koeffs;

const
  quGetEngMon:  querys = (Action: acGetEngMon; cwOut: 2+2+2; cwIn: 1+16+2; bNumber: 0);

var
  bMon:         byte;

procedure QueryGetEngMon;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(5);
  PushByte($30 or bMon);
  PushByte(0);
  Query(quGetEngMon, True);
end;

procedure BoxGetEngMon;
var
  i,j:  byte;
begin
  for i := 0 to 3 do 
    for j := 1 to MONTHS do begin
      mpdwEngMon[i][j] := 0;
      mpfEngMon[i][j] := False;
    end;

  bMon := 1;
  QueryGetEngMon;
end;

procedure ShowGetEngMon;
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
    mpdwEngMon[i][bMon] := dwT;
    mpfEngMon[i][bMon] := True;
  end;  

  ShowProgress(bMon-1,MONTHS);
  
  Inc(bMon);
  if (bMon <= MONTHS) then
    QueryGetEngMon
  else begin  
    AddInfo('');
    AddInfo('');
    AddInfo('»мпульсы по мес€цам');

    s := PackStrR('',GetColWidth);
    for j := 1 to MONTHS do s := s + PackStrR(Times2StrMon(MonIndexToDate(DateToMonIndex(tiCurr)-((12+tiCurr.bMonth-j) mod 12))),GetColWidth);
    AddInfo(s);    
    s := PackStrR('',GetColWidth);
    for j := 1 to MONTHS do s := s + PackStrR('мес€ц '+IntToStr(j),GetColWidth);
    AddInfo(s);

    for i := 0 to 3 do begin
      s := PackStrR(GetCanalName(i),GetColWidth);
      for j := 1 to MONTHS do s := s + PackStrR(IntToStr(mpdwEngMon[i][j]),GetColWidth);
      AddInfo(s);
    end;
    
    AddInfo('');
    AddInfo('Ёнерги€ по мес€цам');

    s := PackStrR('',GetColWidth);
    for j := 1 to MONTHS do s := s + PackStrR(Times2StrMon(MonIndexToDate(DateToMonIndex(tiCurr)-((12+tiCurr.bMonth-j) mod 12))),GetColWidth);
    AddInfo(s);    
    s := PackStrR('',GetColWidth);
    for j := 1 to MONTHS do s := s + PackStrR('мес€ц '+IntToStr(j),GetColWidth);
    AddInfo(s);

    for i := 0 to 3 do begin
      s := PackStrR(GetCanalName(i),GetColWidth);
      for j := 1 to MONTHS do s := s + Reals2StrR(mpdwEngMon[i][j]*kE2);
      AddInfo(s);
    end;
    
    BoxRun;
  end;    
end;

end.

