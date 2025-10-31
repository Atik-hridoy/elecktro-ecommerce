import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../../../app/core/network/app_urls.dart';
import '../../../../../app/core/stroage/storage_services.dart';
import '../../../../../app/core/util/app_logger.dart';
import '../model/get_profile_model.dart';

class GetProfileService {
  final Dio _dio = Get.find<Dio>();

  Future<GetProfileModel?> getProfile() async {
    try {
      // Get the access token from local storage
      await LocalStorage.getAllPrefData();
      
      if (LocalStorage.token.isEmpty) {
        throw Exception('No access token found');
      }

      // Make the GET request with the authorization header
      final url = '${AppUrls.baseUrl}${AppUrls.getProfile}';
      final headers = {
        'Authorization': 'Bearer ${LocalStorage.token}',
        'Content-Type': 'application/json',
      };

      // Log the request
      AppLogger.apiRequest(
        method: 'GET',
        endpoint: url,
        headers: headers,
      );

      final response = await _dio.get(
        url,
        options: Options(headers: headers),
      );

      // Log the response
      AppLogger.apiResponse(
        method: 'GET',
        endpoint: url,
        statusCode: response.statusCode ?? 0,
        responseData: response.data,
        response: response,
      );

      if (response.statusCode == 200) {
        try {
          final profileData = GetProfileModel.fromJson(response.data);
          AppLogger.success('Profile data parsed successfully');
          return profileData;
        } catch (e, stackTrace) {
          AppLogger.error(
            'Failed to parse profile data',
            error: e,
            stackTrace: stackTrace,
          );
          rethrow;
        }
      } else {
        final errorMsg = 'Failed to load profile: ${response.statusMessage}';
        AppLogger.error(
          errorMsg,
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
          error: e,
          stackTrace: e.stackTrace,
        );
        throw Exception(errorMsg);
      } else {
        final errorMsg = 'Network error: ${e.message}';
        AppLogger.error(
          errorMsg, 
          error: e,
          stackTrace: e.stackTrace,
        );
        throw Exception(errorMsg);
      }
    } catch (e) {
      // Handle other errors
      throw Exception('Failed to load profile: $e');
    }
  }
}
