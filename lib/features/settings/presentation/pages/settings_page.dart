import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/l10n/app_strings.dart';
import '../../../../core/constants/app_colors.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _ipController;

  @override
  void initState() {
    super.initState();
    _ipController = TextEditingController(
      text: context.read<SettingsCubit>().state.esp32Ip,
    );
  }

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        String t(String key) => AppStrings.t(key, state.language);

        return Scaffold(
          backgroundColor: AppColors.bg,
          body: SafeArea(
            child: ListView(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 40.h),
              children: [
                Text(
                  t('settings').toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 4,
                  ),
                ),
                SizedBox(height: 20.h),
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _cardTitle(t('language')),
                      SizedBox(height: 14.h),
                      Row(
                        children: [
                          _LangChip(lang: 'uz', label: 'UZ', current: state.language),
                          SizedBox(width: 10.w),
                          _LangChip(lang: 'en', label: 'EN', current: state.language),
                          SizedBox(width: 10.w),
                          _LangChip(lang: 'ru', label: 'RU', current: state.language),
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
                      _cardTitle(t('esp32Ip')),
                      SizedBox(height: 14.h),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _ipController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              style: TextStyle(
                                fontFamily: 'Rajdhani',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.surfaceElevated,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 14.h,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: const BorderSide(color: AppColors.border),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: const BorderSide(color: AppColors.border),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: const BorderSide(color: AppColors.accent),
                                ),
                                hintText: '192.168.4.1',
                                hintStyle: TextStyle(color: AppColors.textDim, fontSize: 14.sp),
                              ),
                              onChanged: (v) => context.read<SettingsCubit>().setEsp32Ip(v),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          GestureDetector(
                            onTap: state.pingStatus == 'pinging'
                                ? null
                                : () {
                                    HapticFeedback.lightImpact();
                                    context.read<SettingsCubit>().pingDevice();
                                  },
                            child: Container(
                              width: 52.r,
                              height: 52.r,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceElevated,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Icon(
                                state.pingStatus == 'ok'
                                    ? Icons.check_circle
                                    : state.pingStatus == 'fail'
                                        ? Icons.cancel
                                        : Icons.wifi,
                                color: state.pingStatus == 'ok'
                                    ? AppColors.success
                                    : state.pingStatus == 'fail'
                                        ? AppColors.danger
                                        : AppColors.accent,
                                size: 22.r,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (state.pingStatus == 'ok') ...[
                        SizedBox(height: 8.h),
                        Text(
                          t('deviceConnected'),
                          style: TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 13.sp,
                            color: AppColors.success,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ] else if (state.pingStatus == 'fail') ...[
                        SizedBox(height: 8.h),
                        Text(
                          t('deviceDisconnected'),
                          style: TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 13.sp,
                            color: AppColors.danger,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
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
                          _cardTitle(t('intensity')),
                          const Spacer(),
                          Text(
                            '${state.intensity}',
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
                      Row(
                        children: List.generate(5, (i) {
                          final level = i + 1;
                          final sel = state.intensity == level;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: i < 4 ? 8.w : 0),
                              child: GestureDetector(
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  context.read<SettingsCubit>().setIntensity(level);
                                },
                                child: Container(
                                  height: 44.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                      color: sel ? AppColors.accent : AppColors.border,
                                    ),
                                    color: sel
                                        ? AppColors.accent.withValues(alpha: 0.2)
                                        : AppColors.surfaceElevated,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$level',
                                      style: TextStyle(
                                        fontFamily: 'Rajdhani',
                                        fontSize: 16.sp,
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
                      ),
                      SizedBox(height: 16.h),
                      GestureDetector(
                        onTap: state.testStatus == 'sending'
                            ? null
                            : () {
                                HapticFeedback.mediumImpact();
                                context.read<SettingsCubit>().testSignal();
                              },
                        child: Opacity(
                          opacity: state.testStatus == 'sending' ? 0.5 : 1.0,
                          child: Container(
                            // height: 52.h,
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: state.testStatus == 'ok'
                                    ? AppColors.success
                                    : state.testStatus == 'fail'
                                        ? AppColors.danger
                                        : AppColors.accent,
                              ),
                              gradient: LinearGradient(
                                colors: state.testStatus == 'ok'
                                    ? [AppColors.success.withValues(alpha: 0.3), AppColors.success.withValues(alpha: 0.1)]
                                    : state.testStatus == 'fail'
                                        ? [AppColors.danger.withValues(alpha: 0.3), AppColors.danger.withValues(alpha: 0.1)]
                                        : [AppColors.accent.withValues(alpha: 0.3), AppColors.accent.withValues(alpha: 0.1)],
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 10.w,
                              children: [
                                Icon(
                                  state.testStatus == 'ok'
                                      ? Icons.check_circle
                                      : state.testStatus == 'fail'
                                          ? Icons.cancel
                                          : Icons.send,
                                  color: state.testStatus == 'ok'
                                      ? AppColors.success
                                      : state.testStatus == 'fail'
                                          ? AppColors.danger
                                          : AppColors.accent,
                                  size: 20.r,
                                ),
                                Flexible(
                                  child: Text(
                                    state.testStatus == 'ok'
                                        ? t('signalSent')
                                        : state.testStatus == 'fail'
                                            ? t('signalFailed')
                                            : state.testStatus == 'sending'
                                                ? t('connecting')
                                                : t('testSignal').toUpperCase(),
                                    style: TextStyle(
                                      fontFamily: 'Rajdhani',
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                      color: state.testStatus == 'ok'
                                          ? AppColors.success
                                          : state.testStatus == 'fail'
                                              ? AppColors.danger
                                              : AppColors.accent,
                                      letterSpacing: 1.5,                                    
                                    ),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      maxLines: 2,
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
                SizedBox(height: 20.h),
                _buildCard(
                  child: Column(
                    children: [
                      Text(
                        'RDR',
                        style: TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 52.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accent,
                          letterSpacing: 10,
                        ),
                      ),
                      Text(
                        'Real-time Drowsiness Response',
                        style: TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 13.sp,
                          color: AppColors.textSec,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'v1.0.0',
                        style: TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 12.sp,
                          color: AppColors.textDim,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard({required Widget child}) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.border),
        ),
        padding: EdgeInsets.all(20.r),
        child: child,
      );

  Widget _cardTitle(String label) => Row(
        children: [
          Icon(Icons.settings_outlined, color: AppColors.accent, size: 16.r),
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

class _LangChip extends StatelessWidget {
  final String lang;
  final String label;
  final String current;

  const _LangChip({required this.lang, required this.label, required this.current});

  @override
  Widget build(BuildContext context) {
    final sel = current == lang;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        context.read<SettingsCubit>().setLanguage(lang);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: sel ? AppColors.accent : AppColors.border),
          color: sel ? AppColors.accent.withValues(alpha: 0.2) : AppColors.surface,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: sel ? AppColors.accent : AppColors.textDim,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
