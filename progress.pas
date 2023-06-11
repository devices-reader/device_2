unit progress;

interface

procedure ShowProgress(i: integer; j: integer);

implementation

uses main;

procedure ShowProgress(i: integer; j: integer);
begin
  with frmMain.prbMain do begin
    Min := 0;
    Position := i+1;
    Max := j;
  end;
end;

end.
