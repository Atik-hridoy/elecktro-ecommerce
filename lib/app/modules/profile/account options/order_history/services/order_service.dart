import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/core/network/app_urls.dart';
import 'package:elecktro_ecommerce/app/core/util/app_logger.dart';
import 'package:elecktro_ecommerce/app/core/stroage/storage_services.dart';
import 'package:elecktro_ecommerce/app/modules/profile/account%20options/order_history/models/order_model.dart';

class OrderService extends GetxService {
  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppUrls.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
  
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final String _tag = 'OrderService';

  @override
  void onInit() {
    super.onInit();
    
    // Add interceptors for logging and authentication
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Log request
          AppLogger.apiRequest(
            method: options.method.toUpperCase(),
            endpoint: options.path,
            headers: options.headers,
            queryParams: options.queryParameters,
            body: options.data,
          );
          
          // Add auth token if available
          final token = LocalStorage.token;
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Log successful response
          AppLogger.apiResponse(
            statusCode: response.statusCode ?? 200,
            response: response.data,
            endpoint: response.requestOptions.path, method: response.requestOptions.method,
          );
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          // Log error response
          AppLogger.apiError(
            method: e.requestOptions.method,
            endpoint: e.requestOptions.path,
            error: e,
            statusCode: e.response?.statusCode,
            stackTrace: e.stackTrace,
          );
          
          // Handle 401 Unauthorized
          if (e.response?.statusCode == 401) {
            await LocalStorage.removeAllPrefData();
            // You might want to trigger navigation to login here
          }
          
          return handler.next(e);
        },
      ),
    );
  }

  /// Fetches the list of orders for the authenticated user
  Future<OrderResponse?> getOrders({int page = 1, int limit = 10}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      AppLogger.info('Fetching orders (Page: $page, Limit: $limit)', tag: _tag);
      
      final response = await _dio.get(
        AppUrls.getOrders,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        print("responseData==========================>>>>>>>>>>>>>>>>> $responseData");
        
        if (responseData is Map<String, dynamic> && responseData['data'] != null) {
          // Handle the actual API response format
          final data = responseData['data'] as Map<String, dynamic>;
          final results = data['orders'] as List<dynamic>;
          
          // Convert each order to OrderModel
          final orders = results.map((orderData) {
            return OrderModel(
              id: orderData['_id'] ?? '',
              orderNumber: orderData['orderNumber'] ?? 'N/A',
              customerId: orderData['customerId'] ?? '',
              sellerId: orderData['sellerId'] ?? '',
              products: (orderData['products'] as List<dynamic>? ?? []).map((p) {
                return OrderProduct(
                  productId: p['productId'] is String ? p['productId'] : p['productId']?['_id'] ?? '',
                  sellerId: p['sellerId'] ?? '',
                  productName: p['productName'] ?? 'Unknown Product',
                  size: p['size'] ?? '',
                  color: p['color'] ?? '',
                  quantity: p['quantity'] ?? 1,
                  price: (p['price'] ?? 0).toDouble(),
                  discount: (p['discount'] ?? 0).toDouble(),
                  totalPrice: (p['totalPrice'] ?? 0).toDouble(),
                );
              }).toList(),
              totalPrice: (orderData['totalPrice'] ?? 0).toDouble(),
              paymentStatus: orderData['paymentStatus'] ?? 'pending',
              deliveryStatus: orderData['deliveryStatus'] ?? 'pending',
              address: orderData['shippingAddress']?['address'] ?? 'No address provided',
              phoneNumber: orderData['shippingAddress']?['phoneNumber'],
              email: orderData['shippingAddress']?['email'],
              createdAt: orderData['createdAt'] != null 
                  ? DateTime.parse(orderData['createdAt']) 
                  : DateTime.now(),
              updatedAt: orderData['updatedAt'] != null 
                  ? DateTime.parse(orderData['updatedAt']) 
                  : DateTime.now(),
            );
          }).toList();
          
          // Create a proper OrderResponse
          final total = data['total'] ?? orders.length;
          return OrderResponse(
            orders: orders,
            page: page,
            limit: limit,
            total: total,
            totalPage: (total / limit).ceil(),
          );
        } else {
          throw Exception('Invalid response format: Missing data');
        }
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data?['message'] ?? e.message ?? 'Network error';
      errorMessage.value = errorMsg;
      AppLogger.error('Failed to fetch orders: $errorMsg', tag: _tag, error: e);
      return null;
    } catch (e, stackTrace) {
      errorMessage.value = 'An unexpected error occurred';
      AppLogger.error('Unexpected error in getOrders', tag: _tag, error: e, stackTrace: stackTrace);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches a single order by ID
  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      AppLogger.info('Fetching order details for ID: $orderId', tag: _tag);
      
      final response = await _dio.get('${AppUrls.getOrders}/$orderId');

      if (response.statusCode == 200) {
        final responseData = response.data;
        
        if (responseData is Map<String, dynamic> && responseData['data'] != null) {
          return OrderModel.fromJson(responseData['data']);
        } else {
          throw Exception('Invalid order data format');
        }
      } else {
        throw Exception('Failed to load order: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data?['message'] ?? e.message ?? 'Network error';
      errorMessage.value = errorMsg;
      AppLogger.error('Failed to fetch order: $errorMsg', tag: _tag, error: e);
      return null;
    } catch (e, stackTrace) {
      errorMessage.value = 'An unexpected error occurred';
      AppLogger.error('Unexpected error in getOrderById', tag: _tag, error: e, stackTrace: stackTrace);
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
