import '../entities/alarm_config.dart';

abstract class AlarmRepository {
  Future<AlarmConfig> loadConfig();
  Future<void> saveConfig(AlarmConfig config);
  Stream<void> get alarmStream;
  void scheduleAlarm(int hour, int minute);
  void cancelAlarm();
  void dispose();
}
