import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/modules/profile/account%20options/order_history/services/order_service.dart';
import 'package:elecktro_ecommerce/app/modules/profile/account%20options/order_history/models/order_model.dart';
import 'package:elecktro_ecommerce/app/core/util/app_logger.dart';

class HistoryController extends GetxController {
  final RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final OrderService _orderService = Get.put(OrderService());

  @override
  void onInit() {
    super.onInit();
    // Load orders when the controller initializes
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Fetch orders from the service
      final response = await _orderService.getOrders();
      print("response==========================>>>>>>>>>>>>>>>>> $response");
      
      if (response != null && response.orders.isNotEmpty) {
        // Map the API response to the format expected by the UI
        orders.value = response.orders.map((order) => {
          'id': order.orderNumber,
          'status': _mapStatus(order.deliveryStatus),
          'address': order.address ?? 'No address provided',
          'date': _formatDate(order.createdAt),
          'product_name': _getProductNames(order.products),
          'quantity': order.products.length.toString(),
          'total': order.totalPrice,
        }).toList();
        
        // Log the actual response for debugging
        AppLogger.info('Successfully loaded ${orders.length} orders');
        AppLogger.info('Orders data: $orders');
      } else {
        orders.value = [];
        AppLogger.info('No orders found');
      }
    } catch (e) {
      errorMessage.value = 'Failed to load orders. Please try again.';
      AppLogger.error('Error loading orders: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  String _mapStatus(String deliveryStatus) {
    // Map the API status to the UI status if needed
    return deliveryStatus;
  }
  
  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)}, ${date.year}';
  }
  
  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
  
  String _getProductNames(List<dynamic> products) {
    if (products.isEmpty) return 'No products';
    if (products.length == 1) {
      final product = products[0];
      return product is OrderProduct ? product.productName : product['productName'] ?? 'Product';
    }
    final firstProduct = products[0];
    final productName = firstProduct is OrderProduct 
        ? firstProduct.productName 
        : firstProduct['productName'] ?? 'Product';
    return '$productName +${products.length - 1} more';
  }

  Future<void> refreshOrders() async {
    await loadOrders();
  }
  
  // Method to add a new order (for testing purposes)
  void addOrder(Map<String, dynamic> order) {
    orders.add(order);
  }
  
  // Method to update order status
  void updateOrderStatus(String orderId, String newStatus) {
    final index = orders.indexWhere((order) => order['id'] == orderId);
    if (index != -1) {
      orders[index]['status'] = newStatus;
      orders.refresh(); // Notify listeners
    }
  }
  
  // Method to remove/cancel an order
  void cancelOrder(String orderId) {
    orders.removeWhere((order) => order['id'] == orderId);
  }
  
  // Get orders by status
  List<Map<String, dynamic>> getOrdersByStatus(String status) {
    return orders.where((order) => 
      order['status'].toString().toLowerCase() == status.toLowerCase()
    ).toList();
  }
}