unit calendar;

interface

uses timez;

function DateToDayIndex(tiT: times): longword;
function DayIndexToDate(dwT: longword): times;

function DateToMonIndex(tiT: times): longword;
function MonIndexToDate(dwT: longword): times;

function DateToHalfIndex(tiT: times): longword;
function HalfIndexToDate(dwT: longword): times;

implementation

function GetDaysInYear(bYear: byte): word;
begin
  if (bYear mod 4 = 0) then
      Result := 366
  else
      Result := 365;
end;

function GetDaysInMonth(bYear: byte; bMonth: byte): word;
const
  mpbDaysInMonth: array[1..12] of byte =
  ( 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 );
begin
  if ((bYear mod 4 = 0) and (bMonth = 2)) then
    Result := 29
  else
    Result := mpbDaysInMonth[bMonth];
end;

function DateToDayIndex(tiT: times): longword;
var
  i:  byte;
begin
  Result := 0;

  for i:=0 to tiT.bYear-1 do
    Result := Result + GetDaysInYear(i);

  for i:=1 to tiT.bMonth-1 do
    Result := Result + GetDaysInMonth(tiT.bYear,i);

  Result := Result + tiT.bDay - 1;
end;

function DayIndexToDate(dwT: longword): times;
begin
  Result.bYear := 0;
  while (dwT >= GetDaysInYear(Result.bYear)) do begin
    dwT := dwT - GetDaysInYear(Result.bYear);
    Inc(Result.bYear);
  end;

  Result.bMonth := 1;
  while (dwT >= GetDaysInMonth(Result.bYear,Result.bMonth)) do begin
    dwT := dwT - GetDaysInMonth(Result.bYear,Result.bMonth);
    Inc(Result.bMonth);
  end;

  Result.bDay := dwT + 1;
  
  Result.bHour   := 0;
  Result.bMinute := 0;
  Result.bSecond := 0;
end;

function DateToMonIndex(tiT: times): longword;
var
  i:  byte;
begin
  Result := 0;

  for i:=0 to tiT.bYear-1 do
    Result := Result + 12;

  Result := Result + tiT.bMonth - 1;
end;

function MonIndexToDate(dwT: longword): times;
begin
  Result.bYear := 0;
  while (dwT >= 12) do begin
    dwT := dwT - 12;
    Inc(Result.bYear);
  end;

  Result.bMonth := dwT + 1;
  
  Result.bDay    := 1;
  Result.bHour   := 0;
  Result.bMinute := 0;
  Result.bSecond := 0;
end;

function DateToHalfIndex(tiT: times): longword;
var
  i:  byte;
begin
  Result := 0;

  for i:=0 to tiT.bYear-1 do
    Result := Result + GetDaysInYear(i);

  for i:=1 to tiT.bMonth-1 do
    Result := Result + GetDaysInMonth(tiT.bYear,i);

  Result := Result + tiT.bDay - 1;
  Result := Result * 48;
  Result := Result + tiT.bHour*2 + tiT.bMinute div 30;
end;

function HalfIndexToDate(dwT: longword): times;
begin
  Result.bYear := 0;
  while (dwT >= 48*GetDaysInYear(Result.bYear)) do begin
    dwT := dwT - 48*GetDaysInYear(Result.bYear);
    Inc(Result.bYear);
  end;

  Result.bMonth := 1;
  while (dwT >= 48*GetDaysInMonth(Result.bYear,Result.bMonth)) do begin
    dwT := dwT - 48*GetDaysInMonth(Result.bYear,Result.bMonth);
    Inc(Result.bMonth);
  end;

  Result.bDay := dwT div 48;
  dwT := dwT - Result.bDay*48;
  Inc(Result.bDay);

  Result.bHour := dwT div 2;
  dwT := dwT - Result.bHour*2;

  Result.bMinute := dwT*30;
  Result.bSecond := 0;
end;

end.
