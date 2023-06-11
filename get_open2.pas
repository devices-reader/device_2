unit get_open2;

interface

uses box;

procedure BoxGetOpen2(ac: actions);
procedure ShowGetOpen2;

implementation

uses SysUtils, support, soutput, timez, get_time2, get_correct2, get_setup2,
  get_disable_season_time, get_enable_season_time;

var
  acNext: actions;
  
const
  quGetOpen2:  querys = (Action: acGetOpen2; cwOut: 3+6+2; cwIn: 1+1+2; bNumber: 0);
  
procedure QueryGetOpen2(ac: actions);
var
  s:  string;
begin
  acNext := ac;
  
  try
    s := GetDevicePass;
    if Length(s) <> 6 then raise Exception.Create('Неправильная длина пароля !');    
    if not 
      ((s[1] in ['0'..'9']) and
       (s[2] in ['0'..'9']) and    
       (s[3] in ['0'..'9']) and    
       (s[4] in ['0'..'9']) and    
       (s[5] in ['0'..'9']) and    
       (s[6] in ['0'..'9'])) then raise Exception.Create('Неправильные символы пароля !');    
       
    InitPushZero;
    PushByte(GetDeviceAddr);
    PushByte(1);
    PushByte(2);
  
    PushByte(Ord(s[1])-Ord('0'));
    PushByte(Ord(s[2])-Ord('0'));
    PushByte(Ord(s[3])-Ord('0'));
    PushByte(Ord(s[4])-Ord('0'));
    PushByte(Ord(s[5])-Ord('0'));
    PushByte(Ord(s[6])-Ord('0'));
    Query(quGetOpen2, True);
  except
    ErrBox('Пароль счетчика задан неправильно !');
  end;    
end;

procedure BoxGetOpen2(ac: actions);
begin
  AddInfo('');
  AddInfo('Открытие канала');
  QueryGetOpen2(ac);
end;

procedure ShowGetOpen2;
var
  i:    byte;
begin
  Stop;
  InitPop(1);

  i := PopByte;
  if i = 0 then begin
    AddInfo('Канал открыт успешно');
    
    if acNext = acGetTime2 then 
      BoxGetTime2
    else if acNext = acGetCorrect2 then 
      BoxGetCorrect2
    else if acNext = acGetSetup2 then 
      BoxGetSetup2
    else if acNext = acGetDisableSeasonTime then
      BoxGetDisableSeasonTime
    else if acNext = acGetEnableSeasonTime then
      BoxGetEnableSeasonTime
    else 
      ErrBox('Неизвестный запрос !');  
  end  
  else begin
    WrnBox('Ошибка открытия канала - код '+IntToHex(i,2));  
  end;  
end;

end.
