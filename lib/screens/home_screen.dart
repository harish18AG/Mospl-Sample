import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ai/ai_recommendation_service.dart';
import '../constants/app_constants.dart';
import '../models/product.dart';
import '../providers/app_state.dart';
import '../routes/app_routes.dart';
import '../widgets/luxury_widgets.dart';
import 'catalog_screens.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen();

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return LuxuryScaffold(
      title: 'MOSPL',
      actions: [
        IconButton(onPressed: () => Navigator.pushNamed(context, '/shop/search'), icon: const Icon(Icons.search)),
        IconButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.settings), icon: const Icon(Icons.settings_outlined)),
      ],
      child: FutureBuilder<List<Product>>(
        future: app.products.all(),
        builder: (context, snapshot) {
          final products = snapshot.data ?? [];
          final recommended = AiRecommendationService().recommend(catalog: products, viewedIds: app.recentlyViewed, wishlistIds: app.wishlist);
          return ListView(children: [
            _hero(context),
            const SectionHeader('Categories', subtitle: 'Premium leather essentials'),
            SizedBox(height: 112, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 12), children: [
              for (final c in AppConstants.categories)
                _CategoryPill(category: c),
            ])),
            const SectionHeader('AI picks for you', subtitle: 'Personalized from browsing, wishlist, rating and offers'),
            ProductGrid(products: recommended.isEmpty ? products.take(12).toList() : recommended),
          ]);
        },
      ),
    );
  }

  Widget _hero(BuildContext context) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(28), gradient: const LinearGradient(colors: [Color(0xFF3A2418), Color(0xFF8E6E53)])),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Premium Collection', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          const Text('Luxury leather crafted for modern India', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          FilledButton.tonal(onPressed: () => Navigator.pushNamed(context, '/shop/ai-recommendations'), child: const Text('Explore AI recommendations')),
        ]),
      );
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({required this.category});
  final String category;
  @override
  Widget build(BuildContext context) => Container(
        width: 150,
        margin: const EdgeInsets.all(6),
        child: Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryScreen(category: category))),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.category_outlined),
                const SizedBox(height: 8),
                Text(category, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w800)),
              ]),
            ),
          ),
        ),
      );
}
