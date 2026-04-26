import '../../../../core/enums/alert_mode.dart';
import '../../domain/repositories/device_repository.dart';
import '../data_sources/esp32_data_source.dart';

const _modeMap = {
  AlertMode.vibration: 'VIBRATE',
  AlertMode.audio: 'AUDIO_ALARM',
  AlertMode.electric: 'ELECTRIC_PULSE',
};

class DeviceRepositoryImpl implements DeviceRepository {
  final Esp32DataSource _dataSource;

  DeviceRepositoryImpl(this._dataSource);

  @override
  Future<bool> ping() => _dataSource.ping();

  @override
  Future<bool> sendAlert({required AlertMode mode, required int intensity}) =>
      _dataSource.sendAction(mode: _modeMap[mode] ?? 'VIBRATE', power: intensity);

  @override
  Future<bool> testSignal({required int intensity}) =>
      _dataSource.sendAction(mode: 'TEST', power: intensity);

  @override
  Future<bool> triggerAlarm({required int intensity}) =>
      _dataSource.sendAction(mode: 'ALARM_WAKEUP', power: intensity);
}
