import 'package:flutter/material.dart';

class AppTheme {
  static const cream = Color(0xFFF7F2EA);
  static const leather = Color(0xFF8B5E3C);

  static ThemeData light() => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: leather, brightness: Brightness.light),
        scaffoldBackgroundColor: cream,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
      );

  static ThemeData dark() => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: leather, brightness: Brightness.dark),
      );
}
