import 'dart:math';
import 'package:flutter/material.dart';
import '../providers/app_provider.dart';

class EyeRing extends StatefulWidget {
  final MonitoringStatus status;
  const EyeRing({super.key, required this.status});

  @override
  State<EyeRing> createState() => _EyeRingState();
}

class _EyeRingState extends State<EyeRing> with TickerProviderStateMixin {
  static const _accent = Color(0xFF00D4FF);
  static const _warning = Color(0xFFFF6B35);
  static const _danger = Color(0xFFFF2D55);
  static const _border = Color(0xFF1E2D45);

  late AnimationController _pulseCtrl;
  late AnimationController _rotCtrl;
  late AnimationController _blinkCtrl;

  late Animation<double> _pulseAnim;
  late Animation<double> _rotAnim;
  late Animation<double> _blinkAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));
    _rotCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 12));
    _blinkCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));

    _pulseAnim = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _rotAnim = Tween<double>(begin: 0, end: 2 * pi).animate(_rotCtrl);
    _blinkAnim = Tween<double>(begin: 1.0, end: 0.05).animate(
      CurvedAnimation(parent: _blinkCtrl, curve: Curves.easeIn),
    );

    _updateAnimations();
  }

  @override
  void didUpdateWidget(EyeRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status) {
      _updateAnimations();
    }
  }

  void _updateAnimations() {
    _pulseCtrl.stop();
    _rotCtrl.stop();
    _blinkCtrl.stop();

    switch (widget.status) {
      case MonitoringStatus.monitoring:
        _pulseCtrl.repeat(reverse: true);
        _rotCtrl.repeat();
        break;
      case MonitoringStatus.warning:
        _pulseCtrl.repeat(reverse: true);
        _blinkCtrl.repeat(reverse: true);
        break;
      case MonitoringStatus.sleeping:
        _blinkCtrl.repeat(reverse: true);
        break;
      case MonitoringStatus.idle:
        _pulseCtrl.reset();
        _rotCtrl.reset();
        _blinkCtrl.reset();
        break;
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _rotCtrl.dispose();
    _blinkCtrl.dispose();
    super.dispose();
  }

  Color get _ringColor {
    switch (widget.status) {
      case MonitoringStatus.sleeping:
        return _danger;
      case MonitoringStatus.warning:
        return _warning;
      case MonitoringStatus.monitoring:
        return _accent;
      case MonitoringStatus.idle:
        return _border;
    }
  }

  Color get _innerColor {
    switch (widget.status) {
      case MonitoringStatus.sleeping:
        // FIXED: Replaced .withOpacity() with .withValues()
        return _danger.withValues(alpha: 0.15);
      case MonitoringStatus.warning:
        return _warning.withValues(alpha: 0.12);
      case MonitoringStatus.monitoring:
        return _accent.withValues(alpha: 0.10);
      case MonitoringStatus.idle:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.68;

    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnim, _rotAnim, _blinkAnim]),
      builder: (_, __) {
        return Transform.scale(
          scale: _pulseAnim.value,
          child: Transform.rotate(
            angle: _rotAnim.value,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _ringColor, width: 2),
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    // FIXED: Replaced .withOpacity() with .withValues()
                    color: _ringColor.withValues(alpha: 0.35),
                    blurRadius: 24,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: size - 24,
                  height: size - 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _innerColor,
                  ),
                  child: Center(
                    child: Transform.rotate(
                      angle: -_rotAnim.value,
                      child: Transform.scale(
                        scaleY: _blinkAnim.value,
                        child: Icon(
                          widget.status == MonitoringStatus.sleeping
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: 52,
                          color: _ringColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}