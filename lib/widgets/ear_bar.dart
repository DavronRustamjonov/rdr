import 'package:flutter/material.dart';

class EarBar extends StatelessWidget {
  final double value;
  final double threshold;
  final String Function(String) t;

  const EarBar({
    super.key,
    required this.value,
    required this.threshold,
    required this.t,
  });

  static const _accent = Color(0xFF00D4FF);
  static const _danger = Color(0xFFFF2D55);
  static const _border = Color(0xFF1E2D45);
  static const _textSec = Color(0xFF8899AA);

  @override
  Widget build(BuildContext context) {
    final percent = (value * 100).clamp(0, 100).toDouble();
    final color = value < threshold ? _danger : _accent;

    return Column(
      children: [
        Text(
          t('earScore').toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: _textSec,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent / 100,
            minHeight: 5,
            backgroundColor: _border,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value.toStringAsFixed(2),
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}
