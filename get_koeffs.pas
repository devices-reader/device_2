unit get_koeffs;

interface

procedure BoxGetTrans;
procedure ShowGetTrans;

procedure BoxGetPulse1;
procedure ShowGetPulse1;

procedure BoxGetPulse2;
procedure ShowGetPulse2;

var
  kE1,kE2:  extended;

implementation

uses SysUtils, support, soutput, timez, realz, box;

var
  kI,kU:  longword;
  kP:     word;

const
  quGetTrans:   querys = (Action: acGetTrans; cwOut: 2+1+2; cwIn: 1+4+2; bNumber: 0);
  quGetPulse1:  querys = (Action: acGetPulse1; cwOut: 2+1+2; cwIn: 1+3+2;  bNumber: 0);
  quGetPulse2:  querys = (Action: acGetPulse2; cwOut: 2+1+2; cwIn: 1+6+2;  bNumber: 0);

procedure QueryGetTrans;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(8);
  PushByte(2);
  Query(quGetTrans, True);
end;

procedure QueryGetPulse1;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(8);
  PushByte($12);
  Query(quGetPulse1, True);
end;

procedure QueryGetPulse2;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(8);
  PushByte($12);
  Query(quGetPulse2, True);
end;

procedure BoxGetTrans;
begin
  AddInfo('');
  AddInfo('');
  AddInfo('К. трансформации');
  QueryGetTrans;
end;

procedure BoxGetPulse1;
begin
  AddInfo('');
  AddInfo('');
  AddInfo('К. преобразования 1');
  QueryGetPulse1;
end;

procedure BoxGetPulse2;
begin
  AddInfo('');
  AddInfo('К. преобразования 2');
  QueryGetPulse2;
end;

procedure ShowGetTrans;
begin
  Stop;
  InitPop(1);

  kU := PopByte*$100 + PopByte;
  kI := PopByte*$100 + PopByte;

  AddInfo('Ki*Ku = '+IntToStr(kI)+'*'+IntToStr(kU)+' = '+IntToStr(kI*kU));

  BoxRun;
end;

procedure ShowGetPulse1;
begin
  Stop;
  InitPop(3);

  case (PopByte and $0F) of 
    1:  kP := 5000;
    2:  kP := 1000;
    3:  kP := 500;
    4:  kP := 1000;
    else begin kP := 1; AddInfo('Ошибка при чтении К. преобразования !'); end;
  end;
  
  kE1 := kI*kU/kP;
  kE2 := kI*kU/1000;

  AddInfo('Kp = '+IntToStr(kP)+'*2 = '+IntToStr(kP*2) + ' (для расчета энергии по получасам)');
  AddInfo('*для использования в сумматоре СЭМ+2 К. преобразования необходимо умножать на 2');
  AddInfo('Kp2 = 1000 (для расчета значений счетчиков по суткам, месяцам и всего)');

  AddInfo('');
  AddInfo('К. пропорциональности (для расчета энергии по получасам)');
  AddInfo('Ke = Ki*Ku/Kp = '+Reals2Str(kE1));
  AddInfo('К. пропорциональности (для расчета значений счетчиков по суткам, месяцам и всего)');
  AddInfo('Ke2 = Ki*Ku/Kp2 = '+Reals2Str(kE2));

  BoxRun;
end;

procedure ShowGetPulse2;
begin
  Stop;
  InitPop(3);

  case (PopByte and $0F) of 
    1:  kP := 5000;
    2:  kP := 1000;
    3:  kP := 500;
    4:  kP := 1000;
    else begin kP := 1; AddInfo('Ошибка при чтении К. преобразования !'); end;
  end;

  AddInfo('Kp = '+IntToStr(kP)+'*2 = '+IntToStr(kP*2) + ' (для расчета энергии по получасам)');
  AddInfo('*для использования в сумматоре СЭМ+2 К. преобразования необходимо умножать на 2');
  AddInfo('Kp2 = 1000 (для расчета значений счетчиков по суткам, месяцам и всего)');

  kP := kP*2;

  kE1 := kI*kU/kP;
  kE2 := kI*kU/1000;

  AddInfo('');
  AddInfo('К. пропорциональности (для расчета энергии по получасам)');
  AddInfo('Ke = Ki*Ku/Kp = '+Reals2Str(kE1));
  AddInfo('К. пропорциональности (для расчета значений счетчиков по суткам, месяцам и всего)');
  AddInfo('Ke2 = Ki*Ku/Kp2 = '+Reals2Str(kE2));
  
  BoxRun;
end;

end.
