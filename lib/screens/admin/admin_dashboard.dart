// lib/screens/admin/admin_dashboard.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../themes/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
import '../../models/models.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});
  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  final List<_AdminNavItem> _navItems = [
    _AdminNavItem(Icons.dashboard_rounded, 'Dashboard'),
    _AdminNavItem(Icons.inventory_2_rounded, 'Products'),
    _AdminNavItem(Icons.receipt_long_rounded, 'Orders'),
    _AdminNavItem(Icons.group_rounded, 'Users'),
    _AdminNavItem(Icons.bar_chart_rounded, 'Analytics'),
  ];

  @override
  Widget build(BuildContext context) {
    // Check admin access
    final auth = context.watch<AuthProvider>();
    if (!auth.isAdmin) {
      return Scaffold(body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.block, size: 60, color: AppColors.accentError),
        const SizedBox(height: 16),
        const Text('Access Denied', style: TextStyle(fontFamily: 'Montserrat', fontSize: 22, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        const Text('Admin privileges required', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.textDarkGray)),
        const SizedBox(height: 24),
        ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Go Back')),
      ])));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.matteBlack,
        foregroundColor: Colors.white,
        title: Row(children: [
          const Icon(Icons.admin_panel_settings_rounded, color: AppColors.softGold, size: 22),
          const SizedBox(width: 10),
          const Text('Admin Panel', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, color: Colors.white)),
        ]),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.white), onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.refresh_rounded, color: Colors.white), onPressed: () => setState(() {})),
        ],
      ),
      body: Row(
        children: [
          // Side nav for tablets, bottom nav for phones
          if (MediaQuery.of(context).size.width > 600)
            _buildSideNav()
          else
            const SizedBox.shrink(),
          Expanded(
            child: [
              const _AdminOverviewTab(),
              const _AdminProductsTab(),
              const _AdminOrdersTab(),
              const _AdminUsersTab(),
              const _AdminAnalyticsTab(),
            ][_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width <= 600
          ? BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.softBrown,
        unselectedItemColor: AppColors.textLight,
        items: _navItems.map((n) => BottomNavigationBarItem(icon: Icon(n.icon), label: n.label)).toList(),
      )
          : null,
    );
  }

  Widget _buildSideNav() {
    return Container(
      width: 220,
      color: AppColors.matteBlack,
      child: Column(
        children: [
          const SizedBox(height: 20),
          ..._navItems.asMap().entries.map((e) {
            final isSelected = _selectedIndex == e.key;
            return ListTile(
              leading: Icon(e.value.icon, color: isSelected ? AppColors.softGold : Colors.white54, size: 22),
              title: Text(e.value.label, style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: isSelected ? AppColors.softGold : Colors.white70, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
              selected: isSelected,
              selectedTileColor: Colors.white.withOpacity(0.05),
              onTap: () => setState(() => _selectedIndex = e.key),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            );
          }),
        ],
      ),
    );
  }
}

class _AdminNavItem {
  final IconData icon;
  final String label;
  _AdminNavItem(this.icon, this.label);
}

// ==================== OVERVIEW TAB ====================
class _AdminOverviewTab extends StatelessWidget {
  const _AdminOverviewTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Dashboard Overview', style: TextStyle(fontFamily: 'Montserrat', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textCharcoal)),
          const SizedBox(height: 4),
          Text('Welcome back, ${context.read<AuthProvider>().user?.name ?? 'Admin'}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.textDarkGray)),
          const SizedBox(height: 20),
          // KPI Cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.4,
            children: [
              _KpiCard('Total Revenue', '₹4,82,350', Icons.currency_rupee_rounded, AppColors.accentSuccess, '+18.5%'),
              _KpiCard('Total Orders', '1,247', Icons.shopping_cart_rounded, AppColors.accentInfo, '+12.3%'),
              _KpiCard('Active Users', '3,891', Icons.people_rounded, AppColors.softBrown, '+8.7%'),
              _KpiCard('Products', '${DummyData.products.length}', Icons.inventory_2_rounded, AppColors.accentWarning, '+5 new'),
            ],
          ),
          const SizedBox(height: 24),
          // Revenue chart
          const Text('Revenue Trend (Last 7 Days)', style: TextStyle(fontFamily: 'Montserrat', fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (v) => FlLine(color: AppColors.divider, strokeWidth: 1)),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 44, getTitlesWidget: (v, _) => Text('₹${(v / 1000).toStringAsFixed(0)}k', style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: AppColors.textLight)))),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) {
                    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                    return Text(v.toInt() < days.length ? days[v.toInt()] : '', style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: AppColors.textLight));
                  })),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 42000), FlSpot(1, 58000), FlSpot(2, 51000),
                      FlSpot(3, 72000), FlSpot(4, 65000), FlSpot(5, 88000), FlSpot(6, 79000),
                    ],
                    isCurved: true,
                    color: AppColors.softBrown,
                    barWidth: 3,
                    belowBarData: BarAreaData(show: true, color: AppColors.softBrown.withOpacity(0.1)),
                    dotData: FlDotData(show: true, getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(radius: 4, color: AppColors.softBrown, strokeColor: Colors.white, strokeWidth: 2)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Category breakdown pie chart
          const Text('Sales by Category', style: TextStyle(fontFamily: 'Montserrat', fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: Row(
              children: [
                SizedBox(
                  height: 160,
                  width: 160,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: [
                        PieChartSectionData(value: 28, color: AppColors.softBrown, title: '28%', radius: 55, titleStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                        PieChartSectionData(value: 22, color: AppColors.lightCoffee, title: '22%', radius: 55, titleStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                        PieChartSectionData(value: 18, color: AppColors.warmBeige, title: '18%', radius: 55, titleStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textCharcoal)),
                        PieChartSectionData(value: 15, color: AppColors.darkChocolate, title: '15%', radius: 55, titleStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                        PieChartSectionData(value: 17, color: AppColors.softGold, title: '17%', radius: 55, titleStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _legendItem(AppColors.softBrown, 'Bags', '28%'),
                      _legendItem(AppColors.lightCoffee, 'Jackets', '22%'),
                      _legendItem(AppColors.warmBeige, 'Wallets', '18%'),
                      _legendItem(AppColors.darkChocolate, 'Belts', '15%'),
                      _legendItem(AppColors.softGold, 'Others', '17%'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Recent orders
          const Text('Recent Orders', style: TextStyle(fontFamily: 'Montserrat', fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          _buildRecentOrdersTable(),
          const SizedBox(height: 24),
          // AI Insights
          _buildAIInsightsCard(),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label, String percent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textCharcoal))),
        Text(percent, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDarkGray)),
      ]),
    );
  }

  Widget _buildRecentOrdersTable() {
    final orders = [
      {'id': 'MSP1001', 'customer': 'Arjun Sharma', 'amount': '₹6,999', 'status': 'Delivered', 'statusColor': 0xFF4CAF50},
      {'id': 'MSP1002', 'customer': 'Priya Venkatesh', 'amount': '₹3,499', 'status': 'Shipped', 'statusColor': 0xFF1976D2},
      {'id': 'MSP1003', 'customer': 'Rahul Kumar', 'amount': '₹11,999', 'status': 'Processing', 'statusColor': 0xFFF57C00},
      {'id': 'MSP1004', 'customer': 'Deepika S', 'amount': '₹1,199', 'status': 'Placed', 'statusColor': 0xFF8B6F47},
    ];

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(color: AppColors.bgLightCream, borderRadius: BorderRadius.vertical(top: Radius.circular(14))),
            child: const Row(children: [
              Expanded(flex: 2, child: Text('Order ID', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textDarkGray))),
              Expanded(flex: 3, child: Text('Customer', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textDarkGray))),
              Expanded(flex: 2, child: Text('Amount', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textDarkGray))),
              Expanded(flex: 2, child: Text('Status', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textDarkGray))),
            ]),
          ),
          ...orders.map((o) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(children: [
              Expanded(flex: 2, child: Text(o['id'] as String, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.softBrown, fontWeight: FontWeight.w500))),
              Expanded(flex: 3, child: Text(o['customer'] as String, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textCharcoal))),
              Expanded(flex: 2, child: Text(o['amount'] as String, style: const TextStyle(fontFamily: 'Montserrat', fontSize: 12, fontWeight: FontWeight.w700))),
              Expanded(flex: 2, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(color: Color(o['statusColor'] as int).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(o['status'] as String, style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w700, color: Color(o['statusColor'] as int))),
              )),
            ]),
          )),
        ],
      ),
    );
  }

  Widget _buildAIInsightsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.darkChocolate, AppColors.softBrown], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.auto_awesome, color: AppColors.softGold, size: 20),
            const SizedBox(width: 10),
            const Text('AI Business Insights', style: TextStyle(fontFamily: 'Montserrat', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
          ]),
          const SizedBox(height: 16),
          ...[
            '📈 Revenue projected to grow 22% this month based on current trends',
            '🛍️ Leather Bags category showing highest demand — consider restocking',
            '⚡ Flash sale recommended for Wallets — low stock, high interest',
            '👥 3 new premium customers in last 7 days — send loyalty rewards',
          ].map((insight) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(width: 4),
              Expanded(child: Text(insight, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.white70, height: 1.4))),
            ]),
          )),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String change;

  const _KpiCard(this.title, this.value, this.icon, this.color, this.change);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border), boxShadow: [BoxShadow(color: AppColors.shadowLight, blurRadius: 6)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(width: 36, height: 36, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 18)),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.accentSuccess.withOpacity(0.08), borderRadius: BorderRadius.circular(6)), child: Text(change, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.accentSuccess))),
          ]),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(value, style: const TextStyle(fontFamily: 'Montserrat', fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textCharcoal)),
            Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textLight)),
          ]),
        ],
      ),
    );
  }
}

// ==================== ADMIN PRODUCTS TAB ====================
class _AdminProductsTab extends StatelessWidget {
  const _AdminProductsTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        final products = provider.products.isEmpty ? DummyData.products : [];
        return Scaffold(
          body: Column(
            children: [
              // Search & Filter bar
              Container(
                padding: const EdgeInsets.all(16),
                color: AppColors.bgOffWhite,
                child: Row(children: [
                  Expanded(child: Container(height: 42, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)), child: const Row(children: [SizedBox(width: 12), Icon(Icons.search, size: 18, color: AppColors.textLight), SizedBox(width: 8), Text('Search products...', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textLight))]))),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.adminAddProduct),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add', style: TextStyle(fontFamily: 'Poppins', fontSize: 13)),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10)),
                  ),
                ]),
              ),
              // Products list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: DummyData.products.length,
                  itemBuilder: (_, i) {
                    final p = DummyData.products[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                      child: Row(children: [
                        ClipRRect(borderRadius: BorderRadius.circular(8), child: SizedBox(width: 60, height: 60, child: Image.network((p['images'] as List).first, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: AppColors.bgLightCream)))),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(p['name'] as String, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text(p['categoryName'] as String, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textLight)),
                          Row(children: [
                            Text('₹${p['offerPrice']}', style: const TextStyle(fontFamily: 'Montserrat', fontSize: 14, fontWeight: FontWeight.w700)),
                            const SizedBox(width: 8),
                            Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.accentSuccess.withOpacity(0.1), borderRadius: BorderRadius.circular(4)), child: Text('Stock: ${p['stockCount']}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: AppColors.accentSuccess, fontWeight: FontWeight.w600))),
                          ]),
                        ])),
                        Column(children: [
                          IconButton(icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.softBrown), onPressed: () => Navigator.pushNamed(context, '/admin/products/${p['id']}/edit')),
                          IconButton(icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.accentError), onPressed: () => _confirmDelete(context, p['name'] as String)),
                        ]),
                      ]),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Product', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700)),
        content: Text('Are you sure you want to delete "$name"?', style: const TextStyle(fontFamily: 'Poppins', fontSize: 14)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(fontFamily: 'Poppins'))),
          ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentError), child: const Text('Delete', style: TextStyle(fontFamily: 'Poppins'))),
        ],
      ),
    );
  }
}

// ==================== ADMIN ORDERS TAB ====================
class _AdminOrdersTab extends StatelessWidget {
  const _AdminOrdersTab();

  @override
  Widget build(BuildContext context) {
    final mockOrders = [
      {'id': 'MSP1001', 'customer': 'Arjun Sharma', 'amount': 6999, 'status': 'delivered', 'items': 2, 'date': '05 Jan 2024'},
      {'id': 'MSP1002', 'customer': 'Priya Venkatesh', 'amount': 3499, 'status': 'shipped', 'items': 1, 'date': '06 Jan 2024'},
      {'id': 'MSP1003', 'customer': 'Rahul Kumar', 'amount': 11999, 'status': 'processing', 'items': 3, 'date': '06 Jan 2024'},
      {'id': 'MSP1004', 'customer': 'Deepika Subramaniam', 'amount': 1199, 'status': 'placed', 'items': 1, 'date': '07 Jan 2024'},
      {'id': 'MSP1005', 'customer': 'Vikram Nair', 'amount': 8499, 'status': 'cancelled', 'items': 2, 'date': '07 Jan 2024'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mockOrders.length,
      itemBuilder: (_, i) {
        final o = mockOrders[i];
        final statusColors = {'delivered': AppColors.accentSuccess, 'shipped': AppColors.accentInfo, 'processing': AppColors.accentWarning, 'placed': AppColors.softBrown, 'cancelled': AppColors.accentError};
        final color = statusColors[o['status']] ?? AppColors.textLight;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(o['id'] as String, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.softBrown)),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Text((o['status'] as String).toUpperCase(), style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w700, color: color))),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                const Icon(Icons.person_outline, size: 16, color: AppColors.textLight),
                const SizedBox(width: 6),
                Text(o['customer'] as String, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textCharcoal)),
                const Spacer(),
                Text('${o['items']} items', style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textLight)),
              ]),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textLight),
                const SizedBox(width: 6),
                Text(o['date'] as String, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textLight)),
                const Spacer(),
                Text('₹${o['amount']}', style: const TextStyle(fontFamily: 'Montserrat', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textCharcoal)),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8)), child: const Text('View Details', style: TextStyle(fontFamily: 'Poppins', fontSize: 12)))),
                const SizedBox(width: 10),
                Expanded(child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8)), child: const Text('Update Status', style: TextStyle(fontFamily: 'Poppins', fontSize: 12)))),
              ]),
            ],
          ),
        );
      },
    );
  }
}

// ==================== ADMIN USERS TAB ====================
class _AdminUsersTab extends StatelessWidget {
  const _AdminUsersTab();

  @override
  Widget build(BuildContext context) {
    final users = [
      {'name': 'Arjun Sharma', 'email': 'arjun@gmail.com', 'orders': 12, 'spent': 48500, 'status': 'active'},
      {'name': 'Priya Venkatesh', 'email': 'priya@gmail.com', 'orders': 8, 'spent': 32000, 'status': 'active'},
      {'name': 'Rahul Kumar', 'email': 'rahul@gmail.com', 'orders': 5, 'spent': 21500, 'status': 'active'},
      {'name': 'Deepika S', 'email': 'deepika@gmail.com', 'orders': 3, 'spent': 9800, 'status': 'inactive'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (_, i) {
        final u = users[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
          child: Row(children: [
            CircleAvatar(radius: 24, backgroundColor: AppColors.warmBeige, child: Text((u['name'] as String)[0], style: const TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.softBrown))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(u['name'] as String, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: u['status'] == 'active' ? AppColors.accentSuccess.withOpacity(0.1) : AppColors.accentError.withOpacity(0.1), borderRadius: BorderRadius.circular(4)), child: Text(u['status'] as String, style: TextStyle(fontFamily: 'Poppins', fontSize: 9, fontWeight: FontWeight.w700, color: u['status'] == 'active' ? AppColors.accentSuccess : AppColors.accentError))),
              ]),
              Text(u['email'] as String, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textLight)),
              Row(children: [
                Text('${u['orders']} orders', style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textDarkGray)),
                const Text(' · ', style: TextStyle(color: AppColors.textLight)),
                Text('₹${u['spent']}', style: const TextStyle(fontFamily: 'Montserrat', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.softBrown)),
              ]),
            ])),
            IconButton(icon: const Icon(Icons.more_vert, color: AppColors.textLight), onPressed: () {}),
          ]),
        );
      },
    );
  }
}

// ==================== ADMIN ANALYTICS TAB ====================
class _AdminAnalyticsTab extends StatelessWidget {
  const _AdminAnalyticsTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sales Analytics', style: TextStyle(fontFamily: 'Montserrat', fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          // Bar chart - Monthly revenue
          Container(
            height: 220,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Monthly Revenue', style: TextStyle(fontFamily: 'Montserrat', fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (v) => FlLine(color: AppColors.divider, strokeWidth: 1)),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 44, getTitlesWidget: (v, _) => Text('₹${(v / 1000).toStringAsFixed(0)}k', style: const TextStyle(fontFamily: 'Poppins', fontSize: 9, color: AppColors.textLight)))),
                        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) {
                          const months = ['Oct', 'Nov', 'Dec', 'Jan'];
                          return Text(v.toInt() < months.length ? months[v.toInt()] : '', style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: AppColors.textLight));
                        })),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: [
                        BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 82000, color: AppColors.softBrown, width: 32, borderRadius: BorderRadius.circular(6))]),
                        BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 96000, color: AppColors.softBrown, width: 32, borderRadius: BorderRadius.circular(6))]),
                        BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 142000, color: AppColors.lightCoffee, width: 32, borderRadius: BorderRadius.circular(6))]),
                        BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 115000, color: AppColors.softBrown, width: 32, borderRadius: BorderRadius.circular(6))]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Top products
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Top Products', style: TextStyle(fontFamily: 'Montserrat', fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                ...DummyData.products.take(5).toList().asMap().entries.map((e) {
                  final p = e.value;
                  final pct = 100 - (e.key * 18);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(children: [
                      SizedBox(width: 24, child: Text('${e.key + 1}', style: const TextStyle(fontFamily: 'Montserrat', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textLight))),
                      const SizedBox(width: 8),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(p['name'] as String, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(value: pct / 100, backgroundColor: AppColors.bgLightCream, color: AppColors.softBrown, minHeight: 6, borderRadius: BorderRadius.circular(3)),
                      ])),
                      const SizedBox(width: 12),
                      Text('$pct%', style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDarkGray)),
                    ]),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}