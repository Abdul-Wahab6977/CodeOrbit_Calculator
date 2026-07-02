import 'package:flutter/material.dart';

/// Centralized color palette for the app.
///
/// Kept separate from [AppTheme] so individual widgets (e.g. custom
/// neumorphic/glass button surfaces) can reference exact colors without
/// digging through a ThemeData tree.
class AppColors {
  AppColors._();

  // Base neutrals
  static const Color matteBlack = Color(0xFF121212);
  static const Color slateGrayDark = Color(0xFF1E2228);
  static const Color slateGray = Color(0xFF2A2F38);
  static const Color slateGrayLight = Color(0xFFEDEFF3);
  static const Color offWhite = Color(0xFFF7F8FA);

  // Accents
  static const Color accentOrange = Color(0xFFFF8A3D);
  static const Color accentBlue = Color(0xFF4C8CFF);
  static const Color errorRed = Color(0xFFFF5C5C);

  // Dark theme surfaces
  static const Color darkBackground = matteBlack;
  static const Color darkSurface = slateGrayDark;
  static const Color darkButtonNumber = slateGray;
  static const Color darkButtonFunction = Color(0xFF3A4048);

  // Light theme surfaces
  static const Color lightBackground = offWhite;
  static const Color lightSurface = Colors.white;
  static const Color lightButtonNumber = slateGrayLight;
  static const Color lightButtonFunction = Color(0xFFE2E5EA);
}

/// Builds the app's light and dark [ThemeData], both seeded from the same
/// accent color so Material 3 components stay visually consistent.
class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accentBlue,
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accentOrange,
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
      );
}

/// Semantic button categories, used by the UI layer to pick the right
/// color/elevation for a given key without hardcoding logic in widgets.
enum CalcButtonType { number, operatorKey, function, equals }
