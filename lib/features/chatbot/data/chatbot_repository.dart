import 'package:cloud_firestore/cloud_firestore.dart';

class ChatbotRepository {
  final _db = FirebaseFirestore.instance;

  Future<void> sendMessage(String text) async {
    await _db.collection('chat_messages').add({
      'message': text,
      'createdAt': FieldValue.serverTimestamp(),
      'from': 'user',
    });
  }
}
