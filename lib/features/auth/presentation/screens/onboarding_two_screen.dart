import 'package:flutter/material.dart';
import '../../../../core/widgets/app_scaffold.dart';

class OnboardingTwoScreen extends StatelessWidget {
  const OnboardingTwoScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AppScaffold(title: 'Onboarding Two', showBottomNav: false, body: ListView(padding: const EdgeInsets.all(16), children: [
      Container(height: 160, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), child: const Center(child: Icon(Icons.shopping_bag, size: 52))),
      const SizedBox(height: 12),
      const Text('Premium leather experience for MOSPL', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 8, children: List.generate(6, (i) => Chip(label: Text('Item ${i+1}')))),
    ]));
  }
}
