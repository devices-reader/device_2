unit box;

interface

uses SysUtils, AdTapi, timez;

type
  actions =
  (
    acGetOpen,
    acGetTime,
    acGetVersion,
    acGetFlags,
    acGetId,
    acGetSummer,
    
    acGetTariffs1,
    acGetTariffs2,
    
    acGetTrans,
    acGetPulse1,
    acGetPulse2,
    acGetEngAbs,
    acGetEngAbsTar,
    acGetEngMon,
    acGetEngMonTar,    
    acGetEngDayCur,
    acGetEngDayCurTar,    
    acGetCalc1,        
    acGetCalc2,
    acGetGraphTop,
    acGetGraphTop10,
    acGetGraphTop11,
    acGetGraphTop2,
    
    acGetInfo1,
    acGetInfo2,
    acGetInfo3,
    acGetInfo4,
    acGetInfo5,
    acGetInfo6,
    acGetInfo7,
    acGetInfo8,
    acGetInfo9,
    acGetInfo10,
    acGetInfo11,
    acGetInfo12,
    acGetInfo13,
    acGetInfo14,
    acGetInfo15,
    acGetInfo16,

    acGetCurrent0,
    acGetCurrent1,
    acGetCurrent2,
    acGetCurrent3,
    acGetCurrent4,

    acNone,
    acTransit,
    acGetGraphData,
    acGetGraphData10,
    acGetGraphData11,
    acGetGraphData2,
    
    acGetOpen2,
    acGetTime2,
    acGetCorrect2,
    acGetSetup2,
    
    acGetFlags2,
    acGetSummer2,

    acGetDisableSeasonTime,
    acGetEnableSeasonTime,

    acUniOpen,
    acUniTransit
  );

  querys = record
    Action:     actions;
    cwOut:      word;
    cwIn:       word;
    bNumber:    byte;
  end;

procedure BoxCreate;
procedure BoxRun;
procedure BoxRead;
procedure BoxShow(ac: actions);

var
  cwConnect:  longword;
  tiCurr:     times;

implementation

uses main, support, progress, histograms,
get_open, get_time, get_version, get_flags, get_id, get_summer,
get_koeffs,
get_engabs, get_engabstar, get_engmon, get_engmontar, get_engdaycur, get_engdaycurtar,
get_tariffs, get_info, get_current,
get_calc1,
get_calc2,
get_graph_top, get_graph_top10, get_graph_top11, get_graph_top2,
get_graph_data, get_graph_data10, get_graph_data11, get_graph_data2,
get_open2, get_time2, get_correct2, get_setup2,
get_flags2, get_summer2,
get_disable_season_time, get_enable_season_time,
uni_open, uni_transit
;

var
  BoxStart:   TDateTime;
  iwBox:      word;

procedure BoxCreate;
var
  i:  word;
begin
  with frmMain.clbMain do begin
    for i := 1 to Ord(acNone) do Items.Add('?');
    Items[Ord(acGetOpen)]         := 'Открытие канала';
    Items[Ord(acGetTime)]         := 'Время';
    Items[Ord(acGetVersion)]      := 'Версия';
    Items[Ord(acGetFlags)]        := 'Конфигурация';
    Items[Ord(acGetId)]           := 'Логический номер';
    Items[Ord(acGetSummer)]       := 'Время переходов на летнее/зимнее время';
    
    Items[Ord(acGetTariffs1)]     := 'Тарифы 1';
    Items[Ord(acGetTariffs2)]     := 'Тарифы 2';
    Items[Ord(acGetTrans)]        := 'К. трансформации';
    Items[Ord(acGetPulse1)]       := 'К. преобразования 1';
    Items[Ord(acGetPulse2)]       := 'К. преобразования 2';
    Items[Ord(acGetEngAbs)]       := 'Энергия всего';
    Items[Ord(acGetEngAbsTar)]    := 'Энергия всего (по тарифам)';
    Items[Ord(acGetEngMon)]       := 'Энергия по месяцам';
    Items[Ord(acGetEngMonTar)]    := 'Энергия по месяцам (по тарифам)';
    Items[Ord(acGetEngDayCur)]    := 'Энергия за текущие сутки';
    Items[Ord(acGetEngDayCurTar)] := 'Энергия за текущие сутки (по тарифам)';
    Items[Ord(acGetCalc1)]        := 'Счетчики на начало текущих суток (по тарифам) - расчет';
    Items[Ord(acGetCalc2)]        := 'Счетчики по месяцам - расчет';
    Items[Ord(acGetGraphTop)]     := 'Энергия по получасам';
    Items[Ord(acGetGraphTop10)]   := 'Энергия по получасам x1 (для Меркурий-233 версии меньше 7.1.0)';
    Items[Ord(acGetGraphTop11)]   := 'Энергия по получасам x17 (для Меркурий-233 версии больше 7.1.0)';
    Items[Ord(acGetGraphTop2)]    := 'Энергия по получасам x20 (для ПРТ-М230)';
    
    Items[Ord(acGetInfo1)]      := GetInfoName(1);
    Items[Ord(acGetInfo2)]      := GetInfoName(2);
    Items[Ord(acGetInfo3)]      := GetInfoName(3);
    Items[Ord(acGetInfo4)]      := GetInfoName(4);
    Items[Ord(acGetInfo5)]      := GetInfoName(5);
    Items[Ord(acGetInfo6)]      := GetInfoName(6);
    Items[Ord(acGetInfo7)]      := GetInfoName(7);
    Items[Ord(acGetInfo8)]      := GetInfoName(8);
    Items[Ord(acGetInfo9)]      := GetInfoName(9);
    Items[Ord(acGetInfo10)]     := GetInfoName(10);
    Items[Ord(acGetInfo11)]     := GetInfoName(11);
    Items[Ord(acGetInfo12)]     := GetInfoName(12);
    Items[Ord(acGetInfo13)]     := GetInfoName(13);
    Items[Ord(acGetInfo14)]     := GetInfoName(14);
    Items[Ord(acGetInfo15)]     := GetInfoName(15);
    Items[Ord(acGetInfo16)]     := GetInfoName(16);

    Items[Ord(acGetCurrent0)]  := GetCurrentName(0);
    Items[Ord(acGetCurrent1)]  := GetCurrentName(1);
    Items[Ord(acGetCurrent2)]  := GetCurrentName(2);
    Items[Ord(acGetCurrent3)]  := GetCurrentName(3);
    Items[Ord(acGetCurrent4)]  := GetCurrentName(4);
  end;
end;

procedure BoxRun;
var
  b:  boolean;
begin
  with frmMain do begin
    with clbMain do  while (iwBox < Items.Count) do begin
      if Checked[iwBox] then begin
        case iwBox of
          Ord(acGetOpen):         begin BoxGetOpen;         Inc(iwBox); exit; end;
          Ord(acGetTime):         begin BoxGetTime;         Inc(iwBox); exit; end;
          Ord(acGetVersion):      begin BoxGetVersion;      Inc(iwBox); exit; end;
          Ord(acGetFlags):        begin BoxGetFlags;        Inc(iwBox); exit; end;
          Ord(acGetId):           begin BoxGetId;           Inc(iwBox); exit; end;
          Ord(acGetSummer):       begin BoxGetSummer;       Inc(iwBox); exit; end;

          Ord(acGetTariffs1):     begin BoxGetTariffs(True);    Inc(iwBox); exit; end;        
          Ord(acGetTariffs2):     begin BoxGetTariffs(False);   Inc(iwBox); exit; end;        
          Ord(acGetTrans):        begin BoxGetTrans;        Inc(iwBox); exit; end;
          Ord(acGetPulse1):       begin BoxGetPulse1;       Inc(iwBox); exit; end;
          Ord(acGetPulse2):       begin BoxGetPulse2;       Inc(iwBox); exit; end;
          Ord(acGetEngAbs):       begin BoxGetEngAbs;       Inc(iwBox); exit; end;
          Ord(acGetEngAbsTar):    begin BoxGetEngAbsTar;    Inc(iwBox); exit; end;        
          Ord(acGetEngMon):       begin BoxGetEngMon;       Inc(iwBox); exit; end;        
          Ord(acGetEngMonTar):    begin BoxGetEngMonTar;    Inc(iwBox); exit; end;        
          Ord(acGetEngDayCur):    begin BoxGetEngDayCur;    Inc(iwBox); exit; end;        
          Ord(acGetEngDayCurTar): begin BoxGetEngDayCurTar; Inc(iwBox); exit; end;
          Ord(acGetCalc1):        begin BoxGetCalc1;        Inc(iwBox); exit; end;        
          Ord(acGetCalc2):        begin BoxGetCalc2;        Inc(iwBox); exit; end;
          Ord(acGetGraphTop):     begin BoxGetGraphTop;     Inc(iwBox); exit; end;        
          Ord(acGetGraphTop2):    begin BoxGetGraphTop2;    Inc(iwBox); exit; end;        
          Ord(acGetGraphTop10):   begin BoxGetGraphTop10;   Inc(iwBox); exit; end;
          Ord(acGetGraphTop11):   begin BoxGetGraphTop11;   Inc(iwBox); exit; end;
          
          Ord(acGetInfo1):      begin BoxGetInfo(1);   Inc(iwBox); exit; end;
          Ord(acGetInfo2):      begin BoxGetInfo(2);   Inc(iwBox); exit; end;
          Ord(acGetInfo3):      begin BoxGetInfo(3);   Inc(iwBox); exit; end;
          Ord(acGetInfo4):      begin BoxGetInfo(4);   Inc(iwBox); exit; end;
          Ord(acGetInfo5):      begin BoxGetInfo(5);   Inc(iwBox); exit; end;
          Ord(acGetInfo6):      begin BoxGetInfo(6);   Inc(iwBox); exit; end;
          Ord(acGetInfo7):      begin BoxGetInfo(7);   Inc(iwBox); exit; end;
          Ord(acGetInfo8):      begin BoxGetInfo(8);   Inc(iwBox); exit; end;
          Ord(acGetInfo9):      begin BoxGetInfo(9);   Inc(iwBox); exit; end;
          Ord(acGetInfo10):     begin BoxGetInfo(10);  Inc(iwBox); exit; end;
          Ord(acGetInfo11):     begin BoxGetInfo(11);  Inc(iwBox); exit; end;
          Ord(acGetInfo12):     begin BoxGetInfo(12);  Inc(iwBox); exit; end;
          Ord(acGetInfo13):     begin BoxGetInfo(13);  Inc(iwBox); exit; end;
          Ord(acGetInfo14):     begin BoxGetInfo(14);  Inc(iwBox); exit; end;
          Ord(acGetInfo15):     begin BoxGetInfo(15);  Inc(iwBox); exit; end;
          Ord(acGetInfo16):     begin BoxGetInfo(16);  Inc(iwBox); exit; end;

          Ord(acGetCurrent0):  begin BoxGetCurrent(0); Inc(iwBox); exit; end;
          Ord(acGetCurrent1):  begin BoxGetCurrent(1); Inc(iwBox); exit; end;
          Ord(acGetCurrent2):  begin BoxGetCurrent(2); Inc(iwBox); exit; end;
          Ord(acGetCurrent3):  begin BoxGetCurrent(3); Inc(iwBox); exit; end;
          Ord(acGetCurrent4):  begin BoxGetCurrent(4); Inc(iwBox); exit; end;

          else ErrBox('Ошибка при задании списка запросов !');
        end;
      end;
      Inc(iwBox);
    end;

    AddInfo('');
    AddInfo('');
    AddInfo('Начало опроса: '+Times2Str(ToTimes(BoxStart)));
    AddInfo('Конец опроса:  '+Times2Str(ToTimes(Now)));
    AddInfo('Длительность опроса:'+DeltaTimes2Str(ToTimes(BoxStart)));
{
    b := False;
    if (TapiDevice.TapiState = tsConnected) and (chbCancelCall.Checked) then begin
      b := True;
      btbCancelCallClick(nil);
    end;

    if b then begin
      AddInfo(' ');
      AddInfo('Cоединение: ' + IntToStr(timNow.Interval * cwConnect div 1000) + ' секунд');
    end;
}
    AddInfo(' ');
    AddInfo('Опрос успешно завершен: '+mitVersion.Caption);

    HistogramsReport;

    ShowProgress(-1, 1);
  end;
end;

procedure BoxRead;
begin
  with frmMain do begin
    with clbMain do begin    
      Checked[Ord(acGetOpen)] := True;

      if Checked[Ord(acGetCalc1)] 
      then begin
        Checked[Ord(acGetEngAbsTar)] := True;
        Checked[Ord(acGetEngDayCurTar)] := True;
      end;    
      if Checked[Ord(acGetCalc2)] 
      then begin
        Checked[Ord(acGetEngAbs)] := True;
        Checked[Ord(acGetEngDayCur)] := True;
        Checked[Ord(acGetEngMon)] := True;
      end;    
      
      if Checked[Ord(acGetEngAbs)] or
         Checked[Ord(acGetEngAbsTar)] or
         Checked[Ord(acGetEngMon)] or
         Checked[Ord(acGetEngMonTar)] or
         Checked[Ord(acGetEngDayCur)] or
         Checked[Ord(acGetEngDayCurTar)] 
      then begin
        Checked[Ord(acGetTime)] := True;
        Checked[Ord(acGetTrans)] := True;
      end;    
      
      if Checked[Ord(acGetGraphTop)] or
         Checked[Ord(acGetGraphTop10)] or
         Checked[Ord(acGetGraphTop11)] or
         Checked[Ord(acGetGraphTop2)]
      then begin
        Checked[Ord(acGetTime)] := True;
        Checked[Ord(acGetTrans)] := True;
      end;    
      
      if Checked[Ord(acGetTrans)]
      then begin
        if (Checked[Ord(acGetPulse1)] and Checked[Ord(acGetPulse2)]) or
           (not Checked[Ord(acGetPulse1)] and not Checked[Ord(acGetPulse2)]) then begin 
          WrnBox('Необходимо задать один из двух вариантов чтения К. преобразования'); Abort;
        end;
      end;    
      
      if Checked[Ord(acGetSummer)]
      then begin
        Checked[Ord(acGetTime)] := True;
        Checked[Ord(acGetFlags)] := True;
      end;
    end;

    BoxStart := Now;
    
    AddInfo('');
    AddInfo('');
    AddInfo('Cчетчик: номер '+IntToStr(GetDeviceAddr));
    
    iwBox := 0;
    BoxRun;
  end;
end;

procedure BoxShow(ac: actions);
begin
  case ac of
    acGetOpen:          ShowGetOpen;
    acGetTime:          ShowGetTime;
    acGetVersion:       ShowGetVersion;
    acGetFlags:         ShowGetFlags;
    acGetId:            ShowGetId;
    acGetSummer:        ShowGetSummer;
    
    acGetTariffs1:      ShowGetTariffs(True);
    acGetTariffs2:      ShowGetTariffs(False);
    acGetTrans:         ShowGetTrans;
    acGetPulse1:        ShowGetPulse1;
    acGetPulse2:        ShowGetPulse2;
    acGetEngAbs:        ShowGetEngAbs;
    acGetEngAbsTar:     ShowGetEngAbsTar;
    acGetEngMon:        ShowGetEngMon;
    acGetEngMonTar:     ShowGetEngMonTar;
    acGetEngDayCur:     ShowGetEngDayCur;    
    acGetEngDayCurTar:  ShowGetEngDayCurTar;
    acGetCalc1:         ShowGetCalc1;
    acGetCalc2:         ShowGetCalc2;
    
    acGetGraphTop:      ShowGetGraphTop;
    acGetGraphData:     ShowGetGraphData;

    acGetGraphTop10:    ShowGetGraphTop10;
    acGetGraphData10:   ShowGetGraphData10;
    
    acGetGraphTop11:    ShowGetGraphTop11;
    acGetGraphData11:   ShowGetGraphData11;

    acGetGraphTop2:     ShowGetGraphTop2;
    acGetGraphData2:    ShowGetGraphData2;
    
    acGetInfo1:       ShowGetInfo(1);
    acGetInfo2:       ShowGetInfo(2);
    acGetInfo3:       ShowGetInfo(3);
    acGetInfo4:       ShowGetInfo(4);
    acGetInfo5:       ShowGetInfo(5);
    acGetInfo6:       ShowGetInfo(6);
    acGetInfo7:       ShowGetInfo(7);
    acGetInfo8:       ShowGetInfo(8);
    acGetInfo9:       ShowGetInfo(9);
    acGetInfo10:      ShowGetInfo(10);
    acGetInfo11:      ShowGetInfo(11);
    acGetInfo12:      ShowGetInfo(12);
    acGetInfo13:      ShowGetInfo(13);
    acGetInfo14:      ShowGetInfo(14);
    acGetInfo15:      ShowGetInfo(15);
    acGetInfo16:      ShowGetInfo(16);

    acGetCurrent0:    ShowGetCurrent(0);
    acGetCurrent1:    ShowGetCurrent(1);
    acGetCurrent2:    ShowGetCurrent(2);
    acGetCurrent3:    ShowGetCurrent(3);
    acGetCurrent4:    ShowGetCurrent(4);

    acGetOpen2:       ShowGetOpen2;
    acGetTime2:       ShowGetTime2;
    acGetCorrect2:    ShowGetCorrect2;
    acGetSetup2:      ShowGetSetup2;

    acGetFlags2:      ShowGetFlags2;
    acGetSummer2:     ShowGetSummer2;

    acGetDisableSeasonTime: ShowGetDisableSeasonTime;
    acGetEnableSeasonTime:  ShowGetEnableSeasonTime;

    acUniOpen:        ShowUniOpen;
    acUniTransit:     ShowUniTransit;
  end;
end;

end.

