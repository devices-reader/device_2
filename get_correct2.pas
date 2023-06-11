unit get_correct2;

interface

procedure BoxGetCorrect2;
procedure ShowGetCorrect2;

implementation

uses SysUtils, support, soutput, timez, box, get_open2;

const
  quGetCorrect2:  querys = (Action: acGetCorrect2; cwOut: 3+3+2; cwIn: 1+1+2; bNumber: 0);

procedure QueryGetCorrect2;
var
  ti: TDateTime;
  Hour,Min,Sec,MSec: word;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(13);

  ti := Now;
  DecodeTime(ti, Hour,Min,Sec,MSec);

  PushByte(ToBCD(Sec));
  PushByte(ToBCD(Min));
  PushByte(ToBCD(Hour));
  
  AddInfo('время коррекции:  ' + Times2StrTime(ToTimes(ti)));
  
  Query(quGetCorrect2, True);
end;

procedure BoxGetCorrect2;
begin
  AddInfo('');
  AddInfo('');
  AddInfo('Коррекция времени');
  QueryGetCorrect2;
end;

procedure ShowGetCorrect2;
var
  i:    byte;
begin
  Stop;
  InitPop(1);

  i := PopByte;
  if i = 0 then 
    InfBox('Коррекция времени - проведена успешно')
  else if i = 1 then 
    WrnBox('Коррекция времени невозможна - переход в другой час или величина коррекции больше плюс/минус 4 минуты')
  else if i = 4 then 
    WrnBox('Коррекция времени невозможна - коррекция разрешена только раз в сутки')
  else
    WrnBox('Ошибка коррекции времени - код '+IntToHex(i,2));  
end;

end.
