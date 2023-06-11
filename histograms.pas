unit histograms;

interface

procedure HistogramsCreate;
procedure HistogramsInit;
procedure HistogramsAddOutBytes(wValue: word);
procedure HistogramsAddInBytes(wValue: word);
procedure HistogramsAddTimeout(wValue: word);
procedure HistogramsReport;

implementation

uses histogram, main;

var
  OutBytesHistogram: THistogram;
  InBytesHistogram: THistogram;
  TimeoutHistogram: THistogram;

procedure HistogramsCreate;
begin
  OutBytesHistogram := THistogram.Create('Гистограмма размера запросов', 'байт');;
  InBytesHistogram := THistogram.Create('Гистограмма размера ответов', 'байт');
  TimeoutHistogram := THistogram.Create('Гистограмма таймаутов между запросами и ответами', 'мсек');
end;

procedure HistogramsInit;
begin
  OutBytesHistogram.Clean;
  InBytesHistogram.Clean;
  TimeoutHistogram.Clean;
end;

procedure HistogramsAddOutBytes(wValue: word);
begin
  OutBytesHistogram.Add(wValue);
end;

procedure HistogramsAddInBytes(wValue: word);
begin
  InBytesHistogram.Add(wValue);
end;

procedure HistogramsAddTimeout(wValue: word);
begin
  TimeoutHistogram.Add(wValue);
end;

procedure HistogramsReport;
begin
  with frmMain do begin
    AddTerminalAll(OutBytesHistogram.Report);
    AddTerminalAll(InBytesHistogram.Report);
    AddTerminalAll(TimeoutHistogram.Report);
  end;
end;

end.
