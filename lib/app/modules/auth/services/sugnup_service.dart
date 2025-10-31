import 'package:dio/dio.dart';
import 'package:elecktro_ecommerce/app/core/network/app_urls.dart';
import 'package:get/get.dart';
import '../../../core/util/app_logger.dart';

class AuthCreateUserService extends GetxService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: AppUrls.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  // Add interceptors for logging
  Future<AuthCreateUserService> init() async {
    // Add request interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Log the request
        AppLogger.apiRequest(
          method: options.method,
          endpoint: options.path,
          headers: options.headers,
          body: options.data,
          queryParams: options.queryParameters,
        );
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Log the response
        AppLogger.apiResponse(
          method: response.requestOptions.method,
          endpoint: response.requestOptions.path,
          statusCode: response.statusCode ?? 200,
          responseData: response.data,
          response: response,
        );
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        // Log the error
        AppLogger.apiError(
          method: error.requestOptions.method,
          endpoint: error.requestOptions.path,
          error: error.message,
          statusCode: error.response?.statusCode,
          stackTrace: error.stackTrace,
        );
        return handler.next(error);
      },
    ));

    return this;
  }

  // Register a new seller
  Future<Map<String, dynamic>> registerSeller({
    required String email,
  }) async {
    const String endpoint = AppUrls.createAccount;
    
    try {
      final response = await _dio.post(
        endpoint,
        data: {
          'email': email,
          'role': 'USER',
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data['data'] ?? response.data,
          'message': response.data['message'] ?? 'Registration successful',
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Registration failed',
          'statusCode': response.statusCode,
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data?['message'] ?? e.message ?? 'Network error',
        'statusCode': e.response?.statusCode,
      };
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error in registerSeller',
        error: e,
        stackTrace: stackTrace,
        tag: 'AuthService',
      );
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }
}