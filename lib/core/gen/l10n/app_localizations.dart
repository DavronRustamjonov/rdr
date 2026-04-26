import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('uz')
  ];

  /// No description provided for @monitoringActive.
  ///
  /// In en, this message translates to:
  /// **'Monitoring Active'**
  String get monitoringActive;

  /// No description provided for @monitoringIdle.
  ///
  /// In en, this message translates to:
  /// **'Monitoring Stopped'**
  String get monitoringIdle;

  /// No description provided for @eyesOpen.
  ///
  /// In en, this message translates to:
  /// **'Eyes Open'**
  String get eyesOpen;

  /// No description provided for @eyesClosed.
  ///
  /// In en, this message translates to:
  /// **'Eyes Closed'**
  String get eyesClosed;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning! Wake up'**
  String get warning;

  /// No description provided for @setAlarm.
  ///
  /// In en, this message translates to:
  /// **'Set Alarm'**
  String get setAlarm;

  /// No description provided for @pulseIntensity.
  ///
  /// In en, this message translates to:
  /// **'Pulse Intensity'**
  String get pulseIntensity;

  /// No description provided for @calibration.
  ///
  /// In en, this message translates to:
  /// **'Calibration'**
  String get calibration;

  /// No description provided for @alarm.
  ///
  /// In en, this message translates to:
  /// **'Alarm'**
  String get alarm;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @monitoring.
  ///
  /// In en, this message translates to:
  /// **'Monitor'**
  String get monitoring;

  /// No description provided for @startMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Start Monitoring'**
  String get startMonitoring;

  /// No description provided for @stopMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Stop Monitoring'**
  String get stopMonitoring;

  /// No description provided for @deviceConnected.
  ///
  /// In en, this message translates to:
  /// **'Device Connected'**
  String get deviceConnected;

  /// No description provided for @deviceDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Device Disconnected'**
  String get deviceDisconnected;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @intensity.
  ///
  /// In en, this message translates to:
  /// **'Signal Intensity'**
  String get intensity;

  /// No description provided for @alertMode.
  ///
  /// In en, this message translates to:
  /// **'Alert Mode'**
  String get alertMode;

  /// No description provided for @vibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibration;

  /// No description provided for @audio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get audio;

  /// No description provided for @electric.
  ///
  /// In en, this message translates to:
  /// **'Electric Pulse'**
  String get electric;

  /// No description provided for @threshold.
  ///
  /// In en, this message translates to:
  /// **'EAR Threshold'**
  String get threshold;

  /// No description provided for @calibrateNow.
  ///
  /// In en, this message translates to:
  /// **'Calibrate Now'**
  String get calibrateNow;

  /// No description provided for @eyesClosedWarn.
  ///
  /// In en, this message translates to:
  /// **'Your eyes are closing!'**
  String get eyesClosedWarn;

  /// No description provided for @awake.
  ///
  /// In en, this message translates to:
  /// **'Awake'**
  String get awake;

  /// No description provided for @drowsy.
  ///
  /// In en, this message translates to:
  /// **'Drowsy'**
  String get drowsy;

  /// No description provided for @asleep.
  ///
  /// In en, this message translates to:
  /// **'Asleep'**
  String get asleep;

  /// No description provided for @alarmTime.
  ///
  /// In en, this message translates to:
  /// **'Alarm Time'**
  String get alarmTime;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @earScore.
  ///
  /// In en, this message translates to:
  /// **'Eye Openness Score'**
  String get earScore;

  /// No description provided for @connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get connecting;

  /// No description provided for @esp32Ip.
  ///
  /// In en, this message translates to:
  /// **'ESP32 IP Address'**
  String get esp32Ip;

  /// No description provided for @testSignal.
  ///
  /// In en, this message translates to:
  /// **'Test Signal'**
  String get testSignal;

  /// No description provided for @signalSent.
  ///
  /// In en, this message translates to:
  /// **'Signal Sent'**
  String get signalSent;

  /// No description provided for @signalFailed.
  ///
  /// In en, this message translates to:
  /// **'Device Unreachable'**
  String get signalFailed;

  /// No description provided for @alarmActive.
  ///
  /// In en, this message translates to:
  /// **'Alarm Active'**
  String get alarmActive;

  /// No description provided for @alarmStopped.
  ///
  /// In en, this message translates to:
  /// **'Alarm Stopped'**
  String get alarmStopped;

  /// No description provided for @cameraPermission.
  ///
  /// In en, this message translates to:
  /// **'Camera permission required'**
  String get cameraPermission;

  /// No description provided for @grantPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant Permission'**
  String get grantPermission;

  /// No description provided for @keepEyesOpen.
  ///
  /// In en, this message translates to:
  /// **'Keep your eyes wide open...'**
  String get keepEyesOpen;

  /// No description provided for @calibrating.
  ///
  /// In en, this message translates to:
  /// **'Calibrating...'**
  String get calibrating;

  /// No description provided for @calibrationDone.
  ///
  /// In en, this message translates to:
  /// **'Calibration complete'**
  String get calibrationDone;

  /// No description provided for @esp32Address.
  ///
  /// In en, this message translates to:
  /// **'ESP32 Address'**
  String get esp32Address;

  /// No description provided for @pingDevice.
  ///
  /// In en, this message translates to:
  /// **'Ping Device'**
  String get pingDevice;

  /// Info box text in calibration page
  ///
  /// In en, this message translates to:
  /// **'EAR (Eye Aspect Ratio) — values below 0.20 indicate closed eyes, above 0.30 is fully open. Keep your eyes wide open during calibration.'**
  String get calibrationInfo;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
