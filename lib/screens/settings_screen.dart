import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/luxury_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen();
  static const sections = {
    'Account Settings': ['/settings/edit-profile','/settings/change-password','/settings/change-email','/settings/change-mobile','/settings/delete-account'],
    'Order & Tracking': ['/orders/tracking','/orders/timeline','/orders/list','/orders/returns','/orders/invoice'],
    'Notification Settings': ['/settings/push'],
    'Privacy & Security': ['/settings/privacy','/auth/biometric','/auth/session','/auth/two-factor'],
    'Payment Settings': ['/settings/payments'],
    'App Preferences': ['/settings/preferences'],
    'AI Settings': ['/settings/ai','/shop/ai-recommendations','/shop/chatbot'],
    'Support & Help': ['/settings/help','/shop/support'],
    'Tracking & Analytics': ['/settings/activity','/shop/recently-viewed','/shop/rewards'],
    'Admin Settings': ['/admin/settings','/admin/revenue','/admin/product-analytics','/admin/ai-sales'],
  };

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return LuxuryScaffold(
      title: 'Settings',
      child: ListView(padding: const EdgeInsets.all(12), children: [
        Card(child: SwitchListTile(title: const Text('Dark mode'), subtitle: const Text('Luxury matte black theme'), value: app.themeMode == ThemeMode.dark, onChanged: app.toggleTheme)),
        for (final entry in sections.entries) ...[
          SectionHeader(entry.key),
          for (final route in entry.value)
            PremiumTile(title: _title(route), subtitle: 'Open ${_title(route)} controls', icon: Icons.chevron_right, onTap: () => Navigator.pushNamed(context, route)),
        ],
        PremiumTile(title: 'Logout', subtitle: 'End this session securely', icon: Icons.logout, onTap: app.logout),
      ]),
    );
  }

  String _title(String route) => route.split('/').last.replaceAll('-', ' ').split(' ').map((w) => '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
}
