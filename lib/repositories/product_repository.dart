import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product.dart';

class ProductRepository {
  List<Product>? _cache;

  Future<List<Product>> all() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/data/products.json');
    _cache = (jsonDecode(raw) as List).map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    return _cache!;
  }

  Future<List<Product>> byCategory(String category) async =>
      (await all()).where((p) => p.category == category).toList();

  Future<Product> byId(String id) async => (await all()).firstWhere((p) => p.id == id);

  Future<List<Product>> search(String query) async {
    final q = query.toLowerCase();
    return (await all()).where((p) => p.name.toLowerCase().contains(q) || p.category.toLowerCase().contains(q)).toList();
  }
}
