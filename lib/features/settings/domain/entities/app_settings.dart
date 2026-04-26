import 'package:equatable/equatable.dart';
import '../../../../core/enums/alert_mode.dart';

class AppSettings extends Equatable {
  final String language;
  final String esp32Ip;
  final AlertMode alertMode;
  final int intensity;
  final double earThreshold;
  final bool deviceConnected;

  const AppSettings({
    this.language = 'uz',
    this.esp32Ip = '192.168.4.1',
    this.alertMode = AlertMode.vibration,
    this.intensity = 3,
    this.earThreshold = 0.25,
    this.deviceConnected = false,
  });

  AppSettings copyWith({
    String? language,
    String? esp32Ip,
    AlertMode? alertMode,
    int? intensity,
    double? earThreshold,
    bool? deviceConnected,
  }) =>
      AppSettings(
        language: language ?? this.language,
        esp32Ip: esp32Ip ?? this.esp32Ip,
        alertMode: alertMode ?? this.alertMode,
        intensity: intensity ?? this.intensity,
        earThreshold: earThreshold ?? this.earThreshold,
        deviceConnected: deviceConnected ?? this.deviceConnected,
      );

  @override
  List<Object?> get props =>
      [language, esp32Ip, alertMode, intensity, earThreshold, deviceConnected];
}
