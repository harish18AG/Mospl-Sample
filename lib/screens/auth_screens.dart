import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/app_state.dart';
import '../routes/app_routes.dart';
import '../widgets/luxury_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen();
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF171513), Color(0xFF3A2418)])),
          child: const Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.diamond_outlined, color: Color(0xFFC7A253), size: 84),
            SizedBox(height: 18),
            Text(AppConstants.appName, style: TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w900, letterSpacing: 5)),
            Text(AppConstants.companyName, style: TextStyle(color: Color(0xFFD8C3A5))),
          ]),
        ),
      );
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen();
  @override
  Widget build(BuildContext context) => LuxuryScaffold(
        title: 'Premium Leather',
        child: PageView(children: [
          _page(context, 'Luxury leather products', 'Curated jackets, bags, wallets, belts, shoes, watches, and accessories.'),
          _page(context, 'AI-assisted shopping', 'Personalized recommendations, smart search, and a premium chatbot assistant.'),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              _pageContent(context, 'Secure checkout', 'OTP, password, Google, biometric login, coupons, delivery tracking, and invoices.'),
              const SizedBox(height: 24),
              FilledButton(onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login), child: const Text('Enter MOSPL')),
            ]),
          ),
        ]),
      );

  Widget _page(BuildContext context, String title, String text) => Padding(
        padding: const EdgeInsets.all(24),
        child: Center(child: _pageContent(context, title, text)),
      );

  Widget _pageContent(BuildContext context, String title, String text) => Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.shopping_bag_outlined, size: 90),
        const SizedBox(height: 24),
        Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        Text(text, textAlign: TextAlign.center),
      ]);
}

class LoginScreen extends StatelessWidget {
  const LoginScreen();
  @override
  Widget build(BuildContext context) => LuxuryScaffold(
        title: 'Sign in',
        child: ListView(padding: const EdgeInsets.all(20), children: [
          Text('Welcome to MOSPL', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          const TextField(decoration: InputDecoration(labelText: 'Email or mobile number')),
          const SizedBox(height: 12),
          const TextField(obscureText: true, decoration: InputDecoration(labelText: 'Password / OTP')),
          const SizedBox(height: 20),
          FilledButton(onPressed: () { context.read<AppState>().login(); Navigator.pushReplacementNamed(context, AppRoutes.home); }, child: const Text('Sign in')),
          TextButton(onPressed: () => Navigator.pushNamed(context, '/auth/signup'), child: const Text('Create account')),
          TextButton(onPressed: () { context.read<AppState>().login(admin: true); Navigator.pushReplacementNamed(context, AppRoutes.admin); }, child: const Text('Continue as Admin')),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final route in ['/auth/otp-login','/auth/google','/auth/biometric','/auth/two-factor','/auth/forgot-password'])
              ActionChip(label: Text(route.split('/').last.replaceAll('-', ' ')), onPressed: () => Navigator.pushNamed(context, route)),
          ]),
        ]),
      );
}
