unit t_profile2;

interface

uses Classes, timez;

procedure InitProfile; 
procedure AddProfile(c: byte; e: extended; w: word; tiT: times); 
function ResultProfile: TStringList; 

implementation

uses SysUtils, support, realz;

type
  canal_t = record
    energy: array[1..4] of extended;
    impulse: array[1..4] of longword;
  end;

  half_t = record
    value:  canal_t;
    flag:   boolean;
  end;

  day_t = record
    halfs:  array[0..47] of half_t;
    value:  canal_t;
    flag:   boolean;
  end;

  month_t = record
    days:   array[1..31] of day_t;
    value:  canal_t;
    flag:   boolean;
  end;
  
var
  year:     array[1..12] of month_t;

procedure InitProfile; 
var
  c,d,h,m:  byte;
begin
  for c := 1 to 4 do begin
    for m := 1 to 12 do begin
      year[m].flag := false;
      year[m].value.energy[c] := 0;
      year[m].value.impulse[c] := 0;
      for d := 1 to 31 do begin
        year[m].days[d].flag := false;
        year[m].days[d].value.energy[c] := 0;
        year[m].days[d].value.impulse[c] := 0;
        for h := 0 to 47 do begin
          year[m].days[d].halfs[h].flag := false;
          year[m].days[d].halfs[h].value.energy[c] := 0;
          year[m].days[d].halfs[h].value.impulse[c] := 0;
        end;
      end;  
    end;  
  end;  
end;
  
procedure AddProfile(c: byte; e: extended; w: word; tiT: times); 
var
  d,h,m:  byte;
begin 
  h := tiT.bHour*2 + tiT.bMinute div 30;
  d := tiT.bDay; 
  m := tiT.bMonth; 
  
  year[m].flag := true;
  year[m].value.energy[c] := year[m].value.energy[c] + e;
  year[m].value.impulse[c] := year[m].value.impulse[c] + w;

  year[m].days[d].flag := true;
  year[m].days[d].value.energy[c] := year[m].days[d].value.energy[c] + e;
  year[m].days[d].value.impulse[c] := year[m].days[d].value.impulse[c] + w;
  
  year[m].days[d].halfs[h].flag := true;
  year[m].days[d].halfs[h].value.energy[c] := year[m].days[d].halfs[h].value.energy[c] + e;  
  year[m].days[d].halfs[h].value.impulse[c] := year[m].days[d].halfs[h].value.impulse[c] + w;  
end;

function ResultProfile: TStringList; 
var
  c,d,h,m:  byte;
  s:  string;
begin
  
  Result := TStringList.Create;

  
  Result.Add('');     
  for m := 1 to 12 do begin
    for d := 1 to 31 do begin
      if year[m].days[d].flag then begin

        Result.Add('');   
        s := '';
        for c := 0 to 4 do s := s + PackLine(GetColWidth);
        Result.Add(s);    
      
        s := PackStrR('сутки ' + Int2Str(d,2) + '.' + Int2Str(m,2),GetColWidth);
        Result.Add(s);        
        for h := 0 to 47 do begin        
          s := PackStrR(Int2Str(h div 2,2)+'.'+Int2Str((h mod 2)*30,2),GetColWidth);
          if (year[m].days[d].halfs[h].flag) then
            for c := 1 to 4 do s := s + Reals2StrR(year[m].days[d].halfs[h].value.energy[c]);
          Result.Add(s);
        end;                
      end;  
    end;  
  end;

  Result.Add('');     
  for m := 1 to 12 do begin
    if year[m].flag then Result.Add(PackStrR('мес€ц '+IntToStr(m),GetColWidth));
    for d := 1 to 31 do begin
      if year[m].days[d].flag then begin
        s := PackStrR('сутки ' + Int2Str(d,2) + '.' + Int2Str(m,2),GetColWidth);
        for c := 1 to 4 do
          s := s + Reals2StrR(year[m].days[d].value.energy[c]);
        Result.Add(s);
      end;  
    end;  
  end;
  
  Result.Add('');   
  for m := 1 to 12 do begin
    if year[m].flag then begin
      s := PackStrR('мес€ц '+IntToStr(m),GetColWidth);
      for c := 1 to 4 do s := s + Reals2StrR(year[m].value.energy[c]);
      Result.Add(s);
    end;  
  end;


  Result.Add('');     
  for m := 1 to 12 do begin
    for d := 1 to 31 do begin
      if year[m].days[d].flag then begin

        Result.Add('');   
        s := '';
        for c := 0 to 4 do s := s + PackLine(GetColWidth);
        Result.Add(s);    
      
        s := PackStrR('сутки ' + Int2Str(d,2) + '.' + Int2Str(m,2),GetColWidth);
        Result.Add(s);        
        for h := 0 to 47 do begin        
          s := PackStrR(Int2Str(h div 2,2)+'.'+Int2Str((h mod 2)*30,2),GetColWidth);
          if (year[m].days[d].halfs[h].flag) then
            for c := 1 to 4 do s := s + PackStrR(IntToStr(year[m].days[d].halfs[h].value.impulse[c]), GetColWidth);
          Result.Add(s);
        end;                
      end;  
    end;  
  end;

  Result.Add('');     
  for m := 1 to 12 do begin
    if year[m].flag then Result.Add(PackStrR('мес€ц '+IntToStr(m),GetColWidth));
    for d := 1 to 31 do begin
      if year[m].days[d].flag then begin
        s := PackStrR('сутки ' + Int2Str(d,2) + '.' + Int2Str(m,2),GetColWidth);
        for c := 1 to 4 do
          s := s + PackStrR(IntToStr(year[m].days[d].value.impulse[c]), GetColWidth);
        Result.Add(s);
      end;  
    end;  
  end;
  
  Result.Add('');   
  for m := 1 to 12 do begin
    if year[m].flag then begin
      s := PackStrR('мес€ц '+IntToStr(m),GetColWidth);
      for c := 1 to 4 do s := s + PackStrR(IntToStr((year[m].value.impulse[c])), GetColWidth);
      Result.Add(s);
    end;  
  end;
  
end;

end.
