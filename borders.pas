unit borders;

interface

uses kernel;

function TestDays: boolean;
function TestDays2: boolean;
function TestMonths: boolean;

var
  ibMinDay,
  ibMaxDay:     shortint;

  ibMinMonth,
  ibMaxMonth:   shortint;

implementation

uses SysUtils, main, support;

function TestDays: boolean;
begin
  with frmMain do begin
    Result := False;

    ibMinDay := StrToIntDef(edtDaysMin.Text,-1);
    if (ibMinDay < 0) or (ibMinDay > DAYS-1) then begin ErrBox('Ќачальный номер суток задан неправильно !'); exit; end;

    ibMaxDay := StrToIntDef(edtDaysMax.Text,-1);
    if (ibMaxDay < 0) or (ibMaxDay > DAYS-1) then begin ErrBox(' онечный номер суток задан неправильно !'); exit; end;

    if (ibMaxDay < ibMinDay) then begin ErrBox('Ќачальный номер суток больше конечного !'); exit; end;

    Result := True;
  end;
end;

function TestDays2: boolean;
begin
  with frmMain do begin
    Result := False;

    ibMinDay := StrToIntDef(edtDaysMin2.Text,-1);
    if (ibMinDay < 0) then begin ErrBox('Ќачальный номер суток задан неправильно !'); exit; end;

    ibMaxDay := StrToIntDef(edtDaysMax2.Text,-1);
    if (ibMaxDay < 0) then begin ErrBox(' онечный номер суток задан неправильно !'); exit; end;

    if (ibMaxDay < ibMinDay) then begin ErrBox('Ќачальный номер суток больше конечного !'); exit; end;

    Result := True;
  end;
end;

function TestMonths: boolean;
begin
  with frmMain do begin
    Result := False;

    ibMinMonth := StrToIntDef(edtMonthsMin.Text,-1);
    if (ibMinMonth > MONTHS-1) then begin ErrBox('Ќачальный номер мес€ца задан неправильно !'); exit; end;

    ibMaxMonth := StrToIntDef(edtMonthsMax.Text,-1);
    if (ibMaxMonth > MONTHS-1) then begin ErrBox(' онечный номер мес€ца задан неправильно !'); exit; end;

    if (ibMaxMonth < ibMinMonth) then begin ErrBox('Ќачальный номер мес€ца больше конечного !'); exit; end;

    Result := True;
  end;
end;

end.
