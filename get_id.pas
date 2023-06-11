unit get_id;

interface

procedure BoxGetId;
procedure ShowGetId;

implementation

uses SysUtils, support, soutput, box;

const
  quGetId:  querys = (Action: acGetId; cwOut: 3+0+2; cwIn: 1+2+2; bNumber: 0);

procedure QueryGetId;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(8);
  PushByte(5);
  Query(quGetId, True);
end;

procedure BoxGetId;
begin
  AddInfo('');
  AddInfo('');
  AddInfo('Логический номер');
  QueryGetId;
end;

procedure ShowGetId;
begin
  Stop;
  InitPop(2);

  AddInfo(IntToStr(PopByte));

  BoxRun;
end;

end.
