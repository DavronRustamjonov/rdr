import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/monitoring_result.dart';
import '../repositories/monitoring_repository.dart';

class StartMonitoringParams extends Equatable {
  final List<CameraDescription> cameras;
  const StartMonitoringParams(this.cameras);
  @override
  List<Object?> get props => [cameras];
}

class StartMonitoring extends StreamUseCase<MonitoringResult, StartMonitoringParams> {
  final MonitoringRepository _repository;
  StartMonitoring(this._repository);

  @override
  Stream<MonitoringResult> call(StartMonitoringParams params) async* {
    await _repository.initialize(params.cameras);
    yield* _repository.startMonitoring();
  }
}
