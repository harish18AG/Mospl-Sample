// lib/screens/profile/profile_screens.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../themes/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (!auth.isAuthenticated) return _buildGuestView(context);
          final user = auth.user!;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 200,
                pinned: true,
                backgroundColor: AppColors.matteBlack,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.matteBlack, AppColors.darkChocolate],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                // Avatar
                                CircleAvatar(
                                  radius: 36,
                                  backgroundColor: AppColors.softGold.withOpacity(0.2),
                                  backgroundImage: user.profileImage != null ? NetworkImage(user.profileImage!) : null,
                                  child: user.profileImage == null
                                      ? Text(user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                                      style: const TextStyle(fontFamily: 'Montserrat', fontSize: 30, fontWeight: FontWeight.w700, color: AppColors.softGold))
                                      : null,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(user.name, style: const TextStyle(fontFamily: 'Montserrat', fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                                      Text(user.email, style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.white.withOpacity(0.7))),
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.softGold.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: AppColors.softGold.withOpacity(0.3)),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.star_rounded, size: 14, color: AppColors.softGold),
                                            const SizedBox(width: 4),
                                            Text('${user.rewardPoints} pts', style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.softGold)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, color: Colors.white),
                                  onPressed: () => Navigator.pushNamed(context, AppRoutes.editProfile),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                actions: [
                  if (user.isAdmin)
                    TextButton.icon(
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.adminDashboard),
                      icon: const Icon(Icons.admin_panel_settings_rounded, color: AppColors.softGold, size: 18),
                      label: const Text('Admin', style: TextStyle(color: AppColors.softGold, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                    ),
                ],
              ),
              SliverToBoxAdapter(child: _buildProfileContent(context, user, auth)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, user, AuthProvider auth) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick stats
          Row(
            children: [
              _statCard('Orders', '12', Icons.shopping_bag_outlined),
              const SizedBox(width: 12),
              _statCard('Wishlist', '8', Icons.favorite_border_rounded),
              const SizedBox(width: 12),
              _statCard('Reviews', '5', Icons.star_border_rounded),
            ],
          ),
          const SizedBox(height: 24),

          // Orders & Tracking
          _sectionTitle('Orders & Tracking'),
          _menuTile(context, Icons.receipt_long_outlined, 'My Orders', 'Track and manage orders', AppRoutes.orderHistory),
          _menuTile(context, Icons.local_shipping_outlined, 'Track Shipment', 'Real-time delivery tracking', AppRoutes.orderTracking.replaceAll(':id', 'latest')),
          _menuTile(context, Icons.assignment_return_outlined, 'Returns & Refunds', 'Manage return requests', AppRoutes.returnRequest.replaceAll(':orderId', 'select')),
          _menuTile(context, Icons.file_download_outlined, 'Download Invoice', 'Get order invoices', AppRoutes.invoice.replaceAll(':orderId', 'select')),

          const SizedBox(height: 20),
          _sectionTitle('Account'),
          _menuTile(context, Icons.person_outline_rounded, 'Edit Profile', 'Update your personal info', AppRoutes.editProfile),
          _menuTile(context, Icons.location_on_outlined, 'Manage Addresses', 'Add or edit addresses', AppRoutes.addAddress),
          _menuTile(context, Icons.credit_card_outlined, 'Payment Methods', 'Saved cards & UPI', AppRoutes.settings),
          _menuTile(context, Icons.card_giftcard_rounded, 'Reward Points', '${user.rewardPoints} pts available', AppRoutes.rewardPoints),
          _menuTile(context, Icons.local_offer_outlined, 'Coupons & Offers', 'View available coupons', AppRoutes.coupons),

          const SizedBox(height: 20),
          _sectionTitle('Preferences'),
          _menuTile(context, Icons.notifications_outlined, 'Notifications', 'Manage notifications', AppRoutes.notifications),
          _menuTile(context, Icons.smart_toy_outlined, 'AI Preferences', 'Personalize AI recommendations', AppRoutes.settings),
          _menuTile(context, Icons.dark_mode_outlined, 'App Theme', 'Dark / Light mode', AppRoutes.settings),

          const SizedBox(height: 20),
          _sectionTitle('Support'),
          _menuTile(context, Icons.chat_bubble_outline_rounded, 'AI Chat Assistant', 'Get instant help', AppRoutes.aiChat),
          _menuTile(context, Icons.headset_mic_outlined, 'Customer Support', 'Contact our team', AppRoutes.support),
          _menuTile(context, Icons.help_outline_rounded, 'FAQ', 'Frequently asked questions', AppRoutes.faq),
          _menuTile(context, Icons.policy_outlined, 'Privacy Policy', '', AppRoutes.privacy),
          _menuTile(context, Icons.description_outlined, 'Terms & Conditions', '', AppRoutes.terms),

          const SizedBox(height: 20),
          // Logout button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () => _confirmLogout(context, auth),
              icon: const Icon(Icons.logout_rounded, color: AppColors.accentError),
              label: const Text('Sign Out', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.accentError)),
              style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.accentError), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            ),
          ),
          const SizedBox(height: 8),
          Center(child: Text('MOSPL v${AppConstants.appVersion} · ${AppConstants.companyName}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textLight))),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
        child: Column(
          children: [
            Icon(icon, color: AppColors.softBrown, size: 22),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontFamily: 'Montserrat', fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textCharcoal)),
            Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textLight)),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title, style: const TextStyle(fontFamily: 'Montserrat', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textCharcoal, letterSpacing: 0.5)),
    );
  }

  Widget _menuTile(BuildContext context, IconData icon, String title, String subtitle, String route) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: ListTile(
        leading: Container(width: 38, height: 38, decoration: BoxDecoration(color: AppColors.warmBeige, borderRadius: BorderRadius.circular(10)), child: Icon(icon, size: 20, color: AppColors.softBrown)),
        title: Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textCharcoal)),
        subtitle: subtitle.isNotEmpty ? Text(subtitle, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textLight)) : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textLight),
        onTap: () => Navigator.pushNamed(context, route),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildGuestView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 90, height: 90, decoration: BoxDecoration(color: AppColors.warmBeige, shape: BoxShape.circle), child: const Icon(Icons.person_outline_rounded, size: 48, color: AppColors.softBrown)),
            const SizedBox(height: 20),
            const Text('Sign in to MOSPL', style: TextStyle(fontFamily: 'Montserrat', fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textCharcoal)),
            const SizedBox(height: 8),
            const Text('Access your orders, wishlist, and personalized recommendations', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.textDarkGray, height: 1.5)),
            const SizedBox(height: 32),
            SizedBox(width: double.infinity, height: 52, child: ElevatedButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.login), child: const Text('Sign In'))),
            const SizedBox(height: 12),
            SizedBox(width: double.infinity, height: 52, child: OutlinedButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.register), child: const Text('Create Account'))),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign Out', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700)),
        content: const Text('Are you sure you want to sign out?', style: TextStyle(fontFamily: 'Poppins', fontSize: 14)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(fontFamily: 'Poppins'))),
          ElevatedButton(
            onPressed: () { auth.signOut(); Navigator.pop(context); },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentError),
            child: const Text('Sign Out', style: TextStyle(fontFamily: 'Poppins')),
          ),
        ],
      ),
    );
  }
}

// ==================== WISHLIST SCREEN ====================
class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Wishlist'), automaticallyImplyLeading: false),
      body: Consumer2<WishlistProvider, AuthProvider>(
        builder: (context, wl, auth, _) {
          if (wl.wishlistProducts.isEmpty) {
            return EmptyState(
              icon: Icons.favorite_border_rounded,
              title: 'Your wishlist is empty',
              subtitle: 'Save items you love to your wishlist',
              buttonLabel: 'Explore Products',
              onButtonTap: () => Navigator.pushNamed(context, AppRoutes.productListing),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: 0.68),
            itemCount: wl.wishlistProducts.length,
            itemBuilder: (_, i) {
              final product = wl.wishlistProducts[i];
              return ProductCard(
                product: product,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product))),
                onWishlistTap: () => wl.toggleWishlist(auth.user?.id ?? '', product),
                isWishlisted: true,
              );
            },
          );
        },
      ),
    );
  }
}

// ==================== SEARCH SCREEN ====================
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();
  List<dynamic> _results = [];
  bool _isSearching = false;

  void _search(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      _results = context.read<ProductProvider>().searchProducts(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
          controller: _ctrl,
          autofocus: false,
          onChanged: _search,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Search leather bags, wallets...',
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search, color: AppColors.textLight),
            suffixIcon: _ctrl.text.isNotEmpty
                ? IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () { _ctrl.clear(); _search(''); })
                : null,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.mic, color: AppColors.softBrown),
            onPressed: () {}, // Voice search
          ),
        ],
      ),
      body: _isSearching ? _buildResults() : _buildDefault(),
    );
  }

  Widget _buildDefault() {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        final history = provider.searchHistory;
        final trending = ['Leather Wallet', 'Biker Jacket', 'Office Bag', 'Chelsea Boots', 'Tote Bag'];
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (history.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent Searches', style: TextStyle(fontFamily: 'Montserrat', fontSize: 15, fontWeight: FontWeight.w700)),
                  TextButton(onPressed: provider.clearSearchHistory, child: const Text('Clear', style: TextStyle(color: AppColors.softBrown, fontFamily: 'Poppins'))),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: history.take(8).map((h) => GestureDetector(
                  onTap: () { _ctrl.text = h; _search(h); },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(color: AppColors.bgLightCream, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.history, size: 14, color: AppColors.textLight),
                      const SizedBox(width: 6),
                      Text(h, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textCharcoal)),
                    ]),
                  ),
                )).toList(),
              ),
              const SizedBox(height: 24),
            ],
            const Text('Trending Searches', style: TextStyle(fontFamily: 'Montserrat', fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: trending.map((t) => GestureDetector(
                onTap: () { _ctrl.text = t; _search(t); },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(color: AppColors.warmBeige, borderRadius: BorderRadius.circular(20)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.trending_up_rounded, size: 14, color: AppColors.softBrown),
                    const SizedBox(width: 6),
                    Text(t, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.softBrown, fontWeight: FontWeight.w500)),
                  ]),
                ),
              )).toList(),
            ),
            const SizedBox(height: 24),
            const Text('Browse Categories', style: TextStyle(fontFamily: 'Montserrat', fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            ...DummyData.categories.map((cat) => ListTile(
              leading: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.warmBeige, borderRadius: BorderRadius.circular(10)), child: Center(child: Text(cat['icon'], style: const TextStyle(fontSize: 20)))),
              title: Text(cat['name'], style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500)),
              subtitle: Text('${cat['productCount']} products', style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textLight)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textLight),
              onTap: () => Navigator.pushNamed(context, AppRoutes.productListing, arguments: {'categoryId': cat['id'], 'categoryName': cat['name']}),
            )),
          ],
        );
      },
    );
  }

  Widget _buildResults() {
    if (_results.isEmpty) {
      return EmptyState(icon: Icons.search_off_rounded, title: 'No results found', subtitle: 'Try different keywords or browse categories');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Text('${_results.length} results for "${_ctrl.text}"', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textLight)),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: 0.68),
            itemCount: _results.length,
            itemBuilder: (_, i) => ProductCard(
              product: _results[i],
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: _results[i]))),
              onWishlistTap: () => context.read<WishlistProvider>().toggleWishlist(context.read<AuthProvider>().user?.id ?? '', _results[i]),
              isWishlisted: context.watch<WishlistProvider>().isWishlisted(_results[i].id),
            ),
          ),
        ),
      ],
    );
  }
}

// ==================== ORDER HISTORY SCREEN ====================
class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});
  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = context.read<AuthProvider>().user?.id;
      if (uid != null) context.read<OrderProvider>().loadOrders(uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context))),
      body: Consumer<OrderProvider>(
        builder: (context, orders, _) {
          if (orders.isLoading) return const Center(child: CircularProgressIndicator(color: AppColors.softBrown));
          if (orders.orders.isEmpty) return EmptyState(icon: Icons.receipt_long_outlined, title: 'No Orders Yet', subtitle: 'Your orders will appear here', buttonLabel: 'Start Shopping', onButtonTap: () => Navigator.pushReplacementNamed(context, AppRoutes.home));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.orders.length,
            itemBuilder: (_, i) => _OrderCard(order: orders.orders[i]),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  const _OrderCard({required this.order});

  Color _statusColor(String status) {
    switch (status) {
      case 'delivered': return AppColors.accentSuccess;
      case 'cancelled': return AppColors.accentError;
      case 'shipped': case 'out_for_delivery': return AppColors.accentInfo;
      default: return AppColors.accentWarning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border), boxShadow: [BoxShadow(color: AppColors.shadowLight, blurRadius: 6, offset: const Offset(0, 2))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(order.id, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textCharcoal)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: _statusColor(order.orderStatus).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(order.orderStatus.toUpperCase(), style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w700, color: _statusColor(order.orderStatus))),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              if (order.items.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(width: 60, height: 60, child: Image.network(order.items[0].productImage, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: AppColors.bgLightCream))),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${order.items.length} item${order.items.length > 1 ? 's' : ''}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textDarkGray)),
                    Text('₹${order.total.toStringAsFixed(0)}', style: const TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textCharcoal)),
                    Text('${order.paymentMethod.toUpperCase()} · ${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textLight)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pushNamed(context, '/order-tracking/${order.id}'),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 10)),
                  child: const Text('Track Order', style: TextStyle(fontFamily: 'Poppins', fontSize: 13)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/order/${order.id}'),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 10)),
                  child: const Text('View Details', style: TextStyle(fontFamily: 'Poppins', fontSize: 13)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ==================== NOTIFICATIONS SCREEN ====================
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  final List<Map<String, dynamic>> _notifications = const [
    {'icon': Icons.local_shipping_outlined, 'title': 'Order Shipped!', 'body': 'Your order #MSP1234 has been shipped and is on its way.', 'time': '2 hours ago', 'isRead': false, 'color': 0xFF1976D2},
    {'icon': Icons.local_offer_outlined, 'title': 'Weekend Sale is Live!', 'body': 'Get up to 25% off on premium leather bags this weekend only.', 'time': '1 day ago', 'isRead': false, 'color': 0xFFD32F2F},
    {'icon': Icons.star_rounded, 'title': 'Review Your Purchase', 'body': 'How was your experience with the Classic Bifold Wallet? Share your review!', 'time': '3 days ago', 'isRead': true, 'color': 0xFFF57C00},
    {'icon': Icons.favorite_rounded, 'title': 'Back in Stock!', 'body': 'The Heritage Tote Bag in Cognac is back in stock. Grab it before it sells out!', 'time': '4 days ago', 'isRead': true, 'color': 0xFF8B6F47},
    {'icon': Icons.card_giftcard_rounded, 'title': '100 Reward Points Earned!', 'body': 'You earned 100 bonus points for joining MOSPL. Use them on your next order.', 'time': '5 days ago', 'isRead': true, 'color': 0xFFD4AF7A},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
        actions: [TextButton(onPressed: () {}, child: const Text('Mark all read', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.softBrown)))],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final n = _notifications[i];
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: n['isRead'] as bool ? Colors.white : AppColors.warmBeige.withOpacity(0.5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: n['isRead'] as bool ? AppColors.border : AppColors.softBrown.withOpacity(0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: Color(n['color'] as int).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(n['icon'] as IconData, color: Color(n['color'] as int), size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(n['title'] as String, style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: n['isRead'] as bool ? FontWeight.w500 : FontWeight.w700, color: AppColors.textCharcoal))),
                          if (!(n['isRead'] as bool)) Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.softBrown, shape: BoxShape.circle)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(n['body'] as String, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textDarkGray, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(n['time'] as String, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textLight)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}