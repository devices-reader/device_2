unit get_graph_data11;

interface

procedure BoxGetGraphData11;
procedure ShowGetGraphData11;

implementation

uses SysUtils, support, soutput, timez, progress, box, kernel, get_koeffs, get_graph_top11, t_profile2, calendar, main;

const
  quGetGraphData11:  querys = (Action: acGetGraphData11; cwOut: 3+3+2; cwIn: 1+15*17+2; bNumber: 0);
  
procedure QueryGetGraphData11;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(6);

  if wGraphTop11 >= $10000 then PushByte($83) else PushByte(3);

  PushByte((wGraphTop11 mod $10000) div $100);
  PushByte(wGraphTop11 mod $100);

  PushByte($FF);
  
  Query(quGetGraphData11, True);
end;

procedure BoxGetGraphData11;
begin
  AddTerm('Данные блока');
  QueryGetGraphData11;
end;

procedure ShowGetGraphData11;
var
  s:    string;
  ti:   times;
  a,b:  byte;
  x,y:  word;
  z:    byte;
  e:    extended;
begin
  Stop;
  InitPop(1);

  AddInfo('');
  for z := 0 to 17-1 do begin  
    InitPop(1+(16-z)*15);
  
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
         PackStrR('0x' + IntToHex(wGraphTop11+16*$10,5),GetColWidth);
       
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

    if wGraphTop11 = 0 then wGraphTop11 := $1FFF0 else wGraphTop11 := wGraphTop11 - $10;

    ShowProgress(wGraphCount11, frmMain.updGraphCount.Position+1);
    Inc(wGraphCount11);    
  end;
  
  if wGraphCount11 < frmMain.updGraphCount.Position then 
    BoxGetGraphData11
  else begin
    frmMain.AddInfoAll(ResultProfile);
    BoxRun; 
  end;   
end;

end.
