import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/alarm_config.dart';

abstract class AlarmDataSource {
  Future<AlarmConfig> loadConfig();
  Future<void> saveConfig(AlarmConfig config);
  Stream<void> get alarmStream;
  void schedule(int hour, int minute);
  void cancel();
  void dispose();
}

class AlarmDataSourceImpl implements AlarmDataSource {
  Timer? _timer;
  final _controller = StreamController<void>.broadcast();

  @override
  Stream<void> get alarmStream => _controller.stream;

  @override
  Future<AlarmConfig> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt('alarmHour');
    final minute = prefs.getInt('alarmMinute');
    final enabled = prefs.getBool('alarmEnabled') ?? false;
    return AlarmConfig(hour: hour, minute: minute, enabled: enabled);
  }

  @override
  Future<void> saveConfig(AlarmConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('alarmEnabled', config.enabled);
    if (config.hour != null) await prefs.setInt('alarmHour', config.hour!);
    if (config.minute != null) await prefs.setInt('alarmMinute', config.minute!);
  }

  @override
  void schedule(int hour, int minute) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      if (now.hour == hour && now.minute == minute && now.second == 0) {
        _controller.add(null);
        timer.cancel();
      }
    });
  }

  @override
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}
