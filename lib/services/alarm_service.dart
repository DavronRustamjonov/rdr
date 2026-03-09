//alarm_service.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'esp32_service.dart';

class AlarmService {
  Timer? _timer;
  bool _isActive = false;
  final Esp32Service esp32;

  AlarmService({required this.esp32});

  bool get isActive => _isActive;

  void scheduleAlarm({
    required TimeOfDay time,
    required int intensity,
    required String alertMode,
    required VoidCallback onAlarmFired,
  }) {
    _timer?.cancel();
    _isActive = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final nowTime = TimeOfDay(hour: now.hour, minute: now.minute);

      if (nowTime.hour == time.hour && nowTime.minute == time.minute && now.second == 0) {
        _fireAlarm(intensity: intensity, onFired: onAlarmFired);
        timer.cancel();
        _isActive = false;
      }
    });
  }

  Future<void> _fireAlarm({required int intensity, required VoidCallback onFired}) async {
    onFired();
    await esp32.triggerAlarm(intensity: intensity);
  }

  void cancelAlarm() {
    _timer?.cancel();
    _isActive = false;
  }

  void dispose() {
    _timer?.cancel();
  }
}
