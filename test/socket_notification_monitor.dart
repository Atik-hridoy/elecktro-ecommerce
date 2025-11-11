import 'package:flutter/material.dart';
import 'package:elecktro_ecommerce/app/core/socket_facility/socket_service.dart';
import 'package:elecktro_ecommerce/app/core/socket_facility/socket_checker.dart';

/// Floating debug monitor to track socket notifications in real-time
/// Add this to your app to see notifications as they arrive
class SocketNotificationMonitor extends StatefulWidget {
  const SocketNotificationMonitor({Key? key}) : super(key: key);

  @override
  State<SocketNotificationMonitor> createState() => _SocketNotificationMonitorState();
}

class _SocketNotificationMonitorState extends State<SocketNotificationMonitor> {
  final List<NotificationEvent> _events = [];
  bool _isExpanded = false;
  bool _isConnected = false;
  int _notificationCount = 0;
  int _orderCount = 0;
  int _chatCount = 0;

  @override
  void initState() {
    super.initState();
    _setupListeners();
  }

  void _setupListeners() {
    final socketService = SocketService();

    // Connection status
    socketService.connectionStream.listen((isConnected) {
      if (mounted) {
        setState(() {
          _isConnected = isConnected;
          _addEvent(NotificationEvent(
            type: 'CONNECTION',
            message: isConnected ? 'Connected' : 'Disconnected',
            icon: Icons.power,
            color: isConnected ? Colors.green : Colors.red,
          ));
        });
      }
    });

    // Notifications
    socketService.notificationStream.listen((data) {
      if (mounted) {
        setState(() {
          _notificationCount++;
          _addEvent(NotificationEvent(
            type: 'NOTIFICATION',
            message: data['message'] ?? data['body'] ?? 'New notification',
            data: data,
            icon: Icons.notifications_active,
            color: Colors.blue,
          ));
        });
      }
    });

    // Order updates
    socketService.orderUpdateStream.listen((data) {
      if (mounted) {
        setState(() {
          _orderCount++;
          _addEvent(NotificationEvent(
            type: 'ORDER',
            message: data['message'] ?? 'Order updated',
            data: data,
            icon: Icons.shopping_bag,
            color: Colors.orange,
          ));
        });
      }
    });

    // Chat messages
    socketService.chatMessageStream.listen((data) {
      if (mounted) {
        setState(() {
          _chatCount++;
          _addEvent(NotificationEvent(
            type: 'CHAT',
            message: data['message'] ?? 'New message',
            data: data,
            icon: Icons.chat_bubble,
            color: Colors.purple,
          ));
        });
      }
    });
  }

  void _addEvent(NotificationEvent event) {
    setState(() {
      _events.insert(0, event);
      if (_events.length > 100) _events.removeLast();
    });
  }

  void _clearEvents() {
    setState(() {
      _events.clear();
      _notificationCount = 0;
      _orderCount = 0;
      _chatCount = 0;
    });
  }

  Future<void> _checkStatus() async {
    final status = await SocketChecker.checkSocketStatus();
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Socket Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusRow('Connected', status['isConnected'].toString()),
              _buildStatusRow('User ID', status['userId'].toString()),
              _buildStatusRow('Has Token', status['hasToken'].toString()),
              _buildStatusRow('Timestamp', status['timestamp'].toString()),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, style: TextStyle(fontSize: 12))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: _isExpanded ? 350 : 60,
          height: _isExpanded ? 500 : 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isConnected ? Colors.green : Colors.red,
              width: 2,
            ),
          ),
          child: _isExpanded ? _buildExpandedView() : _buildCollapsedView(),
        ),
      ),
    );
  }

  Widget _buildCollapsedView() {
    return InkWell(
      onTap: () => setState(() => _isExpanded = true),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: _isConnected ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(
                Icons.monitor_heart,
                color: Colors.white,
                size: 30,
              ),
            ),
            if (_events.isNotEmpty)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${_events.length}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedView() {
    return Column(
      children: [
        // Header
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _isConnected ? Colors.green : Colors.red,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.monitor_heart, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Socket Monitor',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.info_outline, color: Colors.white, size: 20),
                onPressed: _checkStatus,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
              SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.white, size: 20),
                onPressed: _clearEvents,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
              SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.close, color: Colors.white, size: 20),
                onPressed: () => setState(() => _isExpanded = false),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ],
          ),
        ),

        // Stats
        Container(
          padding: EdgeInsets.all(8),
          color: Colors.grey.shade100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatChip(Icons.notifications, _notificationCount, Colors.blue),
              _buildStatChip(Icons.shopping_bag, _orderCount, Colors.orange),
              _buildStatChip(Icons.chat, _chatCount, Colors.purple),
            ],
          ),
        ),

        // Events list
        Expanded(
          child: _events.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text(
                        'No events yet',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 4),
                      Text(
                        _isConnected ? 'Listening...' : 'Not connected',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: _events.length,
                  itemBuilder: (context, index) {
                    final event = _events[index];
                    return _buildEventCard(event);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStatChip(IconData icon, int count, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 4),
          Text(
            '$count',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(NotificationEvent event) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        dense: true,
        leading: Icon(event.icon, color: event.color, size: 20),
        title: Text(
          event.type,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: event.color,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.message,
              style: TextStyle(fontSize: 11),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              event.timestamp,
              style: TextStyle(fontSize: 9, color: Colors.grey),
            ),
          ],
        ),
        trailing: event.data != null
            ? IconButton(
                icon: Icon(Icons.code, size: 16),
                onPressed: () => _showEventData(event),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              )
            : null,
      ),
    );
  }

  void _showEventData(NotificationEvent event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Event Data'),
        content: SingleChildScrollView(
          child: Text(
            event.data.toString(),
            style: TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}

class NotificationEvent {
  final String type;
  final String message;
  final Map<String, dynamic>? data;
  final IconData icon;
  final Color color;
  final String timestamp;

  NotificationEvent({
    required this.type,
    required this.message,
    this.data,
    required this.icon,
    required this.color,
  }) : timestamp = DateTime.now().toString().substring(11, 19);
}
