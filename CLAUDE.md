# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get                          # install dependencies
flutter analyze                         # lint (must return "No issues found!")
flutter run                             # run on connected device
flutter build apk --release             # release APK
flutter pub run build_runner build      # regenerate lib/core/gen/ after adding assets/fonts
flutter gen-l10n                        # regenerate lib/core/gen/l10n/ after editing ARB files
flutter test                            # run all tests
flutter test test/path/to_test.dart     # run single test
```

## Architecture

Clean Architecture + BLoC/Cubit. Design baseline **360×800** — all sizing uses `.r`, `.w`, `.h`, `.sp` (flutter_screenutil).

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
| `lib/core/di/injection_container.dart` | GetIt wiring — data sources → repos → use cases → cubits |
| `lib/config/routes/app_router.dart` | GoRouter with `StatefulShellRoute` (4 tabs) |
| `lib/core/constants/app_colors.dart` | All colors via `AppColors.*` |
| `lib/core/theme/app_theme.dart` | `AppTheme.dark` — single dark theme |
| `lib/core/extensions/l10n_extension.dart` | `context.l10n` — shorthand for `AppLocalizations.of(context)` |

### DI rules
- Repos + data sources: `registerLazySingleton`
- Use cases: `registerFactory`
- Cubits: `registerFactory` — **except** `SettingsCubit`: `registerLazySingleton` (shared global state)
- Cubits with no data deps: `create: (_) => MyCubit()` directly, skip GetIt

### Navigation
`GoRouter` → `StatefulShellRoute.indexedStack` → `AppShellPage` (4 branches: `/`, `/calibration`, `/alarm`, `/settings`). Branch route builders wrap with `BlocProvider`. `SettingsCubit` provided at root in `main.dart` via `BlocProvider.value`.

### Shared state
`SettingsCubit` holds `AppSettings` (language, esp32Ip, alertMode, intensity, earThreshold, deviceConnected). Other cubits read via `SettingsRepository.current` (sync getter) — not via `SettingsCubit`. ESP32 IP fetched via closure: `getIp: () => getIt<SettingsRepository>().current.esp32Ip`.

### Assets & fonts
After adding any image, SVG, or font: run `flutter pub run build_runner build` → regenerates `lib/core/gen/assets.gen.dart` + `lib/core/gen/fonts.gen.dart`. Reference via `Assets.*` / `FontFamily.*`, never raw strings. Lists containing `AssetGenImage` must be `final`, not `const`.

### Localization
ARB-based, code-generated. Supported languages: **uz / en / ru**.

- ARB files: `lib/l10n/app_en.arb` (template), `app_uz.arb`, `app_ru.arb`
- Generated output: `lib/core/gen/l10n/app_localizations.dart` (do not edit manually)
- Config: `l10n.yaml` at project root (`nullable-getter: false`)
- In pages: `context.l10n.keyName` via extension in `lib/core/extensions/l10n_extension.dart`
- To add a string: add key+value to all 3 ARB files, run `flutter gen-l10n`
- Language switching: `SettingsCubit.setLanguage(lang)` updates `locale` in `MaterialApp.router`; Flutter selects the correct `AppLocalizations` delegate automatically

### Features
- **monitoring** — ML Kit face detection → `Stream<MonitoringResult>` via `FaceDetectionDataSource`. `MonitoringCubit` subscribes on start, calls `DeviceRepository.sendAlert()` on `sleeping` status.
- **calibration** — auto-calibrate: 5 s timer in `CalibrationRepositoryImpl.autoCalibrate()`. Manual: `CalibrationCubit.setManualThreshold()`.
- **alarm** — `AlarmDataSource` uses `Timer.periodic` + `StreamController<void>`. `AlarmCubit` subscribes, calls `DeviceRepository.triggerAlarm()` on fire.
- **device** — `Esp32DataSourceImpl` (Dio) hits `/ping` + `/action?mode=&power=`. vibration→VIBRATE, audio→AUDIO_ALARM, electric→ELECTRIC_PULSE.
- **settings** — `pingDevice()` + `testSignal()` auto-reset status to `'idle'` after 3 s.
