// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get monitoringActive => 'Monitoring Active';

  @override
  String get monitoringIdle => 'Monitoring Stopped';

  @override
  String get eyesOpen => 'Eyes Open';

  @override
  String get eyesClosed => 'Eyes Closed';

  @override
  String get warning => 'Warning! Wake up';

  @override
  String get setAlarm => 'Set Alarm';

  @override
  String get pulseIntensity => 'Pulse Intensity';

  @override
  String get calibration => 'Calibration';

  @override
  String get alarm => 'Alarm';

  @override
  String get settings => 'Settings';

  @override
  String get monitoring => 'Monitor';

  @override
  String get startMonitoring => 'Start Monitoring';

  @override
  String get stopMonitoring => 'Stop Monitoring';

  @override
  String get deviceConnected => 'Device Connected';

  @override
  String get deviceDisconnected => 'Device Disconnected';

  @override
  String get language => 'Language';

  @override
  String get intensity => 'Signal Intensity';

  @override
  String get alertMode => 'Alert Mode';

  @override
  String get vibration => 'Vibration';

  @override
  String get audio => 'Audio';

  @override
  String get electric => 'Electric Pulse';

  @override
  String get threshold => 'EAR Threshold';

  @override
  String get calibrateNow => 'Calibrate Now';

  @override
  String get eyesClosedWarn => 'Your eyes are closing!';

  @override
  String get awake => 'Awake';

  @override
  String get drowsy => 'Drowsy';

  @override
  String get asleep => 'Asleep';

  @override
  String get alarmTime => 'Alarm Time';

  @override
  String get stop => 'Stop';

  @override
  String get save => 'Save';

  @override
  String get earScore => 'Eye Openness Score';

  @override
  String get connecting => 'Connecting...';

  @override
  String get esp32Ip => 'ESP32 IP Address';

  @override
  String get testSignal => 'Test Signal';

  @override
  String get signalSent => 'Signal Sent';

  @override
  String get signalFailed => 'Device Unreachable';

  @override
  String get alarmActive => 'Alarm Active';

  @override
  String get alarmStopped => 'Alarm Stopped';

  @override
  String get cameraPermission => 'Camera permission required';

  @override
  String get grantPermission => 'Grant Permission';

  @override
  String get keepEyesOpen => 'Keep your eyes wide open...';

  @override
  String get calibrating => 'Calibrating...';

  @override
  String get calibrationDone => 'Calibration complete';

  @override
  String get esp32Address => 'ESP32 Address';

  @override
  String get pingDevice => 'Ping Device';

  @override
  String get calibrationInfo =>
      'EAR (Eye Aspect Ratio) — values below 0.20 indicate closed eyes, above 0.30 is fully open. Keep your eyes wide open during calibration.';
}
