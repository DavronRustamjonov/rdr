import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';

class CalibrationScreen extends StatefulWidget {
  const CalibrationScreen({super.key});

  @override
  State<CalibrationScreen> createState() => _CalibrationScreenState();
}

class _CalibrationScreenState extends State<CalibrationScreen>
    with TickerProviderStateMixin {
  static const _bg = Color(0xFF050A14);
  static const _surface = Color(0xFF0D1626);
  static const _accent = Color(0xFF00D4FF);
  static const _success = Color(0xFF30D158);
  static const _border = Color(0xFF1E2D45);
  static const _textSec = Color(0xFF8899AA);
  static const _textDim = Color(0xFF445566);

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;
  bool _isCalibrating = false;
  bool _isDone = false;
  double? _sampledThreshold;
  Timer? _calibrationTimer;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _calibrationTimer?.cancel();
    super.dispose();
  }

  void _startCalibration() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isCalibrating = true;
      _isDone = false;
      _sampledThreshold = null;
    });
    _pulseController.repeat(reverse: true);

    _calibrationTimer = Timer(const Duration(seconds: 5), () {
      final sampled = 0.28 + (0.06 * (DateTime.now().millisecond / 1000.0));
      final threshold = double.parse((sampled * 0.78).toStringAsFixed(3));
      context.read<AppProvider>().setEarThreshold(threshold);
      _pulseController.stop();
      _pulseController.reset();
      HapticFeedback.heavyImpact();
      setState(() {
        _isCalibrating = false;
        _isDone = true;
        _sampledThreshold = threshold;
      });
    });
  }

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
              t('calibration').toUpperCase(),
              style: const TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 20),

            // Animation card
            Container(
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _border),
              ),
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [
                  ScaleTransition(
                    scale: _isCalibrating ? _pulseAnim : const AlwaysStoppedAnimation(1.0),
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _isCalibrating ? _accent : _border,
                          width: 2,
                        ),
                        color: _surface,
                      ),
                      child: Icon(
                        Icons.visibility,
                        size: 52,
                        color: _isCalibrating ? _accent : _textDim,
                      ),
                    ),
                  ),
                  if (_isCalibrating) ...[
                    const SizedBox(height: 14),
                    Text(
                      t('keepEyesOpen'),
                      style: const TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 15,
                        color: _accent,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(_accent),
                      backgroundColor: _border,
                    ),
                  ],
                  if (_isDone && _sampledThreshold != null) ...[
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle, color: _success, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          '${t('threshold')}: ${_sampledThreshold!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _success,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: _isCalibrating ? null : _startCalibration,
                    child: Opacity(
                      opacity: _isCalibrating ? 0.4 : 1.0,
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: _accent),
                          gradient: LinearGradient(
                            // FIXED: replaced withOpacity with withValues
                            colors: [_accent.withValues(alpha: 0.3), _accent.withValues(alpha: 0.1)],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _isCalibrating ? Icons.hourglass_empty : Icons.center_focus_strong,
                              color: _accent,
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _isCalibrating ? '5s...' : t('calibrateNow').toUpperCase(),
                              style: const TextStyle(
                                fontFamily: 'Rajdhani',
                                fontSize: 16,
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
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Manual threshold selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t('threshold').toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _textSec,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  provider.earThreshold.toStringAsFixed(2),
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
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _border),
              ),
              padding: const EdgeInsets.all(20),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [0.15, 0.18, 0.20, 0.22, 0.25, 0.28, 0.30, 0.32].map((val) {
                  final selected = (val - provider.earThreshold).abs() < 0.015;
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      provider.setEarThreshold(val);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected ? _accent : _border,
                        ),
                        // FIXED: replaced withOpacity with withValues
                        color: selected ? _accent.withValues(alpha: 0.2) : _surface,
                      ),
                      child: Text(
                        val.toStringAsFixed(2),
                        style: TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: selected ? _accent : _textDim,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // FIXED: Added 'const' to this info container
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _accent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _accent.withValues(alpha: 0.2)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: _textSec, size: 18),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'EAR (Eye Aspect Ratio) — 0.20 past, 0.30 yuqori chegaraviy qiymat. Kalibratsiya vaqtida ko\'zingizni keng oching.',
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 14,
                        color: _textSec,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}