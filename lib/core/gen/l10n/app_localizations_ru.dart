// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get monitoringActive => 'Мониторинг активен';

  @override
  String get monitoringIdle => 'Мониторинг остановлен';

  @override
  String get eyesOpen => 'Глаза открыты';

  @override
  String get eyesClosed => 'Глаза закрыты';

  @override
  String get warning => 'Внимание! Проснитесь';

  @override
  String get setAlarm => 'Настройка будильника';

  @override
  String get pulseIntensity => 'Сила тока';

  @override
  String get calibration => 'Калибровка';

  @override
  String get alarm => 'Будильник';

  @override
  String get settings => 'Настройки';

  @override
  String get monitoring => 'Монитор';

  @override
  String get startMonitoring => 'Начать мониторинг';

  @override
  String get stopMonitoring => 'Остановить мониторинг';

  @override
  String get deviceConnected => 'Устройство подключено';

  @override
  String get deviceDisconnected => 'Устройство не подключено';

  @override
  String get language => 'Язык';

  @override
  String get intensity => 'Интенсивность сигнала';

  @override
  String get alertMode => 'Тип сигнала';

  @override
  String get vibration => 'Вибрация';

  @override
  String get audio => 'Звук';

  @override
  String get electric => 'Электрический импульс';

  @override
  String get threshold => 'Порог EAR';

  @override
  String get calibrateNow => 'Калибровать';

  @override
  String get eyesClosedWarn => 'Ваши глаза закрываются!';

  @override
  String get awake => 'Бодрствует';

  @override
  String get drowsy => 'Сонный';

  @override
  String get asleep => 'Спит';

  @override
  String get alarmTime => 'Время будильника';

  @override
  String get stop => 'Стоп';

  @override
  String get save => 'Сохранить';

  @override
  String get earScore => 'Степень открытости глаз';

  @override
  String get connecting => 'Подключение...';

  @override
  String get esp32Ip => 'IP адрес ESP32';

  @override
  String get testSignal => 'Тест сигнала';

  @override
  String get signalSent => 'Сигнал отправлен';

  @override
  String get signalFailed => 'Устройство недоступно';

  @override
  String get alarmActive => 'Будильник активен';

  @override
  String get alarmStopped => 'Будильник остановлен';

  @override
  String get cameraPermission => 'Необходим доступ к камере';

  @override
  String get grantPermission => 'Разрешить';

  @override
  String get keepEyesOpen => 'Держите глаза широко открытыми...';

  @override
  String get calibrating => 'Калибровка...';

  @override
  String get calibrationDone => 'Калибровка завершена';

  @override
  String get esp32Address => 'Адрес ESP32';

  @override
  String get pingDevice => 'Проверить устройство';

  @override
  String get calibrationInfo =>
      'EAR (Соотношение сторон глаза) — ниже 0.20 означает закрытые глаза, выше 0.30 — полностью открытые. Держите глаза широко открытыми во время калибровки.';
}
