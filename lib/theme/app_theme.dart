import 'package:expense_tracker_app/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static TextTheme _buildTextTheme(TextTheme base, Color textColor) {
    return base.apply(
      bodyColor: textColor,
      displayColor: textColor,
    );
  }

  static TextTheme get _baseTextTheme => GoogleFonts.poppinsTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
              fontSize: 96, fontWeight: FontWeight.w300, letterSpacing: -1.5),
          displayMedium: TextStyle(
              fontSize: 60, fontWeight: FontWeight.w300, letterSpacing: -0.5),
          displaySmall: TextStyle(fontSize: 48, fontWeight: FontWeight.w400),
          headlineMedium: TextStyle(
              fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
          headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
          titleLarge: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
          titleMedium: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
          titleSmall: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
          bodyLarge: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
          bodyMedium: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
          labelLarge: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
          bodySmall: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
          labelSmall: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
        ),
      );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    textTheme: _buildTextTheme(_baseTextTheme, Palette.blackColor),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Palette.montraPurple,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Palette.whiteColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Palette.whiteColor,
      foregroundColor: Palette.blackColor,
      elevation: 0,
    ),
    // Add more customizations for light theme here
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    textTheme: _buildTextTheme(_baseTextTheme, Palette.whiteColor),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Palette.montraPurple,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: Palette.blackColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Palette.blackColor,
      foregroundColor: Palette.whiteColor,
      elevation: 0,
    ),
  );
}
