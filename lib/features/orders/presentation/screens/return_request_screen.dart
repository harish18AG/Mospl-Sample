import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ReturnRequestScreen extends StatelessWidget {
  const ReturnRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Return Request')),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Return Request - MOSPL').animate().fadeIn().slideY(begin: 0.2),
          ),
        ),
      ),
    );
  }
}
