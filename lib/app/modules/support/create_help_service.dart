import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../core/network/app_urls.dart';
import '../../core/stroage/storage_services.dart';
import '../../core/util/app_logger.dart';

class CreateHelpService {
  final Dio _dio = Get.find<Dio>();
  static const String _tag = 'CreateHelpService';

  Future<Map<String, dynamic>> createHelpRequest({
    required String email,
    required String message,
  }) async {
    try {
      // Get the access token from local storage
      await LocalStorage.getAllPrefData();
      
      if (LocalStorage.token.isEmpty) {
        AppLogger.warning('No access token found', tag: _tag);
        throw Exception('No access token found');
      }

      // Prepare request body
      final requestBody = {
        'email': email,
        'message': message,
      };

      // Make the POST request with the authorization header
      final url = '${AppUrls.baseUrl}${AppUrls.createHelp}';
      final headers = {
        'Authorization': 'Bearer ${LocalStorage.token}',
        'Content-Type': 'application/json',
      };

      // Log the request
      AppLogger.apiRequest(
        method: 'POST',
        endpoint: url,
        headers: headers,
        body: requestBody,
      );

      final response = await _dio.post(
        url,
        data: requestBody,
        options: Options(headers: headers),
      );

      // Log the response
      AppLogger.apiResponse(
        method: 'POST',
        endpoint: url,
        statusCode: response.statusCode ?? 0,
        responseData: response.data,
        response: response,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.success('Help request created successfully', tag: _tag);
        
        // Return the response data
        if (response.data is Map<String, dynamic>) {
          return response.data as Map<String, dynamic>;
        } else {
          return {'success': true, 'data': response.data};
        }
      } else {
        final errorMsg = 'Failed to create help request: ${response.statusMessage}';
        AppLogger.error(
          errorMsg,
          tag: _tag,
          error: Exception(errorMsg),
          stackTrace: StackTrace.current,
        );
        throw Exception(errorMsg);
      }
    } on DioException catch (e) {
      // Handle Dio errors
      if (e.response != null) {
        final errorMsg = 'API Error: ${e.response?.statusCode} - ${e.response?.statusMessage}';
        final errorData = e.response?.data;
        
        AppLogger.error(
          errorMsg,
          tag: _tag,
          error: e,
          stackTrace: e.stackTrace,
        );
        
        // Try to extract error message from response
        String userMessage = errorMsg;
        if (errorData is Map && errorData['message'] != null) {
          userMessage = errorData['message'].toString();
        }
        
        throw Exception(userMessage);
      } else {
        final errorMsg = 'Network error: ${e.message}';
        AppLogger.error(
          errorMsg,
          tag: _tag,
          error: e,
          stackTrace: e.stackTrace,
        );
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      // Handle other errors
      AppLogger.error(
        'Failed to create help request: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      throw Exception('Failed to create help request: $e');
    }
  }
}
