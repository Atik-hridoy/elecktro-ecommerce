import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/stroage/storage_services.dart';
import '../../../../core/util/app_logger.dart';

class GetFaqService {
  final Dio _dio = Get.find<Dio>();
  static const String _tag = 'GetFaqService';

  Future<List<Map<String, dynamic>>> getFaqs() async {
    try {
      // Get the access token from local storage
      await LocalStorage.getAllPrefData();
      
      if (LocalStorage.token.isEmpty) {
        AppLogger.warning('No access token found', tag: _tag);
        throw Exception('No access token found');
      }

      // Make the GET request with the authorization header
      final url = '${AppUrls.baseUrl}${AppUrls.faqs}';
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
          // Parse the response data
          final data = response.data;
          List<Map<String, dynamic>> faqList = [];

          if (data is Map && data['data'] != null) {
            // If response has a 'data' field
            final faqData = data['data'];
            if (faqData is List) {
              faqList = faqData.map((item) => item as Map<String, dynamic>).toList();
            }
          } else if (data is List) {
            // If response is directly a list
            faqList = data.map((item) => item as Map<String, dynamic>).toList();
          }

          AppLogger.success('FAQs loaded successfully: ${faqList.length} items', tag: _tag);
          return faqList;
        } catch (e, stackTrace) {
          AppLogger.error(
            'Failed to parse FAQ data',
            tag: _tag,
            error: e,
            stackTrace: stackTrace,
          );
          rethrow;
        }
      } else {
        final errorMsg = 'Failed to load FAQs: ${response.statusMessage}';
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
        throw Exception(errorMsg);
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
        'Failed to load FAQs: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      throw Exception('Failed to load FAQs: $e');
    }
  }
}
