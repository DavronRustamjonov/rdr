import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';

class StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool active;

  const StatusChip({
    super.key,
    required this.label,
    required this.color,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: active ? color : AppColors.border),
        color: active ? color.withValues(alpha: 0.15) : Colors.transparent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7.r,
            height: 7.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? color : AppColors.textDim,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: active ? color : AppColors.textDim,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
