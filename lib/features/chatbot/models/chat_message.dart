class ChatMessage {
  ChatMessage({required this.text, required this.isUser, this.typing = false});
  final String text;
  final bool isUser;
  final bool typing;
}
