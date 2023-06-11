unit uni_transit;

interface

function InfoUniTransit: string;
procedure BoxUniTransit;
procedure ShowUniTransit;

implementation

uses SysUtils, soutput, sinput, support, box, main, timez;

const
  quUniTransit: querys = (Action: acUniTransit; cwOut: 6 + 4 + 4; cwIn: 6 + 0 + 10; bNumber: $F8);

function InfoUniTransit: string;
begin
  Result := 'Транзит';
end;

procedure QueryUniTransit;
begin
  with frmMain do begin
    InitPush(6);
    PushIntUni(updUniTransitDevice.Position);
    PushByte(0);
    PushByte(updUniTransitTimeout.Position);
    QueryUni(quUniTransit);
  end;
end;

procedure BoxUniTransit;
begin
  AddInfo('');
  AddInfo('');
  AddInfo(InfoUniTransit);
  AddInfo('');
  QueryUniTransit;
end;

procedure ShowUniTransit;
var
  i:  byte;
  s:  string;
  ti: times;
begin
  Stop;
  InitPop(6);

  i := PopByte;

  s := PackStrR('Время', GetColWidth);
  with ti do begin
    bSecond := 0;
    bMinute := PopByte;
    bHour   := PopByte;
    bDay    := PopByte;
    bMonth  := PopByte;
    bYear   := PopByte;

    s := s +        Int2Str(bHour)   +
              ':' + Int2Str(bMinute) +
              ':' + Int2Str(bSecond) +
              ' ' + Int2Str(bDay)    +
              '.' + Int2Str(bMonth)  +
              '.' + Int2Str(bYear);
  end;
  AddInfo(s);

  if i = 9 then
    AddInfo('Транзит открыт успешно')
  else if i = 10 then
    WrnBox('Ошибка открытия транзита !')
  else
    WrnBox('Ошибка обмена - код ' + IntToStr(i))
end;

end.
