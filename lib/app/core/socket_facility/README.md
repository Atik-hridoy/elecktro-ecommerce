# Socket Facility for Instant Notifications

This module provides real-time notification capabilities using WebSocket connections for the Elecktro E-commerce application.

## Features

- **Real-time WebSocket connection** using socket.io
- **Automatic reconnection** with configurable attempts
- **Multiple notification types**: orders, chat, products, payments, etc.
- **Local push notifications** integration
- **Event-driven architecture** with stream-based communication
- **Type-safe event constants**
- **Notification models** for structured data

## Structure

```
socket_facility/
├── socket_service.dart          # Core WebSocket service
├── socket_manager.dart          # High-level manager coordinating socket & notifications
├── socket_events.dart           # Event name constants
├── notification_handler.dart    # Local notification handling
├── models/
│   └── notification_model.dart  # Notification data model
└── README.md                    # This file
```

## Dependencies

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  socket_io_client: ^2.0.3+1
  flutter_local_notifications: ^16.3.0
```

## Usage

### 1. Initialize Socket Manager

```dart
import 'package:your_app/app/core/socket_facility/socket_manager.dart';

// In your app initialization (e.g., main.dart or splash screen)
await SocketManager().initialize(
  serverUrl: 'https://your-server.com',
  userId: 'user123',
  extraHeaders: {
    'Authorization': 'Bearer your_token',
  },
  enableNotifications: true,
);
```

### 2. Listen to Connection Status

```dart
SocketManager().connectionStream.listen((isConnected) {
  if (isConnected) {
    print('Connected to server');
  } else {
    print('Disconnected from server');
  }
});
```

### 3. Listen to Notification Taps

```dart
SocketManager().notificationTapStream.listen((payload) {
  // Handle notification tap
  if (payload.startsWith('order:')) {
    final orderId = payload.split(':')[1];
    // Navigate to order details
  } else if (payload.startsWith('chat:')) {
    final chatId = payload.split(':')[1];
    // Navigate to chat
  }
});
```

### 4. Emit Custom Events

```dart
SocketManager().emit('custom_event', {
  'userId': 'user123',
  'data': 'some data',
});
```

### 5. Listen to Custom Events

```dart
SocketManager().on('custom_event', (data) {
  print('Received custom event: $data');
});
```

### 6. Disconnect

```dart
// When user logs out or app is closing
SocketManager().disconnect();
```

## Event Types

The following events are predefined in `SocketEvents`:

### Connection Events
- `connect`, `disconnect`, `connect_error`, `reconnect`

### Notification Events
- `notification`, `notification_read`, `notification_received`

### Order Events
- `order_update`, `order_placed`, `order_confirmed`, `order_shipped`, `order_delivered`, `order_cancelled`

### Chat Events
- `chat_message`, `chat_message_sent`, `chat_message_received`, `chat_typing`, `chat_stop_typing`

### Product Events
- `product_update`, `product_stock_update`, `product_price_update`

### Payment Events
- `payment_success`, `payment_failed`, `payment_pending`

### Admin Events
- `admin_broadcast`, `system_maintenance`, `flash_sale_start`, `flash_sale_end`

## Notification Model

```dart
final notification = NotificationModel(
  id: '123',
  title: 'Order Shipped',
  body: 'Your order #456 has been shipped',
  type: NotificationType.order,
  timestamp: DateTime.now(),
  payload: 'order:456',
);
```

## Server-Side Requirements

Your backend server should:

1. Support socket.io connections
2. Implement user-specific rooms (using userId)
3. Emit events with the following structure:

```javascript
// Example: Emit order update
socket.to(userId).emit('order_update', {
  orderId: '456',
  status: 'shipped',
  message: 'Your order has been shipped',
  timestamp: new Date().toISOString()
});
```

## Android Configuration

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
```

## iOS Configuration

Add to `ios/Runner/Info.plist`:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

## Best Practices

1. **Initialize once**: Call `SocketManager().initialize()` only once during app startup
2. **Handle reconnection**: The service automatically handles reconnection
3. **Clean up**: Always call `disconnect()` when user logs out
4. **Error handling**: Listen to connection stream to handle connection issues
5. **Payload structure**: Use consistent payload format for navigation (e.g., `type:id`)

## Troubleshooting

### Connection Issues
- Verify server URL is correct
- Check if server supports WebSocket protocol
- Ensure proper CORS configuration on server

### Notifications Not Showing
- Request notification permissions on app startup
- Check if notifications are enabled in device settings
- Verify notification channel is properly configured

### Events Not Received
- Ensure user has joined the correct room on server
- Check if event names match between client and server
- Verify socket is connected before emitting events
