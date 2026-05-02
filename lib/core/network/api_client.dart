import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

class ApiClient {
  ApiClient()
      : dio = Dio(BaseOptions(
          baseUrl: AppConstants.apiBaseUrl,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
        ));

  final Dio dio;
}
