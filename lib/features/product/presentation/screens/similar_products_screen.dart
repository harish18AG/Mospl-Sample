import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SimilarProductsScreen extends StatelessWidget {
  const SimilarProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Similar Products')),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Similar Products - MOSPL').animate().fadeIn().slideY(begin: 0.2),
          ),
        ),
      ),
    );
  }
}
