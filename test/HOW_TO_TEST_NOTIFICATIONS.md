# How to Test Socket Notifications Visually

## Option 1: Standalone Visual Test App (Recommended for Testing)

### Run the visual test app:
```bash
flutter run test/notification_visual_test.dart
```

### What you'll see:
- ✅ **Connection Status** - Green when connected, Red when disconnected
- 📊 **Event Counters** - Shows count of notifications, orders, and chats received
- 🎛️ **Control Panel** - Connect/disconnect buttons and test event senders
- 📝 **Live Event Log** - Real-time log of all socket events

### How to use:
1. **Enter your User ID and Token** (or use the default test values)
2. **Click "Connect"** - Watch the status turn green if successful
3. **Send Test Events** - Click the buttons to emit test events to your server
4. **Watch the Logs** - All incoming and outgoing events appear in real-time

### What to look for:
- ✅ Connection status changes to GREEN
- ✅ Logs show "CONNECTED" message
- ✅ When server sends notifications, they appear in the log
- ✅ Counter numbers increase when events are received

---

## Option 2: Floating Monitor Widget (For Your Main App)

### Add to your app:

1. **Import the monitor** in your main screen:
```dart
import '../test/socket_notification_monitor.dart';
```

2. **Add to your widget tree** (wrap your screen with Stack):
```dart
@override
Widget build(BuildContext context) {
  return Stack(
    children: [
      // Your existing screen content
      YourMainScreen(),
      
      // Add the floating monitor
      SocketNotificationMonitor(),
    ],
  );
}
```

### What you'll see:
- 🔴/🟢 **Floating button** in bottom-right corner (red = disconnected, green = connected)
- **Tap to expand** - Shows full monitoring panel
- **Real-time events** - All notifications appear as they arrive
- **Event details** - Tap the code icon to see full event data

---

## How to Know Notifications Are Working

### ✅ Signs Everything is Working:

1. **Connection Indicator is GREEN**
   - Shows socket is connected to server

2. **You see "Connected" in logs**
   - Confirms successful connection

3. **When server sends notification, you see:**
   - 📬 Blue notification icon in log
   - Counter increases
   - Event details show in the list

4. **Test events work:**
   - Click "Send Test" buttons
   - See "📤 Sending..." in logs
   - Server should echo back or respond

### ❌ Signs Something is Wrong:

1. **Connection stays RED**
   - Check server URL in `AppUrls.socketUrl`
   - Verify server is running
   - Check network connection

2. **"Connection error" in logs**
   - Server might be down
   - Wrong URL or port
   - Firewall blocking connection

3. **Connected but no events received**
   - Server not sending to correct user ID
   - Event names don't match (check server code)
   - User not joined to room on server

---

## Testing with Your Backend

### Server should emit events in this format:

**For Notifications:**
```javascript
// Server code (Node.js example)
io.to(`notification::${userId}`).emit('notification::${userId}', {
  title: 'New Notification',
  body: 'You have a new message',
  payload: { /* any data */ }
});
```

**For Order Updates:**
```javascript
socket.emit('order_update', {
  orderId: '12345',
  status: 'shipped',
  message: 'Your order has been shipped'
});
```

**For Chat Messages:**
```javascript
socket.emit('chat_message', {
  chatId: 'chat_123',
  senderName: 'John',
  message: 'Hello!'
});
```

### Expected Event Names:
- `notification::${userId}` - For user-specific notifications
- `order_update` - For order status changes
- `chat_message` - For chat messages

---

## Quick Debugging Checklist

- [ ] Server is running and accessible
- [ ] `AppUrls.socketUrl` points to correct server
- [ ] User ID matches what server expects
- [ ] Socket connects (green indicator)
- [ ] Server emits events with correct event names
- [ ] User joined to correct room on server
- [ ] No firewall blocking WebSocket connections
- [ ] Auth token is valid (if required by server)

---

## Example Test Flow

1. **Start the visual test app**
   ```bash
   flutter run test/notification_visual_test.dart
   ```

2. **Connect to socket**
   - Enter user ID: `test_user_123`
   - Click "Connect"
   - Wait for GREEN status

3. **From your server, send a test notification:**
   ```javascript
   io.emit('notification::test_user_123', {
     title: 'Test',
     body: 'This is a test notification'
   });
   ```

4. **Watch the app:**
   - You should see 📬 icon in logs
   - "Notification received" message
   - Counter increases to 1

5. **Success!** Your notifications are working! 🎉

---

## Troubleshooting

### "Cannot connect to server"
- Check `lib/app/core/network/app_urls.dart`
- Verify `socketUrl` is correct
- Test server URL in browser or Postman

### "Connected but no notifications"
- Check server logs - is it sending events?
- Verify event names match exactly
- Check user ID matches on both sides
- Ensure user joined the room on server

### "Events received but not showing in app"
- Check if streams are being listened to
- Verify SocketManager is initialized
- Check for errors in console

---

## Need More Help?

1. Enable debug mode:
   ```dart
   SocketChecker.enableDebugMode();
   ```

2. Check socket status:
   ```dart
   final status = await SocketChecker.checkSocketStatus();
   print(status);
   ```

3. Look at console logs for detailed error messages
