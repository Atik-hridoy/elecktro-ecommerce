import 'package:flutter/foundation.dart';
import 'socket_manager.dart';
import 'package:get_storage/get_storage.dart';

/// Utility class to check and debug socket connection
class SocketChecker {
  /// Check if socket is initialized and connected
  static Future<Map<String, dynamic>> checkSocketStatus() async {
    final storage = GetStorage();
    final userId = storage.read('userId') ?? storage.read('user_id');
    final token = storage.read('token') ?? storage.read('auth_token');
    
    final status = {
      'isConnected': SocketManager().isConnected,
      'hasUserId': userId != null,
      'hasToken': token != null,
      'userId': userId?.toString() ?? 'NOT_FOUND',
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('🔍 SOCKET STATUS CHECK');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('📡 Socket Connected: ${status['isConnected']}');
    debugPrint('👤 User ID Found: ${status['hasUserId']} (${status['userId']})');
    debugPrint('🔑 Auth Token Found: ${status['hasToken']}');
    debugPrint('⏰ Timestamp: ${status['timestamp']}');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    
    if ((status['isConnected'] as bool? ?? false) == false) {
      debugPrint('⚠️  WARNING: Socket is NOT connected!');
      debugPrint('💡 Solution: Call SocketManager().initialize() after login');
    }
    
    if ((status['hasUserId'] as bool? ?? false) == false) {
      debugPrint('⚠️  WARNING: User ID not found in storage!');
      debugPrint('💡 Solution: Ensure userId is saved after login');
    }
    
    if ((status['hasToken'] as bool? ?? false) == false) {
      debugPrint('⚠️  WARNING: Auth token not found in storage!');
      debugPrint('💡 Solution: Ensure token is saved after login');
    }
    
    return status;
  }
  
  /// Initialize socket with current user data
  static Future<bool> initializeSocket() async {
    final storage = GetStorage();
    final userId = storage.read('userId') ?? storage.read('user_id');
    final token = storage.read('token') ?? storage.read('auth_token');
    
    if (userId == null) {
      debugPrint('❌ Cannot initialize socket: User ID not found');
      return false;
    }
    
    try {
      await SocketManager().initialize(
        userId: userId.toString(),
        extraHeaders: token != null ? {
          'Authorization': 'Bearer $token',
        } : null,
        enableNotifications: true,
      );
      
      debugPrint('✅ Socket initialized successfully for user: $userId');
      
      // Wait a bit and check connection
      await Future.delayed(Duration(seconds: 2));
      final isConnected = SocketManager().isConnected;
      
      if (isConnected) {
        debugPrint('✅ Socket connection confirmed!');
      } else {
        debugPrint('⚠️  Socket initialized but not connected yet. Check server.');
      }
      
      return isConnected;
    } catch (e) {
      debugPrint('❌ Error initializing socket: $e');
      return false;
    }
  }
  
  /// Test notification manually
  static void sendTestNotification() {
    debugPrint('🧪 Sending test notification event...');
    
    SocketManager().emit('test_notification', {
      'userId': GetStorage().read('userId')?.toString() ?? 'unknown',
      'message': 'Test from app',
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    debugPrint('📤 Test event emitted. Check server logs.');
  }
  
  /// Listen to all socket events for debugging
  static void enableDebugMode() {
    debugPrint('🐛 Socket Debug Mode Enabled');
    
    SocketManager().connectionStream.listen((isConnected) {
      debugPrint('📡 Socket Connection Status Changed: $isConnected');
    });
    
    SocketManager().notificationTapStream.listen((payload) {
      debugPrint('👆 Notification Tapped: $payload');
    });
  }
}
