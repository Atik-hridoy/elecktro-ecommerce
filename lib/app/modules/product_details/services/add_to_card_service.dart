import 'package:dio/dio.dart';
import 'package:elecktro_ecommerce/app/core/network/app_urls.dart';
import 'package:elecktro_ecommerce/app/core/stroage/storage_services.dart';
import 'package:elecktro_ecommerce/app/modules/product_details/model/add_to_cart.dart';
import 'package:flutter/material.dart';

class CartService {
  final Dio _dio;

  CartService() : _dio = Dio(
    BaseOptions(
      baseUrl: AppUrls.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  ) {
    // Initialize LocalStorage data
    LocalStorage.getAllPrefData();
    
    // Add interceptor to include token in headers
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = LocalStorage.token;
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> addToCart(AddToCartModel addToCartModel) async {

    try {
      final response = await _dio.post(
        AppUrls.addToCart,
        data: addToCartModel.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Product added to cart successfully',
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Failed to add product to cart',
          'statusCode': response.statusCode,
        };
      }
    } on DioException catch (e) {
      String errorMessage = 'An error occurred while adding to cart';
      
      if (e.response?.statusCode == 401) {
        errorMessage = 'Please login to continue';
      } else if (e.response?.statusCode == 400) {
        errorMessage = e.response?.data['message'] ?? 'Invalid request data';
      } else if (e.response?.statusCode == 404) {
        errorMessage = 'Product not found';
      } else if (e.response?.statusCode == 500) {
        errorMessage = 'Server error. Please try again later';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout. Please check your internet connection';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Server is taking too long to respond';
      }

      return {
        'success': false,
        'message': errorMessage,
        'statusCode': e.response?.statusCode,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred: ${e.toString()}',
      };
    }
  }
  /// Fetches the user's cart from the server
  /// Returns a map containing the cart data or error information
  Future<Map<String, dynamic>> getCart() async {
    try {
      final response = await _dio.get(AppUrls.getCart);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch cart',
          'statusCode': response.statusCode,
        };
      }
    } on DioException catch (e) {
      String errorMessage = 'An error occurred while fetching cart';
      
      if (e.response?.statusCode == 401) {
        errorMessage = 'Please login to view your cart';
      } else if (e.response?.statusCode == 404) {
        errorMessage = 'Cart not found';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout. Please check your internet connection';
      }

      return {
        'success': false,
        'message': errorMessage,
        'statusCode': e.response?.statusCode,
      };
    } catch (e) {
      debugPrint('Error getting cart: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }
}