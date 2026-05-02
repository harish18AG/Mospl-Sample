import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SavedForLaterScreen extends StatelessWidget {
  const SavedForLaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved For Later')),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Saved For Later - MOSPL').animate().fadeIn().slideY(begin: 0.2),
          ),
        ),
      ),
    );
  }
}
