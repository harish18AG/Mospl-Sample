import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../viewmodels/chatbot_view_model.dart';
import '../widgets/message_bubble.dart';

class ChatUiScreen extends ConsumerStatefulWidget {
  const ChatUiScreen({super.key});

  @override
  ConsumerState<ChatUiScreen> createState() => _ChatUiScreenState();
}

class _ChatUiScreenState extends ConsumerState<ChatUiScreen> {
  final controller = TextEditingController();
  final quickReplies = const [
    'Suggest a leather wallet under ₹1000',
    'Where is my order?',
    'Best leather bags?'
  ];

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatbotVmProvider);
    return AppScaffold(
      title: 'MOSPL Assistant',
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: quickReplies
                  .map((q) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ActionChip(label: Text(q), onPressed: () => ref.read(chatbotVmProvider.notifier).send(q)),
                      ))
                  .toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (_, i) {
                final m = messages[i];
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: 1,
                  child: MessageBubble(text: m.text, isUser: m.isUser),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(child: TextField(controller: controller, decoration: const InputDecoration(hintText: 'Ask about products/orders...'))),
                IconButton(
                    onPressed: () {
                      final text = controller.text.trim();
                      if (text.isEmpty) return;
                      controller.clear();
                      ref.read(chatbotVmProvider.notifier).send(text);
                    },
                    icon: const Icon(Icons.send))
              ],
            ),
          )
        ],
      ),
    );
  }
}
