import 'package:flutter/material.dart';

class AppStrings {
  static const supported = [Locale('en'), Locale('hi')];
  static const labels = {
    'en': {'app': 'MOSPL', 'search': 'Search products', 'chat': 'Assistant'},
    'hi': {'app': 'मॉसप्ल', 'search': 'उत्पाद खोजें', 'chat': 'सहायक'},
  };

  static String t(BuildContext context, String key) {
    final code = Localizations.localeOf(context).languageCode;
    return labels[code]?[key] ?? labels['en']![key] ?? key;
  }
}
