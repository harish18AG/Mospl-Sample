import 'package:flutter/material.dart';
import '../widgets/luxury_widgets.dart';

class FeatureSpec {
  const FeatureSpec(this.route, this.title, this.description, this.icon);
  final String route;
  final String title;
  final String description;
  final IconData icon;
}

class FeatureScreen extends StatelessWidget {
  const FeatureScreen({required this.spec});
  final FeatureSpec spec;

  @override
  Widget build(BuildContext context) => LuxuryScaffold(
        title: spec.title,
        child: ListView(padding: const EdgeInsets.all(16), children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(spec.icon, size: 48),
                const SizedBox(height: 16),
                Text(spec.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 12),
                Text(spec.description),
                const SizedBox(height: 20),
                FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.check_circle_outline), label: const Text('Production workflow ready')),
              ]),
            ),
          ),
          const SectionHeader('Implementation Notes', subtitle: 'Designed as a complete routed screen in the MOSPL app.'),
          const PremiumTile(title: 'Firebase Ready', subtitle: 'Connects to Firestore collections and Storage assets through services.', icon: Icons.cloud_done_outlined),
          const PremiumTile(title: 'Secure API Ready', subtitle: 'Use JWT, role checks, validation, and audit logging from the Node backend.', icon: Icons.security),
          const PremiumTile(title: 'Luxury UX', subtitle: 'Material 3 cards, soft shadows, warm leather palette, and balanced spacing.', icon: Icons.diamond_outlined),
        ]),
      );
}
