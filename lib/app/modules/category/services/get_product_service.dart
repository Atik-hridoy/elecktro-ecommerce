import 'package:dio/dio.dart' hide Response;
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/core/network/app_urls.dart';
import 'package:elecktro_ecommerce/app/core/stroage/storage_services.dart';
import 'package:elecktro_ecommerce/app/core/util/app_logger.dart';

class ProductService extends GetxService {
  final Dio _dio = Get.find<Dio>();

  /// GET /products/{productId}
  /// Requires bearer authentication
  Future<Response<dynamic>> getProductDetails(String productId) async {
    final endpoint = '${AppUrls.getProducts}$productId';
    final url = '${AppUrls.baseUrl}$endpoint';

    // Log request (hide token)
    AppLogger.apiRequest(
      method: 'GET',
      endpoint: url,
      headers: const {
        'Authorization': 'Bearer <hidden>',
        'Accept': 'application/json',
      },
    );

    final sw = Stopwatch()..start();

    try {
      await LocalStorage.getAllPrefData();
      final token = LocalStorage.token;
      if (token.isEmpty) {
        throw Exception('No authentication token found. Please log in again.');
      }

      final res = await _dio.get<dynamic>(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      sw.stop();
      AppLogger.apiResponse(
        method: 'GET',
        endpoint: url,
        statusCode: res.statusCode ?? 0,
        responseData: res.data,
        duration: sw.elapsed,
        response: res,
      );

      return Response(
        body: res.data,
        statusCode: res.statusCode,
        statusText: res.statusMessage,
      );
    } on DioException catch (e) {
      sw.stop();
      final status = e.response?.statusCode;
      AppLogger.apiError(
        method: 'GET',
        endpoint: url,
        error: e.message ?? e.toString(),
        statusCode: status,
        stackTrace: e.stackTrace,
      );

      if (e.response != null) {
        return Response(
          body: e.response?.data,
          statusCode: e.response?.statusCode,
          statusText: e.response?.statusMessage,
        );
      }

      rethrow;
    } catch (e, st) {
      sw.stop();
      AppLogger.apiError(
        method: 'GET',
        endpoint: url,
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  /// GET /products
  /// Fetch list of products (no productId in path)
  Future<Response<dynamic>> getProducts({Map<String, dynamic>? query}) async {
    final endpoint = AppUrls.getProducts; // 'products/'
    final url = '${AppUrls.baseUrl}$endpoint';

    AppLogger.apiRequest(
      method: 'GET',
      endpoint: url,
      headers: const {
        'Authorization': 'Bearer <hidden>',
        'Accept': 'application/json',
      },
      queryParams: query,
    );

    final sw = Stopwatch()..start();

    try {
      await LocalStorage.getAllPrefData();
      final token = LocalStorage.token;
      if (token.isEmpty) {
        throw Exception('No authentication token found. Please log in again.');
      }

      // Debug token format
      AppLogger.info(
        'Making API request with token - Length: ${token.length}, First 20 chars: ${token.length > 20 ? token.substring(0, 20) : token}...',
        tag: 'ProductService',
      );

      final res = await _dio.get<dynamic>(
        url,
        queryParameters: query,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      sw.stop();
      AppLogger.apiResponse(
        method: 'GET',
        endpoint: url,
        statusCode: res.statusCode ?? 0,
        responseData: res.data,
        duration: sw.elapsed,
        response: res,
      );

      return Response(
        body: res.data,
        statusCode: res.statusCode,
        statusText: res.statusMessage,
      );
    } on DioException catch (e) {
      sw.stop();
      final status = e.response?.statusCode;
      
      // Handle 403 Forbidden error - just return error response, don't redirect
      if (status == 403) {
        AppLogger.error(
          'Authentication failed - 403 Forbidden. Endpoint: $url, Token: ${LocalStorage.token.isNotEmpty ? 'Present' : 'Missing'}, Length: ${LocalStorage.token.length}, LoggedIn: ${LocalStorage.isLogIn}',
          tag: 'ProductService',
          error: e,
        );
        
        // Just return error response - let the UI handle it gracefully
        return Response(
          body: {
            'success': false, 
            'message': 'Authentication error. Please check your login status.',
            'data': []
          },
          statusCode: 403,
          statusText: 'Authentication Failed',
        );
      }
      
      AppLogger.apiError(
        method: 'GET',
        endpoint: url,
        error: e.message ?? e.toString(),
        statusCode: status,
        stackTrace: e.stackTrace,
      );
      if (e.response != null) {
        return Response(
          body: e.response?.data,
          statusCode: e.response?.statusCode,
          statusText: e.response?.statusMessage,
        );
      }
      rethrow;
    } catch (e, st) {
      sw.stop();
      AppLogger.apiError(
        method: 'GET',
        endpoint: url,
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }
}

