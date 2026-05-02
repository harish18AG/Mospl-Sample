import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/chatbot_api.dart';
import '../../models/chat_message.dart';

final chatbotVmProvider = StateNotifierProvider<ChatbotVm, List<ChatMessage>>((ref) => ChatbotVm(ChatbotApi()));

class ChatbotVm extends StateNotifier<List<ChatMessage>> {
  ChatbotVm(this._api) : super([]);
  final ChatbotApi _api;

  Future<void> send(String text, {String userId = 'demo-user'}) async {
    final history = state.map((e) => e.text).toList();
    state = [...state, ChatMessage(text: text, isUser: true), ChatMessage(text: 'Typing...', isUser: false, typing: true)];
    final reply = await _api.ask(message: text, userId: userId, history: history);
    final withoutTyping = [...state]..removeWhere((e) => e.typing);
    state = [...withoutTyping, ChatMessage(text: reply, isUser: false)];
  }
}
