import 'package:flutter/material.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';

class AppState extends ChangeNotifier {
  AppState(this.products);
  final ProductRepository products;

  ThemeMode themeMode = ThemeMode.light;
  bool isAuthenticated = false;
  bool isAdmin = false;
  final Map<String, int> cart = {};
  final Set<String> wishlist = {};
  final List<String> recentlyViewed = [];
  final List<String> searchHistory = [];

  void toggleTheme(bool dark) {
    themeMode = dark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void login({bool admin = false}) {
    isAuthenticated = true;
    isAdmin = admin;
    notifyListeners();
  }

  void logout() {
    isAuthenticated = false;
    isAdmin = false;
    notifyListeners();
  }

  void addToCart(Product product) {
    cart.update(product.id, (value) => value + 1, ifAbsent: () => 1);
    notifyListeners();
  }

  void toggleWishlist(Product product) {
    wishlist.contains(product.id) ? wishlist.remove(product.id) : wishlist.add(product.id);
    notifyListeners();
  }

  void trackProduct(Product product) {
    recentlyViewed.remove(product.id);
    recentlyViewed.insert(0, product.id);
    if (recentlyViewed.length > 20) recentlyViewed.removeLast();
    notifyListeners();
  }

  void addSearch(String query) {
    if (query.trim().isEmpty) return;
    searchHistory.remove(query);
    searchHistory.insert(0, query);
    notifyListeners();
  }
}
