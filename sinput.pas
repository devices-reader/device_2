unit sinput;

interface

procedure PostInputComPort;
procedure PostInputSocket(s: string);

procedure SaveOut(wSize: word);
procedure LoadOut(wSize: word);

var
  cbMaxRepeat,
  cbCurRepeat:  byte;

implementation

uses SysUtils, Graphics, support, soutput, main, terminal, crc, box;

procedure SaveOut(wSize: word);
var
  i:  word;
begin
  cbCurRepeat := 0;
  if wSize > 0 then
    for i := 0 to wSize-1 do mpbOutSave[i] := mpbOut[i];  
end;

procedure LoadOut(wSize: word);
var
  i:  word;
begin
  if wSize > 0 then
    for i := 0 to wSize-1 do mpbOut[i] := mpbOutSave[i];  
end;

procedure RepeatAction;
begin
  if (cbCurRepeat < frmMain.updRepeats.Position) then 
    with frmMain do begin
      Inc(cbCurRepeat);
      Inc(cbMaxRepeat); ShowRepeat;
      //AddTerminal('повтор: ' + IntToStr(cbCurRepeat),clGray);
      AddInfo('повтор: ' + IntToStr(cbCurRepeat) + ' из ' + IntToStr(frmMain.updRepeats.Position));
      LoadOut(quCurr.cwOut);  
      Query(quCurr, False);
    end;
end;

procedure BadSizeBox(wSize1,wSize2: word);
begin
  AddInfo('Неправильная длина ответа: ' + IntToStr(wSize1) + ' вместо ' + IntToStr(wSize2) + ' байт');
  RepeatAction; 
end;

procedure OtherActions(cwIn: word);
begin
  if cwIn <> quCurr.cwIn then
    BadSizeBox(cwIn,quCurr.cwIn)
  else begin
    cbCurRepeat := 0;
    BoxShow(quCurr.Action);
  end;  
end;

function Checksum(mpbT: array of byte; wSize: word): boolean;
var
  i:  word;
begin
  if wSize < 2 then 
    Result := False
  else begin
    i := CRC16(mpbIn,wSize);
    Result := (i = 0);
  end;
end;

function ChecksumUni(mpbT: array of byte; wSize: word): boolean;
var
  i:  word;
begin
  if wSize < 2 then
    Result := False
  else begin
    Result := CRC16(mpbIn,wSize) = 0;
  end;
end;

procedure PostInputComPort;
var
  i,wSize:  word;
begin
  with frmMain,ComPort do begin

    wSize := InBuffUsed;
    GetBlock(mpbIn, wSize);
    ShowInData(wSize);
    
    if quCurr.Action in [acUniOpen,acUniTransit] then begin
      if wSize = 0 then
        ErrBox('Нет ответа от устройства !')
      else if not ChecksumUni(mpbIn,wSize)
        then ErrBox('Ошибка контрольной суммы !')
      else
        OtherActions(wSize);

      exit;
    end;

    if frmMain.rgrTransit.ItemIndex = 1 then begin
      if (wSize = 0) then begin end
      else
      if (wSize <= 7) then begin
        AddInfo('Ошибка туннеля: малая длина ответа');
        RepeatAction;
      end  
      else
      if (wSize = 0) or (CRC16(mpbIn,wSize) <> 0) then begin
        AddInfo('Ошибка туннеля: нет ответа');
        RepeatAction;
      end  
      else if quCurr.Action <> acNone then begin
        for i := 0 to wSize-7 do mpbIn[i] := mpbIn[i+5];
        wSize := wSize-7;
        quCurr.cwIn := quCurr.cwIn-7;
        ShowInData(wSize);
      end;
    end;
    
    ShowTimeout;

    if quCurr.Action = acNone then begin
    end
    
    else if quCurr.Action = acTransit then begin
      ShowTransit;
    end

    else if (wSize = 0) and (cbCurRepeat < frmMain.updRepeats.Position) then begin
      RepeatAction;
    end
    else if not Checksum(mpbIn,wSize) and (cbCurRepeat < frmMain.updRepeats.Position) then begin
      RepeatAction;
    end

    else begin
      if wSize = 0 then 
        ErrBox('Нет ответа от устройства !')
      else if not Checksum(mpbIn,wSize) 
        then ErrBox('Ошибка контрольной суммы !') 
      else
        OtherActions(wSize);
    end;
  end;
end;

procedure PostInputSocket(s: string);
var
  i,wSize:  word;
begin
  with frmMain do begin
    wSize := Length(s);
    AddTerminal('// принято с сокета: ' + IntToStr(wSize) + ' байт',clGray);

    if wSize = 0 then exit;
    for i := 0 to Length(s) - 1 do  mpbIn[i] := Ord(s[i+1]);

    ShowInData(wSize);

    if quCurr.Action in [acUniOpen,acUniTransit] then begin
      if wSize = 0 then
        ErrBox('Нет ответа от устройства !')
      else if not ChecksumUni(mpbIn,wSize)
        then ErrBox('Ошибка контрольной суммы !')
      else
        OtherActions(wSize);

      exit;
    end;

    if frmMain.rgrTransit.ItemIndex = 1 then begin
      if (wSize = 0) then begin end
      else
      if (wSize <= 7) then begin
        AddInfo('Ошибка туннеля: малая длина ответа');
        RepeatAction;
      end
      else
      if (wSize = 0) or (CRC16(mpbIn,wSize) <> 0) then begin
        AddInfo('Ошибка туннеля: нет ответа');
        RepeatAction;
      end
      else if quCurr.Action <> acNone then begin
        for i := 0 to wSize-7 do mpbIn[i] := mpbIn[i+5];
        wSize := wSize-7;
        quCurr.cwIn := quCurr.cwIn-7;
        ShowInData(wSize);
      end;
    end;

    ShowTimeout;

    if quCurr.Action = acNone then begin
    end

    else if quCurr.Action = acTransit then begin
      ShowTransit;
    end

    else if (wSize = 0) and (cbCurRepeat < frmMain.updRepeats.Position) then begin
      RepeatAction;
    end
    else if not Checksum(mpbIn,wSize) and (cbCurRepeat < frmMain.updRepeats.Position) then begin
      RepeatAction;
    end

    else begin
      if wSize = 0 then
        ErrBox('Нет ответа от устройства !')
      else if not Checksum(mpbIn,wSize)
        then ErrBox('Ошибка контрольной суммы !')
      else
        OtherActions(wSize);
    end;
  end;
end;

end.

