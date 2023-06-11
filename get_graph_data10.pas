unit get_graph_data10;

interface

procedure BoxGetGraphData10;
procedure ShowGetGraphData10;

implementation

uses SysUtils, support, soutput, timez, progress, box, kernel, get_koeffs, get_graph_top10, t_profile2, calendar, main;

const
  quGetGraphData10:  querys = (Action: acGetGraphData10; cwOut: 3+3+2; cwIn: 1+15+2; bNumber: 0);
  
procedure QueryGetGraphData10;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(6);

  if wGraphTop10 >= $10000 then PushByte($83) else PushByte(3);

  PushByte((wGraphTop10 mod $10000) div $100);
  PushByte(wGraphTop10 mod $100);

  PushByte(15);
  
  Query(quGetGraphData10, True);
end;

procedure BoxGetGraphData10;
begin
  AddTerm('Данные блока');
  QueryGetGraphData10;
end;

procedure ShowGetGraphData10;
var
  s:    string;
  ti:   times;
  a,b:  byte;
  x,y:  word;
  e:    extended;
begin
  Stop;
  InitPop(1);

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
  
  s := PackStrR(s,3*GetColWidth div 2) + 
       PackStrR('0x' + IntToHex(wGraphTop10,5),GetColWidth);
       
  for x := 1 to 4 do begin
    y := PopByte;
    y := y + PopByte*$100;
    s := s + PackStrR(IntToStr(y),GetColWidth);

    with ti do begin
      if (bHour <> 0) or (bMinute <> 0) or (bDay <> 0) or (bHour <> 0) or (bMinute <> 0) then begin
        try 
          if y = $FFFF then y := 0;
          e := y * kE1;
          AddProfile(x, e, y, HalfIndexToDate(DateToHalfIndex(ti)-1));
        except
          AddInfo('Ошибка при обработке даты ' + Times2Str(ti));
        end;  
      end;   
    end;
  end;  
  AddInfo(s + PackStrR(IntToStr(b) + ' мин.',GetColWidth) + GetStatusName(a));

  if wGraphTop10 = 0 then wGraphTop10 := $1FFF0 else wGraphTop10 := wGraphTop10 - $10;

  ShowProgress(wGraphCount10, frmMain.updGraphCount.Position+1);
  Inc(wGraphCount10);    
  
  if wGraphCount10 < frmMain.updGraphCount.Position then 
    BoxGetGraphData10
  else begin
    frmMain.AddInfoAll(ResultProfile);
    BoxRun; 
  end;   
end;

end.
