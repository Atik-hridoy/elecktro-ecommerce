import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../core/network/app_urls.dart';
import '../../../core/stroage/storage_services.dart';
import '../../../core/util/app_logger.dart';
import '../models/seller_rating_model.dart';

class GetSellerRatingService {
  final Dio _dio = Get.find<Dio>();

  /// Fetches seller rating information from the API
  /// [sellerId] - The ID of the seller whose rating is to be fetched
  /// Returns a [SellerRatingModel] if successful, null otherwise
  Future<SellerRatingModel?> getSellerRating(String sellerId) async {
    try {
      // Get the access token from local storage
      await LocalStorage.getAllPrefData();
      
      if (LocalStorage.token.isEmpty) {
        throw Exception('No access token found');
      }

      // Construct the full URL with seller ID
      final url = '${AppUrls.baseUrl}${AppUrls.sellerRating}$sellerId';
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
          final sellerRatingData = SellerRatingModel.fromJson(response.data);
          AppLogger.success('Seller rating data parsed successfully');
          return sellerRatingData;
        } catch (e, stackTrace) {
          AppLogger.error(
            'Failed to parse seller rating data',
            error: e,
            stackTrace: stackTrace,
          );
          rethrow;
        }
      } else {
        final errorMsg = 'Failed to load seller rating: ${response.statusMessage}';
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
    } catch (e, stackTrace) {
      // Handle other errors
      AppLogger.error(
        'Failed to load seller rating',
        error: e,
        stackTrace: stackTrace,
      );
      throw Exception('Failed to load seller rating: $e');
    }
  }
}
