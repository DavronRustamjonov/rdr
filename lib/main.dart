//main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'providers/app_provider.dart';
import 'screens/home_screen.dart';
import 'screens/calibration_screen.dart';
import 'screens/alarm_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientation and system UI overlay
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider()..loadSettings(),
      child: const RDRApp(),
    ),
  );
}

class RDRApp extends StatelessWidget {
  const RDRApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        return MaterialApp(
          title: 'RDR',
          debugShowCheckedModeBanner: false,
          theme: _buildTheme(),
          locale: Locale(provider.language),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('uz'),
            Locale('en'),
            Locale('ru'),
          ],
          home: const MainNavigation(),
        );
      },
    );
  }

  ThemeData _buildTheme() {
    const bg = Color(0xFF050A14);
    const surface = Color(0xFF0D1626);
    const surfaceElevated = Color(0xFF162035);
    const border = Color(0xFF1E2D45);
    const accent = Color(0xFF00D4FF);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(
        primary: accent,
        surface: surface,
        onPrimary: Colors.black,
        onSurface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Rajdhani',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 4,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: accent,
        unselectedItemColor: Color(0xFF445566),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      // FIX: Ensure this is treated correctly as CardThemeData
      cardTheme: CardThemeData(
        color: surfaceElevated, // Used the previously unused variable here
        elevation: 0,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: border),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Rajdhani', fontWeight: FontWeight.w700),
        headlineLarge: TextStyle(fontFamily: 'Rajdhani', fontWeight: FontWeight.w700),
        headlineMedium: TextStyle(fontFamily: 'Rajdhani', fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontFamily: 'Rajdhani', fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontFamily: 'Rajdhani', fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontFamily: 'Rajdhani'),
        bodyMedium: TextStyle(fontFamily: 'Rajdhani'),
        labelLarge: TextStyle(fontFamily: 'Rajdhani', fontWeight: FontWeight.w600, letterSpacing: 1.5),
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    CalibrationScreen(),
    AlarmScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // watch is preferred inside build methods for reactive updates
    final provider = context.watch<AppProvider>();
    final t = provider.t;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFF1E2D45), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
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