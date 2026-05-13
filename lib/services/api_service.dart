// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../core/constants/app_constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final String _baseUrl = AppConstants.devBaseUrl; // Switch to baseUrl for production

  Future<String?> _getToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return user != null ? await user.getIdToken() : null;
  }

  Map<String, String> _headers(String? token) => {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  Future<ApiResponse> get(String endpoint, {bool requiresAuth = false}) async {
    try {
      final token = requiresAuth ? await _getToken() : null;
      final response = await http
          .get(Uri.parse('$_baseUrl$endpoint'), headers: _headers(token))
          .timeout(const Duration(seconds: 15));
      return _parseResponse(response);
    } catch (e) {
      return ApiResponse(success: false, message: 'Network error: $e');
    }
  }

  Future<ApiResponse> post(String endpoint, Map<String, dynamic> body,
      {bool requiresAuth = true}) async {
    try {
      final token = requiresAuth ? await _getToken() : null;
      final response = await http
          .post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _headers(token),
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 15));
      return _parseResponse(response);
    } catch (e) {
      return ApiResponse(success: false, message: 'Network error: $e');
    }
  }

  Future<ApiResponse> put(String endpoint, Map<String, dynamic> body,
      {bool requiresAuth = true}) async {
    try {
      final token = requiresAuth ? await _getToken() : null;
      final response = await http
          .put(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _headers(token),
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 15));
      return _parseResponse(response);
    } catch (e) {
      return ApiResponse(success: false, message: 'Network error: $e');
    }
  }

  Future<ApiResponse> delete(String endpoint, {bool requiresAuth = true}) async {
    try {
      final token = requiresAuth ? await _getToken() : null;
      final response = await http
          .delete(Uri.parse('$_baseUrl$endpoint'), headers: _headers(token))
          .timeout(const Duration(seconds: 15));
      return _parseResponse(response);
    } catch (e) {
      return ApiResponse(success: false, message: 'Network error: $e');
    }
  }

  ApiResponse _parseResponse(http.Response response) {
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return ApiResponse(
        success: body['success'] == true,
        data: body['data'],
        message: body['message'] as String?,
        statusCode: response.statusCode,
      );
    } catch (_) {
      return ApiResponse(
        success: false,
        message: 'Failed to parse response',
        statusCode: response.statusCode,
      );
    }
  }
}

class ApiResponse {
  final bool success;
  final dynamic data;
  final String? message;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
  });
}

// ==================== PRODUCT SERVICE ====================
class ProductService {
  static final _api = ApiService();

  static Future<List<dynamic>> getProducts({
    String? categoryId,
    String? sortBy,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool? isFeatured,
    bool? isNewArrival,
    bool? isBestSeller,
    int page = 1,
  }) async {
    final params = StringBuffer('/products?page=$page');
    if (categoryId != null) params.write('&categoryId=$categoryId');
    if (sortBy != null) params.write('&sortBy=$sortBy');
    if (minPrice != null) params.write('&minPrice=$minPrice');
    if (maxPrice != null) params.write('&maxPrice=$maxPrice');
    if (minRating != null) params.write('&minRating=$minRating');
    if (isFeatured == true) params.write('&isFeatured=true');
    if (isNewArrival == true) params.write('&isNewArrival=true');
    if (isBestSeller == true) params.write('&isBestSeller=true');

    final response = await _api.get(params.toString());
    return response.success ? (response.data as List? ?? []) : [];
  }

  static Future<Map<String, dynamic>?> getProductById(String id) async {
    final response = await _api.get('/products/$id');
    return response.success ? response.data as Map<String, dynamic>? : null;
  }

  static Future<List<dynamic>> searchProducts(String query) async {
    final response = await _api.get('/products/search?q=${Uri.encodeComponent(query)}');
    return response.success ? (response.data as List? ?? []) : [];
  }

  static Future<bool> createProduct(Map<String, dynamic> product) async {
    final response = await _api.post('/products', product);
    return response.success;
  }

  static Future<bool> updateProduct(String id, Map<String, dynamic> updates) async {
    final response = await _api.put('/products/$id', updates);
    return response.success;
  }

  static Future<bool> deleteProduct(String id) async {
    final response = await _api.delete('/products/$id');
    return response.success;
  }
}

// ==================== ORDER SERVICE ====================
class OrderService {
  static final _api = ApiService();

  static Future<Map<String, dynamic>?> placeOrder(Map<String, dynamic> orderData) async {
    final response = await _api.post('/orders', orderData);
    return response.success ? response.data as Map<String, dynamic>? : null;
  }

  static Future<List<dynamic>> getMyOrders() async {
    final response = await _api.get('/orders', requiresAuth: true);
    return response.success ? (response.data as List? ?? []) : [];
  }

  static Future<Map<String, dynamic>?> getOrderById(String id) async {
    final response = await _api.get('/orders/$id', requiresAuth: true);
    return response.success ? response.data as Map<String, dynamic>? : null;
  }

  static Future<bool> cancelOrder(String id, String reason) async {
    final response = await _api.put('/orders/$id/cancel', {'reason': reason});
    return response.success;
  }
}

// ==================== AI SERVICE ====================
class AIService {
  static final _api = ApiService();

  static Future<List<dynamic>> getRecommendations({
    List<String> recentlyViewed = const [],
    List<String> cartItems = const [],
    List<String> wishlist = const [],
    double? budget,
  }) async {
    final response = await _api.post('/ai/recommendations', {
      'recentlyViewed': recentlyViewed,
      'cartItems': cartItems,
      'wishlist': wishlist,
      if (budget != null) 'budget': budget,
    });
    return response.success ? (response.data as List? ?? []) : [];
  }

  static Future<String> chat(String message,
      {List<Map<String, String>> history = const []}) async {
    final response = await _api.post('/ai/chat', {
      'message': message,
      'conversationHistory': history,
    });
    if (response.success && response.data != null) {
      return response.data['response'] as String? ??
          'I\'m here to help! What can I assist you with?';
    }
    return 'I\'m having trouble connecting right now. Please try again.';
  }

  static Future<Map<String, dynamic>?> getAdminInsights() async {
    final response = await _api.get('/ai/insights', requiresAuth: true);
    return response.success ? response.data as Map<String, dynamic>? : null;
  }
}

// ==================== REVIEW SERVICE ====================
class ReviewService {
  static final _api = ApiService();

  static Future<List<dynamic>> getProductReviews(String productId) async {
    final response = await _api.get('/reviews/$productId');
    return response.success ? (response.data as List? ?? []) : [];
  }

  static Future<bool> submitReview({
    required String productId,
    required double rating,
    required String title,
    required String comment,
    List<String> images = const [],
  }) async {
    final response = await _api.post('/reviews', {
      'productId': productId,
      'rating': rating,
      'title': title,
      'comment': comment,
      'images': images,
    });
    return response.success;
  }
}

// ==================== ANALYTICS SERVICE (Admin) ====================
class AnalyticsService {
  static final _api = ApiService();

  static Future<Map<String, dynamic>?> getDashboardStats() async {
    final response = await _api.get('/admin/stats', requiresAuth: true);
    return response.success ? response.data as Map<String, dynamic>? : null;
  }

  static Future<Map<String, dynamic>?> getFullAnalytics() async {
    final response = await _api.get('/analytics/dashboard', requiresAuth: true);
    return response.success ? response.data as Map<String, dynamic>? : null;
  }

  static Future<List<dynamic>> getLowStockProducts() async {
    final response = await _api.get('/admin/inventory', requiresAuth: true);
    return response.success ? (response.data as List? ?? []) : [];
  }
}