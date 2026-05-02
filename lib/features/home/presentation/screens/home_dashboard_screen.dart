import 'package:flutter/material.dart';
import '../../../../core/widgets/app_scaffold.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'MOSPL Home',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            height: 180,
            child: PageView(
              children: List.generate(
                3,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(color: Colors.brown[(i + 1) * 100], borderRadius: BorderRadius.circular(18)),
                  child: Center(child: Text('Luxury Drop ${i + 1}', style: const TextStyle(fontSize: 24, color: Colors.white))),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Shop by Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2.5),
            itemBuilder: (_, i) => Card(child: Center(child: Text(['Wallets', 'Belts', 'Bags', 'Jackets', 'Accessories'][i]))),
          )
        ],
      ),
    );
  }
}
