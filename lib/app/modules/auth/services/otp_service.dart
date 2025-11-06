import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/core/network/app_urls.dart';
import 'package:elecktro_ecommerce/app/core/util/app_logger.dart';

class AuthVerifyOtpService extends GetxService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: AppUrls.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
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
          response: response,
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
    required String oneTimeCode,
  }) async {
    try {
      // Convert OTP to number if it's a valid number
      final otpNumber = int.tryParse(oneTimeCode);
      
      if (otpNumber == null) {
        throw Exception('Invalid OTP format. Must be a number.');
      }

      AppLogger.debug(
        'Sending OTP verification request',
        tag: 'AuthVerifyOtpService',
        details: {
          'email': email,
          'oneTimeCode': otpNumber,
          'endpoint': AppUrls.verifyOtp,
        },
      );

      final response = await _dio.post(
        AppUrls.verifyOtp,
        data: {
          'email': email.trim(),
          'oneTimeCode': otpNumber, // Sending as number
        },
      );

      AppLogger.debug(
        'Received OTP verification response',
        tag: 'AuthVerifyOtpService',
        details: {
          'statusCode': response.statusCode ?? 200,
          'response': response.data,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final accessToken = response.data['data']?['accessToken'];
        final refreshToken = response.data['data']?['refreshToken'];

        AppLogger.debug(
          'OTP verification successful',
          tag: 'Auth',
          details: {
            'hasAccessToken': accessToken != null,
            'hasRefreshToken': refreshToken != null,
          },
        );

        return {
          'success': true,
          'message': response.data['message'] ?? 'OTP verified successfully',
          'data': response.data['data'] ?? response.data,
          'accessToken': accessToken,
          'refreshToken': refreshToken,
        };
      } else {
AppLogger.debug(
          'OTP verification failed',
          tag: 'Auth',
          details: {
            'statusCode': response.statusCode ?? 200,
            'message': response.data['message'] ?? 'No message from server',
          },
        );
        
        return {
          'success': false,
          'message': response.data['message'] ?? 'OTP verification failed',
          'statusCode': response.statusCode ?? 200,
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data?['message'] ?? 
                  e.message ?? 
                  'Network error during OTP verification',
        'statusCode': e.response?.statusCode ?? 0,
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