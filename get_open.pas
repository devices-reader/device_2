unit get_open;

interface

procedure BoxGetOpen;
procedure ShowGetOpen;

implementation

uses SysUtils, support, soutput, timez, box;

const
  quGetOpen:  querys = (Action: acGetOpen; cwOut: 3+6+2; cwIn: 1+1+2; bNumber: 0);

procedure QueryGetOpen;
var
  s:  string;
begin
  try
    s := GetDevicePass;
    if Length(s) <> 6 then raise Exception.Create('������������ ����� ������ !');    
    if not 
      ((s[1] in ['0'..'9']) and
       (s[2] in ['0'..'9']) and    
       (s[3] in ['0'..'9']) and    
       (s[4] in ['0'..'9']) and    
       (s[5] in ['0'..'9']) and    
       (s[6] in ['0'..'9'])) then raise Exception.Create('������������ ������� ������ !');    
       
    InitPushZero;
    PushByte(GetDeviceAddr);
    PushByte(1);
    PushByte(2);
  
    PushByte(Ord(s[1])-Ord('0'));
    PushByte(Ord(s[2])-Ord('0'));
    PushByte(Ord(s[3])-Ord('0'));
    PushByte(Ord(s[4])-Ord('0'));
    PushByte(Ord(s[5])-Ord('0'));
    PushByte(Ord(s[6])-Ord('0'));
    Query(quGetOpen, True);
  except
    ErrBox('������ �������� ����� ����������� !');
  end;    
end;

procedure BoxGetOpen;
begin
  AddInfo('');
  AddInfo('�������� ������');
  QueryGetOpen;
end;

procedure ShowGetOpen;
var
  i:    byte;
begin
  Stop;
  InitPop(1);

  i := PopByte;
  if i = 0 then begin
    AddInfo('����� ������ �������');
    BoxRun;
  end  
  else begin
    AddInfo('������ �������� ������: ��� '+IntToHex(i,2));
    WrnBox('������ �������� ������: ��� '+IntToHex(i,2));  
  end;  
end;

end.
