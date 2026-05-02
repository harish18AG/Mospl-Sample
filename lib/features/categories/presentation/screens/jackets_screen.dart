import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class JacketsScreen extends StatelessWidget {
  const JacketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jackets')),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Jackets - MOSPL').animate().fadeIn().slideY(begin: 0.2),
          ),
        ),
      ),
    );
  }
}
