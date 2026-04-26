import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/enums/alert_mode.dart';
import '../../../../core/extensions/l10n_extension.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/alarm_config.dart';
import '../cubit/alarm_cubit.dart';
import '../cubit/alarm_state.dart';

class AlarmPage extends StatelessWidget {
  const AlarmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlarmCubit, AlarmState>(
      builder: (context, state) {
        final isFired = state is AlarmFired;
        final isScheduled = state is AlarmScheduled;
        final config = switch (state) {
          AlarmReady s => s.config,
          AlarmScheduled s => s.config,
          AlarmFired s => s.config,
          _ => const AlarmConfig(),
        };
        final alertMode = context.select((SettingsCubit c) => c.state.alertMode);
        final intensity = context.select((SettingsCubit c) => c.state.intensity);

        return Scaffold(
          backgroundColor: AppColors.bg,
          body: SafeArea(
            child: ListView(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 40.h),
              children: [
                Text(
                  context.l10n.alarm.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 4,
                  ),
                ),
                SizedBox(height: 16.h),
                if (isFired) const _AlarmFiredBanner(),
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _cardHeader(Icons.access_time, context.l10n.alarmTime),
                      SizedBox(height: 16.h),
                      GestureDetector(
                        onTap: () => _pickTime(context),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: AppColors.accent.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Text(
                            config.hasTime
                                ? _fmt(config.hour!, config.minute!)
                                : '--:--',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Rajdhani',
                              fontSize: 52.sp,
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
                SizedBox(height: 16.h),
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _cardHeader(Icons.vibration, context.l10n.alertMode),
                      SizedBox(height: 14.h),
                      Row(
                        children: [
                          _ModeChip(mode: AlertMode.vibration, icon: Icons.phone_android, label: context.l10n.vibration, current: alertMode),
                          SizedBox(width: 8.w),
                          _ModeChip(mode: AlertMode.audio, icon: Icons.volume_up, label: context.l10n.audio, current: alertMode),
                          SizedBox(width: 8.w),
                          _ModeChip(mode: AlertMode.electric, icon: Icons.bolt, label: context.l10n.electric, current: alertMode),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _cardHeader(Icons.flash_on, context.l10n.pulseIntensity),
                          const Spacer(),
                          Text(
                            '$intensity',
                            style: TextStyle(
                              fontFamily: 'Rajdhani',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accent,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      _IntensityRow(current: intensity),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: config.hasTime ? () => context.read<AlarmCubit>().saveAndSchedule() : null,
                  child: Opacity(
                    opacity: config.hasTime ? 1.0 : 0.4,
                    child: Container(
                      height: 58.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: AppColors.accent),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.accent.withValues(alpha: 0.35),
                            AppColors.accent.withValues(alpha: 0.12),
                          ],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline, color: AppColors.accent, size: 22.r),
                          SizedBox(width: 10.w),
                          Text(
                            context.l10n.save.toUpperCase(),
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
                    ),
                  ),
                ),
                if (isScheduled && config.hasTime) ...[
                  SizedBox(height: 14.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8.r,
                        height: 8.r,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.success,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '${context.l10n.alarmActive} — ${_fmt(config.hour!, config.minute!)}',
                        style: TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
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
      },
    );
  }

  Future<void> _pickTime(BuildContext context) async {
    final config = switch (context.read<AlarmCubit>().state) {
      AlarmReady s => s.config,
      AlarmScheduled s => s.config,
      AlarmFired s => s.config,
      _ => const AlarmConfig(),
    };
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: config.hour ?? 7,
        minute: config.minute ?? 0,
      ),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.accent,
            onPrimary: Colors.black,
          ),
          dialogTheme: const DialogThemeData(backgroundColor: AppColors.surface),
        ),
        child: child!,
      ),
    );
    if (picked != null && context.mounted) {
      HapticFeedback.selectionClick();
      context.read<AlarmCubit>().setTime(picked.hour, picked.minute);
    }
  }

  String _fmt(int h, int m) =>
      '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';

  Widget _buildCard({required Widget child}) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.border),
        ),
        padding: EdgeInsets.all(20.r),
        child: child,
      );

  Widget _cardHeader(IconData icon, String label) => Row(
        children: [
          Icon(icon, color: AppColors.accent, size: 18.r),
          SizedBox(width: 8.w),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textSec,
              letterSpacing: 2,
            ),
          ),
        ],
      );
}

class _AlarmFiredBanner extends StatefulWidget {
  const _AlarmFiredBanner();

  @override
  State<_AlarmFiredBanner> createState() => _AlarmFiredBannerState();
}

class _AlarmFiredBannerState extends State<_AlarmFiredBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.warning),
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => Transform.scale(
              scale: 1.0 + (_ctrl.value * 0.1),
              child: Icon(Icons.alarm, size: 48.r, color: AppColors.warning),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            context.l10n.alarmActive.toUpperCase(),
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.warning,
              letterSpacing: 3,
            ),
          ),
          SizedBox(height: 14.h),
          GestureDetector(
            onTap: () => context.read<AlarmCubit>().stopAlarm(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.danger.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.danger),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.stop_circle, color: AppColors.danger, size: 20.r),
                  SizedBox(width: 8.w),
                  Text(
                    context.l10n.stop.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.danger,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final AlertMode mode;
  final IconData icon;
  final String label;
  final AlertMode current;

  const _ModeChip({
    required this.mode,
    required this.icon,
    required this.label,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    final sel = current == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          context.read<SettingsCubit>().setAlertMode(mode);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: sel ? AppColors.accent : AppColors.border),
            color: sel ? AppColors.accent.withValues(alpha: 0.18) : AppColors.surface,
          ),
          child: Column(
            children: [
              Icon(icon, color: sel ? AppColors.accent : AppColors.textDim, size: 20.r),
              SizedBox(height: 6.h),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: sel ? AppColors.accent : AppColors.textDim,
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

class _IntensityRow extends StatelessWidget {
  final int current;
  const _IntensityRow({required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        final level = i + 1;
        final sel = current == level;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < 4 ? 8.w : 0),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                context.read<SettingsCubit>().setIntensity(level);
              },
              child: Container(
                height: 48.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: sel ? AppColors.accent : AppColors.border),
                  color: sel ? AppColors.accent.withValues(alpha: 0.2) : AppColors.surface,
                ),
                child: Center(
                  child: Text(
                    '$level',
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: sel ? AppColors.accent : AppColors.textDim,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
