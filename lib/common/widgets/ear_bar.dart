import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';

class EarBar extends StatelessWidget {
  final double value;
  final double threshold;
  final String label;

  const EarBar({
    super.key,
    required this.value,
    required this.threshold,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (value * 100).clamp(0, 100).toDouble();
    final color = value < threshold ? AppColors.danger : AppColors.accent;

    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textSec,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: percent / 100,
            minHeight: 5.h,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          value.toStringAsFixed(2),
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}
