import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final darkModeProvider = StateProvider<bool>((ref) => false);
final bottomNavProvider = StateProvider<int>((ref) => 0);
final localeProvider = StateProvider<Locale>((ref) => const Locale('en'));
