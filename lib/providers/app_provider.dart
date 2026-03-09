//app_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AlertMode { vibration, audio, electric }
enum MonitoringStatus { idle, monitoring, warning, sleeping }

const Map<String, Map<String, String>> _strings = {
  'uz': {
    'monitoringActive': 'Monitoring faol',
    'monitoringIdle': "Monitoring to'xtatilgan",
    'eyesOpen': "Ko'z ochiq",
    'eyesClosed': "Ko'z yumiq",
    'warning': "Diqqat! Uyg'oning",
    'setAlarm': 'Budilnikni sozlash',
    'pulseIntensity': 'Tok kuchi',
    'calibration': 'Kalibrasiya',
    'alarm': 'Budilnik',
    'settings': 'Sozlamalar',
    'monitoring': 'Monitoring',
    'startMonitoring': 'Monitoringni boshlash',
    'stopMonitoring': "Monitoringni to'xtatish",
    'deviceConnected': 'Qurilma ulangan',
    'deviceDisconnected': 'Qurilma ulanmagan',
    'language': 'Til',
    'intensity': 'Signal kuchi',
    'alertMode': 'Signal turi',
    'vibration': 'Vibratsiya',
    'audio': 'Ovoz',
    'electric': 'Elektr impuls',
    'threshold': 'Chegaraviy qiymat',
    'calibrateNow': 'Kalibrasiya qilish',
    'eyesClosed_warn': "Ko'zingiz yumilmoqda!",
    'awake': "Uyg'oq",
    'drowsy': 'Uyquchan',
    'asleep': 'Uxlayapti',
    'alarmTime': 'Budilnik vaqti',
    'stop': "To'xtatish",
    'save': 'Saqlash',
    'earScore': "Ko'z ochiq darajasi",
    'connecting': 'Ulanmoqda...',
    'esp32Ip': 'ESP32 IP manzil',
    'testSignal': "Signal sinovdan o'tkazish",
    'signalSent': 'Signal yuborildi',
    'signalFailed': "Qurilma bilan aloqa yo'q",
    'alarmActive': 'Budilnik faol',
    'alarmStopped': "Budilnik to'xtatildi",
    'cameraPermission': 'Kamera ruxsati kerak',
    'grantPermission': 'Ruxsat berish',
    'keepEyesOpen': "Ko'zingizni keng oching...",
    'calibrating': 'Kalibrasiya...',
    'calibrationDone': 'Kalibrasiya yakunlandi',
    'esp32Address': 'ESP32 manzili',
    'pingDevice': 'Qurilmani tekshirish',
  },
  'en': {
    'monitoringActive': 'Monitoring Active',
    'monitoringIdle': 'Monitoring Stopped',
    'eyesOpen': 'Eyes Open',
    'eyesClosed': 'Eyes Closed',
    'warning': 'Warning! Wake up',
    'setAlarm': 'Set Alarm',
    'pulseIntensity': 'Pulse Intensity',
    'calibration': 'Calibration',
    'alarm': 'Alarm',
    'settings': 'Settings',
    'monitoring': 'Monitor',
    'startMonitoring': 'Start Monitoring',
    'stopMonitoring': 'Stop Monitoring',
    'deviceConnected': 'Device Connected',
    'deviceDisconnected': 'Device Disconnected',
    'language': 'Language',
    'intensity': 'Signal Intensity',
    'alertMode': 'Alert Mode',
    'vibration': 'Vibration',
    'audio': 'Audio',
    'electric': 'Electric Pulse',
    'threshold': 'EAR Threshold',
    'calibrateNow': 'Calibrate Now',
    'eyesClosed_warn': 'Your eyes are closing!',
    'awake': 'Awake',
    'drowsy': 'Drowsy',
    'asleep': 'Asleep',
    'alarmTime': 'Alarm Time',
    'stop': 'Stop',
    'save': 'Save',
    'earScore': 'Eye Openness Score',
    'connecting': 'Connecting...',
    'esp32Ip': 'ESP32 IP Address',
    'testSignal': 'Test Signal',
    'signalSent': 'Signal Sent',
    'signalFailed': 'Device Unreachable',
    'alarmActive': 'Alarm Active',
    'alarmStopped': 'Alarm Stopped',
    'cameraPermission': 'Camera permission required',
    'grantPermission': 'Grant Permission',
    'keepEyesOpen': 'Keep your eyes wide open...',
    'calibrating': 'Calibrating...',
    'calibrationDone': 'Calibration complete',
    'esp32Address': 'ESP32 Address',
    'pingDevice': 'Ping Device',
  },
  'ru': {
    'monitoringActive': 'Мониторинг активен',
    'monitoringIdle': 'Мониторинг остановлен',
    'eyesOpen': 'Глаза открыты',
    'eyesClosed': 'Глаза закрыты',
    'warning': 'Внимание! Проснитесь',
    'setAlarm': 'Настройка будильника',
    'pulseIntensity': 'Сила тока',
    'calibration': 'Калибровка',
    'alarm': 'Будильник',
    'settings': 'Настройки',
    'monitoring': 'Монитор',
    'startMonitoring': 'Начать мониторинг',
    'stopMonitoring': 'Остановить мониторинг',
    'deviceConnected': 'Устройство подключено',
    'deviceDisconnected': 'Устройство не подключено',
    'language': 'Язык',
    'intensity': 'Интенсивность сигнала',
    'alertMode': 'Тип сигнала',
    'vibration': 'Вибрация',
    'audio': 'Звук',
    'electric': 'Электрический импульс',
    'threshold': 'Порог EAR',
    'calibrateNow': 'Калибровать',
    'eyesClosed_warn': 'Ваши глаза закрываются!',
    'awake': 'Бодрствует',
    'drowsy': 'Сонный',
    'asleep': 'Спит',
    'alarmTime': 'Время будильника',
    'stop': 'Стоп',
    'save': 'Сохранить',
    'earScore': 'Степень открытости глаз',
    'connecting': 'Подключение...',
    'esp32Ip': 'IP адрес ESP32',
    'testSignal': 'Тест сигнала',
    'signalSent': 'Сигнал отправлен',
    'signalFailed': 'Устройство недоступно',
    'alarmActive': 'Будильник активен',
    'alarmStopped': 'Будильник остановлен',
    'cameraPermission': 'Необходим доступ к камере',
    'grantPermission': 'Разрешить',
    'keepEyesOpen': 'Держите глаза широко открытыми...',
    'calibrating': 'Калибровка...',
    'calibrationDone': 'Калибровка завершена',
    'esp32Address': 'Адрес ESP32',
    'pingDevice': 'Проверить устройство',
  },
};

class AppProvider extends ChangeNotifier {
  String _language = 'uz';
  AlertMode _alertMode = AlertMode.vibration;
  int _intensity = 3;
  double _earThreshold = 0.25;
  String _esp32Ip = '192.168.4.1';
  TimeOfDay? _alarmTime;
  bool _alarmEnabled = false;

  MonitoringStatus _monitoringStatus = MonitoringStatus.idle;
  bool _isMonitoring = false;
  double _earScore = 0.35;
  bool _deviceConnected = false;

  String get language => _language;
  AlertMode get alertMode => _alertMode;
  int get intensity => _intensity;
  double get earThreshold => _earThreshold;
  String get esp32Ip => _esp32Ip;
  TimeOfDay? get alarmTime => _alarmTime;
  bool get alarmEnabled => _alarmEnabled;
  MonitoringStatus get monitoringStatus => _monitoringStatus;
  bool get isMonitoring => _isMonitoring;
  double get earScore => _earScore;
  bool get deviceConnected => _deviceConnected;

  String t(String key) => _strings[_language]?[key] ?? key;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _language = prefs.getString('language') ?? 'uz';
    _alertMode = AlertMode.values[prefs.getInt('alertMode') ?? 0];
    _intensity = prefs.getInt('intensity') ?? 3;
    _earThreshold = prefs.getDouble('earThreshold') ?? 0.25;
    _esp32Ip = prefs.getString('esp32Ip') ?? '192.168.4.1';
    _alarmEnabled = prefs.getBool('alarmEnabled') ?? false;
    final alarmH = prefs.getInt('alarmHour');
    final alarmM = prefs.getInt('alarmMinute');
    if (alarmH != null && alarmM != null) {
      _alarmTime = TimeOfDay(hour: alarmH, minute: alarmM);
    }
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', _language);
    await prefs.setInt('alertMode', _alertMode.index);
    await prefs.setInt('intensity', _intensity);
    await prefs.setDouble('earThreshold', _earThreshold);
    await prefs.setString('esp32Ip', _esp32Ip);
    await prefs.setBool('alarmEnabled', _alarmEnabled);
    if (_alarmTime != null) {
      await prefs.setInt('alarmHour', _alarmTime!.hour);
      await prefs.setInt('alarmMinute', _alarmTime!.minute);
    }
  }

  void setLanguage(String lang) {
    _language = lang;
    _save();
    notifyListeners();
  }

  void setAlertMode(AlertMode mode) {
    _alertMode = mode;
    _save();
    notifyListeners();
  }

  void setIntensity(int v) {
    _intensity = v;
    _save();
    notifyListeners();
  }

  void setEarThreshold(double v) {
    _earThreshold = v;
    _save();
    notifyListeners();
  }

  void setEsp32Ip(String ip) {
    _esp32Ip = ip;
    _save();
    notifyListeners();
  }

  void setAlarmTime(TimeOfDay time) {
    _alarmTime = time;
    _save();
    notifyListeners();
  }

  void setAlarmEnabled(bool v) {
    _alarmEnabled = v;
    _save();
    notifyListeners();
  }

  void setMonitoringStatus(MonitoringStatus s) {
    _monitoringStatus = s;
    notifyListeners();
  }

  void setIsMonitoring(bool v) {
    _isMonitoring = v;
    if (!v) _monitoringStatus = MonitoringStatus.idle;
    notifyListeners();
  }

  void setEarScore(double v) {
    _earScore = v;
    notifyListeners();
  }

  void setDeviceConnected(bool v) {
    _deviceConnected = v;
    notifyListeners();
  }
}
