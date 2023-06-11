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
  
  AddInfo('����� ���������:  ' + Times2StrTime(ToTimes(ti)));
  
  Query(quGetCorrect2, True);
end;

procedure BoxGetCorrect2;
begin
  AddInfo('');
  AddInfo('');
  AddInfo('��������� �������');
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
    InfBox('��������� ������� - ��������� �������')
  else if i = 1 then 
    WrnBox('��������� ������� ���������� - ������� � ������ ��� ��� �������� ��������� ������ ����/����� 4 ������')
  else if i = 4 then 
    WrnBox('��������� ������� ���������� - ��������� ��������� ������ ��� � �����')
  else
    WrnBox('������ ��������� ������� - ��� '+IntToHex(i,2));  
end;

end.
