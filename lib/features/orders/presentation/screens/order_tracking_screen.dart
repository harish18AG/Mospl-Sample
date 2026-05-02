import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Tracking')),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Order Tracking - MOSPL').animate().fadeIn().slideY(begin: 0.2),
          ),
        ),
      ),
    );
  }
}
