//esp32_service.dart
import 'package:http/http.dart' as http;

class Esp32Service {
  final String Function() getIp;

  Esp32Service({required this.getIp});

  Future<bool> ping() async {
    final url = Uri.parse('http://${getIp()}/ping');
    try {
      final res = await http.get(url).timeout(const Duration(milliseconds: 800));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> sendAlert({required String mode, required int power}) async {
    final url = Uri.parse('http://${getIp()}/action?mode=$mode&power=$power');
    try {
      final res = await http.get(url).timeout(const Duration(milliseconds: 500));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> triggerAlert({required String alertMode, required int intensity}) async {
    final modeMap = {
      'vibration': 'VIBRATE',
      'audio': 'AUDIO_ALARM',
      'electric': 'ELECTRIC_PULSE',
    };
    return sendAlert(mode: modeMap[alertMode] ?? 'VIBRATE', power: intensity);
  }

  Future<bool> triggerAlarm({required int intensity}) async {
    return sendAlert(mode: 'ALARM_WAKEUP', power: intensity);
  }

  Future<bool> testSignal({required int intensity}) async {
    return sendAlert(mode: 'TEST', power: intensity);
  }
}
