import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../widgets/luxury_widgets.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen();
  @override
  Widget build(BuildContext context) => LuxuryScaffold(
        title: 'Admin Dashboard',
        actions: [IconButton(onPressed: () => Navigator.pushNamed(context, '/admin/settings'), icon: const Icon(Icons.settings))],
        child: ListView(padding: const EdgeInsets.all(14), children: [
          GridView.count(
            crossAxisCount: MediaQuery.sizeOf(context).width > 700 ? 4 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              _Metric(title: 'Revenue', value: '₹18.4L', icon: Icons.currency_rupee),
              _Metric(title: 'Orders', value: '1,248', icon: Icons.receipt_long),
              _Metric(title: 'Stock Alerts', value: '17', icon: Icons.inventory),
              _Metric(title: 'AI Forecast', value: '+22%', icon: Icons.auto_graph),
            ],
          ),
          const SectionHeader('Sales analytics', subtitle: 'Bar graph visualization for monthly premium leather sales'),
          SizedBox(height: 240, child: Card(child: Padding(padding: const EdgeInsets.all(18), child: BarChart(BarChartData(barGroups: [for (var i = 0; i < 6; i++) BarChartGroupData(x: i, barRods: [BarChartRodData(toY: (i + 2) * 6, color: const Color(0xFF8E6E53), borderRadius: BorderRadius.circular(8))])])))),
          const SectionHeader('Management'),
          for (final route in ['/admin/add-product','/admin/edit-product','/admin/categories','/admin/users','/admin/orders','/admin/inventory','/admin/discounts','/admin/banners','/admin/reviews','/admin/delivery'])
            PremiumTile(title: route.split('/').last.replaceAll('-', ' '), subtitle: 'Manage ${route.split('/').last.replaceAll('-', ' ')}', icon: Icons.admin_panel_settings, onTap: () => Navigator.pushNamed(context, route)),
        ]),
      );
}

class _Metric extends StatelessWidget {
  const _Metric({required this.title, required this.value, required this.icon});
  final String title;
  final String value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon), const Spacer(), Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)), Text(title)])));
}
