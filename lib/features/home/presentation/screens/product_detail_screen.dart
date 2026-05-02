import 'package:flutter/material.dart';
import '../../../../core/widgets/app_scaffold.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool inCart = false;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Product Detail',
      body: ListView(children: [
        SizedBox(
          height: 260,
          child: PageView(children: List.generate(4, (i) => Padding(padding: const EdgeInsets.all(12), child: DecoratedBox(decoration: BoxDecoration(color: Colors.brown.shade100, borderRadius: BorderRadius.circular(20)))))),
        ),
        ListTile(title: const Text('Premium Leather Wallet'), subtitle: const Text('49.99')),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () => setState(() => inCart = !inCart),
            icon: Icon(inCart ? Icons.check : Icons.shopping_cart),
            label: Text(inCart ? 'Added to Cart' : 'Add to Cart'),
          ),
        )
      ]),
    );
  }
}
