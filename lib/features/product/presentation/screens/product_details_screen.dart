import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool added = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.brown.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(child: Icon(Icons.checkroom, size: 100, color: Colors.brown)),
              ).animate().scale(duration: 400.ms),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => setState(() => added = !added),
            icon: Icon(added ? Icons.check : Icons.shopping_cart),
            label: Text(added ? 'Added to Cart' : 'Add to Cart'),
          ).animate(target: added ? 1 : 0).shakeX(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
