import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'repositories/product_repository.dart';
import 'routes/app_routes.dart';
import 'themes/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(create: (_) => AppState(ProductRepository()), child: const MosplApp()));
}

class MosplApp extends StatelessWidget {
  const MosplApp();
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return MaterialApp(
      title: 'MOSPL',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: app.themeMode,
      routes: AppRoutes.routes(),
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
