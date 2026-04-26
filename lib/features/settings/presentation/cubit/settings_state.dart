import 'package:equatable/equatable.dart';
import '../../../../core/enums/alert_mode.dart';
import '../../domain/entities/app_settings.dart';

class SettingsState extends Equatable {
  final AppSettings settings;
  final String pingStatus; // idle | pinging | ok | fail
  final String testStatus; // idle | sending | ok | fail
  final bool isLoaded;

  const SettingsState({
    this.settings = const AppSettings(),
    this.pingStatus = 'idle',
    this.testStatus = 'idle',
    this.isLoaded = false,
  });

  String get language => settings.language;
  String get esp32Ip => settings.esp32Ip;
  AlertMode get alertMode => settings.alertMode;
  int get intensity => settings.intensity;
  double get earThreshold => settings.earThreshold;
  bool get deviceConnected => settings.deviceConnected;

  SettingsState copyWith({
    AppSettings? settings,
    String? pingStatus,
    String? testStatus,
    bool? isLoaded,
  }) =>
      SettingsState(
        settings: settings ?? this.settings,
        pingStatus: pingStatus ?? this.pingStatus,
        testStatus: testStatus ?? this.testStatus,
        isLoaded: isLoaded ?? this.isLoaded,
      );

  @override
  List<Object?> get props => [settings, pingStatus, testStatus, isLoaded];
}
