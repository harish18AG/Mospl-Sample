import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Chatbot')),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('AI Chatbot - MOSPL').animate().fadeIn().slideY(begin: 0.2),
          ),
        ),
      ),
    );
  }
}
