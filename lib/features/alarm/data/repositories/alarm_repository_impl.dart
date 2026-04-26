import '../../domain/entities/alarm_config.dart';
import '../../domain/repositories/alarm_repository.dart';
import '../data_sources/alarm_data_source.dart';

class AlarmRepositoryImpl implements AlarmRepository {
  final AlarmDataSource _dataSource;

  AlarmRepositoryImpl(this._dataSource);

  @override
  Future<AlarmConfig> loadConfig() => _dataSource.loadConfig();

  @override
  Future<void> saveConfig(AlarmConfig config) => _dataSource.saveConfig(config);

  @override
  Stream<void> get alarmStream => _dataSource.alarmStream;

  @override
  void scheduleAlarm(int hour, int minute) => _dataSource.schedule(hour, minute);

  @override
  void cancelAlarm() => _dataSource.cancel();

  @override
  void dispose() => _dataSource.dispose();
}
