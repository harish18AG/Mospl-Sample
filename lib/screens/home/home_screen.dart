// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../themes/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;
  final List<Widget> _pages = const [
    _HomeTab(),
    SearchScreen(),
    CartScreen(),
    WishlistScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _navIndex, children: _pages),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, -4))],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(0, Icons.home_rounded, Icons.home_outlined, 'Home'),
                  _navItem(1, Icons.search_rounded, Icons.search, 'Search'),
                  _cartNavItem(cart.itemCount),
                  _navItem(3, Icons.favorite_rounded, Icons.favorite_border_rounded, 'Wishlist'),
                  _navItem(4, Icons.person_rounded, Icons.person_outline_rounded, 'Profile'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _navItem(int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isActive = _navIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _navIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isActive ? activeIcon : inactiveIcon, size: 24,
                color: isActive ? AppColors.softBrown : AppColors.textLight),
            const SizedBox(height: 3),
            Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppColors.softBrown : AppColors.textLight)),
          ],
        ),
      ),
    );
  }

  Widget _cartNavItem(int count) {
    final isActive = _navIndex == 2;
    return GestureDetector(
      onTap: () => setState(() => _navIndex = 2),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(isActive ? Icons.shopping_bag_rounded : Icons.shopping_bag_outlined, size: 24,
                    color: isActive ? AppColors.softBrown : AppColors.textLight),
                if (count > 0)
                  Positioned(
                    top: -6, right: -6,
                    child: Container(
                      width: 17, height: 17,
                      decoration: BoxDecoration(color: AppColors.accentError, shape: BoxShape.circle),
                      child: Center(child: Text('$count', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white))),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text('Cart', style: TextStyle(fontFamily: 'Poppins', fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppColors.softBrown : AppColors.textLight)),
          ],
        ),
      ),
    );
  }
}

// ==================== HOME TAB ====================
class _HomeTab extends StatefulWidget {
  const _HomeTab();
  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadAll();
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return AppStrings.homeGreetingMorning;
    if (hour < 17) return AppStrings.homeGreetingAfternoon;
    return AppStrings.homeGreetingEvening;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      expandedHeight: 0,
      toolbarHeight: 70,
      title: Consumer<AuthProvider>(
        builder: (context, auth, _) => Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${_getGreeting()},', style: Theme.of(context).textTheme.bodySmall),
                  Text(auth.user?.name.split(' ').first ?? 'Guest',
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
            // Notification bell
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, size: 26),
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
                ),
                Positioned(
                  top: 8, right: 8,
                  child: Container(
                    width: 8, height: 8,
                    decoration: const BoxDecoration(color: AppColors.accentError, shape: BoxShape.circle),
                  ),
                ),
              ],
            ),
            // AI Chat
            IconButton(
              icon: const Icon(Icons.smart_toy_outlined, size: 26, color: AppColors.softBrown),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.aiChat),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Consumer<ProductProvider>(
      builder: (context, products, _) {
        if (products.isLoading) return _buildSkeleton();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              _buildSearchBar(),
              const SizedBox(height: 20),
              // Banners
              BannerCarousel(banners: DummyData.banners),
              const SizedBox(height: 24),
              // Quick Stats strip
              _buildQuickStats(),
              const SizedBox(height: 24),
              // Categories
              SectionHeader(
                title: 'Shop by Category',
                onSeeAll: () => Navigator.pushNamed(context, AppRoutes.productListing),
              ),
              const SizedBox(height: 14),
              _buildCategories(products.categories),
              const SizedBox(height: 24),
              // Featured / Banner strip
              _buildFeatureBanner(),
              const SizedBox(height: 24),
              // New Arrivals
              if (products.newArrivals.isNotEmpty) ...[
                SectionHeader(
                  title: AppStrings.newArrivals,
                  subtitle: 'Just landed in our collection',
                  onSeeAll: () => Navigator.pushNamed(context, AppRoutes.productListing, arguments: {'filter': 'new_arrival'}),
                ),
                const SizedBox(height: 14),
                _buildProductRow(products.newArrivals.take(6).toList()),
                const SizedBox(height: 24),
              ],
              // Best Sellers
              if (products.bestSellers.isNotEmpty) ...[
                SectionHeader(
                  title: AppStrings.bestSellers,
                  subtitle: 'Our customers love these',
                  onSeeAll: () => Navigator.pushNamed(context, AppRoutes.productListing, arguments: {'filter': 'best_seller'}),
                ),
                const SizedBox(height: 14),
                _buildProductRow(products.bestSellers.take(6).toList()),
                const SizedBox(height: 24),
              ],
              // Trending
              if (products.trendingProducts.isNotEmpty) ...[
                SectionHeader(
                  title: AppStrings.trendingNow,
                  onSeeAll: () {},
                ),
                const SizedBox(height: 14),
                _buildProductRow(products.trendingProducts.take(6).toList()),
                const SizedBox(height: 24),
              ],
              // AI Recommendations strip
              _buildAIStrip(),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.search),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.bgLightCream,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            const Icon(Icons.search, color: AppColors.textLight, size: 20),
            const SizedBox(width: 10),
            const Expanded(child: Text('Search leather goods...', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.textLight))),
            Container(
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.softBrown, borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.mic, color: Colors.white, size: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    final stats = [
      {'icon': Icons.local_shipping_outlined, 'label': 'Free Shipping', 'sub': 'Above ₹999'},
      {'icon': Icons.verified_outlined, 'label': 'Genuine Leather', 'sub': 'Certified'},
      {'icon': Icons.replay_outlined, 'label': '7-Day Return', 'sub': 'Hassle free'},
      {'icon': Icons.headset_mic_outlined, 'label': '24/7 Support', 'sub': 'Always here'},
    ];
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final s = stats[i];
          return Container(
            width: 120,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.bgLightCream,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(s['icon'] as IconData, size: 18, color: AppColors.softBrown),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(s['label'] as String, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textCharcoal)),
                      Text(s['sub'] as String, style: const TextStyle(fontFamily: 'Poppins', fontSize: 9, color: AppColors.textLight)),
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

  Widget _buildCategories(List categories) {
    if (categories.isEmpty) {
      return SizedBox(
        height: 90,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: DummyData.categories.length,
          itemBuilder: (_, i) => _buildCategoryItemFromDummy(DummyData.categories[i]),
        ),
      );
    }
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (_, i) => _buildCategoryItem(categories[i]),
      ),
    );
  }

  Widget _buildCategoryItemFromDummy(Map<String, dynamic> cat) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.productListing, arguments: {'categoryId': cat['id'], 'categoryName': cat['name']}),
      child: Container(
        width: 75,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(color: AppColors.warmBeige, borderRadius: BorderRadius.circular(16)),
              child: Center(child: Text(cat['icon'], style: const TextStyle(fontSize: 26))),
            ),
            const SizedBox(height: 6),
            Text(cat['name'], style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.textCharcoal), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(dynamic cat) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.productListing, arguments: {'categoryId': cat.id, 'categoryName': cat.name}),
      child: Container(
        width: 75,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(color: AppColors.warmBeige, borderRadius: BorderRadius.circular(16)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(cat.imageUrl, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Center(child: Text(cat.icon, style: const TextStyle(fontSize: 26)))),
              ),
            ),
            const SizedBox(height: 6),
            Text(cat.name, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.textCharcoal), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  Widget _buildProductRow(List products) {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (_, i) {
          final p = products[i];
          return Container(
            width: 170,
            margin: const EdgeInsets.only(right: 14),
            child: ProductCard(
              product: p,
              onTap: () => Navigator.pushNamed(context, '/product/${p.id}', arguments: p),
              onWishlistTap: () => context.read<WishlistProvider>().toggleWishlist(
                  context.read<AuthProvider>().user?.id ?? '', p),
              isWishlisted: context.watch<WishlistProvider>().isWishlisted(p.id),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeatureBanner() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [AppColors.darkChocolate, AppColors.softBrown],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.softGold.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
                    child: const Text('LIMITED OFFER', style: TextStyle(fontFamily: 'Poppins', fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.softGold, letterSpacing: 1)),
                  ),
                  const SizedBox(height: 8),
                  const Text('Premium Collection\nUp to 25% Off', style: TextStyle(fontFamily: 'Montserrat', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white, height: 1.3)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(color: AppColors.softGold, borderRadius: BorderRadius.circular(10)),
              child: const Text('Shop Now', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.matteBlack)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIStrip() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.softBrown.withOpacity(0.2)),
        gradient: LinearGradient(colors: [AppColors.warmBeige, AppColors.bgLightCream]),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: AppColors.softBrown, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Shopping Assistant', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textCharcoal)),
                Text('Ask me anything about leather goods!', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textDarkGray)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.softBrown),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          ShimmerLoader(width: double.infinity, height: 50, borderRadius: 14),
          const SizedBox(height: 20),
          ShimmerLoader(width: double.infinity, height: 200, borderRadius: 16),
          const SizedBox(height: 20),
          Row(children: List.generate(4, (_) => Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ShimmerLoader(width: 75, height: 90, borderRadius: 12),
          ))),
          const SizedBox(height: 20),
          Row(children: List.generate(3, (_) => Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ShimmerLoader(width: 170, height: 260, borderRadius: 16),
          ))),
        ],
      ),
    );
  }
}