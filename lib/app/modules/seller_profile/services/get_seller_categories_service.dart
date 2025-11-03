import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../core/network/app_urls.dart';
import '../../../core/stroage/storage_services.dart';
import '../../../core/util/app_logger.dart';
import '../models/seller_category_model.dart';

class GetSellerCategoriesService {
  final Dio _dio = Get.find<Dio>();
  static const String _tag = 'GetSellerCategoriesService';

  /// Fetches all product categories from a specific seller
  /// [sellerId] - The ID of the seller whose categories are to be fetched
  /// Returns a list of [SellerCategory] if successful
  Future<List<SellerCategory>> getSellerCategories(String sellerId) async {
    try {
      // Get the access token from local storage
      await LocalStorage.getAllPrefData();
      
      if (LocalStorage.token.isEmpty) {
        AppLogger.warning('No access token found', tag: _tag);
        throw Exception('No access token found');
      }

      // Construct the full URL with seller ID
      final url = '${AppUrls.baseUrl}${AppUrls.getSellerProductsCategories}$sellerId';
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
          List<SellerCategory> categories = [];

          if (data is Map && data['data'] != null) {
            // If response has a 'data' field
            final categoriesData = data['data'];
            if (categoriesData is List) {
              categories = categoriesData
                  .map((item) => SellerCategory.fromJson(item as Map<String, dynamic>))
                  .toList();
            }
          } else if (data is List) {
            // If response is directly a list
            categories = data
                .map((item) => SellerCategory.fromJson(item as Map<String, dynamic>))
                .toList();
          }

          AppLogger.success(
            'Seller categories loaded successfully: ${categories.length} items',
            tag: _tag,
          );
          return categories;
        } catch (e, stackTrace) {
          AppLogger.error(
            'Failed to parse seller categories data',
            tag: _tag,
            error: e,
            stackTrace: stackTrace,
          );
          rethrow;
        }
      } else {
        final errorMsg = 'Failed to load seller categories: ${response.statusMessage}';
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
        'Failed to load seller categories: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      throw Exception('Failed to load seller categories: $e');
    }
  }
}
