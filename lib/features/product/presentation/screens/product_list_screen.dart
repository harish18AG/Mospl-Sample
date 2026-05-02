import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product List')),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Product List - MOSPL').animate().fadeIn().slideY(begin: 0.2),
          ),
        ),
      ),
    );
  }
}
