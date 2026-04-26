import 'package:shared_preferences/shared_preferences.dart';

abstract class CalibrationLocalDataSource {
  Future<double> getThreshold();
  Future<void> saveThreshold(double threshold);
}

class CalibrationLocalDataSourceImpl implements CalibrationLocalDataSource {
  @override
  Future<double> getThreshold() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('earThreshold') ?? 0.25;
  }

  @override
  Future<void> saveThreshold(double threshold) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('earThreshold', threshold);
  }
}
