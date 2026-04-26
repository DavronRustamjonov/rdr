import 'package:camera/camera.dart';
import '../../domain/entities/monitoring_result.dart';
import '../../domain/repositories/monitoring_repository.dart';
import '../data_sources/face_detection_data_source.dart';

class MonitoringRepositoryImpl implements MonitoringRepository {
  final FaceDetectionDataSource _dataSource;

  MonitoringRepositoryImpl(this._dataSource);

  @override
  Future<void> initialize(List<CameraDescription> cameras) =>
      _dataSource.initialize(cameras);

  @override
  Stream<MonitoringResult> startMonitoring() => _dataSource.startStream();

  @override
  Future<void> stopMonitoring() => _dataSource.stopStream();

  @override
  Future<void> dispose() => _dataSource.dispose();
}
