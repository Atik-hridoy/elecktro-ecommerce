import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/core/network/app_urls.dart';
import 'package:elecktro_ecommerce/app/core/switching_language_facilities/localization_service.dart';

class AboutService {
  final Dio _dio = Dio();

  /// Fetch About Us content from the API
  /// Returns a Map with success status, message, and data
  Future<Map<String, dynamic>> fetchAboutUsContent() async {
    try {
      print('🔄 AboutService: Fetching About Us content...');
      
      // Get current locale for translated content (fallback to 'en' if service not available)
      String currentLocale = 'en';
      try {
        final localizationService = Get.find<LocalizationService>();
        currentLocale = localizationService.currentLanguage.value;
      } catch (e) {
        print('⚠️ LocalizationService not found, using default locale: en');
      }
      
      // Add locale parameter to the request
      final url = '${AppUrls.baseUrl}${AppUrls.aboutUs}&locale=$currentLocale';
      
      final response = await _dio.get(url);
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data != null && data['success'] == true) {
          print('✅ AboutService: About Us content fetched successfully');
          return {
            'success': true,
            'message': data['message'] ?? 'Content loaded successfully',
            'data': {
              'content': data['data'] ?? 'No content available',
            },
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'No content available',
            'data': null,
          };
        }
      } else {
        print('❌ AboutService: Failed to fetch content - Status: ${response.statusCode}');
        return {
          'success': false,
          'message': 'Failed to load About Us content (${response.statusCode})',
          'data': null,
        };
      }
    } on DioException catch (dioError) {
      print('❌ AboutService: Dio error - ${dioError.message}');
      String errorMessage = 'Network error occurred';
      
      if (dioError.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout. Please check your internet connection.';
      } else if (dioError.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Server response timeout. Please try again.';
      } else if (dioError.type == DioExceptionType.connectionError) {
        errorMessage = 'Unable to connect to server. Please check your internet connection.';
      } else if (dioError.response?.statusCode == 404) {
        errorMessage = 'About Us content not found.';
      } else if (dioError.response?.statusCode == 500) {
        errorMessage = 'Server error. Please try again later.';
      }
      
      return {
        'success': false,
        'message': errorMessage,
        'data': null,
      };
    } catch (e) {
      print('❌ AboutService: Unexpected error - $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred: ${e.toString()}',
        'data': null,
      };
    }
  }
}
