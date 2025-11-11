# Socket Notification Troubleshooting Guide

## Problem: No notifications appearing after placing order

### Step 1: Check if Socket is Connected

Add this to any screen to see socket status:

```dart
import 'package:elecktro_ecommerce/app/core/socket_facility/socket_debug_widget.dart';

// In your build method, add this widget anywhere:
SocketDebugWidget()
```

### Step 2: Run Socket Status Check

Add this code to check socket status:

```dart
import 'package:elecktro_ecommerce/app/core/socket_facility/socket_checker.dart';

// Call this after login or on app start
await SocketChecker.checkSocketStatus();
```

Check the console output. You should see:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔍 SOCKET STATUS CHECK
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📡 Socket Connected: true
👤 User ID Found: true (your_user_id)
🔑 Auth Token Found: true
⏰ Timestamp: 2024-11-11T11:27:00.000Z
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Step 3: Initialize Socket After Login

**IMPORTANT:** Socket must be initialized after user logs in!

In your login controller, add:

```dart
import 'package:elecktro_ecommerce/app/core/socket_facility/socket_manager.dart';

// After successful login
Future<void> onLoginSuccess(String userId, String token) async {
  // Save to storage
  final storage = GetStorage();
  await storage.write('userId', userId);
  await storage.write('token', token);
  
  // Initialize socket - THIS IS CRITICAL!
  await SocketManager().initialize(
    userId: userId,
    extraHeaders: {
      'Authorization': 'Bearer $token',
    },
    enableNotifications: true,
  );
  
  print('✅ Socket initialized for user: $userId');
}
```

### Step 4: Verify Server is Sending Events

Your backend must emit events in this format:

```javascript
// Event name format: notification::userId
socket.emit('notification::' + userId, {
  id: 'order_123',
  title: 'Order Placed',
  message: 'Your order has been placed successfully',
  payload: 'order:123',
  orderId: '123',
  status: 'placed'
});
```

**Check server logs** to confirm events are being sent!

### Step 5: Test Socket Manually

Add this button to test:

```dart
ElevatedButton(
  onPressed: () async {
    await SocketChecker.initializeSocket();
  },
  child: Text('Initialize Socket'),
)
```

### Common Issues & Solutions

#### ❌ Socket shows "Disconnected"
**Causes:**
1. Socket was never initialized
2. Server is not running
3. Wrong server URL
4. Network issue

**Solutions:**
```dart
// 1. Initialize socket after login
await SocketManager().initialize(userId: 'your_user_id');

// 2. Check server URL
print(AppUrls.socketUrl); // Should be: http://10.10.7.62:7010

// 3. Verify server is running
// Visit http://10.10.7.62:7010 in browser
```

#### ❌ Socket connected but no notifications
**Causes:**
1. Server not emitting events with correct format
2. Wrong event name
3. Wrong userId

**Solutions:**
```dart
// Check what userId is being used
final storage = GetStorage();
print('User ID: ${storage.read('userId')}');

// Server must emit to: notification::userId
// Example: notification::user123
```

#### ❌ Notifications work in background but not in-app
**Cause:** `scaffoldMessengerKey` not added to MaterialApp

**Solution:**
```dart
// In main.dart
GetMaterialApp(
  scaffoldMessengerKey: NotificationOverlay().scaffoldMessengerKey,
  // ... rest of config
)
```

#### ❌ Dependencies missing
**Solution:**
```yaml
# Add to pubspec.yaml
dependencies:
  socket_io_client: ^2.0.3+1
  flutter_local_notifications: ^16.3.0
```

Then run:
```bash
flutter pub get
```

### Debug Mode

Enable detailed logging:

```dart
import 'package:elecktro_ecommerce/app/core/socket_facility/socket_checker.dart';

// Enable debug mode
SocketChecker.enableDebugMode();
```

### Quick Test

Run this complete test:

```dart
import 'package:elecktro_ecommerce/app/core/socket_facility/socket_checker.dart';

Future<void> testSocket() async {
  print('🧪 Starting Socket Test...');
  
  // 1. Check status
  await SocketChecker.checkSocketStatus();
  
  // 2. Try to initialize
  final success = await SocketChecker.initializeSocket();
  
  if (success) {
    print('✅ Socket test PASSED');
  } else {
    print('❌ Socket test FAILED');
  }
}
```

### Server-Side Checklist

Make sure your backend:

1. ✅ Has socket.io installed and configured
2. ✅ Listens for client connections
3. ✅ Emits events with format: `notification::userId`
4. ✅ Sends proper data structure:
```javascript
{
  id: 'unique_id',
  title: 'Notification Title',
  message: 'Notification message',
  payload: 'type:id',  // For navigation
  // ... other fields
}
```

### Still Not Working?

1. **Check console logs** - Look for socket connection messages
2. **Check server logs** - Verify events are being emitted
3. **Test with Postman/curl** - Verify server is accessible
4. **Check network** - Ensure device can reach server IP
5. **Restart app** - Sometimes needed after code changes

### Example: Complete Integration

```dart
// 1. In your login controller
class AuthController extends GetxController {
  Future<void> login(String email, String password) async {
    try {
      final response = await apiService.login(email, password);
      
      if (response.success) {
        final userId = response.data['userId'];
        final token = response.data['token'];
        
        // Save to storage
        final storage = GetStorage();
        await storage.write('userId', userId);
        await storage.write('token', token);
        
        // Initialize socket
        await SocketManager().initialize(
          userId: userId,
          extraHeaders: {'Authorization': 'Bearer $token'},
          enableNotifications: true,
        );
        
        // Navigate to home
        Get.offAllNamed('/home');
      }
    } catch (e) {
      print('Login error: $e');
    }
  }
  
  void logout() {
    SocketManager().disconnect();
    GetStorage().erase();
    Get.offAllNamed('/login');
  }
}
```

### Need More Help?

Check the socket service logs in your console. Look for:
- `Socket connection initiated to http://10.10.7.62:7010 for user: xxx`
- `Socket connected successfully`
- `Received notification for user xxx: {...}`
