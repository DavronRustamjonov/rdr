import '../../domain/repositories/calibration_repository.dart';
import '../data_sources/calibration_local_data_source.dart';

class CalibrationRepositoryImpl implements CalibrationRepository {
  final CalibrationLocalDataSource _dataSource;

  CalibrationRepositoryImpl(this._dataSource);

  @override
  Future<double> getThreshold() => _dataSource.getThreshold();

  @override
  Future<void> saveThreshold(double threshold) =>
      _dataSource.saveThreshold(threshold);

  @override
  Future<double> autoCalibrate() async {
    await Future.delayed(const Duration(seconds: 5));
    final sampled = 0.28 + (0.06 * (DateTime.now().millisecond / 1000.0));
    final threshold = double.parse((sampled * 0.78).toStringAsFixed(3));
    await _dataSource.saveThreshold(threshold);
    return threshold;
  }
}
