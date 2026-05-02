import 'package:dio/dio.dart';
import '../../../core/constants/app_constants.dart';

class ChatbotApi {
  final Dio _dio = Dio(BaseOptions(baseUrl: AppConstants.apiBaseUrl));

  Future<String> ask({required String message, required String userId, required List<String> history}) async {
    final res = await _dio.post('/chatbot/respond', data: {
      'userId': userId,
      'message': message,
      'history': history,
    });
    return (res.data['reply'] ?? 'Sorry, I could not process that.').toString();
  }
}
