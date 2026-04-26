abstract class CalibrationRepository {
  Future<double> getThreshold();
  Future<void> saveThreshold(double threshold);
  Future<double> autoCalibrate();
}
