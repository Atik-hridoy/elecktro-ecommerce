import 'package:dio/dio.dart' as dio;
import 'package:elecktro_ecommerce/app/core/network/app_urls.dart';
import 'package:elecktro_ecommerce/app/core/stroage/storage_services.dart';
import 'package:elecktro_ecommerce/app/core/util/app_logger.dart';
import 'package:elecktro_ecommerce/app/modules/update_profile/update_profile_model.dart';
import 'package:get/get.dart';


class UpdateProfileService extends GetxService {
  final dio.Dio _dio = Get.put<dio.Dio>(dio.Dio());

  Future<Map<String, dynamic>> updateProfile({
    required UpdateProfileModel profileData,
  }) async {
    try {
      // Log the raw data before creating form data
      
      
      // Create form data from model
      final formData = dio.FormData.fromMap(profileData.toJson());
      
      // Log the form data fields
      final fields = formData.fields.map((e) => '${e.key}: ${e.value}').join(', ');
      

      // Get auth token
      final token = LocalStorage.token;
      if (token.isEmpty) {
        const error = 'No authentication token found';
        AppLogger.error(error, tag: 'UpdateProfileService');
        throw Exception(error);
      }

      // Log API request
      AppLogger.apiRequest(
        method: 'POST',
        endpoint: '${AppUrls.baseUrl}${AppUrls.updateProfile}',
        headers: {
          'Authorization': 'Bearer ${token.substring(0, 10)}...',
          'Content-Type': 'multipart/form-data',
        },
        body: profileData.toJson(),
      );
      
      // Make the request
      final response = await _dio.post<Map<String, dynamic>>(
        '${AppUrls.baseUrl}${AppUrls.updateProfile}',
        data: formData,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      // Log API response
      AppLogger.apiResponse(
        method: 'POST',
        endpoint: '${AppUrls.baseUrl}${AppUrls.updateProfile}',
        statusCode: response.statusCode!,
        responseData: response.data, response: response,
      );

      if (response.statusCode == 200) {
        AppLogger.success('Profile updated successfully', tag: 'UpdateProfileService');
        return response.data ?? {};
      } else {
        final error = 'Failed to update profile. Status: ${response.statusCode}. Response: ${response.data}';
        AppLogger.error(error, tag: 'UpdateProfileService');
        throw Exception(error);
      }
    } on dio.DioException catch (e) {
      AppLogger.error(
        'Dio error: ${e.type}. Message: ${e.message}',
        tag: 'UpdateProfileService',
        error: e,
        stackTrace: e.stackTrace,
      );
      
      // Log detailed response if available
      if (e.response != null) {
        AppLogger.error(
          'API Error Response',
          tag: 'UpdateProfileService',
          error: {
            'status': e.response?.statusCode,
            'data': e.response?.data,
            'headers': e.response?.headers.map,
          },
        );
      }
      
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error updating profile',
        tag: 'UpdateProfileService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}