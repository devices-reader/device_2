unit get_current;

interface

uses box;

function GetCurrentName(i: byte): string;
procedure QueryGetCurrent(i: byte; j: byte);
function GetCurrentQuery(i: byte): querys;
procedure BoxGetCurrent(i: byte);
procedure ShowGetCurrent(i: byte);

implementation

uses SysUtils, support, soutput, realz, crc, terminal, progress;

const
  quGetCurrent0: querys = (Action: acGetCurrent0; cwOut: 2+2+2; cwIn: 1+3+2; bNumber: 0);
  quGetCurrent1: querys = (Action: acGetCurrent1; cwOut: 2+2+2; cwIn: 1+3+2; bNumber: 0);
  quGetCurrent2: querys = (Action: acGetCurrent2; cwOut: 2+2+2; cwIn: 1+3+2; bNumber: 0);
  quGetCurrent3: querys = (Action: acGetCurrent3; cwOut: 2+2+2; cwIn: 1+3+2; bNumber: 0);
  quGetCurrent4: querys = (Action: acGetCurrent4; cwOut: 2+2+2; cwIn: 1+3+2; bNumber: 0);

  mpsPhases:  array[0..3] of string = ('всего', 'фаза 1', 'фаза 2', 'фаза 3');
  mpsNames:   array[0..4] of string = ('Р, Вт', 'Q, ВAP', 'S, ВA', 'U, В' , 'I, мА');

var
  ibCurr: byte;

function GetMaximum(i: byte): byte;
begin
  if i in [0..2] then Result := 4 else Result := 3;
end;

function GetCode(i: byte; j: byte): byte;
begin
  if i in [0..2] then Result := i*4+j else if i = 3 then Result := $11+j else Result := $21+j;
end;

function GetDivider(i: byte): word;
begin
  if i in [0..2] then Result := 100 else if i = 3 then Result := 100 else Result := 1;
end;

function GetCurrentName(i: byte): string;
begin
  Result := 'Мгновенный парамер: ' + mpsNames[i];
end;

procedure QueryGetCurrent(i: byte; j: byte);
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(8);
  PushByte($11);
  PushByte(GetCode(i,j));
  Query(GetCurrentQuery(i), True);
end;

procedure BoxGetCurrent(i: byte);
begin
  AddInfo('');
  AddInfo(GetCurrentName(i));

  ibCurr := 0;
  QueryGetCurrent(i,ibCurr);
end;

function GetCurrentQuery(i: byte): querys;
begin
  case i of
    0: Result := quGetCurrent0;
    1: Result := quGetCurrent1;
    2: Result := quGetCurrent2;
    3: Result := quGetCurrent3;
    4: Result := quGetCurrent4;
  end;
end;

procedure ShowGetCurrent(i: byte);
var
  a,b,c: byte;
  dw: longint;
begin
  Stop;

  InitPop(1);
  a := PopByte;
  b := PopByte;
  c := PopByte;

  if i in [0..2] then begin
    dw := (a and $3F)*$10000 + c*$100 + b;
    if (i = 0) and (a and $80 <> 0) then dw := -dw; // P
    if (i = 1) and (a and $40 <> 0) then dw := -dw; // Q
    AddInfo(PackStrR(mpsPhases[ibCurr] ,GetColWidth) + Reals2Str(dw/GetDivider(i)));
  end
  else if i in [3..4] then begin
    dw := a*$10000 + c*$100 + b;
    AddInfo(PackStrR(mpsPhases[ibCurr+1] ,GetColWidth) + Reals2Str(dw/GetDivider(i)));
  end;

  ShowProgress(ibCurr,GetMaximum(i));
  if ibCurr < GetMaximum(i)-1 then begin
    Inc(ibCurr);
    QueryGetCurrent(i,ibCurr);
  end
  else BoxRun;
end;

end.
