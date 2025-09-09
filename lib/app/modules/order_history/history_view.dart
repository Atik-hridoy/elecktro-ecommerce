import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrderList('pending'),
            _buildOrderList('to_ship'),
            _buildOrderList('completed'),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(String status) {
    // Use demo data if controller orders are empty, otherwise use controller data
    final allOrders = controller.orders.isEmpty ? _getDemoOrders() : controller.orders;
    
    final filteredOrders = allOrders.where((order) {
      switch (status) {
        case 'pending':
          return order['status'].toString().toLowerCase() == 'pending';
        case 'to_ship':
          return order['status'].toString().toLowerCase() == 'to ship';
        case 'completed':
          return order['status'].toString().toLowerCase() == 'completed';
        default:
          return false;
      }
    }).toList();

    if (filteredOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No ${status.replaceAll('_', ' ')} orders found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order['status']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      order['status'] ?? 'Pending',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(order['status']),
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

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.blue;
      case 'to ship':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
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

  // Enhanced demo data with more variety
  List<Map<String, dynamic>> _getDemoOrders() {
    return [
      // Pending Orders
       
    ];
  }
}