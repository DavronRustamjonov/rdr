import '../../../../core/usecases/usecase.dart';
import '../repositories/monitoring_repository.dart';

class StopMonitoring extends UseCase<void, NoParams> {
  final MonitoringRepository _repository;
  StopMonitoring(this._repository);

  @override
  Future<void> call(NoParams params) => _repository.stopMonitoring();
}
