unit get_graph_top;

interface

procedure BoxGetGraphTop;
procedure ShowGetGraphTop;

var
  wGraphTop:    word;
  wGraphCount:  word;

implementation

uses SysUtils, support, soutput, timez, box, kernel, get_graph_data, t_profile2, main;
  
const
  quGetGraphTop:  querys = (Action: acGetGraphTop; cwOut: 3+0+2; cwIn: 1+9+2; bNumber: 0);

procedure QueryGetGraphTop;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(8);
  PushByte($13);
  Query(quGetGraphTop, True);
end;

procedure BoxGetGraphTop;
begin
  AddTerm('Указатель на вершину блоков');
  QueryGetGraphTop;
end;

procedure ShowGetGraphTop;
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
       PackStrR('0x' + IntToHex(y,4),GetColWidth);
      
  AddInfo(s);
  AddInfo('Период: ' + IntToStr(b) + ' мин.');
  AddInfo('Статус: ПР - перепролнение, НС - неполный срез, ИН - инициализация, СЗ - сезон');
  AddInfo(GetStatusName(a));

  wGraphTop := y;
  for x := 1 to frmMain.updGraphOffset.Position do
    if wGraphTop = 0 then wGraphTop := $FFF0 else wGraphTop := wGraphTop - $10;
  
  AddInfo('Вершина с учетом смещения ' + IntToStr(frmMain.updGraphOffset.Position) + ': ' +'0x' + IntToHex(wGraphTop,4));
  AddInfo('');
  
  wGraphCount := 0;  
  InitProfile;
  BoxGetGraphData; 
end;

end.
