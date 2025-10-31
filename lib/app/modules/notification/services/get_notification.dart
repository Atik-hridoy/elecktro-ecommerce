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

  Future<Map<String, dynamic>> markNotificationAsRead(String notificationId) async {
    try {
      final token = LocalStorage.token;
      if (token.isEmpty) throw Exception('No token found');

      final endpoint = '${AppUrls.baseUrl}${AppUrls.readSingleNotification}$notificationId';
      
      AppLogger.debug(
        'Marking notification as read',
        tag: 'NotificationService',
        details: {'endpoint': endpoint, 'method': 'PATCH', 'notificationId': notificationId},
      );

      final response = await _dio.patch(
        endpoint,
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
        method: 'PATCH',
        endpoint: endpoint,
        statusCode: response.statusCode ?? 200,
        response: response.data,
      );

      if (response.statusCode == 200 && (response.data['success'] == true || response.data['status'] == 'success')) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Notification marked as read',
          'data': response.data
        };
      } else {
        return {
          'success': false,
          'error': response.data['message'] ?? 'Failed to mark notification as read',
        };
      }
    } on DioException catch (e) {
      // Log error response
      AppLogger.apiResponse(
        method: 'PATCH',
        endpoint: '${AppUrls.baseUrl}${AppUrls.readSingleNotification}',
        statusCode: e.response?.statusCode ?? 500,
        response: e.response?.data,
      );

      return {
        'success': false,
        'error': e.response?.data?['message'] ?? e.message ?? 'Failed to mark notification as read',
      };
    } catch (e) {
      AppLogger.error(
        'Unexpected error marking notification as read',
        error: e,
        stackTrace: StackTrace.current,
      );
      return {
        'success': false,
        'error': 'An unexpected error occurred',
      };
    }
  }

  Future<Map<String, dynamic>> markAllNotificationsAsRead() async {
    try {
      final token = LocalStorage.token;
      if (token.isEmpty) throw Exception('No token found');

      final endpoint = '${AppUrls.baseUrl}${AppUrls.markAllNotificationsRead}';
      
      AppLogger.debug(
        'Marking all notifications as read',
        tag: 'NotificationService',
        details: {'endpoint': endpoint, 'method': 'POST'},
      );

      final response = await _dio.patch(
        endpoint,
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
        method: 'PATCH',
        endpoint: endpoint,
        statusCode: response.statusCode ?? 200,
        response: response.data,
      );

      if (response.statusCode == 200 && (response.data['success'] == true || response.data['status'] == 'success')) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'All notifications marked as read',
          'data': response.data
        };
      } else {
        return {
          'success': false,
          'error': response.data['message'] ?? 'Failed to mark all notifications as read',
        };
      }
    } on DioException catch (e) {
      // Log error response
      AppLogger.apiResponse(
        method: 'PATCH',
        endpoint: '${AppUrls.baseUrl}${AppUrls.markAllNotificationsRead}',
        statusCode: e.response?.statusCode ?? 500,
        response: e.response?.data,
      );

      return {
        'success': false,
        'error': e.response?.data?['message'] ?? e.message ?? 'Failed to mark notifications as read',
      };
    }
  }
}