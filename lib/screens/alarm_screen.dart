import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../services/alarm_service.dart';
import '../services/esp32_service.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> with TickerProviderStateMixin {
  static const _bg = Color(0xFF050A14);
  static const _surface = Color(0xFF0D1626);
  static const _surfaceElevated = Color(0xFF162035);
  static const _accent = Color(0xFF00D4FF);
  static const _success = Color(0xFF30D158);
  static const _warning = Color(0xFFFF6B35);
  static const _danger = Color(0xFFFF2D55);
  static const _border = Color(0xFF1E2D45);
  static const _textSec = Color(0xFF8899AA);
  static const _textDim = Color(0xFF445566);

  late AlarmService _alarmService;
  late AnimationController _pulseController;
  bool _alarmFired = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    final provider = context.read<AppProvider>();
    _alarmService = AlarmService(
      esp32: Esp32Service(getIp: () => provider.esp32Ip),
    );
  }

  @override
  void dispose() {
    _alarmService.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final provider = context.read<AppProvider>();
    final picked = await showTimePicker(
      context: context,
      initialTime: provider.alarmTime ?? const TimeOfDay(hour: 7, minute: 0),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: _accent, onPrimary: Colors.black),
          // FIXED: Use DialogTheme instead of deprecated dialogBackgroundColor
          dialogTheme: const DialogThemeData(backgroundColor: _surface),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      HapticFeedback.selectionClick();
      provider.setAlarmTime(picked);
    }
  }

  void _saveAlarm() {
    final provider = context.read<AppProvider>();
    if (provider.alarmTime == null) return;
    HapticFeedback.heavyImpact();
    provider.setAlarmEnabled(true);
    _alarmService.scheduleAlarm(
      time: provider.alarmTime!,
      intensity: provider.intensity,
      alertMode: provider.alertMode.name,
      onAlarmFired: () {
        if (!mounted) return;
        setState(() => _alarmFired = true);
        _pulseController.repeat(reverse: true);
        HapticFeedback.heavyImpact();
      },
    );
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        '${provider.t('alarmActive')} — ${_formatTime(provider.alarmTime!)}',
        style: const TextStyle(fontFamily: 'Rajdhani', color: Colors.white),
      ),
      backgroundColor: _surface,
    ));
  }

  void _stopAlarm() {
    HapticFeedback.heavyImpact();
    _alarmService.cancelAlarm();
    _pulseController.stop();
    _pulseController.reset();
    context.read<AppProvider>().setAlarmEnabled(false);
    setState(() => _alarmFired = false);
  }

  String _formatTime(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final t = provider.t;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          children: [
            Text(
              t('alarm').toUpperCase(),
              style: const TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 16),

            // Fired alarm banner
            if (_alarmFired)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  // FIXED: replaced withOpacity
                  color: _warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _warning),
                ),
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (_, __) => Transform.scale(
                        scale: 1.0 + (_pulseController.value * 0.1),
                        child: const Icon(Icons.alarm, size: 48, color: _warning),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      t('alarmActive').toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: _warning,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: _stopAlarm,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          // FIXED: replaced withOpacity
                          color: _danger.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _danger),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.stop_circle, color: _danger, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              t('stop').toUpperCase(),
                              style: const TextStyle(
                                fontFamily: 'Rajdhani',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: _danger,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Time picker card
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _cardHeader(Icons.access_time, t('alarmTime')),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _pickTime,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: _surfaceElevated,
                        borderRadius: BorderRadius.circular(16),
                        // FIXED: replaced withOpacity
                        border: Border.all(color: _accent.withValues(alpha: 0.5)),
                      ),
                      child: Text(
                        provider.alarmTime != null
                            ? _formatTime(provider.alarmTime!)
                            : '--:--',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 52,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Alert mode selector
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _cardHeader(Icons.vibration, t('alertMode')),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _modeChip(AlertMode.vibration, Icons.phone_android, t('vibration'), provider),
                      const SizedBox(width: 8),
                      _modeChip(AlertMode.audio, Icons.volume_up, t('audio'), provider),
                      const SizedBox(width: 8),
                      _modeChip(AlertMode.electric, Icons.bolt, t('electric'), provider),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Intensity
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _cardHeader(Icons.flash_on, t('pulseIntensity')),
                      const Spacer(),
                      Text(
                        '${provider.intensity}',
                        style: const TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: _accent,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: List.generate(5, (i) {
                      final level = i + 1;
                      final sel = provider.intensity == level;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: i < 4 ? 8 : 0),
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              provider.setIntensity(level);
                            },
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: sel ? _accent : _border),
                                // FIXED: replaced withOpacity
                                color: sel ? _accent.withValues(alpha: 0.2) : _surface,
                              ),
                              child: Center(
                                child: Text(
                                  '$level',
                                  style: TextStyle(
                                    fontFamily: 'Rajdhani',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: sel ? _accent : _textDim,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Save button
            GestureDetector(
              onTap: provider.alarmTime != null ? _saveAlarm : null,
              child: Opacity(
                opacity: provider.alarmTime != null ? 1.0 : 0.4,
                child: Container(
                  height: 58,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _accent),
                    gradient: LinearGradient(
                      // FIXED: replaced withOpacity
                      colors: [_accent.withValues(alpha: 0.35), _accent.withValues(alpha: 0.12)],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle_outline, color: _accent, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        t('save').toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: _accent,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            if (provider.alarmEnabled && !_alarmFired && provider.alarmTime != null) ...[
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: _success),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${t('alarmActive')} — ${_formatTime(provider.alarmTime!)}',
                    style: const TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _success,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) => Container(
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _border),
        ),
        padding: const EdgeInsets.all(20),
        child: child,
      );

  Widget _cardHeader(IconData icon, String label) => Row(
        children: [
          Icon(icon, color: _accent, size: 18),
          const SizedBox(width: 8),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _textSec,
              letterSpacing: 2,
            ),
          ),
        ],
      );

  Widget _modeChip(AlertMode mode, IconData icon, String label, AppProvider provider) {
    final sel = provider.alertMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          provider.setAlertMode(mode);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: sel ? _accent : _border),
            // FIXED: replaced withOpacity
            color: sel ? _accent.withValues(alpha: 0.18) : _surface,
          ),
          child: Column(
            children: [
              Icon(icon, color: sel ? _accent : _textDim, size: 20),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: sel ? _accent : _textDim,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}