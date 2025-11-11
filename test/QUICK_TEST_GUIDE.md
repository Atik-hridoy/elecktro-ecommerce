# 🚀 Quick Socket Testing Guide

## ✅ The App is Now Running!

Your visual test app is currently running on your emulator. Here's what to do:

---

## 📱 What You See on Screen

### 1. **Status Banner** (Top)
- 🟢 **GREEN** = Connected to server
- 🔴 **RED** = Not connected

### 2. **Event Counters**
- 📬 **Blue** = Notifications received
- 📦 **Orange** = Order updates received
- 💬 **Purple** = Chat messages received

### 3. **Controls**
- **User ID field** - Enter your test user ID
- **CONNECT button** - Click to connect to socket server
- **DISCONNECT button** - Click to disconnect
- **SEND TEST EVENT button** - Send a test event to server

### 4. **Live Event Log** (Bottom)
- Black terminal showing all events in real-time
- Green text = Events received
- Red text = Errors
- White text = Info

---

## 🎯 How to Test

### Step 1: Connect
1. Enter a User ID (default: `test_user_123`)
2. Click **CONNECT**
3. Watch the status banner turn **GREEN** ✅

### Step 2: Watch for Events
- When your server sends a notification, you'll see:
  - Counter increases (📬 1, 📬 2, etc.)
  - Event appears in log with green text
  - Full event data shown

### Step 3: Send Test Event
1. Click **SEND TEST EVENT**
2. Check your server logs to see if it received the event
3. Server should respond back with an event

---

## ✅ Signs It's Working

### You'll Know Notifications Work When:

1. **Status turns GREEN** ✅
   - Socket connected successfully

2. **You see in the log:**
   ```
   [11:42:15] 🔌 CONNECTED
   ```

3. **Server sends notification, you see:**
   ```
   [11:42:20] 📬 NOTIFICATION: {title: Test, body: Hello}
   ```

4. **Counter increases:**
   - 📬 goes from 0 → 1 → 2...

---

## ❌ Troubleshooting

### Status Stays RED?
**Problem:** Can't connect to server

**Check:**
1. Is your server running?
2. Check server URL in `lib/app/core/network/app_urls.dart`
3. Is the URL correct? (e.g., `http://10.10.7.62:7010`)
4. Can you ping the server?

### Connected but No Events?
**Problem:** Connected but not receiving notifications

**Check:**
1. Is server sending events?
2. Check server logs - is it emitting events?
3. Event name must match: `notification::${userId}`
4. User ID must match on both sides

### How to Check Server URL?
```dart
// Look in: lib/app/core/network/app_urls.dart
static const String socketUrl = 'http://YOUR_SERVER:PORT';
```

---

## 🧪 Test Your Server

### From Server, Send This:

**Node.js Example:**
```javascript
// Send notification to specific user
io.emit('notification::test_user_123', {
  title: 'Test Notification',
  body: 'This is a test',
  timestamp: new Date().toISOString()
});
```

**You Should See in App:**
```
[11:42:30] 📬 NOTIFICATION: {title: Test Notification, body: This is a test, ...}
```

---

## 📊 What Each Event Means

| Icon | Type | Event Name | When It Fires |
|------|------|------------|---------------|
| 📬 | Notification | `notification::userId` | General notifications |
| 📦 | Order | `order_update` | Order status changes |
| 💬 | Chat | `chat_message` | New chat messages |
| 🔌 | Connection | - | Socket connects/disconnects |

---

## 🎉 Success Checklist

- [ ] App shows GREEN status
- [ ] Log shows "CONNECTED"
- [ ] Can send test events
- [ ] Server receives test events
- [ ] Server sends notification
- [ ] App receives notification (counter increases)
- [ ] Event appears in log with data

**If all checked = Your socket notifications are working! 🎉**

---

## 💡 Pro Tips

1. **Keep the log visible** - You'll see everything happening in real-time
2. **Watch the counters** - Easy way to see if events are coming through
3. **Check server logs** - Make sure server is sending events
4. **Test with different user IDs** - Verify user-specific notifications work
5. **Try all event types** - Test notifications, orders, and chats

---

## 🔄 Alternative Simple Test

If the main app has issues, run the simpler version:

```bash
flutter run test/simple_socket_test.dart
```

This version has:
- ✅ No notification dependencies
- ✅ Simpler interface
- ✅ Same functionality
- ✅ Faster to build

---

## 📞 Need Help?

1. Check the event log for error messages
2. Look at server logs
3. Verify server URL is correct
4. Make sure server is running
5. Check network connectivity

**The log tells you everything - watch it closely!** 👀
