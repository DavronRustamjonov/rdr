import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/di/injection_container.dart';
import '../../features/alarm/presentation/cubit/alarm_cubit.dart';
import '../../features/alarm/presentation/pages/alarm_page.dart';
import '../../features/calibration/presentation/cubit/calibration_cubit.dart';
import '../../features/calibration/presentation/pages/calibration_page.dart';
import '../../features/monitoring/presentation/cubit/monitoring_cubit.dart';
import '../../features/monitoring/presentation/pages/home_page.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/shell/presentation/pages/app_shell_page.dart';
import 'route_names.dart';

final appRouter = GoRouter(
  initialLocation: RouteNames.home,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShellPage(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.home,
              builder: (context, state) => BlocProvider(
                create: (_) => getIt<MonitoringCubit>(),
                child: const HomePage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.calibration,
              builder: (context, state) => BlocProvider(
                create: (_) => getIt<CalibrationCubit>(),
                child: const CalibrationPage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.alarm,
              builder: (context, state) => BlocProvider(
                create: (_) => getIt<AlarmCubit>(),
                child: const AlarmPage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.settings,
              builder: (context, state) => BlocProvider.value(
                value: getIt<SettingsCubit>(),
                child: const SettingsPage(),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);
