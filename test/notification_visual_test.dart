import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elecktro_ecommerce/app/core/socket_facility/socket_manager.dart';
import 'package:elecktro_ecommerce/app/core/socket_facility/socket_service.dart';
import 'package:get_storage/get_storage.dart';

/// Visual test to verify notification events are working
/// Run this with: flutter run test/notification_visual_test.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(NotificationTestApp());
}

class NotificationTestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Socket Notification Tester',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: NotificationTestScreen(),
    );
  }
}

class NotificationTestScreen extends StatefulWidget {
  @override
  State<NotificationTestScreen> createState() => _NotificationTestScreenState();
}

class _NotificationTestScreenState extends State<NotificationTestScreen> {
  final SocketManager _socketManager = SocketManager();
  final SocketService _socketService = SocketService();
  
  bool _isConnected = false;
  final List<String> _logs = [];
  final List<Map<String, dynamic>> _receivedNotifications = [];
  final List<Map<String, dynamic>> _receivedOrders = [];
  final List<Map<String, dynamic>> _receivedChats = [];
  
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStoredCredentials();
    _setupListeners();
  }

  /// Load actual userId and token from GetStorage
  void _loadStoredCredentials() {
    final storage = GetStorage();
    final userId = storage.read('userId') ?? storage.read('user_id');
    final token = storage.read('token') ?? storage.read('auth_token');
    
    setState(() {
      _userIdController.text = userId?.toString() ?? 'test_user_123';
      _tokenController.text = token?.toString() ?? 'test_token';
    });
    
    if (userId != null) {
      _addLog('✅ Loaded User ID from storage: $userId');
    } else {
      _addLog('⚠️  No User ID found in storage, using default');
    }
    
    if (token != null) {
      _addLog('✅ Loaded Auth Token from storage');
    } else {
      _addLog('⚠️  No Auth Token found in storage, using default');
    }
  }

  void _setupListeners() {
    // Listen to connection status
    _socketService.connectionStream.listen((isConnected) {
      setState(() {
        _isConnected = isConnected;
        _addLog('🔌 Connection status: ${isConnected ? "CONNECTED" : "DISCONNECTED"}');
      });
    });

    // Listen to notifications
    _socketService.notificationStream.listen((data) {
      setState(() {
        _receivedNotifications.add({
          ...data,
          'timestamp': DateTime.now().toString(),
        });
        _addLog('📬 Notification received: ${data.toString()}');
      });
    });

    // Listen to order updates
    _socketService.orderUpdateStream.listen((data) {
      setState(() {
        _receivedOrders.add({
          ...data,
          'timestamp': DateTime.now().toString(),
        });
        _addLog('📦 Order update received: ${data.toString()}');
      });
    });

    // Listen to chat messages
    _socketService.chatMessageStream.listen((data) {
      setState(() {
        _receivedChats.add({
          ...data,
          'timestamp': DateTime.now().toString(),
        });
        _addLog('💬 Chat message received: ${data.toString()}');
      });
    });
  }

  void _addLog(String message) {
    setState(() {
      _logs.insert(0, '[${DateTime.now().toString().substring(11, 19)}] $message');
      if (_logs.length > 50) _logs.removeLast();
    });
  }

  Future<void> _connectSocket() async {
    _addLog('🔄 Attempting to connect...');
    try {
      await _socketManager.initialize(
        userId: _userIdController.text,
        extraHeaders: {
          'Authorization': 'Bearer ${_tokenController.text}',
        },
        enableNotifications: false, // Disable system notifications for testing
      );
      _addLog('✅ Socket initialization completed');
    } catch (e) {
      _addLog('❌ Error: $e');
    }
  }

  void _disconnectSocket() {
    _addLog('🔌 Disconnecting...');
    _socketManager.disconnect();
    setState(() {
      _isConnected = false;
    });
  }

  void _sendTestNotification() {
    _addLog('📤 Sending test notification event...');
    _socketManager.emit('test_notification', {
      'userId': _userIdController.text,
      'message': 'Test notification from app',
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  void _sendTestOrder() {
    _addLog('📤 Sending test order event...');
    _socketManager.emit('test_order', {
      'userId': _userIdController.text,
      'orderId': 'ORDER_${DateTime.now().millisecondsSinceEpoch}',
      'status': 'processing',
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  void _sendTestChat() {
    _addLog('📤 Sending test chat event...');
    _socketManager.emit('test_chat', {
      'userId': _userIdController.text,
      'message': 'Hello from test!',
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  void _clearLogs() {
    setState(() {
      _logs.clear();
      _receivedNotifications.clear();
      _receivedOrders.clear();
      _receivedChats.clear();
    });
  }

  @override
  void dispose() {
    _socketManager.disconnect();
    _userIdController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Socket Notification Tester'),
        backgroundColor: _isConnected ? Colors.green : Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: _clearLogs,
            tooltip: 'Clear logs',
          ),
        ],
      ),
      body: Column(
        children: [
          // Connection Status Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: _isConnected ? Colors.green.shade50 : Colors.red.shade50,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isConnected ? Icons.check_circle : Icons.cancel,
                      color: _isConnected ? Colors.green : Colors.red,
                      size: 32,
                    ),
                    SizedBox(width: 8),
                    Text(
                      _isConnected ? 'CONNECTED' : 'DISCONNECTED',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _isConnected ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Notifications: ${_receivedNotifications.length} | '
                  'Orders: ${_receivedOrders.length} | '
                  'Chats: ${_receivedChats.length}',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),

          // Connection Controls
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _userIdController,
                  decoration: InputDecoration(
                    labelText: 'User ID',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _tokenController,
                  decoration: InputDecoration(
                    labelText: 'Auth Token',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.key),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isConnected ? null : _connectSocket,
                        icon: Icon(Icons.power),
                        label: Text('Connect'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isConnected ? _disconnectSocket : null,
                        icon: Icon(Icons.power_off),
                        label: Text('Disconnect'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Test Event Buttons
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Send Test Events:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isConnected ? _sendTestNotification : null,
                        icon: Icon(Icons.notifications),
                        label: Text('Notification'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isConnected ? _sendTestOrder : null,
                        icon: Icon(Icons.shopping_bag),
                        label: Text('Order'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isConnected ? _sendTestChat : null,
                        icon: Icon(Icons.chat),
                        label: Text('Chat'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Logs Section
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.terminal, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Event Logs (${_logs.length})',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _logs.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.info_outline, size: 48, color: Colors.grey),
                                SizedBox(height: 8),
                                Text(
                                  'No events yet. Connect and send test events.',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.all(8),
                            itemCount: _logs.length,
                            itemBuilder: (context, index) {
                              final log = _logs[index];
                              Color logColor = Colors.black;
                              if (log.contains('❌')) logColor = Colors.red;
                              if (log.contains('✅')) logColor = Colors.green;
                              if (log.contains('📬') || log.contains('📦') || log.contains('💬')) {
                                logColor = Colors.blue;
                              }
                              
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 2),
                                child: Text(
                                  log,
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 12,
                                    color: logColor,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
