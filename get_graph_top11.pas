unit get_graph_top11;

interface

procedure BoxGetGraphTop11;
procedure ShowGetGraphTop11;

var
  wGraphTop11:    longword;
  wGraphCount11:  word;

implementation

uses SysUtils, support, soutput, timez, box, kernel, get_graph_data11, t_profile2, main;
  
const
  quGetGraphTop11:  querys = (Action: acGetGraphTop11; cwOut: 3+0+2; cwIn: 1+9+2; bNumber: 0);

procedure QueryGetGraphTop11;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(8);
  PushByte($13);
  Query(quGetGraphTop11, True);
end;

procedure BoxGetGraphTop11;
begin
  AddTerm('Указатель на вершину блоков');
  QueryGetGraphTop11;
end;

procedure ShowGetGraphTop11;
var
  ti:   times;
  s:    string;
  a,b:  byte;
  x,y:  word;
begin
  Stop;
  InitPop(1);

  y := PopByte*$100+PopByte;
  a := PopByte;
  
  with ti do begin
    bHour   := FromBCD(PopByte);
    bMinute := FromBCD(PopByte);
    bDay    := FromBCD(PopByte);
    bMonth  := FromBCD(PopByte);
    bYear   := FromBCD(PopByte);

    s :=    Int2Str(bHour)   +
      ':' + Int2Str(bMinute) +
      ' ' + Int2Str(bDay)    +
      '.' + Int2Str(bMonth)  +
      '.' + Int2Str(bYear);    
  end;
  
  b := PopByte;

  AddInfo('');
  AddInfo('Энергия по получасам:');
  
  AddInfo('Вершина: ');
  s := PackStrR(s,3*GetColWidth div 2) + 
       PackStrR('0x' + IntToHex(y*$10,5),GetColWidth);
      
  AddInfo(s);
  AddInfo('Период: ' + IntToStr(b) + ' мин.');
  AddInfo('Статус: ПР - перепролнение, НС - неполный срез, ИН - инициализация, СЗ - сезон');
  AddInfo(GetStatusName(a));

  wGraphTop11 := y*$10;
  for x := 1 to frmMain.updGraphOffset.Position do
    if wGraphTop11 = 0 then wGraphTop11 := $FFF0 else wGraphTop11 := wGraphTop11 - $10;
  
  AddInfo('Вершина с учетом смещения ' + IntToStr(frmMain.updGraphOffset.Position) + ': ' +'0x' + IntToHex(wGraphTop11,5));
  AddInfo('');
  
  wGraphCount11 := 0;  
  InitProfile;
  BoxGetGraphData11; 
end;

end.
