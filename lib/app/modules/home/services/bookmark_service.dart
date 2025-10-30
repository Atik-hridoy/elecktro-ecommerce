// lib/app/modules/home/services/bookmark_service.dart
import 'package:dio/dio.dart';
import 'package:elecktro_ecommerce/app/core/network/app_urls.dart';
import 'package:elecktro_ecommerce/app/core/stroage/storage_services.dart';
import 'package:get/get.dart';

class BookmarkService extends GetxService {
  final Dio _dio;

  BookmarkService() : _dio = Dio() {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = LocalStorage.token;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          options.headers['Content-Type'] = 'application/json';
          options.headers['Accept'] = 'application/json';
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          print('BookmarkService Error: ${e.message}');
          if (e.response != null) {
            print('Status: ${e.response?.statusCode}');
            print('Response: ${e.response?.data}');
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<bool> toggleBookmark(String referenceId) async {
    try {
      final response = await _dio.post(
        '${AppUrls.baseUrl}${AppUrls.postBookmark}$referenceId',
      );
      
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error in toggleBookmark: $e');
      return false;
    }
  }
}