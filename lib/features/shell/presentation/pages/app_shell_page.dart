import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/l10n/app_strings.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';

class AppShellPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShellPage({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final lang = context.select((SettingsCubit c) => c.state.language);
    String t(String key) => AppStrings.t(key, lang);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: (i) => navigationShell.goBranch(
            i,
            initialLocation: i == navigationShell.currentIndex,
          ),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.visibility_outlined),
              activeIcon: const Icon(Icons.visibility),
              label: t('monitoring'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.tune_outlined),
              activeIcon: const Icon(Icons.tune),
              label: t('calibration'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.alarm_outlined),
              activeIcon: const Icon(Icons.alarm),
              label: t('alarm'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings_outlined),
              activeIcon: const Icon(Icons.settings),
              label: t('settings'),
            ),
          ],
        ),
      ),
    );
  }
}
