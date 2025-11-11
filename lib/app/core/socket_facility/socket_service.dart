import 'dart:async';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart';
import '../network/app_urls.dart';

/// Service to manage WebSocket connections for real-time notifications
class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;
  bool _isConnected = false;
  String? _userId;
  
  // Stream controllers for different notification types
  final _notificationController = StreamController<Map<String, dynamic>>.broadcast();
  final _orderUpdateController = StreamController<Map<String, dynamic>>.broadcast();
  final _chatMessageController = StreamController<Map<String, dynamic>>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  // Getters for streams
  Stream<Map<String, dynamic>> get notificationStream => _notificationController.stream;
  Stream<Map<String, dynamic>> get orderUpdateStream => _orderUpdateController.stream;
  Stream<Map<String, dynamic>> get chatMessageStream => _chatMessageController.stream;
  Stream<bool> get connectionStream => _connectionController.stream;

  bool get isConnected => _isConnected;

  /// Initialize socket connection
  void connect({
    required String userId,
    Map<String, dynamic>? extraHeaders,
  }) {
    if (_isConnected && _userId == userId) {
      debugPrint('Socket already connected for user: $userId');
      return;
    }

    _userId = userId;

    try {
      _socket = IO.io(
        AppUrls.socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableReconnection()
            .setReconnectionAttempts(5)
            .setReconnectionDelay(2000)
            .setExtraHeaders(extraHeaders ?? {})
            .build(),
      );

      _setupSocketListeners();
      debugPrint('Socket connection initiated to ${AppUrls.socketUrl} for user: $userId');
    } catch (e) {
      debugPrint('Error connecting to socket: $e');
      _isConnected = false;
      _connectionController.add(false);
    }
  }

  /// Setup socket event listeners
  void _setupSocketListeners() {
    _socket?.onConnect((_) {
      _isConnected = true;
      _connectionController.add(true);
      debugPrint('Socket connected successfully');
      
      // Join user-specific room
      if (_userId != null) {
        _socket?.emit('join', {'userId': _userId});
      }
    });

    _socket?.onDisconnect((_) {
      _isConnected = false;
      _connectionController.add(false);
      debugPrint('Socket disconnected');
    });

    _socket?.onConnectError((error) {
      _isConnected = false;
      _connectionController.add(false);
      debugPrint('Socket connection error: $error');
    });

    _socket?.onError((error) {
      debugPrint('Socket error: $error');
    });

    // Listen to notification events with format: notification::userId
    if (_userId != null) {
      _socket?.on('notification::$_userId', (data) {
        debugPrint('Received notification for user $_userId: $data');
        _notificationController.add(_parseData(data));
      });
    }

    _socket?.on('order_update', (data) {
      debugPrint('Received order update: $data');
      _orderUpdateController.add(_parseData(data));
    });

    _socket?.on('chat_message', (data) {
      debugPrint('Received chat message: $data');
      _chatMessageController.add(_parseData(data));
    });

    _socket?.onReconnect((_) {
      debugPrint('Socket reconnected');
      if (_userId != null) {
        _socket?.emit('join', {'userId': _userId});
      }
    });
  }

  /// Parse incoming data
  Map<String, dynamic> _parseData(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    } else if (data is String) {
      try {
        return jsonDecode(data);
      } catch (e) {
        return {'raw': data};
      }
    }
    return {'data': data};
  }

  /// Emit event to server
  void emit(String event, Map<String, dynamic> data) {
    if (_isConnected) {
      _socket?.emit(event, data);
      debugPrint('Emitted event: $event with data: $data');
    } else {
      debugPrint('Cannot emit event. Socket not connected.');
    }
  }

  /// Listen to custom events
  void on(String event, Function(dynamic) callback) {
    _socket?.on(event, callback);
  }

  /// Remove listener for custom events
  void off(String event) {
    _socket?.off(event);
  }

  /// Disconnect socket
  void disconnect() {
    if (_socket != null) {
      _socket?.disconnect();
      _socket?.dispose();
      _socket = null;
      _isConnected = false;
      _userId = null;
      _connectionController.add(false);
      debugPrint('Socket disconnected and disposed');
    }
  }

  /// Dispose all resources
  void dispose() {
    disconnect();
    _notificationController.close();
    _orderUpdateController.close();
    _chatMessageController.close();
    _connectionController.close();
  }
}
