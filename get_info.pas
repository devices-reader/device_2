unit get_info;

interface

uses box;

procedure BoxGetInfo(i: byte);
procedure ShowGetInfo(i: byte);
function GetInfoName(i: byte): string;
function GetInfoQuery(i: byte): querys;

const
  quGetInfo1:   querys = (Action: acGetInfo1;  cwOut: 2+2+2; cwIn: 1+12+2; bNumber: 0);
  quGetInfo2:   querys = (Action: acGetInfo2;  cwOut: 2+2+2; cwIn: 1+12+2; bNumber: 0);
  quGetInfo3:   querys = (Action: acGetInfo3;  cwOut: 2+2+2; cwIn: 1+12+2; bNumber: 0);
  quGetInfo4:   querys = (Action: acGetInfo4;  cwOut: 2+2+2; cwIn: 1+12+2; bNumber: 0);
  quGetInfo5:   querys = (Action: acGetInfo5;  cwOut: 2+2+2; cwIn: 1+12+2; bNumber: 0);
  quGetInfo6:   querys = (Action: acGetInfo6;  cwOut: 2+2+2; cwIn: 1+12+2; bNumber: 0);
  quGetInfo7:   querys = (Action: acGetInfo7;  cwOut: 2+2+2; cwIn:  1+6+2; bNumber: 0);
  quGetInfo8:   querys = (Action: acGetInfo8;  cwOut: 2+2+2; cwIn:  1+6+2; bNumber: 0);
  quGetInfo9:   querys = (Action: acGetInfo9;  cwOut: 2+2+2; cwIn:  1+6+2; bNumber: 0);
  quGetInfo10:  querys = (Action: acGetInfo10; cwOut: 2+2+2; cwIn:  1+6+2; bNumber: 0);
  quGetInfo11:  querys = (Action: acGetInfo11; cwOut: 2+2+2; cwIn:  1+6+2; bNumber: 0);
  quGetInfo12:  querys = (Action: acGetInfo12; cwOut: 2+2+2; cwIn:  1+6+2; bNumber: 0);
  quGetInfo13:  querys = (Action: acGetInfo13; cwOut: 2+2+2; cwIn:  1+6+2; bNumber: 0);
  quGetInfo14:  querys = (Action: acGetInfo14; cwOut: 2+2+2; cwIn:  1+6+2; bNumber: 0);
  quGetInfo15:  querys = (Action: acGetInfo15; cwOut: 2+2+2; cwIn:  1+6+2; bNumber: 0);
  quGetInfo16:  querys = (Action: acGetInfo16; cwOut: 2+2+2; cwIn:  1+6+2; bNumber: 0);

implementation

uses SysUtils, support, soutput, timez, crc, terminal, progress;

var
  ibInfo:   byte;
  mpInfo:   array[1..16,0..1] of times;

function GetInfoSize(i: byte): byte;
begin
  if i in [1..6]
    then Result := 12
  else 
    Result := 6
end;

function GetInfoName(i: byte): string;
begin
  case i of
     1: Result := '������ 1: ����� ���������/���������� �������';
     2: Result := '������ 2: ����� ��/����� ��������� ����� �������';
     3: Result := '������ 3: ����� ���������/���������� ���� 1 �������';
     4: Result := '������ 4: ����� ���������/���������� ���� 2 �������';
     5: Result := '������ 5: ����� ���������/���������� ���� 3 �������';
     6: Result := '������ 6: ����� ������/��������� ���������� ������ �������� �������';
     7: Result := '������ 7: ����� ��������� ��������� ����������';
     8: Result := '������ 8: ����� ��������� ���������� ����������� ����';
     9: Result := '������ 9: ����� ������ ��������� ����������� �������';
    10: Result := '������ 10: ����� ������ ������� ������� ���������';
    11: Result := '������ 11: ����� ���������� ������ ������� �� ������ 1';
    12: Result := '������ 12: ����� ���������� ������ ������� �� ������ 2';
    13: Result := '������ 13: ����� ���������� ������ ������� �� ������ 3';
    14: Result := '������ 14: ����� ���������� ������ ������� �� ������ 4';
    15: Result := '������ 15: ����� ��������� ���������� �������� �� ����������� ������ ��������';
    16: Result := '������ 16: ����� ��������� ���������� �������� �� ����������� ������ �������';
  end;
end;

procedure QueryGetInfo(i: byte; j: byte);
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(4);
  PushByte(i);
  PushByte(j);
  Query(GetInfoQuery(i), True);
end;

procedure BoxGetInfo(i: byte);
begin
  AddInfo('');
  AddInfo(GetInfoName(i));

  ibInfo := 0;
  QueryGetInfo(i,ibInfo);
end;

function GetInfoQuery(i: byte): querys;
begin
  case i of
    1:   Result := quGetInfo1;
    2:   Result := quGetInfo2;
    3:   Result := quGetInfo3;
    4:   Result := quGetInfo4;
    5:   Result := quGetInfo5;
    6:   Result := quGetInfo6;
    7:   Result := quGetInfo7;
    8:   Result := quGetInfo8;
    9:   Result := quGetInfo9;
    10:  Result := quGetInfo10;
    11:  Result := quGetInfo11;
    12:  Result := quGetInfo12;
    13:  Result := quGetInfo13;
    14:  Result := quGetInfo14;
    15:  Result := quGetInfo15;
    16:  Result := quGetInfo16;
  end;
end;

function PopTimesBCD: times;
begin
  with Result do begin
    bSecond := FromBCD(PopByte);
    bMinute := FromBCD(PopByte);
    bHour   := FromBCD(PopByte);
    bDay    := FromBCD(PopByte);
    bMonth  := FromBCD(PopByte);
    bYear   := FromBCD(PopByte);
  end;
end;

procedure ShowGetInfo(i: byte);
var
  s:  string;
  j:  byte;
begin
  Stop;

  InitPopCRC;
  
  s := '����:';
  for j := 0 to GetInfoSize(i)+3-1 do begin
    s := s + IntToHex(PopByte,2) + '';
  end;
  //AddInfo(s);
  
  InitPop(1);
  if i in [7..16] then begin
    mpInfo[i][0] := PopTimesBCD;
    AddInfo(Times2Str(mpInfo[i][0]));
  end;

  if i in [1..6] then begin
    mpInfo[i][0] := PopTimesBCD;
    mpInfo[i][1] := PopTimesBCD;
    AddInfo(Times2Str(mpInfo[i][0]) + '   ' +Times2Str(mpInfo[i][1]));
  end;

  ShowProgress(ibInfo,10);
  if ibInfo < 10-1 then begin
    Inc(ibInfo);
    QueryGetInfo(i,ibInfo);
  end
  else BoxRun;
end;

end.
