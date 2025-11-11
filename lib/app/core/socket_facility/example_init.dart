// Example: How to initialize socket after user login

import 'package:elecktro_ecommerce/app/core/socket_facility/socket_manager.dart';
import 'package:get_storage/get_storage.dart';

/// Initialize socket connection after successful login
Future<void> initializeSocketAfterLogin() async {
  final storage = GetStorage();
  
  // Get user data from storage
  final userId = storage.read('userId') ?? storage.read('user_id');
  final authToken = storage.read('token') ?? storage.read('auth_token');
  
  if (userId != null && authToken != null) {
    await SocketManager().initialize(
      userId: userId.toString(),
      extraHeaders: {
        'Authorization': 'Bearer $authToken',
      },
      enableNotifications: true,
    );
    
    print('Socket initialized for user: $userId');
  }
}

/// Disconnect socket on logout
void disconnectSocketOnLogout() {
  SocketManager().disconnect();
  print('Socket disconnected');
}

/// Example: Listen to connection status
void listenToConnectionStatus() {
  SocketManager().connectionStream.listen((isConnected) {
    if (isConnected) {
      print('✅ Socket connected - Real-time notifications active');
    } else {
      print('❌ Socket disconnected');
    }
  });
}

/// Example: Handle notification taps
void handleNotificationTaps() {
  SocketManager().notificationTapStream.listen((payload) {
    print('Notification tapped with payload: $payload');
    
    // Navigate based on payload
    if (payload.startsWith('order:')) {
      final orderId = payload.split(':')[1];
      // Navigate to order details
      // Get.toNamed('/order-details', arguments: {'orderId': orderId});
    } else if (payload.startsWith('chat:')) {
      final chatId = payload.split(':')[1];
      // Navigate to chat
      // Get.toNamed('/chat', arguments: {'chatId': chatId});
    } else if (payload.startsWith('product:')) {
      final productId = payload.split(':')[1];
      // Navigate to product details
      // Get.toNamed('/product-details', arguments: {'productId': productId});
    }
  });
}
