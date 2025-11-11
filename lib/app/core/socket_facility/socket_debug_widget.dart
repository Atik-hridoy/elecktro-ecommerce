import 'package:flutter/material.dart';
import 'socket_manager.dart';

/// Debug widget to check socket connection status
class SocketDebugWidget extends StatelessWidget {
  const SocketDebugWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: SocketManager().connectionStream,
      initialData: SocketManager().isConnected,
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? false;
        
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isConnected ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isConnected ? Icons.wifi : Icons.wifi_off,
                color: Colors.white,
                size: 16,
              ),
              SizedBox(width: 6),
              Text(
                isConnected ? 'Socket Connected' : 'Socket Disconnected',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Floating debug button to test notifications
class SocketDebugButton extends StatelessWidget {
  const SocketDebugButton({Key? key}) : super(key: key);

  void _testNotification(BuildContext context) {
    // Simulate a test notification
    final testData = {
      'id': 'test_${DateTime.now().millisecondsSinceEpoch}',
      'title': 'Test Notification',
      'message': 'This is a test notification from socket debug',
      'payload': 'test:123',
    };
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Test notification triggered!\nCheck console for socket status.'),
        backgroundColor: Colors.blue,
      ),
    );
    
    print('🔔 Test Notification Data: $testData');
    print('📡 Socket Connected: ${SocketManager().isConnected}');
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      mini: true,
      backgroundColor: Colors.orange,
      onPressed: () => _testNotification(context),
      child: Icon(Icons.bug_report, size: 20),
      tooltip: 'Test Socket',
    );
  }
}
