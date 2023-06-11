unit get_tariffs;

interface

procedure BoxGetTariffs(bo: boolean);
procedure ShowGetTariffs(bo: boolean);

implementation

uses SysUtils, support, soutput, kernel, timez, box, progress;

const
  quGetTariffs1:  querys = (Action: acGetTariffs1; cwOut: 3+3+2; cwIn: 1+16+2; bNumber: 0);
  quGetTariffs2:  querys = (Action: acGetTariffs2; cwOut: 3+3+2; cwIn: 1+16+2; bNumber: 0);

const
  TARIFFS_BREAKS  = 16;
  TARIFFS_DAYS    = 8;
  TARIFFS_MONTHS  = 12;  

  mpDAYS:       array[0..TARIFFS_DAYS-1] of string =
  ('понедельник','вторник','среда','четверг','пятница','суббота','воскресенье','праздники');
  
type
  tariff = record
    bHour:      byte;
    bMinute:    byte;
    bTariff:    byte;
  end;
  
  zones = record
    bSize:      byte;
    mpTariffs:  array[1..TARIFFS_BREAKS] of tariff;
  end;
  
var
  ibMin,ibDay,ibMon:  byte;

  Zone:               zones;
  mpZonesDM:          array[0..TARIFFS_DAYS,1..TARIFFS_MONTHS] of zones;
    
procedure QueryGetTariffs(bo: boolean);
var
  i:  word;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(6);
  PushByte(2);

  i := $1000 + ibMin*$11 + ibDay*$22 + ibMon*$110;
  PushByte(i div $100);
  PushByte(i mod $100);
  PushByte(16);

  if bo then
    Query(quGetTariffs1, True)
  else
    Query(quGetTariffs2, True);
end;

procedure BoxGetTariffs(bo: boolean);
var
  i,j:  word;
begin
  with Zone do begin
    bSize := 0;
    for i := 1 to TARIFFS_BREAKS do with mpTariffs[i] do begin
      bHour   := 0;
      bMinute := 0;
      bTariff := 0;
    end;
  end;

  for i := 0 to TARIFFS_DAYS-1 do
    for j := 1 to TARIFFS_MONTHS do
      mpZonesDM[i,j] := Zone;

  AddInfo('');
  AddInfo('');

  if bo then 
    AddInfo('Тарифы 1') 
  else 
    AddInfo('Тарифы 2');
  
  ibMin := 0;
  ibDay := 0;
  ibMon := 0;  
  QueryGetTariffs(bo);
end;

procedure ShowTariffs(bMonth: byte; bo: boolean);
var
  i,j:  word;
  s:    string;
begin
  if not bo then begin
    AddInfo(' ');
    AddInfo('месяц: ' + IntToStr(bMonth));
    for j := 0 to TARIFFS_DAYS-1 do begin
      s := PackStrR(mpDAYS[j],GetColWidth);
      for i := 1 to TARIFFS_BREAKS do with mpZonesDM[j,bMonth].mpTariffs[i] do
          s := s  + PackStrR(Int2Str(bHour) + ':' + Int2Str(bMinute),GetColWidth div 2);
      AddInfo(s);

      s := PackStrR('',GetColWidth);
      for i := 1 to TARIFFS_BREAKS do with mpZonesDM[j,bMonth].mpTariffs[i] do
          s := s  + PackStrR(IntToStr(bTariff),GetColWidth div 2);
      AddInfo(s);
    end;
  end
  else begin
    AddInfo(' ');
    AddInfo('месяц: ' + IntToStr(bMonth));

    s := PackStrR('',GetColWidth div 2);
    for j := 0 to TARIFFS_DAYS-1 do s := s + PackStrR(mpDAYS[j],GetColWidth);
    AddInfo(s);

    for i := 1 to TARIFFS_BREAKS do begin
      s := PackStrR(IntToStr(i),GetColWidth div 2);
      for j := 0 to TARIFFS_DAYS-1 do with mpZonesDM[j,bMonth].mpTariffs[i] do begin
        s := s  + PackStrR(Int2Str(bHour) + ':' + Int2Str(bMinute) + ' - ' + Int2Str(bTariff),GetColWidth);
      end;
      AddInfo(s);
    end;
  end;
end;

procedure ShowGetTariffs(bo: boolean);
var
  i,a,b:  byte;
begin
  Stop;
  InitPop(1);

  Zone := mpZonesDM[ibDay,ibMon+1];  
  for i := 1 to (TARIFFS_BREAKS div 2) do with Zone.mpTariffs[ibMin*8 + i] do begin
    a := PopByte;
    b := PopByte;

    bHour   := b and $1F;
    bMinute := a and $3F;
    bTariff := (b and $E0) shr 5;
  end;
  mpZonesDM[ibDay,ibMon+1] := Zone;
  
  ShowProgress(ibMon*TARIFFS_DAYS + ibDay, TARIFFS_MONTHS*TARIFFS_DAYS);

  if ibMin < 1 then begin
    Inc(ibMin);
    QueryGetTariffs(bo);
  end
  else begin
    ibMin := 0;
    if ibDay < TARIFFS_DAYS-1 then begin
      Inc(ibDay);
      QueryGetTariffs(bo);
    end
    else begin
      ibDay := 0;
      ShowTariffs(ibMon+1,bo);

      if ibMon < TARIFFS_MONTHS-1 then begin
        Inc(ibMon);
        QueryGetTariffs(bo);
      end
      else BoxRun;
    end;
  end;
end;

end.
