import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common/widgets/ear_bar.dart';
import '../../../../common/widgets/eye_ring.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/enums/monitoring_status.dart';
import '../../../../core/extensions/l10n_extension.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../../settings/presentation/cubit/settings_state.dart';
import '../cubit/monitoring_cubit.dart';
import '../cubit/monitoring_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        return BlocBuilder<MonitoringCubit, MonitoringState>(
          builder: (context, monitoringState) {
            final active = monitoringState is MonitoringActive ? monitoringState : null;
            final isActive = active != null;
            final ear = active?.earScore ?? 0.0;
            final status = active?.status ?? MonitoringStatus.idle;

            final statusColor = switch (status) {
              MonitoringStatus.sleeping => AppColors.danger,
              MonitoringStatus.warning => AppColors.warning,
              MonitoringStatus.monitoring => AppColors.success,
              MonitoringStatus.idle => AppColors.textDim,
            };

            final statusLabel = isActive
                ? switch (status) {
                    MonitoringStatus.sleeping => context.l10n.asleep,
                    MonitoringStatus.warning => context.l10n.drowsy,
                    _ => context.l10n.awake,
                  }
                : '—';

            return Scaffold(
              backgroundColor: AppColors.bg,
              body: SafeArea(
                child: Column(
                  children: [
                    _Header(deviceConnected: settingsState.deviceConnected),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          children: [
                            SizedBox(height: 16.h),
                            EyeRing(status: isActive ? status : MonitoringStatus.idle),
                            SizedBox(height: 20.h),
                            _StatusBlock(
                              label: statusLabel,
                              color: statusColor,
                              status: status,
                              isActive: isActive,
                            ),
                            if (isActive) ...[
                              SizedBox(height: 20.h),
                              EarBar(
                                value: ear,
                                threshold: settingsState.earThreshold,
                                label: context.l10n.earScore,
                              ),
                            ],
                            SizedBox(height: 28.h),
                            _MainButton(isActive: isActive),
                            SizedBox(height: 16.h),
                            _MonitorPill(isActive: isActive),
                            SizedBox(height: 40.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final bool deviceConnected;

  const _Header({required this.deviceConnected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'RDR',
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 36.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.accent,
              letterSpacing: 6,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7.r,
                  height: 7.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: deviceConnected ? AppColors.success : AppColors.danger,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  deviceConnected
                      ? context.l10n.deviceConnected
                      : context.l10n.deviceDisconnected,
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSec,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBlock extends StatelessWidget {
  final String label;
  final Color color;
  final MonitoringStatus status;
  final bool isActive;

  const _StatusBlock({
    required this.label,
    required this.color,
    required this.status,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 70.h),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 40.sp,
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: 4,
              ),
            ),
            if (isActive && status == MonitoringStatus.sleeping) ...[
              SizedBox(height: 4.h),
              Text(
                context.l10n.warning,
                textAlign: TextAlign.center,
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.danger,
                  letterSpacing: 1.2,
                ),
              ),
            ],
            if (isActive && status == MonitoringStatus.warning) ...[
              SizedBox(height: 4.h),
              Text(
                context.l10n.eyesClosedWarn,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.warning,
                  letterSpacing: 0.5,
                  height: 1.2,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MainButton extends StatelessWidget {
  final bool isActive;

  const _MainButton({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final cubit = context.read<MonitoringCubit>();
        if (isActive) {
          cubit.stopMonitoring();
        } else {
          cubit.startMonitoring();
        }
      },
      child: Container(
        width: double.infinity,
        height: 58.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: isActive ? AppColors.danger : AppColors.accent),
          gradient: LinearGradient(
            colors: isActive
                ? [AppColors.danger.withValues(alpha: 0.25), AppColors.danger.withValues(alpha: 0.08)]
                : [AppColors.accent.withValues(alpha: 0.25), AppColors.accent.withValues(alpha: 0.08)],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? Icons.stop_circle_outlined : Icons.play_circle_outline,
              color: isActive ? AppColors.danger : AppColors.accent,
              size: 26.r,
            ),
            SizedBox(width: 10.w),
            Text(
              (isActive
                      ? context.l10n.stopMonitoring
                      : context.l10n.startMonitoring)
                  .toUpperCase(),
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: isActive ? AppColors.danger : AppColors.accent,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonitorPill extends StatelessWidget {
  final bool isActive;

  const _MonitorPill({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: isActive ? AppColors.accent : AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7.r,
            height: 7.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? AppColors.accent : AppColors.textDim,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            isActive ? context.l10n.monitoringActive : context.l10n.monitoringIdle,
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: isActive ? AppColors.accent : AppColors.textDim,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
