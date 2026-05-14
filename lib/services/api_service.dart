import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  Future<Map<String, dynamic>> get(String path, {String? token}) async {
    final response = await _client.get(Uri.parse('${AppConstants.apiBaseUrl}$path'), headers: _headers(token));
    return _handle(response);
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body, {String? token}) async {
    final response = await _client.post(
      Uri.parse('${AppConstants.apiBaseUrl}$path'),
      headers: _headers(token),
      body: jsonEncode(body),
    );
    return _handle(response);
  }

  Map<String, String> _headers(String? token) => {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  Map<String, dynamic> _handle(http.Response response) {
    final body = jsonDecode(response.body.isEmpty ? '{}' : response.body) as Map<String, dynamic>;
    if (response.statusCode >= 400) throw Exception(body['message'] ?? 'Request failed');
    return body;
  }
}
