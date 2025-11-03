import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../core/network/app_urls.dart';
import '../../../core/stroage/storage_services.dart';
import '../../../core/util/app_logger.dart';
import '../../category/models/get_product_details_models.dart';

class GetPopularProductService {
  final Dio _dio = Get.find<Dio>();
  static const String _tag = 'GetPopularProductService';

  Future<List<ProductDetailModel>> getPopularProducts() async {
    try {
      // Get the access token from local storage
      await LocalStorage.getAllPrefData();
      
      if (LocalStorage.token.isEmpty) {
        AppLogger.warning('No access token found', tag: _tag);
        throw Exception('No access token found');
      }

      // Make the GET request with the authorization header
      final url = '${AppUrls.baseUrl}${AppUrls.getPopularProducts}';
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
          List<ProductDetailModel> popularProducts = [];

          if (data is Map && data['data'] != null) {
            // If response has a 'data' field
            final productsData = data['data'];
            if (productsData is List) {
              popularProducts = productsData
                  .map((item) => ProductDetailModel.fromJson(item as Map<String, dynamic>))
                  .toList();
            }
          } else if (data is List) {
            // If response is directly a list
            popularProducts = data
                .map((item) => ProductDetailModel.fromJson(item as Map<String, dynamic>))
                .toList();
          }

          AppLogger.success('Popular products loaded successfully: ${popularProducts.length} items', tag: _tag);
          return popularProducts;
        } catch (e, stackTrace) {
          AppLogger.error(
            'Failed to parse popular products data',
            tag: _tag,
            error: e,
            stackTrace: stackTrace,
          );
          rethrow;
        }
      } else {
        final errorMsg = 'Failed to load popular products: ${response.statusMessage}';
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
        'Failed to load popular products: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      throw Exception('Failed to load popular products: $e');
    }
  }
}
