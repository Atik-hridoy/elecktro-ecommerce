import 'package:dio/dio.dart';
import 'package:elecktro_ecommerce/app/core/network/app_urls.dart';
import 'package:elecktro_ecommerce/app/core/stroage/storage_services.dart';
import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import 'package:elecktro_ecommerce/app/core/stroage/storage_keys.dart';
import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
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
          
          // Validate token is present and not expired
          if (token == null || token.isEmpty) {
            print('❌ No authentication token found');
            return handler.reject(
              DioException(
                requestOptions: options,
                error: 'No authentication token found',
              ),
            );
          }
          
          // Add authorization header
          options.headers['Authorization'] = 'Bearer $token';
          
          // Log the API request
          print('📤 API REQUEST: ${options.method} ${options.baseUrl}${options.path}');
          if (options.headers.isNotEmpty) {
            final headers = Map<String, dynamic>.from(options.headers);
            // Don't log the full auth token for security
            if (headers.containsKey('Authorization')) {
              final authHeader = headers['Authorization'] as String;
              headers['Authorization'] = '${authHeader.substring(0, 20)}...';
            }
            print('Headers: $headers');
          }
          if (options.queryParameters.isNotEmpty) {
            print('Query Parameters: ${options.queryParameters}');
          }
          if (options.data != null) {
            print('Request Data: ${options.data}');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Log successful response
          print('✅ API RESPONSE [${response.statusCode}]');
          if (response.data != null) {
            print('Response Data: ${response.data}');
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          // Log error response
          print('❌ BookmarkService Error: ${e.message}');
          if (e.response != null) {
            final statusCode = e.response?.statusCode;
            print('Status: $statusCode');
            
            if (statusCode == 401 || statusCode == 403) {
              // Handle token expiration or invalid token
              print('⚠️ Authentication error. Attempting to refresh token...');
              try {
                // Clear invalid token
                await LocalStorage.setString(LocalStorageKeys.token, '');
                await LocalStorage.setBool(LocalStorageKeys.isLogIn, false);
                
                // Navigate to login if not already there
                if (Get.currentRoute != Routes.auth) {
                  Get.offAllNamed(Routes.auth);
                }
                
                return handler.reject(e);
              } catch (refreshError) {
                print('❌ Error during token refresh: $refreshError');
                return handler.reject(e);
              }
            }
            
            if (e.response?.data != null) {
              print('Error Response: ${e.response?.data}');
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  /// Toggle bookmark for a product
  Future<bool> toggleBookmark(String referenceId) async {
    try {
      print('Toggling bookmark for referenceId: $referenceId');
      
      final response = await _dio.post(
        '${AppUrls.baseUrl}${AppUrls.postBookmark}$referenceId',
      );
      
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error toggling bookmark: $e');
      rethrow;
    }
  }

  /// Get all bookmarks for the current user
  Future<List<Map<String, dynamic>>> getBookmarks() async {
    try {
      print('🔍 Fetching bookmarks...');
      
      // Check if user is authenticated
      final token = LocalStorage.token;
      if (token == null || token.isEmpty) {
        print('⚠️ User is not authenticated. Cannot fetch bookmarks.');
        if (Get.currentRoute != Routes.auth) {
          Get.offAllNamed(Routes.auth);
        }
        return [];
      }
      
      final response = await _dio.get(
        '${AppUrls.baseUrl}${AppUrls.getBookmarks}',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) => status! < 500, // Don't throw for 4xx errors
        ),
      );
      
      if (response.statusCode == 200) {
        // Handle successful response
        print('✅ Successfully fetched ${response.data['data']?.length ?? 0} bookmarks');
        final List<dynamic> bookmarks = response.data['data'] ?? [];
        return bookmarks.cast<Map<String, dynamic>>();
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        // Handle unauthorized/forbidden
        print('🔒 Authentication required or token expired');
        await LocalStorage.setString(LocalStorageKeys.token, '');
        await LocalStorage.setBool(LocalStorageKeys.isLogIn, false);
        if (Get.currentRoute != Routes.auth) {
          Get.offAllNamed(Routes.auth);
        }
        return [];
      } else {
        // Handle other errors
        print('❌ Failed to fetch bookmarks. Status: ${response.statusCode}');
        return [];
      }
    } on DioException catch (e) {
      print('❌ Dio error fetching bookmarks: ${e.message}');
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        await LocalStorage.setString(LocalStorageKeys.token, '');
        await LocalStorage.setBool(LocalStorageKeys.isLogIn, false);
        if (Get.currentRoute != Routes.auth) {
          Get.offAllNamed(Routes.auth);
        }
      }
      rethrow;
    } catch (e) {
      print('❌ Unexpected error fetching bookmarks: $e');
      rethrow;
    }
  }

  /// Delete a bookmark by ID
  Future<bool> deleteBookmark(String bookmarkId) async {
    try {
      // Validate bookmark ID
      if (bookmarkId.isEmpty) {
        print('❌ Invalid bookmark ID: empty string');
        return false;
      }
      
      print('🗑️ Deleting bookmark with ID: $bookmarkId');
      
      final response = await _dio.delete(
        '${AppUrls.baseUrl}${AppUrls.deleteBookmark}$bookmarkId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) => status! < 500, // Don't throw for 4xx errors
        ),
      );
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ Successfully deleted bookmark');
        return true;
      } else if (response.statusCode == 404) {
        print('⚠️ Bookmark not found (404). It may have already been deleted.');
        // Return true since the bookmark doesn't exist anyway
        return true;
      } else {
        print('❌ Failed to delete bookmark. Status: ${response.statusCode}');
        if (response.data != null) {
          print('Response: ${response.data}');
        }
        return false;
      }
    } on DioException catch (e) {
      print('❌ Error deleting bookmark: ${e.message}');
      if (e.response?.statusCode == 404) {
        print('⚠️ Bookmark not found. It may have already been deleted.');
        return true;
      }
      rethrow;
    } catch (e) {
      print('❌ Unexpected error deleting bookmark: $e');
      rethrow;
    }
  }

  /// Check if a product is bookmarked
  Future<bool> isBookmarked(String productId) async {
    try {
      final bookmarks = await getBookmarks();
      return bookmarks.any((bookmark) => bookmark['productId'] == productId);
    } catch (e) {
      print('Error checking if product is bookmarked: $e');
      return false;
    }
  }
}