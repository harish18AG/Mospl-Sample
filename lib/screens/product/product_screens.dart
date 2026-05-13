// lib/screens/product/product_screens.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../themes/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailScreen({super.key, required this.product});
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _imageIndex = 0;
  String? _selectedColor;
  String? _selectedSize;
  int _quantity = 1;
  bool _isFabVisible = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    if (widget.product.availableColors.isNotEmpty) _selectedColor = widget.product.availableColors[0];
    if (widget.product.availableSizes.isNotEmpty) _selectedSize = widget.product.availableSizes[0];

    // Track recently viewed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().addToRecentlyViewed(widget.product);
    });

    _scrollController.addListener(() {
      final visible = _scrollController.offset < 100;
      if (visible != _isFabVisible) setState(() => _isFabVisible = visible);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _addToCart() async {
    final auth = context.read<AuthProvider>();
    if (auth.user == null) {
      Navigator.pushNamed(context, AppRoutes.login);
      return;
    }
    if (!widget.product.isInStock) return;

    final item = CartItem(
      id: '${widget.product.id}_${_selectedColor}_${_selectedSize}_${DateTime.now().millisecondsSinceEpoch}',
      productId: widget.product.id,
      productName: widget.product.name,
      productImage: widget.product.images.isNotEmpty ? widget.product.images[0] : '',
      price: widget.product.offerPrice,
      quantity: _quantity,
      selectedColor: _selectedColor,
      selectedSize: _selectedSize,
      maxStock: widget.product.stockCount,
    );

    await context.read<CartProvider>().addItem(auth.user!.id, item);
    if (mounted) AppSnackbar.show(context, AppStrings.addedToCart);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildImageSliver(product),
              SliverToBoxAdapter(child: _buildProductInfo(product)),
            ],
          ),
          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleButton(Icons.arrow_back_ios_new_rounded, () => Navigator.pop(context)),
                  Row(
                    children: [
                      Consumer<WishlistProvider>(
                        builder: (context, wl, _) => _circleButton(
                          wl.isWishlisted(product.id) ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              () {
                            final user = context.read<AuthProvider>().user;
                            if (user != null) wl.toggleWishlist(user.id, product);
                          },
                          color: context.watch<WishlistProvider>().isWishlisted(product.id) ? AppColors.accentError : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _circleButton(Icons.share_outlined, () {}),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(product),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap, {Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
        ),
        child: Icon(icon, size: 18, color: color ?? AppColors.textCharcoal),
      ),
    );
  }

  Widget _buildImageSliver(ProductModel product) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 380,
        child: Stack(
          children: [
            PageView.builder(
              itemCount: product.images.length,
              onPageChanged: (i) => setState(() => _imageIndex = i),
              itemBuilder: (context, i) => GestureDetector(
                onTap: () => _openImageZoom(i),
                child: Image.network(
                  product.images[i],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: AppColors.bgLightCream, child: const Icon(Icons.image, size: 60, color: AppColors.border)),
                ),
              ),
            ),
            // Image count indicator
            if (product.images.length > 1)
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                  child: Text('${_imageIndex + 1}/${product.images.length}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.white)),
                ),
              ),
            // Dots indicator
            if (product.images.length > 1)
              Positioned(
                bottom: 16, left: 0, right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(product.images.length, (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == _imageIndex ? 18 : 6, height: 6,
                    decoration: BoxDecoration(
                      color: i == _imageIndex ? AppColors.softBrown : Colors.white54,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  )),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _openImageZoom(int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: Text('${initialIndex + 1}/${widget.product.images.length}', style: const TextStyle(fontFamily: 'Poppins', color: Colors.white)),
          ),
          body: PhotoViewGallery.builder(
            itemCount: widget.product.images.length,
            pageController: PageController(initialPage: initialIndex),
            builder: (context, i) => PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(widget.product.images[i]),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo(ProductModel product) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.warmBeige, borderRadius: BorderRadius.circular(8)),
                  child: Text(product.categoryName, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.softBrown)),
                ),
                const SizedBox(height: 10),
                // Name
                Text(product.name, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                // Brand & SKU
                Text('by ${product.brand} · SKU: ${product.sku}', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 12),
                // Rating & Reviews
                Row(
                  children: [
                    ...List.generate(5, (i) => Icon(
                      i < product.rating.floor() ? Icons.star_rounded : (i < product.rating ? Icons.star_half_rounded : Icons.star_outline_rounded),
                      size: 18, color: AppColors.softGold,
                    )),
                    const SizedBox(width: 8),
                    Text('${product.rating}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textCharcoal)),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/reviews/${product.id}'),
                      child: Text('(${product.reviewCount} reviews)', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.softBrown, decoration: TextDecoration.underline)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Pricing
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(product.formattedPrice, style: const TextStyle(fontFamily: 'Montserrat', fontSize: 30, fontWeight: FontWeight.w700, color: AppColors.textCharcoal)),
                    const SizedBox(width: 12),
                    if (product.discountPercentage > 0) ...[
                      Text(product.formattedOriginalPrice, style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, color: AppColors.textLight, decoration: TextDecoration.lineThrough)),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.accentError, borderRadius: BorderRadius.circular(6)),
                        child: Text('${product.discountPercentage}% OFF', style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                    ],
                  ],
                ),
                if (product.discountPercentage > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text('You save ₹${product.savings.toStringAsFixed(0)}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.accentSuccess, fontWeight: FontWeight.w600)),
                  ),
                const SizedBox(height: 20),
                // Stock
                Row(
                  children: [
                    Container(
                      width: 8, height: 8,
                      decoration: BoxDecoration(
                        color: product.isInStock ? AppColors.accentSuccess : AppColors.accentError,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      product.isInStock ? '${product.stockCount} in stock' : AppStrings.outOfStock,
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w500,
                          color: product.isInStock ? AppColors.accentSuccess : AppColors.accentError),
                    ),
                    if (product.stockCount < 10 && product.isInStock) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.accentWarning.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                        child: Text('Only ${product.stockCount} left!', style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.accentWarning, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: AppColors.divider),
                const SizedBox(height: 16),
                // Colors
                if (product.availableColors.isNotEmpty) ...[
                  _buildSelectorSection(
                    'Color',
                    product.availableColors,
                    _selectedColor,
                        (val) => setState(() => _selectedColor = val),
                    isColor: true,
                  ),
                  const SizedBox(height: 20),
                ],
                // Sizes
                if (product.availableSizes.isNotEmpty) ...[
                  _buildSelectorSection(
                    'Size',
                    product.availableSizes,
                    _selectedSize,
                        (val) => setState(() => _selectedSize = val),
                  ),
                  const SizedBox(height: 20),
                ],
                // Quantity
                _buildQuantitySelector(product),
                const SizedBox(height: 20),
                // Delivery
                _buildDeliveryInfo(product),
                const SizedBox(height: 20),
                // Tabs
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.softBrown,
                  unselectedLabelColor: AppColors.textLight,
                  indicatorColor: AppColors.softBrown,
                  labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600),
                  tabs: const [Tab(text: 'Description'), Tab(text: 'Specs'), Tab(text: 'Reviews')],
                ),
                SizedBox(
                  height: 200,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildDescriptionTab(product),
                      _buildSpecsTab(product),
                      _buildReviewsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectorSection(String title, List<String> options, String? selected, Function(String) onSelect, {bool isColor = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textCharcoal)),
            const SizedBox(width: 8),
            if (selected != null)
              Text('— $selected', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textDarkGray)),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: options.map((opt) {
            final isSelected = opt == selected;
            return GestureDetector(
              onTap: () => onSelect(opt),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.matteBlack : AppColors.bgLightCream,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isSelected ? AppColors.matteBlack : AppColors.border, width: isSelected ? 2 : 1),
                ),
                child: Text(opt, style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w500, color: isSelected ? Colors.white : AppColors.textCharcoal)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector(ProductModel product) {
    return Row(
      children: [
        const Text('Quantity', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textCharcoal)),
        const Spacer(),
        Container(
          decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 18),
                onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                color: AppColors.textCharcoal,
              ),
              SizedBox(
                width: 36,
                child: Text('$_quantity', textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'Montserrat', fontSize: 16, fontWeight: FontWeight.w700)),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 18),
                onPressed: _quantity < (product.stockCount > 5 ? 5 : product.stockCount) ? () => setState(() => _quantity++) : null,
                color: AppColors.textCharcoal,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryInfo(ProductModel product) {
    final deliveryInfo = product.deliveryInfo;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.bgLightCream, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.local_shipping_outlined, color: AppColors.softBrown, size: 18),
              const SizedBox(width: 10),
              Text(
                (deliveryInfo['freeDelivery'] == true) ? AppStrings.freeDelivery : '${AppStrings.standardDelivery} ₹${deliveryInfo['standardCharge']}',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: (deliveryInfo['freeDelivery'] == true) ? AppColors.accentSuccess : AppColors.textCharcoal),
              ),
              const Spacer(),
              Text('${AppStrings.deliveryIn} ${deliveryInfo['standardDays']} ${AppStrings.days}',
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textDarkGray)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.bolt_rounded, color: AppColors.accentWarning, size: 18),
              const SizedBox(width: 10),
              Text('Express Delivery ₹${deliveryInfo['expressCharge']}',
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textCharcoal)),
              const Spacer(),
              Text('${AppStrings.deliveryIn} ${deliveryInfo['expressDays']} ${AppStrings.days}',
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textDarkGray)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.replay_rounded, color: AppColors.softBrown, size: 18),
              const SizedBox(width: 10),
              const Text('7-day easy returns & exchanges',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textDarkGray)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionTab(ProductModel product) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.longDescription, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.textDarkGray, height: 1.7)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: product.tags.map((tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(color: AppColors.warmBeige, borderRadius: BorderRadius.circular(20)),
              child: Text('#$tag', style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.softBrown)),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecsTab(ProductModel product) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: product.specifications.entries.map((entry) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 110, child: Text(entry.key, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textCharcoal))),
              const Text(': ', style: TextStyle(color: AppColors.textLight)),
              Expanded(child: Text(entry.value.toString(), style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textDarkGray))),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildReviewsTab() {
    final reviews = DummyData.sampleReviews;
    return ListView.builder(
      padding: const EdgeInsets.only(top: 12),
      itemCount: reviews.length > 2 ? 2 : reviews.length,
      itemBuilder: (_, i) {
        final review = reviews[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(radius: 18, backgroundColor: AppColors.warmBeige, child: Text(review['userName'][0], style: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, color: AppColors.softBrown))),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(review['userName'], style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textCharcoal)),
                        const SizedBox(width: 8),
                        if (review['isVerifiedPurchase'] == true)
                          const Icon(Icons.verified, size: 14, color: AppColors.accentSuccess),
                      ],
                    ),
                    Row(children: List.generate(5, (j) => Icon(j < (review['rating'] as int) ? Icons.star_rounded : Icons.star_outline_rounded, size: 14, color: AppColors.softGold))),
                    Text(review['title'], style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600)),
                    Text(review['comment'], style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textDarkGray, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(ProductModel product) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, -4))],
        ),
        child: Row(
          children: [
            // Add to wishlist
            Consumer<WishlistProvider>(
              builder: (context, wl, _) => GestureDetector(
                onTap: () {
                  final user = context.read<AuthProvider>().user;
                  if (user != null) wl.toggleWishlist(user.id, product);
                },
                child: Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    wl.isWishlisted(product.id) ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: wl.isWishlisted(product.id) ? AppColors.accentError : AppColors.textLight,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Add to cart
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: product.isInStock ? _addToCart : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkChocolate,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shopping_bag_outlined, size: 18),
                      const SizedBox(width: 8),
                      Text(product.isInStock ? AppStrings.addToCart : AppStrings.outOfStock, style: const TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Buy now
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: product.isInStock ? () async {
                    await _addToCart();
                    if (mounted) Navigator.pushNamed(context, AppRoutes.cart);
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.softBrown,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(AppStrings.buyNow, style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== PRODUCT LISTING SCREEN ====================
class ProductListingScreen extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;
  final String? filter;

  const ProductListingScreen({super.key, this.categoryId, this.categoryName, this.filter});
  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  bool _isGridView = true;
  String _sortBy = 'relevance';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().applyFilters(categoryId: widget.categoryId ?? '', sortBy: _sortBy);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
        title: Text(widget.categoryName ?? 'All Products'),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) return const Center(child: CircularProgressIndicator(color: AppColors.softBrown));
          final products = widget.categoryId != null
              ? provider.products.where((p) => p.categoryId == widget.categoryId).toList()
              : provider.products;

          if (products.isEmpty) return EmptyState(icon: Icons.inventory_2_outlined, title: 'No Products Found', subtitle: 'Try adjusting your filters');

          return Column(
            children: [
              // Sort & Count bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Row(
                  children: [
                    Text('${products.length} products', style: Theme.of(context).textTheme.bodySmall),
                    const Spacer(),
                    GestureDetector(
                      onTap: _showSortBottomSheet,
                      child: Row(
                        children: [
                          const Icon(Icons.sort_rounded, size: 18, color: AppColors.softBrown),
                          const SizedBox(width: 4),
                          Text('Sort', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.softBrown, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _isGridView
                    ? GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: 0.68),
                  itemCount: products.length,
                  itemBuilder: (_, i) => ProductCard(
                    product: products[i],
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: products[i]))),
                    onWishlistTap: () => context.read<WishlistProvider>().toggleWishlist(context.read<AuthProvider>().user?.id ?? '', products[i]),
                    isWishlisted: context.watch<WishlistProvider>().isWishlisted(products[i].id),
                  ),
                )
                    : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: products.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => _buildListItem(products[i]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildListItem(ProductModel product) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product))),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: AppColors.shadowLight, blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
              child: SizedBox(
                width: 110, height: 120,
                child: Image.network(product.images.isNotEmpty ? product.images[0] : '', fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: AppColors.bgLightCream)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(product.name, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 14, color: AppColors.softGold),
                        Text(' ${product.rating}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600)),
                        Text(' (${product.reviewCount})', style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textLight)),
                      ],
                    ),
                    Row(
                      children: [
                        Text(product.formattedPrice, style: const TextStyle(fontFamily: 'Montserrat', fontSize: 16, fontWeight: FontWeight.w700)),
                        const SizedBox(width: 8),
                        if (product.discountPercentage > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.accentError, borderRadius: BorderRadius.circular(4)),
                            child: Text('${product.discountPercentage}% OFF', style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FilterBottomSheet(),
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) {
        final options = [
          {'value': 'relevance', 'label': 'Relevance'},
          {'value': 'price_low', 'label': 'Price: Low to High'},
          {'value': 'price_high', 'label': 'Price: High to Low'},
          {'value': 'rating', 'label': 'Highest Rated'},
          {'value': 'newest', 'label': 'Newest First'},
          {'value': 'discount', 'label': 'Best Discount'},
        ];
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Sort By', style: TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              ...options.map((opt) => ListTile(
                title: Text(opt['label']!, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14)),
                leading: Radio<String>(value: opt['value']!, groupValue: _sortBy, onChanged: (v) {
                  setState(() => _sortBy = v!);
                  context.read<ProductProvider>().applyFilters(sortBy: v);
                  Navigator.pop(context);
                }, activeColor: AppColors.softBrown),
                contentPadding: EdgeInsets.zero,
              )),
            ],
          ),
        );
      },
    );
  }
}

class _FilterBottomSheet extends StatefulWidget {
  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  RangeValues _priceRange = const RangeValues(0, 20000);
  double _minRating = 0;
  List<String> _selectedColors = [];

  final colors = ['Black', 'Brown', 'Tan', 'Cognac', 'Burgundy', 'Navy', 'Camel'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Filters', style: TextStyle(fontFamily: 'Montserrat', fontSize: 20, fontWeight: FontWeight.w700)),
                TextButton(onPressed: () { setState(() { _priceRange = const RangeValues(0, 20000); _minRating = 0; _selectedColors = []; }); }, child: const Text('Reset', style: TextStyle(color: AppColors.softBrown, fontFamily: 'Poppins'))),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Price Range', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w600)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('₹${_priceRange.start.toInt()}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.softBrown, fontWeight: FontWeight.w600)),
                Text('₹${_priceRange.end.toInt()}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.softBrown, fontWeight: FontWeight.w600)),
              ],
            ),
            RangeSlider(
              values: _priceRange,
              min: 0, max: 20000, divisions: 40,
              activeColor: AppColors.softBrown,
              onChanged: (v) => setState(() => _priceRange = v),
            ),
            const SizedBox(height: 16),
            const Text('Minimum Rating', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w600)),
            Row(
              children: [0, 3, 3.5, 4, 4.5].map((r) {
                final isSelected = _minRating == r;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _minRating = r.toDouble()),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.softBrown : AppColors.bgLightCream,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isSelected ? AppColors.softBrown : AppColors.border),
                      ),
                      child: Text(r == 0 ? 'All' : '$r★', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppColors.textCharcoal)),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  context.read<ProductProvider>().applyFilters(
                    priceRange: _priceRange,
                    colors: _selectedColors,
                    minRating: _minRating,
                  );
                  Navigator.pop(context);
                },
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}