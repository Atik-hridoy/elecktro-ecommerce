import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'socket_manager.dart';

/// Initialize socket connection with stored credentials
class SocketInitializer {
  static bool _isInitialized = false;

  /// Initialize socket after user login
  static Future<void> initializeAfterLogin({
    required String userId,
    required String token,
  }) async {
    try {
      debugPrint('🚀 Initializing socket for user: $userId');
      
      await SocketManager().initialize(
        userId: userId,
        extraHeaders: {
          'Authorization': 'Bearer $token',
        },
        enableNotifications: true, // IMPORTANT: Enable notifications!
      );
      
      _isInitialized = true;
      debugPrint('✅ Socket initialized successfully with notifications enabled');
    } catch (e) {
      debugPrint('❌ Error initializing socket: $e');
    }
  }

  /// Initialize socket from stored credentials (on app start)
  static Future<void> initializeFromStorage() async {
    if (_isInitialized) {
      debugPrint('⚠️  Socket already initialized');
      return;
    }

    try {
      final storage = GetStorage();
      final userId = storage.read('userId') ?? storage.read('user_id');
      final token = storage.read('token') ?? storage.read('auth_token');

      if (userId == null || token == null) {
        debugPrint('⚠️  No stored credentials found. Socket not initialized.');
        return;
      }

      debugPrint('🚀 Initializing socket from storage for user: $userId');
      
      await SocketManager().initialize(
        userId: userId.toString(),
        extraHeaders: {
          'Authorization': 'Bearer $token',
        },
        enableNotifications: true, // IMPORTANT: Enable notifications!
      );
      
      _isInitialized = true;
      debugPrint('✅ Socket initialized from storage with notifications enabled');
    } catch (e) {
      debugPrint('❌ Error initializing socket from storage: $e');
    }
  }

  /// Disconnect socket (call on logout)
  static void disconnect() {
    debugPrint('🔌 Disconnecting socket...');
    SocketManager().disconnect();
    _isInitialized = false;
    debugPrint('✅ Socket disconnected');
  }

  /// Check if socket is initialized
  static bool get isInitialized => _isInitialized;
}
