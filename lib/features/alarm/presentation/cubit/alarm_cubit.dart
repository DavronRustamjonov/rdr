import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../device/domain/repositories/device_repository.dart';
import '../../../settings/domain/repositories/settings_repository.dart';
import '../../domain/entities/alarm_config.dart';
import '../../domain/repositories/alarm_repository.dart';
import 'alarm_state.dart';

class AlarmCubit extends Cubit<AlarmState> {
  final AlarmRepository _alarmRepository;
  final DeviceRepository _deviceRepository;
  final SettingsRepository _settingsRepository;

  StreamSubscription<void>? _alarmSub;

  AlarmCubit({
    required AlarmRepository alarmRepository,
    required DeviceRepository deviceRepository,
    required SettingsRepository settingsRepository,
  })  : _alarmRepository = alarmRepository,
        _deviceRepository = deviceRepository,
        _settingsRepository = settingsRepository,
        super(const AlarmInitial()) {
    _load();
  }

  Future<void> _load() async {
    final config = await _alarmRepository.loadConfig();
    emit(AlarmReady(config));
  }

  Future<void> setTime(int hour, int minute) async {
    final current = _currentConfig;
    final updated = current.copyWith(hour: hour, minute: minute);
    await _alarmRepository.saveConfig(updated);
    emit(AlarmReady(updated));
  }

  Future<void> saveAndSchedule() async {
    final current = _currentConfig;
    if (!current.hasTime) return;
    HapticFeedback.heavyImpact();
    final scheduled = current.copyWith(enabled: true);
    await _alarmRepository.saveConfig(scheduled);
    _alarmRepository.scheduleAlarm(scheduled.hour!, scheduled.minute!);

    await _alarmSub?.cancel();
    _alarmSub = _alarmRepository.alarmStream.listen((_) => _onAlarmFired());

    emit(AlarmScheduled(scheduled));
  }

  Future<void> stopAlarm() async {
    HapticFeedback.heavyImpact();
    _alarmRepository.cancelAlarm();
    await _alarmSub?.cancel();
    _alarmSub = null;
    final config = _currentConfig.copyWith(enabled: false);
    await _alarmRepository.saveConfig(config);
    emit(AlarmReady(config));
  }

  Future<void> _onAlarmFired() async {
    if (isClosed) return;
    HapticFeedback.heavyImpact();
    emit(AlarmFired(_currentConfig));
    final s = _settingsRepository.current;
    await _deviceRepository.triggerAlarm(intensity: s.intensity);
  }

  AlarmConfig get _currentConfig {
    final s = state;
    if (s is AlarmReady) return s.config;
    if (s is AlarmScheduled) return s.config;
    if (s is AlarmFired) return s.config;
    return const AlarmConfig();
  }

  @override
  Future<void> close() async {
    await _alarmSub?.cancel();
    _alarmRepository.dispose();
    return super.close();
  }
}
