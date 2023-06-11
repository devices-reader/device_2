unit get_version;

interface

procedure BoxGetVersion;
procedure ShowGetVersion;

implementation

uses SysUtils, support, soutput, box;

const
  quGetVersion:  querys = (Action: acGetVersion; cwOut: 3+0+2; cwIn: 1+3+2; bNumber: 0);

procedure QueryGetVersion;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(8);
  PushByte(3);
  Query(quGetVersion, True);
end;

procedure BoxGetVersion;
begin
  AddInfo('');
  AddInfo('');
  AddInfo('Версия');
  QueryGetVersion;
end;

procedure ShowGetVersion;
begin
  Stop;
  InitPop(1);
  
  AddInfo(IntToStr(FromBCD(PopByte)) + '.' + IntToStr(FromBCD(PopByte)) + '.' + IntToStr(FromBCD(PopByte)));

  BoxRun;
end;

end.
