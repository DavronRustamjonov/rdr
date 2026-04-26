import 'package:get_it/get_it.dart';
import '../../features/alarm/data/data_sources/alarm_data_source.dart';
import '../../features/alarm/data/repositories/alarm_repository_impl.dart';
import '../../features/alarm/domain/repositories/alarm_repository.dart';
import '../../features/alarm/presentation/cubit/alarm_cubit.dart';
import '../../features/calibration/data/data_sources/calibration_local_data_source.dart';
import '../../features/calibration/data/repositories/calibration_repository_impl.dart';
import '../../features/calibration/domain/repositories/calibration_repository.dart';
import '../../features/calibration/domain/usecases/auto_calibrate.dart';
import '../../features/calibration/domain/usecases/set_threshold.dart';
import '../../features/calibration/presentation/cubit/calibration_cubit.dart';
import '../../features/device/data/data_sources/esp32_data_source.dart';
import '../../features/device/data/repositories/device_repository_impl.dart';
import '../../features/device/domain/repositories/device_repository.dart';
import '../../features/device/domain/usecases/ping_device.dart';
import '../../features/device/domain/usecases/send_alert.dart';
import '../../features/device/domain/usecases/test_signal.dart';
import '../../features/monitoring/data/data_sources/face_detection_data_source.dart';
import '../../features/monitoring/data/repositories/monitoring_repository_impl.dart';
import '../../features/monitoring/domain/repositories/monitoring_repository.dart';
import '../../features/monitoring/domain/usecases/start_monitoring.dart';
import '../../features/monitoring/domain/usecases/stop_monitoring.dart';
import '../../features/monitoring/presentation/cubit/monitoring_cubit.dart';
import '../../features/settings/data/data_sources/settings_local_data_source.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/get_settings.dart';
import '../../features/settings/domain/usecases/save_settings.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // ── Data sources ──────────────────────────────────────────────────────────
  getIt.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<Esp32DataSource>(
    () => Esp32DataSourceImpl(
      getIp: () => getIt<SettingsRepository>().current.esp32Ip,
    ),
  );
  getIt.registerLazySingleton<FaceDetectionDataSource>(
    () => FaceDetectionDataSourceImpl(),
  );
  getIt.registerLazySingleton<CalibrationLocalDataSource>(
    () => CalibrationLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<AlarmDataSource>(
    () => AlarmDataSourceImpl(),
  );

  // ── Repositories ──────────────────────────────────────────────────────────
  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(getIt<SettingsLocalDataSource>()),
  );
  getIt.registerLazySingleton<DeviceRepository>(
    () => DeviceRepositoryImpl(getIt<Esp32DataSource>()),
  );
  getIt.registerLazySingleton<MonitoringRepository>(
    () => MonitoringRepositoryImpl(getIt<FaceDetectionDataSource>()),
  );
  getIt.registerLazySingleton<CalibrationRepository>(
    () => CalibrationRepositoryImpl(getIt<CalibrationLocalDataSource>()),
  );
  getIt.registerLazySingleton<AlarmRepository>(
    () => AlarmRepositoryImpl(getIt<AlarmDataSource>()),
  );

  // ── Use cases ─────────────────────────────────────────────────────────────
  getIt.registerFactory(() => GetSettings(getIt<SettingsRepository>()));
  getIt.registerFactory(() => SaveSettings(getIt<SettingsRepository>()));
  getIt.registerFactory(() => PingDevice(getIt<DeviceRepository>()));
  getIt.registerFactory(() => TestSignal(getIt<DeviceRepository>()));
  getIt.registerFactory(() => SendAlert(getIt<DeviceRepository>()));
  getIt.registerFactory(() => StartMonitoring(getIt<MonitoringRepository>()));
  getIt.registerFactory(() => StopMonitoring(getIt<MonitoringRepository>()));
  getIt.registerFactory(() => AutoCalibrate(getIt<CalibrationRepository>()));
  getIt.registerFactory(() => SetThreshold(getIt<CalibrationRepository>()));

  // ── Cubits ────────────────────────────────────────────────────────────────
  // SettingsCubit: singleton so all features share the same state
  getIt.registerLazySingleton<SettingsCubit>(
    () => SettingsCubit(
      getSettings: getIt<GetSettings>(),
      saveSettings: getIt<SaveSettings>(),
      pingDevice: getIt<PingDevice>(),
      testSignal: getIt<TestSignal>(),
    ),
  );
  getIt.registerFactory<MonitoringCubit>(
    () => MonitoringCubit(
      startMonitoring: getIt<StartMonitoring>(),
      stopMonitoring: getIt<StopMonitoring>(),
      sendAlert: getIt<SendAlert>(),
      settingsRepository: getIt<SettingsRepository>(),
    ),
  );
  getIt.registerFactory<CalibrationCubit>(
    () => CalibrationCubit(
      autoCalibrate: getIt<AutoCalibrate>(),
      setThreshold: getIt<SetThreshold>(),
      settingsCubit: getIt<SettingsCubit>(),
    ),
  );
  getIt.registerFactory<AlarmCubit>(
    () => AlarmCubit(
      alarmRepository: getIt<AlarmRepository>(),
      deviceRepository: getIt<DeviceRepository>(),
      settingsRepository: getIt<SettingsRepository>(),
    ),
  );
}
