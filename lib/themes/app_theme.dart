import 'package:flutter/material.dart';

class LuxuryColors {
  static const warmBeige = Color(0xFFD8C3A5);
  static const softBrown = Color(0xFF8E6E53);
  static const creamWhite = Color(0xFFFFFBF3);
  static const matteBlack = Color(0xFF171513);
  static const darkChocolate = Color(0xFF3A2418);
  static const lightCoffee = Color(0xFFC9A77D);
  static const softGold = Color(0xFFC7A253);
  static const charcoal = Color(0xFF24211E);
}

class AppTheme {
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: LuxuryColors.darkChocolate,
      brightness: Brightness.light,
      primary: LuxuryColors.darkChocolate,
      secondary: LuxuryColors.softGold,
      surface: LuxuryColors.creamWhite,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFFBF6EC),
      fontFamily: 'Poppins',
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: LuxuryColors.matteBlack,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: const EdgeInsets.all(8),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: LuxuryColors.matteBlack,
          foregroundColor: LuxuryColors.creamWhite,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  static ThemeData dark() {
    final theme = light();
    return theme.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: LuxuryColors.matteBlack,
      colorScheme: ColorScheme.fromSeed(
        seedColor: LuxuryColors.softGold,
        brightness: Brightness.dark,
        primary: LuxuryColors.softGold,
        secondary: LuxuryColors.lightCoffee,
        surface: const Color(0xFF211C18),
      ),
      cardTheme: theme.cardTheme.copyWith(color: const Color(0xFF211C18)),
    );
  }
}
