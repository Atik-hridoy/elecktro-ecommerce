import 'package:dio/dio.dart';
import 'package:elecktro_ecommerce/app/core/network/app_urls.dart';
import 'package:elecktro_ecommerce/app/core/stroage/storage_services.dart';
import 'package:elecktro_ecommerce/app/core/util/app_logger.dart';

class GetNotificationService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> getNotifications() async {
    try {
      // Get token from local storage
      final token = LocalStorage.token;
      if (token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      // Make the API request
      final response = await _dio.get(
        AppUrls.getNotification,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      // Log successful response
      AppLogger.apiResponse(
        method: 'GET',
        endpoint: '${AppUrls.baseUrl}${AppUrls.getNotification}',
        statusCode: 200,
        response: response.data,
      );

      return {
        'success': true,
        'data': response.data,
      };
    } on DioException catch (e) {
      // Log error response
      AppLogger.apiResponse(
        method: 'GET',
        endpoint: '${AppUrls.baseUrl}${AppUrls.getNotification}',
        statusCode: e.response?.statusCode ?? 500,
        response: e.response?.data,
      );

      return {
        'success': false,
        'error': e.response?.data?['message'] ?? 'Failed to fetch notifications',
        'statusCode': e.response?.statusCode,
      };
    } catch (e) {
      // Log unexpected errors
      AppLogger.apiResponse(
        method: 'GET',
        endpoint: '${AppUrls.baseUrl}${AppUrls.getNotification}',
        statusCode: 500,
        response: e.toString(),
      );

      return {
        'success': false,
        'error': 'An unexpected error occurred',
      };
    }
  }
}