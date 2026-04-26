import '../../../../core/usecases/usecase.dart';
import '../repositories/calibration_repository.dart';

class SetThreshold extends UseCase<void, double> {
  final CalibrationRepository _repository;
  SetThreshold(this._repository);

  @override
  Future<void> call(double params) => _repository.saveThreshold(params);
}
