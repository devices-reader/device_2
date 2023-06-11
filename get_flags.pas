unit get_flags;

interface

procedure BoxGetFlags;
procedure ShowGetFlags;

implementation

uses SysUtils, support, soutput, timez, box;

const
  quGetFlags:  querys = (Action: acGetFlags; cwOut: 3+0+2; cwIn: 1+2+2; bNumber: 0);

procedure QueryGetFlags;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(8);
  PushByte(9);
  Query(quGetFlags, True);
end;

procedure BoxGetFlags;
begin
  AddInfo('');
  AddInfo('');
  AddInfo('������������');
  QueryGetFlags;
end;

procedure ShowGetFlags;
var 
  i,j:  byte;
  s:    string;
begin
  Stop;
  InitPop(1);

  i := PopByte;
  j := PopByte;
  
  AddInfo('�����: 0x' + IntToHex(i,2) + ' 0x' + IntToHex(j,2));
  
  if j and $08 = 0 then s := '0, ��' else s := '1, ���';
  AddInfo('���� 0x'+IntToHex(j,2)+'.3 = ' + s + ' - ��������������� �������� �� ������/������ �����');

  BoxRun;  
end;

end.
