import 'package:dio/dio.dart';
import 'package:elecktro_ecommerce/app/core/network/app_urls.dart';
import 'package:elecktro_ecommerce/app/core/stroage/storage_services.dart';
import 'package:get/get.dart';


class PaymentSessionService extends GetxService {
  final Dio _dio;

  /// Initialize service with Dio client
  PaymentSessionService() : _dio = Dio(
          BaseOptions(
            baseUrl: AppUrls.baseUrl,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        ) {
    _setupInterceptors();
  }

  /// Setup interceptors for auth and logging
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Get token from LocalStorage
          final token = LocalStorage.token;
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          // Log request for debugging
          print('--- PaymentSessionService Request ---');
          print('URL: ${options.uri}');
          print('Headers: ${options.headers}');
          print('Body: ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Log response
          print('--- PaymentSessionService Response ---');
          print('Status code: ${response.statusCode}');
          print('Data: ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          // Log errors
          print('--- PaymentSessionService Error ---');
          print('Message: ${e.message}');
          if (e.response != null) {
            print('Status code: ${e.response?.statusCode}');
            print('Response data: ${e.response?.data}');
          }
          return handler.next(e);
        },
      ),
    );
  }

  /// Create payment session
  /// Pass the cart items body as:
  /// {
  ///   "cartItems": [
  ///     {"productId": "...", "size": "...", "quantity": 1, "profit": 10, "color": "..."},
  ///   ]
  /// }
  Future<String?> createPaymentSession(Map<String, dynamic> body) async {
    try {
      final response = await _dio.post(
        AppUrls.createPaymentSession,
        data: body,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return data['data']['url'] as String?;
        } else {
          print('Backend Error: ${data['message']}');
          return null;
        }
      } else {
        print('Request Failed: Status ${response.statusCode}');
        return null;
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      if (e.response != null) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }
      return null;
    } catch (e) {
      print('Unexpected Error: $e');
      return null;
    }
  }
}
