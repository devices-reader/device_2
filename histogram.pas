unit histogram;

interface

uses Classes;

type
  THistogram = class
  private const
    INTERVAL = 10000;
    STEP = 10;
    STEPS = INTERVAL div STEP;
  private
    sHistogramName: string;
    sUnitName: string;
    mpwSteps: array[0..STEPS-1] of word;
    wIdxMin,wIdxMax: word;
    dwStepsSum: longword;
  public
    constructor Create(sHistogramName: string; sUnitName: string);
    procedure Clean();
    procedure Add(wValue: word);
    function Report(): TStringList;
  end;

implementation

uses SysUtils, support;

constructor THistogram.Create(sHistogramName: string; sUnitName: string);
begin
  self.sHistogramName := sHistogramName;
  self.sUnitName := sUnitName;
end;

procedure THistogram.Clean();
var
  i: word;
begin
  for i := 0 to STEPS-1 do
    mpwSteps[i] := 0;

  wIdxMin := STEPS-1;
  wIdxMax := 0;

  dwStepsSum := 0;
end;

procedure THistogram.Add(wValue: word);
var
  i: word;
begin
  i := wValue div STEP;

  if (i < STEPS) then begin
    if (i < wIdxMin) then
      wIdxMin := i;

    if (i > wIdxMax) then
      wIdxMax := i;

    Inc(mpwSteps[i]);
    Inc(dwStepsSum);
  end;
end;

function THistogram.Report(): TStringList;
var
  i: word;
  s: string;
begin
  Result := TStringList.Create;

  Result.Add(' ');
  Result.Add(sHistogramName);

  for i := wIdxMin to wIdxMax do
  begin
     s := PackStrR(IntToStr(i*STEP) + '-' + IntToStr((i+1)*STEP) + ' ' + sUnitName, 16);
     if mpwSteps[i] > 0 then begin
       s := s + PackStrR(IntToStr(mpwSteps[i]), 8);
       s := s + PackStrR(IntToStr(100*mpwSteps[i] div dwStepsSum)+' %', 8);
     end;
     Result.Add(s);
  end;
end;

end.
