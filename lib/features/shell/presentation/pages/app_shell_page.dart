import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/l10n_extension.dart';

class AppShellPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShellPage({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
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
              label: context.l10n.monitoring,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.tune_outlined),
              activeIcon: const Icon(Icons.tune),
              label: context.l10n.calibration,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.alarm_outlined),
              activeIcon: const Icon(Icons.alarm),
              label: context.l10n.alarm,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings_outlined),
              activeIcon: const Icon(Icons.settings),
              label: context.l10n.settings,
            ),
          ],
        ),
      ),
    );
  }
}
