// lib/providers/providers.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';
import '../core/constants/app_constants.dart';

class ProductProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  List<CategoryModel> _categories = [];
  List<ProductModel> _featuredProducts = [];
  List<ProductModel> _newArrivals = [];
  List<ProductModel> _bestSellers = [];
  List<ProductModel> _trendingProducts = [];
  List<ProductModel> _recentlyViewed = [];
  List<String> _searchHistory = [];

  bool _isLoading = false;
  String? _error;
  String _selectedCategoryId = '';
  String _sortBy = 'relevance';
  RangeValues _priceRange = const RangeValues(0, 20000);
  List<String> _selectedColors = [];
  double _minRating = 0;

  // Getters
  List<ProductModel> get products => _filteredProducts.isEmpty && _selectedCategoryId.isEmpty ? _products : _filteredProducts;
  List<CategoryModel> get categories => _categories;
  List<ProductModel> get featuredProducts => _featuredProducts;
  List<ProductModel> get newArrivals => _newArrivals;
  List<ProductModel> get bestSellers => _bestSellers;
  List<ProductModel> get trendingProducts => _trendingProducts;
  List<ProductModel> get recentlyViewed => _recentlyViewed;
  List<String> get searchHistory => _searchHistory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAll() async {
    await Future.wait([loadCategories(), loadProducts()]);
  }

  Future<void> loadCategories() async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.categoriesCollection)
          .where('isActive', isEqualTo: true)
          .orderBy('sortOrder')
          .get();
      _categories = snapshot.docs.map((doc) => CategoryModel.fromFirestore(doc)).toList();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }
  }

  Future<void> loadProducts({String? categoryId}) async {
    _isLoading = true;
    notifyListeners();
    try {
      Query query = _firestore.collection(AppConstants.productsCollection);
      if (categoryId != null) {
        query = query.where('categoryId', isEqualTo: categoryId);
      }
      final snapshot = await query.get();
      _products = snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
      _featuredProducts = _products.where((p) => p.isFeatured).toList();
      _newArrivals = _products.where((p) => p.isNewArrival).toList();
      _bestSellers = _products.where((p) => p.isBestSeller).toList();
      _trendingProducts = _products.where((p) => p.isTrending).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<ProductModel?> getProductById(String id) async {
    try {
      // Check in-memory first
      final cached = _products.where((p) => p.id == id).firstOrNull;
      if (cached != null) return cached;

      final doc = await _firestore.collection(AppConstants.productsCollection).doc(id).get();
      if (doc.exists) return ProductModel.fromFirestore(doc);
    } catch (e) {
      _error = e.toString();
    }
    return null;
  }

  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.productsCollection)
          .where('categoryId', isEqualTo: categoryId)
          .get();
      return snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
    } catch (e) {
      return [];
    }
  }

  List<ProductModel> searchProducts(String query) {
    if (query.isEmpty) return _products;
    final lowerQuery = query.toLowerCase();
    final results = _products.where((p) =>
    p.name.toLowerCase().contains(lowerQuery) ||
        p.categoryName.toLowerCase().contains(lowerQuery) ||
        p.tags.any((tag) => tag.toLowerCase().contains(lowerQuery)) ||
        p.shortDescription.toLowerCase().contains(lowerQuery)
    ).toList();

    // Save to search history
    if (query.length > 2 && !_searchHistory.contains(query)) {
      _searchHistory.insert(0, query);
      if (_searchHistory.length > 20) _searchHistory.removeLast();
    }
    return results;
  }

  void applyFilters({
    String? categoryId,
    String? sortBy,
    RangeValues? priceRange,
    List<String>? colors,
    double? minRating,
  }) {
    if (categoryId != null) _selectedCategoryId = categoryId;
    if (sortBy != null) _sortBy = sortBy;
    if (priceRange != null) _priceRange = priceRange;
    if (colors != null) _selectedColors = colors;
    if (minRating != null) _minRating = minRating;

    _filteredProducts = _products.where((p) {
      final matchCategory = _selectedCategoryId.isEmpty || p.categoryId == _selectedCategoryId;
      final matchPrice = p.offerPrice >= _priceRange.start && p.offerPrice <= _priceRange.end;
      final matchColor = _selectedColors.isEmpty || _selectedColors.any((c) => p.availableColors.contains(c));
      final matchRating = p.rating >= _minRating;
      return matchCategory && matchPrice && matchColor && matchRating;
    }).toList();

    _sortProducts();
    notifyListeners();
  }

  void _sortProducts() {
    switch (_sortBy) {
      case 'price_low':
        _filteredProducts.sort((a, b) => a.offerPrice.compareTo(b.offerPrice));
        break;
      case 'price_high':
        _filteredProducts.sort((a, b) => b.offerPrice.compareTo(a.offerPrice));
        break;
      case 'rating':
        _filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'newest':
        _filteredProducts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'discount':
        _filteredProducts.sort((a, b) => b.discountPercentage.compareTo(a.discountPercentage));
        break;
    }
  }

  void clearFilters() {
    _selectedCategoryId = '';
    _sortBy = 'relevance';
    _priceRange = const RangeValues(0, 20000);
    _selectedColors = [];
    _minRating = 0;
    _filteredProducts = [];
    notifyListeners();
  }

  void addToRecentlyViewed(ProductModel product) {
    _recentlyViewed.removeWhere((p) => p.id == product.id);
    _recentlyViewed.insert(0, product);
    if (_recentlyViewed.length > 20) _recentlyViewed.removeLast();
    notifyListeners();
  }

  void clearSearchHistory() {
    _searchHistory.clear();
    notifyListeners();
  }
}

// lib/providers/cart_provider.dart
class CartProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<CartItem> _items = [];
  bool _isLoading = false;
  String? _appliedCoupon;
  double _couponDiscount = 0;

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  String? get appliedCoupon => _appliedCoupon;
  double get couponDiscount => _couponDiscount;

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get deliveryCharge => subtotal >= AppConstants.freeShippingThreshold ? 0 : AppConstants.standardShipping;
  double get discount => _couponDiscount;
  double get total => subtotal + deliveryCharge - discount;
  String get formattedTotal => '₹${total.toStringAsFixed(0)}';
  String get formattedSubtotal => '₹${subtotal.toStringAsFixed(0)}';

  Future<void> loadCart(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final snapshot = await _firestore
          .collection(AppConstants.cartCollection)
          .doc(userId)
          .get();
      if (snapshot.exists) {
        final data = snapshot.data()!;
        _items = (data['items'] as List<dynamic>? ?? [])
            .map((item) => CartItem.fromMap(item as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Cart load error: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addItem(String userId, CartItem item) async {
    final existingIndex = _items.indexWhere(
            (i) => i.productId == item.productId &&
            i.selectedColor == item.selectedColor &&
            i.selectedSize == item.selectedSize
    );

    if (existingIndex >= 0) {
      if (_items[existingIndex].quantity < _items[existingIndex].maxStock) {
        _items[existingIndex].quantity++;
      }
    } else {
      _items.add(item);
    }

    await _saveCart(userId);
    notifyListeners();
  }

  Future<void> removeItem(String userId, String itemId) async {
    _items.removeWhere((item) => item.id == itemId);
    await _saveCart(userId);
    notifyListeners();
  }

  Future<void> updateQuantity(String userId, String itemId, int quantity) async {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else if (quantity <= _items[index].maxStock) {
        _items[index].quantity = quantity;
      }
    }
    await _saveCart(userId);
    notifyListeners();
  }

  Future<void> applyCoupon(CouponModel coupon) async {
    _appliedCoupon = coupon.code;
    _couponDiscount = coupon.calculateDiscount(subtotal);
    notifyListeners();
  }

  void removeCoupon() {
    _appliedCoupon = null;
    _couponDiscount = 0;
    notifyListeners();
  }

  Future<void> clearCart(String userId) async {
    _items.clear();
    _appliedCoupon = null;
    _couponDiscount = 0;
    await _firestore.collection(AppConstants.cartCollection).doc(userId).set({'items': []});
    notifyListeners();
  }

  Future<void> _saveCart(String userId) async {
    await _firestore.collection(AppConstants.cartCollection).doc(userId).set({
      'items': _items.map((item) => item.toMap()).toList(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  bool isInCart(String productId) {
    return _items.any((item) => item.productId == productId);
  }
}

// lib/providers/wishlist_provider.dart
class WishlistProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> _wishlistIds = [];
  List<ProductModel> _wishlistProducts = [];
  bool _isLoading = false;

  List<String> get wishlistIds => _wishlistIds;
  List<ProductModel> get wishlistProducts => _wishlistProducts;
  bool get isLoading => _isLoading;
  int get count => _wishlistIds.length;

  bool isWishlisted(String productId) => _wishlistIds.contains(productId);

  Future<void> loadWishlist(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final doc = await _firestore.collection(AppConstants.wishlistCollection).doc(userId).get();
      if (doc.exists) {
        final data = doc.data()!;
        _wishlistIds = List<String>.from(data['productIds'] ?? []);
      }
    } catch (e) {
      debugPrint('Wishlist load error: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleWishlist(String userId, ProductModel product) async {
    if (_wishlistIds.contains(product.id)) {
      _wishlistIds.remove(product.id);
      _wishlistProducts.removeWhere((p) => p.id == product.id);
    } else {
      _wishlistIds.add(product.id);
      _wishlistProducts.add(product);
    }
    notifyListeners();
    await _saveWishlist(userId);
  }

  Future<void> _saveWishlist(String userId) async {
    await _firestore.collection(AppConstants.wishlistCollection).doc(userId).set({
      'productIds': _wishlistIds,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}

// lib/providers/order_provider.dart
class OrderProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _error;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadOrders(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final snapshot = await _firestore
          .collection(AppConstants.ordersCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      _orders = snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<OrderModel?> placeOrder({
    required String userId,
    required String userName,
    required List<CartItem> cartItems,
    required Map<String, dynamic> shippingAddress,
    required String paymentMethod,
    required double subtotal,
    required double deliveryCharge,
    required double discount,
    required double total,
    String? couponCode,
    int rewardPointsUsed = 0,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final orderId = 'MSP${DateTime.now().millisecondsSinceEpoch}';
      final rewardPointsEarned = (total * AppConstants.rewardPointsPerRupee).round();

      final orderData = {
        'id': orderId,
        'userId': userId,
        'userName': userName,
        'items': cartItems.map((item) => item.toMap()).toList(),
        'subtotal': subtotal,
        'deliveryCharge': deliveryCharge,
        'discount': discount,
        'total': total,
        'paymentMethod': paymentMethod,
        'paymentStatus': 'paid',
        'orderStatus': 'placed',
        'shippingAddress': shippingAddress,
        'couponCode': couponCode,
        'trackingId': 'MSPTRK${DateTime.now().millisecondsSinceEpoch}',
        'statusHistory': [
          {
            'status': 'placed',
            'message': 'Your order has been placed successfully!',
            'timestamp': FieldValue.serverTimestamp(),
          }
        ],
        'createdAt': FieldValue.serverTimestamp(),
        'estimatedDelivery': Timestamp.fromDate(
            DateTime.now().add(Duration(days: deliveryCharge > 0 ? AppConstants.standardDeliveryDays : AppConstants.expressDeliveryDays))
        ),
        'rewardPointsEarned': rewardPointsEarned,
      };

      final docRef = await _firestore.collection(AppConstants.ordersCollection).add(orderData);

      // Update user reward points
      await _firestore.collection(AppConstants.usersCollection).doc(userId).update({
        'rewardPoints': FieldValue.increment(rewardPointsEarned - rewardPointsUsed),
      });

      final doc = await docRef.get();
      final order = OrderModel.fromFirestore(doc);
      _orders.insert(0, order);
      _isLoading = false;
      notifyListeners();
      return order;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> cancelOrder(String orderId, String reason) async {
    try {
      await _firestore.collection(AppConstants.ordersCollection).doc(orderId).update({
        'orderStatus': 'cancelled',
        'cancelReason': reason,
        'statusHistory': FieldValue.arrayUnion([
          {
            'status': 'cancelled',
            'message': 'Order cancelled: $reason',
            'timestamp': FieldValue.serverTimestamp(),
          }
        ]),
      });

      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index >= 0) {
        await loadOrders(_orders[index].userId);
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  OrderModel? getOrderById(String orderId) {
    return _orders.where((o) => o.id == orderId).firstOrNull;
  }
}

// lib/providers/theme_provider.dart
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(AppConstants.keyThemeMode) ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyThemeMode, _themeMode == ThemeMode.dark);
    notifyListeners();
  }

  Future<void> setTheme(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyThemeMode, mode == ThemeMode.dark);
    notifyListeners();
  }
}

import 'package:shared_preferences/shared_preferences.dart';