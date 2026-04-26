import 'package:camera/camera.dart';
import '../entities/monitoring_result.dart';

abstract class MonitoringRepository {
  Future<void> initialize(List<CameraDescription> cameras);
  Stream<MonitoringResult> startMonitoring();
  Future<void> stopMonitoring();
  Future<void> dispose();
}
