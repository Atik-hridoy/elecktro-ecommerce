import 'package:get/get.dart';

class HistoryController extends GetxController {
  final RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load orders when the controller initializes
    loadOrders();
  }

  void loadOrders() {
    // Sample orders with the correct data structure that matches the view
    orders.value = [
      // Pending Orders
      {
        'id': '#1458118',
        'status': 'Pending',
        'address': '20 Cooper Square, New York',
        'date': '25 Aug, 2025',
        'product_name': 'Luggage Tag',
        'quantity': '3',
        'total': 9,
      },
      {
        'id': '#1458119',
        'status': 'Pending',
        'address': '15 Madison Avenue, NYC',
        'date': '24 Aug, 2025',
        'product_name': 'Travel Backpack',
        'quantity': '1',
        'total': 45,
      },
      {
        'id': '#1458120',
        'status': 'Pending',
        'address': '350 Fifth Avenue, NYC',
        'date': '23 Aug, 2025',
        'product_name': 'Wireless Headphones',
        'quantity': '2',
        'total': 178,
      },
      
      // To Ship Orders
      {
        'id': '#1468229',
        'status': 'To Ship',
        'address': '20 Cooper Square, New York',
        'date': '25 Aug, 2025',
        'product_name': 'Luggage Tag',
        'quantity': '3',
        'total': 9,
      },
      {
        'id': '#1468230',
        'status': 'To Ship',
        'address': '42 Broadway Street, NY',
        'date': '23 Aug, 2025',
        'product_name': 'Phone Case',
        'quantity': '2',
        'total': 25,
      },
      {
        'id': '#1468231',
        'status': 'To Ship',
        'address': '88 Central Park West, NY',
        'date': '22 Aug, 2025',
        'product_name': 'Wireless Headphones',
        'quantity': '1',
        'total': 89,
      },
      {
        'id': '#1468232',
        'status': 'To Ship',
        'address': '125 Park Avenue, NYC',
        'date': '21 Aug, 2025',
        'product_name': 'Laptop Stand',
        'quantity': '1',
        'total': 35,
      },
      {
        'id': '#1468233',
        'status': 'To Ship',
        'address': '555 Madison Avenue, NY',
        'date': '20 Aug, 2025',
        'product_name': 'Travel Backpack',
        'quantity': '1',
        'total': 65,
      },
      
      // Completed Orders
      {
        'id': '#2365897',
        'status': 'Completed',
        'address': '20 Cooper Square, New York',
        'date': '18 Aug, 2025',
        'product_name': 'Luggage Tag',
        'quantity': '3',
        'total': 9,
      },
      {
        'id': '#2365898',
        'status': 'Completed',
        'address': '120 Wall Street, NYC',
        'date': '17 Aug, 2025',
        'product_name': 'Laptop Stand',
        'quantity': '1',
        'total': 35,
      },
      {
        'id': '#2365899',
        'status': 'Completed',
        'address': '75 Park Avenue, NY',
        'date': '16 Aug, 2025',
        'product_name': 'Coffee Mug Set',
        'quantity': '4',
        'total': 28,
      },
      {
        'id': '#2365900',
        'status': 'Completed',
        'address': '200 5th Avenue, NYC',
        'date': '15 Aug, 2025',
        'product_name': 'Desk Organizer',
        'quantity': '1',
        'total': 22,
      },
      {
        'id': '#2365901',
        'status': 'Completed',
        'address': '1 World Trade Center, NY',
        'date': '14 Aug, 2025',
        'product_name': 'Phone Case',
        'quantity': '3',
        'total': 45,
      },
      {
        'id': '#2365902',
        'status': 'Completed',
        'address': '30 Rockefeller Plaza, NYC',
        'date': '12 Aug, 2025',
        'product_name': 'Wireless Headphones',
        'quantity': '1',
        'total': 129,
      },
      {
        'id': '#2365903',
        'status': 'Completed',
        'address': '432 Park Avenue, NY',
        'date': '10 Aug, 2025',
        'product_name': 'Travel Backpack',
        'quantity': '2',
        'total': 130,
      },
    ];
  }

  void refreshOrders() {
    // Simulate refreshing orders (you can add loading state here)
    loadOrders();
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