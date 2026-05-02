import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/state/app_state.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_strings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MosplApp()));
}

class MosplApp extends ConsumerWidget {
  const MosplApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'MOSPL',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ref.watch(darkModeProvider) ? ThemeMode.dark : ThemeMode.light,
      locale: ref.watch(localeProvider),
      supportedLocales: AppStrings.supported,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
