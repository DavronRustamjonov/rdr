import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/enums/alert_mode.dart';
import '../../domain/entities/app_settings.dart';

abstract class SettingsLocalDataSource {
  Future<AppSettings> load();
  Future<void> save(AppSettings settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  @override
  Future<AppSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    return AppSettings(
      language: prefs.getString('language') ?? 'uz',
      esp32Ip: prefs.getString('esp32Ip') ?? '192.168.4.1',
      alertMode: AlertMode.values[prefs.getInt('alertMode') ?? 0],
      intensity: prefs.getInt('intensity') ?? 3,
      earThreshold: prefs.getDouble('earThreshold') ?? 0.25,
    );
  }

  @override
  Future<void> save(AppSettings s) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', s.language);
    await prefs.setString('esp32Ip', s.esp32Ip);
    await prefs.setInt('alertMode', s.alertMode.index);
    await prefs.setInt('intensity', s.intensity);
    await prefs.setDouble('earThreshold', s.earThreshold);
  }
}
