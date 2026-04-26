import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.accent,
          surface: AppColors.surface,
          onPrimary: Colors.black,
          onSurface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.bg,
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
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.accent,
          unselectedItemColor: AppColors.textDim,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: AppColors.surfaceElevated,
          elevation: 0,
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.border),
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
