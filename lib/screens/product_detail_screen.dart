import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/app_state.dart';
import '../utils/formatters.dart';
import '../widgets/luxury_widgets.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return FutureBuilder<Product>(
      future: app.products.byId(productId),
      builder: (context, snapshot) {
        final p = snapshot.data;
        if (p == null) return const LuxuryScaffold(title: 'Product', child: Center(child: CircularProgressIndicator()));
        return LuxuryScaffold(
          title: p.name,
          child: ListView(children: [
            Hero(tag: 'product-${p.id}', child: CachedNetworkImage(imageUrl: p.images.first, height: 360, width: double.infinity, fit: BoxFit.cover)),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Row(children: [Text(inr(p.offerPrice), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)), const SizedBox(width: 8), Text('${p.discountPercentage}% off'), const Spacer(), Text('★ ${p.rating}')]),
                const SizedBox(height: 12),
                Text(p.longDescription),
                const SectionHeader('Colors & sizes'),
                Wrap(spacing: 8, children: [...p.colors, ...p.sizes].map((e) => Chip(label: Text(e))).toList()),
                const SectionHeader('Delivery'),
                Text(p.deliveryInfo),
                const SectionHeader('Customer reviews'),
                for (final r in p.reviews) PremiumTile(title: '${r.user} · ${r.rating}', subtitle: r.comment, icon: Icons.star),
                const SizedBox(height: 12),
                FilledButton.icon(onPressed: () => app.addToCart(p), icon: const Icon(Icons.shopping_bag_outlined), label: const Text('Add to cart')),
              ]),
            ),
          ]),
        );
      },
    );
  }
}
