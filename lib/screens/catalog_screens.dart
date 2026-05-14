import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/app_state.dart';
import '../routes/app_routes.dart';
import '../widgets/luxury_widgets.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return LuxuryScaffold(
      title: category,
      child: FutureBuilder<List<Product>>(
        future: app.products.byCategory(category),
        builder: (context, snapshot) => ProductGrid(products: snapshot.data ?? []),
      ),
    );
  }
}

class ProductGrid extends StatelessWidget {
  const ProductGrid({required this.products});
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    if (products.isEmpty) return const Center(child: CircularProgressIndicator());
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.sizeOf(context).width > 700 ? 4 : 2,
        childAspectRatio: .63,
      ),
      itemBuilder: (context, index) {
        final p = products[index];
        return ProductCard(
          product: p,
          isWishlisted: app.wishlist.contains(p.id),
          onWishlist: () => app.toggleWishlist(p),
          onTap: () { app.trackProduct(p); Navigator.pushNamed(context, AppRoutes.product, arguments: p.id); },
        );
      },
    );
  }
}
