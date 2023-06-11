unit support;

interface

function Int2Str(wT: word; bSize: byte = 2): string;

function PackLine(wSize: word): string;
function PackStrR(stT: string; wSize: word): string;
function PackStrL(stT: string; wSize: word): string;

function DateTime2Str: string;

function FromBCD(bT: byte): byte;
function ToBCD(bT: byte): byte;

procedure ErrBox(stT: string);
procedure WrnBox(stT: string);
procedure InfBox(stT: string);

procedure Delay(mSec: longword);

procedure AddInfo(stT: string);
procedure AddTerm(stT: string);

function GetColWidth: word;
function GetTunnelIndex: word;
function GetDeviceAddr: byte;
function GetDevicePass: string;
function GetCanalName(i: byte): string;

function GetSeasonName(bT: byte): string;
function GetWeekdayName(bT: byte): string;
function GetStatusName(bT: byte): string;

implementation

uses Windows, Forms, SysUtils, Graphics, main, soutput;

function Int2Str(wT: word; bSize: byte = 2): string;
begin
  Result := IntToStr(wT);
  while Length(Result) < bSize do Result := '0' + Result;
end;

function PackLine(wSize: word): string;
begin
  Result := '';
  while Length(Result) < wSize do Result := Result + '-';
end;

function PackStrR(stT: string; wSize: word): string;
begin
  Result := stT;
  while Length(Result) < wSize do Result := Result + ' ';
end;

function PackStrL(stT: string; wSize: word): string;
begin
  Result := stT;
  while Length(Result) < wSize do Result := ' ' + Result;
end;

function DateTime2Str: string;
begin
  Result := FormatDateTime('hh.mm.ss dd.mm.yyyy',Now);
end;

function FromBCD(bT: byte): byte;
begin
  Result := (bT div 16)*10 + (bT mod 16);
end;

function ToBCD(bT: byte): byte;
begin
  Result := (bT div 10)*16 + bT mod 10;
end;

procedure ErrBox(stT: string);
begin
  Stop;
  AddInfo('Ошибка: '+stT);
  Application.MessageBox(PChar(stT + ' '), 'Ошибка', mb_Ok + mb_IconHand);
end;

procedure WrnBox(stT: string);
begin
  Stop;
  AddInfo('Внимание: '+stT);
  Application.MessageBox(PChar(stT + ' '), 'Внимание', mb_Ok + mb_IconWarning);
end;

procedure InfBox(stT: string);
begin
  Stop;
  AddInfo('Информация: '+stT);
  Application.MessageBox(PChar(stT + ' '), 'Информация', mb_Ok + mb_IconAsterisk);
end;

procedure Delay(mSec: longword);
var
  FirstTickCount,Now: longword;
begin
  FirstTickCount := GetTickCount;
  repeat
    Application.ProcessMessages;
    Now := GetTickCount;
  until (Now - FirstTickCount >= MSec) or (Now < FirstTickCount);
end;

procedure AddInfo(stT: string);
begin
  frmMain.AddInfo(stT);
end;

procedure AddTerm(stT: string);
begin
  frmMain.AddTerminal(stT, clGray);
end;

function GetColWidth: word;
begin
  Result := frmMain.updColWidth.Position;
end;

function GetTunnelIndex: word;
begin
  Result := frmMain.cmbTunnel.ItemIndex;
end;

function GetDeviceAddr: byte;
begin
  Result := frmMain.updDeviceAddr.Position;
end;

function GetDevicePass: string;
begin
  Result := frmMain.medDevicePass.Text;
end;

function GetCanalName(i: uchar): string;
begin
  case i of
    0: Result := 'канал A+';
    1: Result := 'канал A-';
    2: Result := 'канал R+';
    3: Result := 'канал R-';
    else Result := '?';
  end;
end;

function GetSeasonName(bT: byte): string;
begin
  case bT of
    0: Result := 'лето';
    1: Result := 'зима';
    else Result := '? ';
  end;
  Result := IntToStr(bT) + ' - ' + Result;
end;

function GetWeekdayName(bT: byte): string;
begin
  case bT of
    1: Result := 'понедельник';
    2: Result := 'вторник';
    3: Result := 'среда';
    4: Result := 'четверг';
    5: Result := 'пятница';
    6: Result := 'суббота';
    7: Result := 'воскресенье';
    else Result := '? ';
  end;
  Result := IntToStr(bT) + ' - ' + Result;
end;

function GetStatusName(bT: byte): string;
begin
  Result := '0x' + IntToHex(bT,2) + '  ';

  if (bT and $01) = 0 then
    Result := Result + 'ПР: нет;  '
  else
    Result := Result + 'ПР: есть; ';

  if (bT and $02) = 0 then
    Result := Result + 'НС: нет;  '
  else
    Result := Result + 'НС: есть; ';

  if (bT and $04) = 0 then
    Result := Result + 'ИН: нет;  '
  else
    Result := Result + 'ИН: есть; ';

  if (bT and $08) = 0 then
    Result := Result + 'СЗ: лето  '
  else
    Result := Result + 'СЗ: зима  ';
end;

end.
