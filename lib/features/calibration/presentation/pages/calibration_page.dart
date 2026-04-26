import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/l10n/app_strings.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../cubit/calibration_cubit.dart';
import '../cubit/calibration_state.dart';

class CalibrationPage extends StatelessWidget {
  const CalibrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.select((SettingsCubit c) => c.state.language);
    String t(String key) => AppStrings.t(key, lang);

    return BlocBuilder<CalibrationCubit, CalibrationState>(
      builder: (context, state) {
        final isCalibrating = state is CalibrationInProgress;
        final isDone = state is CalibrationDone;
        final threshold = switch (state) {
          CalibrationDone s => s.threshold,
          CalibrationIdle s => s.threshold,
          _ => context.read<SettingsCubit>().state.earThreshold,
        };

        return Scaffold(
          backgroundColor: AppColors.bg,
          body: SafeArea(
            child: ListView(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 40.h),
              children: [
                Text(
                  t('calibration').toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 4,
                  ),
                ),
                SizedBox(height: 20.h),
                _CalibrationCard(
                  isCalibrating: isCalibrating,
                  isDone: isDone,
                  threshold: isDone ? threshold : null,
                  t: t,
                ),
                SizedBox(height: 20.h),
                _ThresholdSelector(currentThreshold: threshold, t: t),
                SizedBox(height: 16.h),
                _InfoBox(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CalibrationCard extends StatefulWidget {
  final bool isCalibrating;
  final bool isDone;
  final double? threshold;
  final String Function(String) t;

  const _CalibrationCard({
    required this.isCalibrating,
    required this.isDone,
    required this.threshold,
    required this.t,
  });

  @override
  State<_CalibrationCard> createState() => _CalibrationCardState();
}

class _CalibrationCardState extends State<_CalibrationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(_CalibrationCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCalibrating && !oldWidget.isCalibrating) {
      _pulseCtrl.repeat(reverse: true);
    } else if (!widget.isCalibrating && oldWidget.isCalibrating) {
      _pulseCtrl.stop();
      _pulseCtrl.reset();
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border),
      ),
      padding: EdgeInsets.all(28.r),
      child: Column(
        children: [
          ScaleTransition(
            scale: widget.isCalibrating ? _pulseAnim : const AlwaysStoppedAnimation(1.0),
            child: Container(
              width: 130.r,
              height: 130.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.isCalibrating ? AppColors.accent : AppColors.border,
                  width: 2,
                ),
                color: AppColors.surface,
              ),
              child: Icon(
                Icons.visibility,
                size: 52.r,
                color: widget.isCalibrating ? AppColors.accent : AppColors.textDim,
              ),
            ),
          ),
          if (widget.isCalibrating) ...[
            SizedBox(height: 14.h),
            Text(
              t('keepEyesOpen'),
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 15.sp,
                color: AppColors.accent,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 10.h),
            const LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppColors.accent),
              backgroundColor: AppColors.border,
            ),
          ],
          if (widget.isDone && widget.threshold != null) ...[
            SizedBox(height: 14.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: AppColors.success, size: 20.r),
                SizedBox(width: 8.w),
                Text(
                  '${t('threshold')}: ${widget.threshold!.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 24.h),
          GestureDetector(
            onTap: widget.isCalibrating
                ? null
                : () {
                    HapticFeedback.mediumImpact();
                    context.read<CalibrationCubit>().startAutoCalibration();
                  },
            child: Opacity(
              opacity: widget.isCalibrating ? 0.4 : 1.0,
              child: Container(
                width: double.infinity,
                height: 52.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: AppColors.accent),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accent.withValues(alpha: 0.3),
                      AppColors.accent.withValues(alpha: 0.1),
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.isCalibrating ? Icons.hourglass_empty : Icons.center_focus_strong,
                      color: AppColors.accent,
                      size: 22.r,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      widget.isCalibrating ? '5s...' : t('calibrateNow').toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accent,
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
    );
  }
}

class _ThresholdSelector extends StatelessWidget {
  final double currentThreshold;
  final String Function(String) t;

  const _ThresholdSelector({required this.currentThreshold, required this.t});

  static const _presets = [0.15, 0.18, 0.20, 0.22, 0.25, 0.28, 0.30, 0.32];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              t('threshold').toUpperCase(),
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textSec,
                letterSpacing: 2,
              ),
            ),
            Text(
              currentThreshold.toStringAsFixed(2),
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.accent,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColors.border),
          ),
          padding: EdgeInsets.all(20.r),
          child: Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            alignment: WrapAlignment.center,
            children: _presets.map((val) {
              final selected = (val - currentThreshold).abs() < 0.015;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.read<CalibrationCubit>().setManualThreshold(val);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: selected ? AppColors.accent : AppColors.border),
                    color: selected ? AppColors.accent.withValues(alpha: 0.2) : AppColors.surface,
                  ),
                  child: Text(
                    val.toStringAsFixed(2),
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: selected ? AppColors.accent : AppColors.textDim,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _InfoBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: AppColors.textSec, size: 18.r),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              "EAR (Eye Aspect Ratio) — 0.20 past, 0.30 yuqori chegaraviy qiymat. Kalibratsiya vaqtida ko'zingizni keng oching.",
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 14.sp,
                color: AppColors.textSec,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
