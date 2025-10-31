import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            'Dealing History',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Get.back(),
          ),
          bottom: TabBar(
            labelColor: Colors.amber[700],
            unselectedLabelColor: Colors.grey[600],
            indicatorColor: Colors.amber[700],
            indicatorWeight: 2,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            tabs: const [
              Tab(text: 'Pending'),
              Tab(text: 'To Ship'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrderList('pending'),
            _buildOrderList('to_ship'),
            _buildOrderList('completed'),
            _buildOrderList('cancelled'),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(String status) {
    // Use demo data if controller orders are empty, otherwise use controller data
    final allOrders = controller.orders.isEmpty ? _getDemoOrders() : controller.orders;
    
    final filteredOrders = allOrders.where((order) {
      final orderStatus = order['status']?.toString().toLowerCase().trim() ?? '';
      final tabStatus = status.toLowerCase().replaceAll('_', ' ').trim();
      
      // Special handling for different status variations
      if (tabStatus == 'pending') {
        return orderStatus == 'pending' || orderStatus == 'processing';
      } else if (tabStatus == 'to ship') {
        return orderStatus.contains('ship') || orderStatus.contains('delivery');
      } else if (tabStatus == 'completed') {
        return orderStatus == 'completed' || orderStatus == 'delivered';
      } else if (tabStatus == 'cancelled') {
        return orderStatus.contains('cancel') || orderStatus.contains('refund');
      }
      return orderStatus == tabStatus;
    }).toList();

    if (filteredOrders.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          if (controller.orders.isNotEmpty) {
            await controller.refreshOrders();
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(Get.context!).size.height * 0.7,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    status == 'completed' 
                      ? Icons.check_circle_outline
                      : status == 'cancelled'
                        ? Icons.cancel_outlined
                        : status == 'pending' || status == 'to_ship'
                          ? Icons.pending_actions_outlined
                          : Icons.receipt_long_outlined,
                    size: 64,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _getEmptyStateTitle(status),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _getEmptyStateSubtitle(status),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (status == 'pending' || status == 'to_ship') ...[
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to products page
                      Get.until((route) => Get.currentRoute == '/home');
                      Get.toNamed('/category');
                    },
                    icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                    label: const Text('Continue Shopping'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (controller.orders.isNotEmpty) {
          controller.refreshOrders();
        }
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredOrders.length,
        itemBuilder: (context, index) {
          final order = filteredOrders[index];
          return _buildOrderCard(order);
        },
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with address and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order['address'] ?? '20 Cooper Square, Newyork',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Order date ${order['date'] ?? '25 Aug, 2025'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Status:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order['status']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getStatusColor(order['status']).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _getStatusText(order['status']),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(order['status']),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Product details and actions
          Row(
            children: [
              // Product image with dynamic icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _getProductColor(order['product_name']),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getProductIcon(order['product_name']),
                  color: Colors.white,
                  size: 24,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Product info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order No: ${order['id'] ?? '#1458118'}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (order['status'].toString().toLowerCase() == 'completed')
                          TextButton(
                            onPressed: () {
                              Get.snackbar(
                                'Return Request',
                                'Return request initiated for ${order['product_name']}',
                                backgroundColor: Colors.blue[50],
                                colorText: Colors.blue[800],
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              minimumSize: const Size(0, 0),
                            ),
                            child: Text(
                              'Return',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order['product_name'] ?? 'Luggage Tag',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Qty ${order['quantity'] ?? '3'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Total Price: \$${order['total']?.toString() ?? '9'}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton(order),
              ),
              if (order['status'].toString().toLowerCase() == 'pending')
                const SizedBox(width: 12),
              if (order['status'].toString().toLowerCase() == 'pending')
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Get.dialog(
                        AlertDialog(
                          title: const Text('Cancel Order'),
                          content: Text('Are you sure you want to cancel order ${order['id']}?'),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();
                                Get.snackbar(
                                  'Order Cancelled',
                                  'Order ${order['id']} has been cancelled',
                                  backgroundColor: Colors.red[50],
                                  colorText: Colors.red[800],
                                );
                              },
                              child: const Text('Yes, Cancel'),
                            ),
                          ],
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'cancel',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(Map<String, dynamic> order) {
    return ElevatedButton(
      onPressed: () {
        Get.snackbar(
          'Buy Again',
          '${order['product_name']} added to cart',
          backgroundColor: Colors.green[50],
          colorText: Colors.green[800],
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Buy Again',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Returns the color and formatted status text for an order status
  static ({Color color, String displayText}) getStatusInfo(String? status) {
    final statusLower = status?.toLowerCase() ?? 'pending';
    
    switch (statusLower) {
      case 'pending':
        return (
          color: const Color(0xFF3498db), // Blue
          displayText: 'Pending',
        );
      case 'processing':
        return (
          color: const Color(0xFF9b59b6), // Purple
          displayText: 'Processing',
        );
      case 'to_ship':
      case 'to ship':
      case 'shipped':
        return (
          color: const Color(0xFFf39c12), // Orange
          displayText: 'Shipped',
        );
      case 'out_for_delivery':
      case 'out for delivery':
        return (
          color: const Color(0xFF2ecc71), // Green
          displayText: 'Out for Delivery',
        );
      case 'delivered':
      case 'completed':
        return (
          color: const Color(0xFF27ae60), // Dark Green
          displayText: 'Delivered',
        );
      case 'cancelled':
      case 'canceled':
        return (
          color: const Color(0xFFe74c3c), // Red
          displayText: 'Cancelled',
        );
      case 'refunded':
        return (
          color: const Color(0xFF7f8c8d), // Gray
          displayText: 'Refunded',
        );
      default:
        return (
          color: Colors.grey,
          displayText: status?.split('_').map((s) => '${s[0].toUpperCase()}${s.substring(1)}').join(' ') ?? 'Pending',
        );
    }
  }
  
  /// Returns the color for a given order status
  Color _getStatusColor(String? status) {
    return getStatusInfo(status).color;
  }
  
  /// Returns the display text for a given order status
  String _getStatusText(String? status) {
    return getStatusInfo(status).displayText;
  }

  // Get product-specific colors for better visual distinction
  Color _getProductColor(String? productName) {
    switch (productName?.toLowerCase()) {
      case 'luggage tag':
        return Colors.brown;
      case 'travel backpack':
        return Colors.indigo;
      case 'phone case':
        return Colors.purple;
      case 'wireless headphones':
        return Colors.deepPurple;
      case 'laptop stand':
        return Colors.teal;
      case 'coffee mug set':
        return Colors.orange;
      case 'desk organizer':
        return Colors.green;
      default:
        return Colors.grey[800]!;
    }
  }

  // Get product-specific icons
  IconData _getProductIcon(String? productName) {
    switch (productName?.toLowerCase()) {
      case 'luggage tag':
        return Icons.luggage;
      case 'travel backpack':
        return Icons.backpack;
      case 'phone case':
        return Icons.phone_android;
      case 'wireless headphones':
        return Icons.headphones;
      case 'laptop stand':
        return Icons.laptop;
      case 'coffee mug set':
        return Icons.coffee;
      case 'desk organizer':
        return Icons.storage;
      default:
        return Icons.shopping_bag_outlined;
    }
  }

  // Get title for empty state based on order status
  String _getEmptyStateTitle(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'No Pending Orders';
      case 'to_ship':
      case 'to ship':
        return 'No Orders to Ship';
      case 'completed':
        return 'No Completed Orders';
      case 'cancelled':
        return 'No Cancelled Orders';
      default:
        return 'No Orders Found';
    }
  }

  // Get subtitle for empty state based on order status
  String _getEmptyStateSubtitle(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'You don\'t have any pending orders. Your new orders will appear here.';
      case 'to_ship':
      case 'to ship':
        return 'All your orders are on their way! Check back later for shipping updates.';
      case 'completed':
        return 'Your completed order history will appear here.';
      case 'cancelled':
        return 'No cancelled orders to display.';
      default:
        return 'Your orders will appear here once you make a purchase.';
    }
  }

  // Enhanced demo data with more variety
  List<Map<String, dynamic>> _getDemoOrders() {
    return [
      // Pending Orders
       
    ];
  }
}