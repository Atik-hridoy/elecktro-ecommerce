import 'package:flutter/material.dart';
import 'package:elecktro_ecommerce/app/core/socket_facility/socket_service.dart';
import 'package:get_storage/get_storage.dart';

/// Simple socket test without notification dependencies
/// Run with: flutter run test/simple_socket_test.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(SimpleSocketTestApp());
}

class SimpleSocketTestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Socket Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: SimpleSocketTestScreen(),
    );
  }
}

class SimpleSocketTestScreen extends StatefulWidget {
  @override
  State<SimpleSocketTestScreen> createState() => _SimpleSocketTestScreenState();
}

class _SimpleSocketTestScreenState extends State<SimpleSocketTestScreen> {
  final SocketService _socketService = SocketService();
  
  bool _isConnected = false;
  int _notificationCount = 0;
  int _orderCount = 0;
  int _chatCount = 0;
  final List<String> _events = [];
  
  final TextEditingController _userIdController = TextEditingController();
  String _currentToken = 'test_token';

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
      _currentToken = token?.toString() ?? 'test_token';
    });
    
    if (userId != null) {
      _addEvent('✅ Loaded User ID: $userId');
    } else {
      _addEvent('⚠️  No User ID in storage');
    }
    
    if (token != null) {
      _addEvent('✅ Loaded Auth Token');
    } else {
      _addEvent('⚠️  No Auth Token in storage');
    }
  }

  void _setupListeners() {
    // Connection status
    _socketService.connectionStream.listen((isConnected) {
      if (mounted) {
        setState(() {
          _isConnected = isConnected;
          _addEvent('🔌 ${isConnected ? "CONNECTED" : "DISCONNECTED"}');
        });
      }
    });

    // Notifications
    _socketService.notificationStream.listen((data) {
      if (mounted) {
        setState(() {
          _notificationCount++;
          _addEvent('📬 NOTIFICATION: ${data.toString()}');
        });
      }
    });

    // Order updates
    _socketService.orderUpdateStream.listen((data) {
      if (mounted) {
        setState(() {
          _orderCount++;
          _addEvent('📦 ORDER: ${data.toString()}');
        });
      }
    });

    // Chat messages
    _socketService.chatMessageStream.listen((data) {
      if (mounted) {
        setState(() {
          _chatCount++;
          _addEvent('💬 CHAT: ${data.toString()}');
        });
      }
    });
  }

  void _addEvent(String event) {
    setState(() {
      _events.insert(0, '[${DateTime.now().toString().substring(11, 19)}] $event');
      if (_events.length > 100) _events.removeLast();
    });
  }

  void _connect() {
    _addEvent('🔄 Connecting...');
    _socketService.connect(
      userId: _userIdController.text,
      extraHeaders: {'Authorization': 'Bearer $_currentToken'},
    );
  }

  void _disconnect() {
    _addEvent('🔌 Disconnecting...');
    _socketService.disconnect();
  }

  void _sendTest() {
    _addEvent('📤 Sending test event...');
    _socketService.emit('test_event', {
      'userId': _userIdController.text,
      'message': 'Test from app',
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  @override
  void dispose() {
    _socketService.disconnect();
    _userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Socket Test'),
        backgroundColor: _isConnected ? Colors.green : Colors.red,
      ),
      body: Column(
        children: [
          // Status Banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: _isConnected ? Colors.green.shade100 : Colors.red.shade100,
            child: Column(
              children: [
                Icon(
                  _isConnected ? Icons.check_circle : Icons.cancel,
                  size: 48,
                  color: _isConnected ? Colors.green : Colors.red,
                ),
                SizedBox(height: 8),
                Text(
                  _isConnected ? 'CONNECTED ✅' : 'DISCONNECTED ❌',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _isConnected ? Colors.green : Colors.red,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCounter('📬', _notificationCount, Colors.blue),
                    _buildCounter('📦', _orderCount, Colors.orange),
                    _buildCounter('💬', _chatCount, Colors.purple),
                  ],
                ),
              ],
            ),
          ),

          // Controls
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
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isConnected ? null : _connect,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.all(16),
                        ),
                        child: Text('CONNECT', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isConnected ? _disconnect : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.all(16),
                        ),
                        child: Text('DISCONNECT', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isConnected ? _sendTest : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.all(16),
                    ),
                    child: Text('SEND TEST EVENT', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),

          // Events Log
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                color: Colors.black,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.terminal, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'LIVE EVENT LOG (${_events.length})',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.clear, color: Colors.white, size: 20),
                          onPressed: () => setState(() => _events.clear()),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _events.isEmpty
                        ? Center(
                            child: Text(
                              'No events yet. Click CONNECT to start.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.all(12),
                            itemCount: _events.length,
                            itemBuilder: (context, index) {
                              final event = _events[index];
                              Color color = Colors.white;
                              if (event.contains('📬') || event.contains('📦') || event.contains('💬')) {
                                color = Colors.greenAccent;
                              } else if (event.contains('❌')) {
                                color = Colors.redAccent;
                              } else if (event.contains('✅')) {
                                color = Colors.greenAccent;
                              }
                              
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 2),
                                child: Text(
                                  event,
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 13,
                                    color: color,
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

  Widget _buildCounter(String emoji, int count, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        children: [
          Text(emoji, style: TextStyle(fontSize: 24)),
          SizedBox(height: 4),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
