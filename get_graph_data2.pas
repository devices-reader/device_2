unit get_graph_data2;

interface

procedure BoxGetGraphData2;
procedure ShowGetGraphData2;

implementation

uses SysUtils, support, soutput, timez, box, progress, kernel, get_koeffs, get_graph_top2, t_profile2, calendar, main;

const
  quGetGraphData2:  querys = (Action: acGetGraphData2; cwOut: 3+3+2; cwIn: 18*20+2; bNumber: 0);
  
procedure QueryGetGraphData2;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(6);
  PushByte(4);

  PushByte(wGraphTop2 div $100);
  PushByte(wGraphTop2 mod $100);

  PushByte(20);
  
  Query(quGetGraphData2, True);
end;

procedure BoxGetGraphData2;
begin
  AddTerm('Данные блока');
  QueryGetGraphData2;
end;

procedure ShowGetGraphData2;
var
  s:    string;
  ti:   times;
  a,b:  byte;
  x,y:  word;
  e:    extended;
  z:    byte;
begin
  Stop;
  InitPop(1);
  
for z := 0 to 20-1 do begin  
  InitPop(1+z*18);
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
       PackStrR('0x' + IntToHex(wGraphTop2,4),GetColWidth);
       
  for x := 1 to 4 do begin
    y := PopByte + PopByte*$100;
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

  if wGraphTop2 = 0 then wGraphTop2 := $FFF0 else wGraphTop2 := wGraphTop2 - $10;

  ShowProgress(wGraphCount2, frmMain.updGraphCount.Position+1);
  Inc(wGraphCount2);    
end;
  
  if wGraphCount2 < frmMain.updGraphCount.Position then 
    BoxGetGraphData2
  else begin
    frmMain.AddInfoAll(ResultProfile);
    BoxRun; 
  end;   
end;

end.
