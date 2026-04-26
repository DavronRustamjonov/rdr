import '../../../../core/usecases/usecase.dart';
import '../repositories/calibration_repository.dart';

class AutoCalibrate extends UseCase<double, NoParams> {
  final CalibrationRepository _repository;
  AutoCalibrate(this._repository);

  @override
  Future<double> call(NoParams params) => _repository.autoCalibrate();
}
