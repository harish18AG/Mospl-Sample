import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../themes/app_theme.dart';
import '../utils/formatters.dart';

class LuxuryScaffold extends StatelessWidget {
  const LuxuryScaffold({required this.title, required this.child, this.actions, this.floatingActionButton});
  final String title;
  final Widget child;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)), actions: actions),
        floatingActionButton: floatingActionButton,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFFBF3), Color(0xFFF2E6D6)],
            ),
          ),
          child: SafeArea(child: child),
        ),
      );
}

class ProductCard extends StatelessWidget {
  const ProductCard({required this.product, required this.onTap, required this.onWishlist, required this.isWishlisted});
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onWishlist;
  final bool isWishlisted;

  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Card(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Hero(
                tag: 'product-${product.id}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: CachedNetworkImage(
                    imageUrl: product.images.first,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (_, __, ___) => const Icon(Icons.image_not_supported_outlined),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(product.shortDescription, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 8),
                Row(children: [
                  Text(inr(product.offerPrice), style: const TextStyle(fontWeight: FontWeight.w900, color: LuxuryColors.darkChocolate)),
                  const Spacer(),
                  IconButton(onPressed: onWishlist, icon: Icon(isWishlisted ? Icons.favorite : Icons.favorite_border, color: LuxuryColors.softBrown)),
                ]),
              ]),
            ),
          ]),
        ),
      );
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {this.subtitle});
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          if (subtitle != null) Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: LuxuryColors.softBrown)),
        ]),
      );
}

class PremiumTile extends StatelessWidget {
  const PremiumTile({required this.title, required this.subtitle, required this.icon, this.onTap, this.trailing});
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          leading: CircleAvatar(backgroundColor: LuxuryColors.warmBeige.withOpacity(.45), child: Icon(icon, color: LuxuryColors.darkChocolate)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          subtitle: Text(subtitle),
          trailing: trailing ?? const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      );
}
