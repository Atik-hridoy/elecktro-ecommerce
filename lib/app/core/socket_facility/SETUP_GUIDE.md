# Socket Notification Setup Guide

## Step 1: Update Your Main App (main.dart)

Add the `scaffoldMessengerKey` to your MaterialApp:

```dart
import 'package:flutter/material.dart';
import 'app/core/socket_facility/notification_overlay.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elecktro',
      
      // Add this line - IMPORTANT for snackbars to work globally
      scaffoldMessengerKey: NotificationOverlay().scaffoldMessengerKey,
      
      home: YourHomePage(),
      // ... rest of your app config
    );
  }
}
```

## Step 2: Initialize Socket After Login

In your login success handler or app initialization:

```dart
import 'package:your_app/app/core/socket_facility/socket_manager.dart';

// After successful login
Future<void> initializeSocket(String userId, String authToken) async {
  await SocketManager().initialize(
    userId: userId,
    extraHeaders: {
      'Authorization': 'Bearer $authToken',
    },
    enableNotifications: true,
  );
}
```

## Step 3: Listen to Connection Status (Optional)

```dart
SocketManager().connectionStream.listen((isConnected) {
  if (isConnected) {
    print('Socket connected - notifications active');
  } else {
    print('Socket disconnected');
  }
});
```

## Step 4: Handle Notification Taps (Optional)

Listen to notification taps to navigate to specific screens:

```dart
SocketManager().notificationTapStream.listen((payload) {
  // payload format: "type:id" (e.g., "order:123", "chat:456")
  if (payload.startsWith('order:')) {
    final orderId = payload.split(':')[1];
    // Navigate to order details
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsPage(orderId: orderId),
      ),
    );
  } else if (payload.startsWith('chat:')) {
    final chatId = payload.split(':')[1];
    // Navigate to chat
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(chatId: chatId),
      ),
    );
  }
});
```

## Step 5: Disconnect on Logout

```dart
void logout() {
  SocketManager().disconnect();
  // ... rest of your logout logic
}
```

## How It Works

### When App is OPEN (Foreground):
- **Snackbar** appears at the bottom of the screen
- Shows notification title, message, and optional image
- Tappable to navigate to relevant screen
- Works on ANY screen in your app

### When App is CLOSED/BACKGROUND:
- **Push notification** appears in system tray
- User can tap to open the app
- Notification tap is handled by `notificationTapStream`

## Server-Side Event Format

Your backend should emit events in this format:

```javascript
// Event name: notification::userId
socket.to(userId).emit('notification::' + userId, {
  id: 'notif_123',
  title: 'Order Shipped',
  message: 'Your order #456 has been shipped',
  imageUrl: 'https://example.com/image.jpg', // optional
  payload: 'order:456', // for navigation
  type: 'order' // optional
});
```

## Example Server Events

### Order Update
```javascript
socket.emit('notification::user123', {
  title: 'Order Update',
  message: 'Your order has been delivered',
  payload: 'order:456',
  orderId: '456',
  status: 'delivered'
});
```

### Chat Message
```javascript
socket.emit('notification::user123', {
  title: 'John Doe',
  message: 'Hey, is this product available?',
  payload: 'chat:789',
  chatId: '789',
  senderName: 'John Doe',
  imageUrl: 'https://example.com/avatar.jpg'
});
```

### Product Update
```javascript
socket.emit('notification::user123', {
  title: 'Price Drop Alert',
  message: 'iPhone 15 is now 20% off!',
  payload: 'product:101',
  imageUrl: 'https://example.com/iphone.jpg'
});
```

## Customization

### Change Snackbar Duration
Edit `notification_overlay.dart`:
```dart
duration: const Duration(seconds: 4), // Change to your preference
```

### Customize Snackbar Appearance
Edit the `showNotificationSnackbar` method in `notification_overlay.dart` to change colors, fonts, etc.

### Add Custom Navigation Logic
Edit the `onTap` callbacks in `socket_manager.dart` handlers to add your navigation logic.

## Troubleshooting

### Snackbars not showing?
- Ensure `scaffoldMessengerKey` is added to MaterialApp
- Check if notifications are enabled in initialize()

### Push notifications not showing?
- Add required dependencies to pubspec.yaml
- Configure Android/iOS permissions (see README.md)

### Socket not connecting?
- Verify server URL in AppUrls.socketUrl
- Check network connectivity
- Ensure server is running and accessible
