import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/enums/monitoring_status.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../device/domain/usecases/send_alert.dart';
import '../../../settings/domain/repositories/settings_repository.dart';
import '../../domain/usecases/start_monitoring.dart';
import '../../domain/usecases/stop_monitoring.dart';
import 'monitoring_state.dart';

class MonitoringCubit extends Cubit<MonitoringState> {
  final StartMonitoring _startMonitoring;
  final StopMonitoring _stopMonitoring;
  final SendAlert _sendAlert;
  final SettingsRepository _settingsRepository;

  List<CameraDescription> _cameras = [];
  StreamSubscription<dynamic>? _subscription;

  MonitoringCubit({
    required StartMonitoring startMonitoring,
    required StopMonitoring stopMonitoring,
    required SendAlert sendAlert,
    required SettingsRepository settingsRepository,
  })  : _startMonitoring = startMonitoring,
        _stopMonitoring = stopMonitoring,
        _sendAlert = sendAlert,
        _settingsRepository = settingsRepository,
        super(const MonitoringInitial()) {
    _loadCameras();
  }

  Future<void> _loadCameras() async {
    try {
      _cameras = await availableCameras();
      emit(const MonitoringIdle());
    } catch (_) {
      emit(const MonitoringIdle());
    }
  }

  Future<void> startMonitoring() async {
    if (_cameras.isEmpty) return;
    await _subscription?.cancel();

    _subscription = _startMonitoring(StartMonitoringParams(_cameras)).listen(
      (result) {
        if (isClosed) return;
        emit(MonitoringActive(earScore: result.ear, status: result.status));
        if (result.status == MonitoringStatus.sleeping) {
          HapticFeedback.heavyImpact();
          final s = _settingsRepository.current;
          _sendAlert(SendAlertParams(mode: s.alertMode, intensity: s.intensity));
        }
      },
      onError: (_) => emit(const MonitoringIdle()),
    );
  }

  Future<void> stopMonitoring() async {
    await _subscription?.cancel();
    _subscription = null;
    await _stopMonitoring(const NoParams());
    emit(const MonitoringIdle());
  }

  bool get isMonitoring => state is MonitoringActive;

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await _stopMonitoring(const NoParams());
    return super.close();
  }
}
