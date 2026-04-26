import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/enums/alert_mode.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_settings.dart';
import '../../domain/usecases/save_settings.dart';
import '../../../device/domain/usecases/ping_device.dart';
import '../../../device/domain/usecases/test_signal.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetSettings _getSettings;
  final SaveSettings _saveSettings;
  final PingDevice _pingDevice;
  final TestSignal _testSignal;

  SettingsCubit({
    required GetSettings getSettings,
    required SaveSettings saveSettings,
    required PingDevice pingDevice,
    required TestSignal testSignal,
  })  : _getSettings = getSettings,
        _saveSettings = saveSettings,
        _pingDevice = pingDevice,
        _testSignal = testSignal,
        super(const SettingsState());

  Future<void> loadSettings() async {
    final settings = await _getSettings(const NoParams());
    emit(state.copyWith(settings: settings, isLoaded: true));
  }

  Future<void> setLanguage(String lang) async {
    final updated = state.settings.copyWith(language: lang);
    emit(state.copyWith(settings: updated));
    await _saveSettings(updated);
  }

  Future<void> setEsp32Ip(String ip) async {
    final updated = state.settings.copyWith(esp32Ip: ip);
    emit(state.copyWith(settings: updated));
    await _saveSettings(updated);
  }

  Future<void> setAlertMode(AlertMode mode) async {
    final updated = state.settings.copyWith(alertMode: mode);
    emit(state.copyWith(settings: updated));
    await _saveSettings(updated);
  }

  Future<void> setIntensity(int v) async {
    final updated = state.settings.copyWith(intensity: v);
    emit(state.copyWith(settings: updated));
    await _saveSettings(updated);
  }

  Future<void> setEarThreshold(double v) async {
    final updated = state.settings.copyWith(earThreshold: v);
    emit(state.copyWith(settings: updated));
    await _saveSettings(updated);
  }

  Future<void> pingDevice() async {
    emit(state.copyWith(pingStatus: 'pinging'));
    final ok = await _pingDevice(const NoParams());
    final updated = state.settings.copyWith(deviceConnected: ok);
    emit(state.copyWith(
      settings: updated,
      pingStatus: ok ? 'ok' : 'fail',
    ));
    await Future.delayed(const Duration(seconds: 3));
    emit(state.copyWith(pingStatus: 'idle'));
  }

  Future<void> testSignal() async {
    emit(state.copyWith(testStatus: 'sending'));
    final ok = await _testSignal(TestSignalParams(state.intensity));
    emit(state.copyWith(testStatus: ok ? 'ok' : 'fail'));
    await Future.delayed(const Duration(seconds: 3));
    emit(state.copyWith(testStatus: 'idle'));
  }

  void setDeviceConnected(bool v) {
    final updated = state.settings.copyWith(deviceConnected: v);
    emit(state.copyWith(settings: updated));
  }
}
