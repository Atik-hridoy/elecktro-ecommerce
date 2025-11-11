import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/core/network/app_urls.dart';
import 'package:elecktro_ecommerce/app/core/stroage/storage_services.dart';
import 'package:elecktro_ecommerce/app/core/util/app_logger.dart';

class DeleteAccountService {
  final Dio _dio = Get.find<Dio>();
  static const String _tag = 'DeleteAccountService';

  /// Delete user account
  Future<Map<String, dynamic>> deleteAccount() async {
    try {
      // Get the access token from local storage
      await LocalStorage.getAllPrefData();
      
      if (LocalStorage.token.isEmpty) {
        AppLogger.warning('No access token found', tag: _tag);
        throw Exception('No access token found');
      }

      // Make the DELETE request with the authorization header
      final url = '${AppUrls.baseUrl}${AppUrls.deleteAccount}';
      final headers = {
        'Authorization': 'Bearer ${LocalStorage.token}',
        'Content-Type': 'application/json',
      };

      // Log the request
      AppLogger.apiRequest(
        method: 'DELETE',
        endpoint: url,
        headers: headers,
      );

      final response = await _dio.delete(
        url,
        options: Options(headers: headers),
      );

      // Log the response
      AppLogger.apiResponse(
        method: 'DELETE',
        endpoint: url,
        statusCode: response.statusCode ?? 0,
        responseData: response.data,
        response: response,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        AppLogger.success('Account deleted successfully', tag: _tag);
        
        // Clear all local storage data
        await LocalStorage.removeAllPrefData();
        
        return {
          'success': true,
          'message': 'Account deleted successfully',
          'data': response.data,
        };
      } else {
        final errorMsg = 'Failed to delete account: ${response.statusMessage}';
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
        AppLogger.error(
          errorMsg,
          tag: _tag,
          error: e,
          stackTrace: e.stackTrace,
        );
        
        // Extract error message from response if available
        String message = 'Failed to delete account';
        if (e.response?.data != null) {
          if (e.response!.data is Map && e.response!.data['message'] != null) {
            message = e.response!.data['message'];
          }
        }
        
        throw Exception(message);
      } else {
        final errorMsg = 'Network error: ${e.message}';
        AppLogger.error(
          errorMsg,
          tag: _tag,
          error: e,
          stackTrace: e.stackTrace,
        );
        throw Exception('Network error. Please check your connection.');
      }
    } catch (e, stackTrace) {
      // Handle other errors
      AppLogger.error(
        'Failed to delete account: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      throw Exception('Failed to delete account: $e');
    }
  }
}
