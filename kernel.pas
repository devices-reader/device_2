unit kernel;

interface

const
  MONTHS        = 12;
  DAYS          = 28;
  
  panCOMPORT    = 0;
  panREPEATS    = 1;
  panCONNECT    = 2;
  panTIMEOUT    = 3;
  panNOW        = 4;
  panPROGRESS   = 5;

  SETTING:    string  = 'Настройки';
  COM_PORT:   string  = 'COM_порт';
  MODEM:      string  = 'Модем';
  SOCKET:     string  = 'Сокет';
  PARAMS:     string  = 'Параметры';

  NUMBER:     string  = 'Порт';
  BAUD:       string  = 'Скорость';
  PARITY:     string  = 'Чётность';
  TIMEOUT:    string  = 'Таймаут';
  DIAL:       string  = 'Номер';
  DEVICE:     string  = 'Устройство';
  HOST:       string  = 'Хост';
  PORT:       string  = 'Порт';
  ADDRESS:    string  = 'Адрес';
  PACKET:     string  = 'Пакет';
  PASSWORD:   string  = 'Пароль';
  MODE:       string  = 'Режим';
  VERSION:    string  = 'Версия';

  stSETTING:    string  = 'Настройки';
  stCOMNUMBER:  string  = 'Порт';
  stBAUD:       string  = 'Скорость';
  stPARITY:     string  = 'Чётность';
  stTIMEOUT:    string  = 'Таймаут';
  stSER_ADDR:   string  = 'Адрес';
  stDIAL:       string  = 'Номер';
  stDEVICE:     string  = 'Устройство';

  stDEV_ADDR:   string  = 'Счетчик';
  stDEV_PASS:   string  = 'Пароль';

  stPARAMS:     string  = 'Параметры';
  stDIGITS:     string  = 'Знаков_после_запятой';
  stCOLWIDTH:   string  = 'Ширина_столбца';
  stREPEATS:    string  = 'Повторы';
  stTRANSIT:    string  = 'Транзит';
  stTUNNEL:     string  = 'Туннель';
  stDAYS_MIN1:  string  = 'Сутки1_от';
  stDAYS_MAX1:  string  = 'Сутки1_до';
  stDAYS_MIN2:  string  = 'Сутки2_от';
  stDAYS_MAX2:  string  = 'Сутки2_до';
  stMONTHS_MIN: string  = 'Месяцы_от';
  stMONTHS_MAX: string  = 'Месяцы_до';

  stOPTIONS:    string  = 'Опции';
  stINQUIRY:    string  = 'Запрос_';

  LOGS_DIR:     string  = 'log';
  
implementation

end.
