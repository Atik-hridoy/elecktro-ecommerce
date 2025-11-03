import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../core/network/app_urls.dart';
import '../../../core/stroage/storage_services.dart';
import '../../../core/util/app_logger.dart';
import '../../category/models/get_product_details_models.dart';

class GetSellerProductsService {
  final Dio _dio = Get.find<Dio>();
  static const String _tag = 'GetSellerProductsService';

  /// Fetches all products from a specific seller
  /// [sellerId] - The ID of the seller whose products are to be fetched
  /// Returns a list of [ProductDetailModel] if successful
  Future<List<ProductDetailModel>> getSellerProducts(String sellerId) async {
    try {
      // Get the access token from local storage
      await LocalStorage.getAllPrefData();
      
      if (LocalStorage.token.isEmpty) {
        AppLogger.warning('No access token found', tag: _tag);
        throw Exception('No access token found');
      }

      // Construct the full URL with seller ID
      final url = '${AppUrls.baseUrl}${AppUrls.getSellerProducts}$sellerId';
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
          List<ProductDetailModel> sellerProducts = [];

          if (data is Map && data['data'] != null) {
            // If response has a 'data' field
            final productsData = data['data'];
            if (productsData is List) {
              sellerProducts = productsData
                  .map((item) => ProductDetailModel.fromJson(item as Map<String, dynamic>))
                  .toList();
            }
          } else if (data is List) {
            // If response is directly a list
            sellerProducts = data
                .map((item) => ProductDetailModel.fromJson(item as Map<String, dynamic>))
                .toList();
          }

          AppLogger.success(
            'Seller products loaded successfully: ${sellerProducts.length} items',
            tag: _tag,
          );
          return sellerProducts;
        } catch (e, stackTrace) {
          AppLogger.error(
            'Failed to parse seller products data',
            tag: _tag,
            error: e,
            stackTrace: stackTrace,
          );
          rethrow;
        }
      } else {
        final errorMsg = 'Failed to load seller products: ${response.statusMessage}';
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
        'Failed to load seller products: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      throw Exception('Failed to load seller products: $e');
    }
  }
}
