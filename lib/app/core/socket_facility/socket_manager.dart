import 'dart:async';
import 'package:flutter/foundation.dart';
import 'socket_service.dart';
import 'notification_handler.dart';
import 'notification_overlay.dart';

/// Manager to coordinate socket service and notification handling
class SocketManager {
  static final SocketManager _instance = SocketManager._internal();
  factory SocketManager() => _instance;
  SocketManager._internal();

  final SocketService _socketService = SocketService();
  final NotificationHandler _notificationHandler = NotificationHandler();
  final NotificationOverlay _notificationOverlay = NotificationOverlay();

  StreamSubscription? _notificationSubscription;
  StreamSubscription? _orderUpdateSubscription;
  StreamSubscription? _chatMessageSubscription;
  StreamSubscription? _connectionSubscription;

  bool _isInitialized = false;

  /// Initialize socket manager
  Future<void> initialize({
    required String userId,
    Map<String, dynamic>? extraHeaders,
    bool enableNotifications = true,
  }) async {
    if (_isInitialized) {
      debugPrint('SocketManager already initialized');
      return;
    }

    // Initialize notification handler
    if (enableNotifications) {
      await _notificationHandler.initialize();
    }

    // Connect to socket
    _socketService.connect(
      userId: userId,
      extraHeaders: extraHeaders,
    );

    // Setup listeners
    _setupListeners(enableNotifications);

    _isInitialized = true;
    debugPrint('SocketManager initialized successfully');
  }

  /// Setup event listeners
  void _setupListeners(bool enableNotifications) {
    // Listen to connection status
    _connectionSubscription = _socketService.connectionStream.listen((isConnected) {
      debugPrint('Socket connection status: $isConnected');
    });

    // Listen to notifications
    _notificationSubscription = _socketService.notificationStream.listen((data) {
      _handleNotification(data, enableNotifications);
    });

    // Listen to order updates
    _orderUpdateSubscription = _socketService.orderUpdateStream.listen((data) {
      _handleOrderUpdate(data, enableNotifications);
    });

    // Listen to chat messages
    _chatMessageSubscription = _socketService.chatMessageStream.listen((data) {
      _handleChatMessage(data, enableNotifications);
    });
  }

  /// Handle general notification
  void _handleNotification(Map<String, dynamic> data, bool showNotification) {
    debugPrint('Handling notification: $data');
    
    if (showNotification) {
      final title = data['title'] ?? 'New Notification';
      final body = data['body'] ?? data['message'] ?? '';
      final id = data['id']?.hashCode ?? DateTime.now().millisecondsSinceEpoch;
      final imageUrl = data['imageUrl'] ?? data['image_url'];

      // Show in-app snackbar
      _notificationOverlay.showNotificationSnackbar(
        title: title,
        message: body,
        imageUrl: imageUrl,
        onTap: () {
          // Handle notification tap - you can navigate here
          debugPrint('Notification tapped: ${data['payload']}');
        },
      );

      // Show push notification (for background)
      _notificationHandler.showNotification(
        id: id,
        title: title,
        body: body,
        payload: data['payload'],
      );
    }
  }

  /// Handle order update
  void _handleOrderUpdate(Map<String, dynamic> data, bool showNotification) {
    debugPrint('Handling order update: $data');
    
    if (showNotification) {
      final orderId = data['orderId'] ?? data['order_id'] ?? '';
      final status = data['status'] ?? '';
      final message = data['message'] ?? 'Your order has been updated';

      // Show in-app snackbar
      _notificationOverlay.showOrderNotification(
        orderId: orderId,
        message: message,
        onTap: () {
          debugPrint('Order notification tapped: $orderId');
        },
      );

      // Show push notification (for background)
      _notificationHandler.showOrderNotification(
        orderId: orderId,
        status: status,
        message: message,
      );
    }
  }

  /// Handle chat message
  void _handleChatMessage(Map<String, dynamic> data, bool showNotification) {
    debugPrint('Handling chat message: $data');
    
    if (showNotification) {
      final chatId = data['chatId'] ?? data['chat_id'] ?? '';
      final senderName = data['senderName'] ?? data['sender_name'] ?? 'User';
      final message = data['message'] ?? '';
      final imageUrl = data['imageUrl'] ?? data['image_url'];

      // Show in-app snackbar
      _notificationOverlay.showChatNotification(
        senderName: senderName,
        message: message,
        imageUrl: imageUrl,
        onTap: () {
          debugPrint('Chat notification tapped: $chatId');
        },
      );

      // Show push notification (for background)
      _notificationHandler.showChatNotification(
        chatId: chatId,
        senderName: senderName,
        message: message,
      );
    }
  }

  /// Emit event to server
  void emit(String event, Map<String, dynamic> data) {
    _socketService.emit(event, data);
  }

  /// Listen to custom events
  void on(String event, Function(dynamic) callback) {
    _socketService.on(event, callback);
  }

  /// Remove listener for custom events
  void off(String event) {
    _socketService.off(event);
  }

  /// Get connection status
  bool get isConnected => _socketService.isConnected;

  /// Get connection stream
  Stream<bool> get connectionStream => _socketService.connectionStream;

  /// Get notification tap stream
  Stream<String> get notificationTapStream => _notificationHandler.notificationTapStream;

  /// Disconnect socket
  void disconnect() {
    _socketService.disconnect();
    _cancelSubscriptions();
    _isInitialized = false;
    debugPrint('SocketManager disconnected');
  }

  /// Cancel all subscriptions
  void _cancelSubscriptions() {
    _notificationSubscription?.cancel();
    _orderUpdateSubscription?.cancel();
    _chatMessageSubscription?.cancel();
    _connectionSubscription?.cancel();
  }

  /// Dispose all resources
  void dispose() {
    disconnect();
    _socketService.dispose();
    _notificationHandler.dispose();
  }
}
