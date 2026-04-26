import '../../../../core/enums/alert_mode.dart';

abstract class DeviceRepository {
  Future<bool> ping();
  Future<bool> sendAlert({required AlertMode mode, required int intensity});
  Future<bool> testSignal({required int intensity});
  Future<bool> triggerAlarm({required int intensity});
}
