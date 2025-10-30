import 'package:dio/dio.dart';
import 'package:elecktro_ecommerce/app/core/network/app_urls.dart';
import 'package:elecktro_ecommerce/app/core/stroage/storage_services.dart';
import 'package:get/get.dart';

/// Service class for handling banner-related API calls

class BannerService extends GetxService {
  final Dio _dio;

  BannerService()
      : _dio = Dio(BaseOptions(
          baseUrl: AppUrls.baseUrl,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        )) {
    // Add request interceptor to include the token in headers
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Get the latest token from storage
          await LocalStorage.getAllPrefData();
          final token = LocalStorage.token;
          
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  /// Fetch all banners
  Future<List<Map<String, dynamic>>?> getBanners() async {
    try {
      // Ensure we have the latest token
      await LocalStorage.getAllPrefData();
      
      final response = await _dio.get(AppUrls.getBanner);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          // Process banners to ensure image URLs are complete
          final banners = List<Map<String, dynamic>>.from(data['data']);
          return banners.map((banner) {
            if (banner['banner'] != null) {
              // Convert relative URL to absolute URL if needed
              String imageUrl = banner['banner'].toString();
              if (!imageUrl.startsWith('http')) {
                // Remove leading slash if present to avoid double slashes
                if (imageUrl.startsWith('/')) {
                  imageUrl = imageUrl.substring(1);
                }
                banner['image_url'] = '${AppUrls.baseImageUrl}$imageUrl';
              } else {
                banner['image_url'] = imageUrl;
              }
            }
            return banner;
          }).toList();
        } else {
          print('BannerService Error: ${data['message']}');
          return null;
        }
      } else {
        print('BannerService Failed: ${response.statusCode}');
        return null;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Handle unauthorized error (token expired or invalid)
        print('BannerService: Unauthorized - Token may be expired or invalid');
        // You might want to trigger a logout or token refresh here
      }
      print('DioException in BannerService: ${e.message}');
      return null;
    } catch (e) {
      print('Unexpected error in BannerService: $e');
      return null;
    }
  }
}
