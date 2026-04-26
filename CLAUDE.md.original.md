# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get                          # install dependencies
flutter analyze                         # lint (must return "No issues found!")
flutter run                             # run on connected device
flutter build apk --release             # release APK
flutter pub run build_runner build      # regenerate lib/core/gen/ after adding assets/fonts
flutter test                            # run all tests
flutter test test/path/to_test.dart     # run single test
```

## Architecture

Clean Architecture with BLoC/Cubit. Design baseline **360×800** — all sizing uses `.r`, `.w`, `.h`, `.sp` (flutter_screenutil).

### Layer rules (per feature)
```
features/<name>/
  data/data_sources/   # Dio (remote) or SharedPreferences (local)
  data/repositories/   # implements domain interface
  domain/entities/     # pure Dart + Equatable, no Flutter imports
  domain/repositories/ # abstract interface
  domain/usecases/     # single-method classes extending UseCase<T,P>
  presentation/cubit/  # XxxCubit extends Cubit<XxxState>; state extends Equatable
  presentation/pages/  # BlocProvider created via getIt<> in app_router.dart
```

### Key files
| File | Purpose |
|------|---------|
| `lib/core/di/injection_container.dart` | All GetIt wiring — data sources → repos → use cases → cubits |
| `lib/config/routes/app_router.dart` | GoRouter with `StatefulShellRoute` (4 tabs) |
| `lib/config/l10n/app_strings.dart` | `AppStrings.t(key, lang)` — uz/en/ru inline |
| `lib/core/constants/app_colors.dart` | All colors via `AppColors.*` constants |
| `lib/core/theme/app_theme.dart` | `AppTheme.dark` — single dark theme |

### DI rules
- Repositories + data sources: `registerLazySingleton`
- Use cases: `registerFactory`
- Cubits: `registerFactory` — **except** `SettingsCubit` which is `registerLazySingleton` (shared global state)
- Cubits with no data deps: instantiate directly with `create: (_) => MyCubit()`

### Navigation
`GoRouter` → `StatefulShellRoute.indexedStack` → `AppShellPage` (4 branches: `/`, `/calibration`, `/alarm`, `/settings`). Each branch's route builder wraps with `BlocProvider`. `SettingsCubit` provided at root in `main.dart` via `BlocProvider.value`.

### Shared state pattern
`SettingsCubit` holds `AppSettings` (language, esp32Ip, alertMode, intensity, earThreshold, deviceConnected). Other cubits read settings at request time via `SettingsRepository.current` (synchronous getter), not via `SettingsCubit`. ESP32 IP is fetched via closure: `getIp: () => getIt<SettingsRepository>().current.esp32Ip`.

### Assets & fonts
After adding any image, SVG, or font asset: run `flutter pub run build_runner build` to regenerate `lib/core/gen/assets.gen.dart` and `lib/core/gen/fonts.gen.dart`. Reference via `Assets.*` and `FontFamily.*` — never raw strings. Lists containing `AssetGenImage` must be `final`, not `const`.

### Localization
No ARB files. Translations live in `AppStrings._map` (`lib/config/l10n/app_strings.dart`). Call `AppStrings.t(key, lang)` where `lang` comes from `SettingsCubit.state.language`. Pages declare `String t(String key) => AppStrings.t(key, lang);` as a local function.

### Features
- **monitoring** — ML Kit face detection streamed via `FaceDetectionDataSource` → `Stream<MonitoringResult>`. `MonitoringCubit` subscribes on `startMonitoring()`, calls `DeviceRepository.sendAlert()` when status is `sleeping`.
- **calibration** — auto-calibrate runs 5 s timer in `CalibrationRepositoryImpl.autoCalibrate()`. Manual threshold chips call `CalibrationCubit.setManualThreshold()`.
- **alarm** — `AlarmDataSource` uses `Timer.periodic` + `StreamController<void>`. `AlarmCubit` subscribes to stream, calls `DeviceRepository.triggerAlarm()` on fire.
- **device** — `Esp32DataSourceImpl` (Dio) hits `/ping` and `/action?mode=&power=`. Mode mapping: vibration→VIBRATE, audio→AUDIO_ALARM, electric→ELECTRIC_PULSE.
- **settings** — `SettingsCubit.pingDevice()` and `testSignal()` include 3-second auto-reset of status back to `'idle'`.
