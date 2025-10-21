import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/core/network/app_urls.dart';
import 'package:elecktro_ecommerce/app/core/util/app_logger.dart';

class AuthVerifyOtpService extends GetxService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: AppUrls.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  // Initialize service with interceptors
  Future<AuthVerifyOtpService> init() async {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
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
        AppLogger.apiResponse(
          method: response.requestOptions.method,
          endpoint: response.requestOptions.path,
          statusCode: response.statusCode ?? 200,
          responseData: response.data,
        );
        return handler.next(response);
      },
      onError: (DioException error, handler) {
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

  // Verify OTP
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required int oneTimeCode,
  }) async {
    try {
      final response = await _dio.post(
        AppUrls.verifyOtp,
        data: {
          'email': email,
          'oneTimeCode': oneTimeCode,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'OTP verified successfully',
          'data': response.data['data'] ?? response.data,
          'accessToken': response.data['data']?['accessToken'],
          'refreshToken': response.data['data']?['refreshToken'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'OTP verification failed',
          'statusCode': response.statusCode,
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data?['message'] ?? 
                  e.message ?? 
                  'Network error during OTP verification',
        'statusCode': e.response?.statusCode,
      };
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error in verifyOtp',
        error: e,
        stackTrace: stackTrace,
        tag: 'AuthVerifyOtpService',
      );
      return {
        'success': false,
        'message': 'An unexpected error occurred during OTP verification',
      };
    }
  }
}