# ✅ Using Real Credentials from Your App

## What Changed

The visual test apps now **automatically load your actual userId and token** from GetStorage instead of using fake test values!

---

## 🔄 How It Works

### When the app starts:

1. **Reads from GetStorage** (your app's storage)
   ```dart
   userId = storage.read('userId') ?? storage.read('user_id')
   token = storage.read('token') ?? storage.read('auth_token')
   ```

2. **Pre-fills the input fields** with your real data

3. **Shows status in logs:**
   - ✅ `Loaded User ID from storage: your_actual_id`
   - ✅ `Loaded Auth Token from storage`

4. **Uses real credentials** when connecting to socket

---

## 📱 What You'll See

### On App Launch:

**If you're logged in to your app:**
```
[11:48:15] ✅ Loaded User ID from storage: 12345
[11:48:15] ✅ Loaded Auth Token from storage
```

**If not logged in yet:**
```
[11:48:15] ⚠️  No User ID found in storage, using default
[11:48:15] ⚠️  No Auth Token found in storage, using default
```

---

## 🎯 Testing Flow

### Option 1: Already Logged In

1. **Login to your main app first**
   - This saves userId and token to GetStorage

2. **Run the test app:**
   ```bash
   flutter run test/notification_visual_test.dart
   ```

3. **See your real credentials loaded automatically**
   - User ID field shows your actual ID
   - Token is loaded (hidden for security)

4. **Click CONNECT**
   - Uses your real userId and token
   - Connects as the actual logged-in user

### Option 2: Not Logged In

1. **Run the test app**
   ```bash
   flutter run test/notification_visual_test.dart
   ```

2. **See default test values**
   - `test_user_123`
   - `test_token`

3. **You can manually edit** the fields to enter real values

4. **Or login to main app first**, then restart test app

---

## 🔍 How to Check What's Stored

### Check your storage keys:

The app looks for these keys in GetStorage:
- `userId` or `user_id`
- `token` or `auth_token`

### To verify what's stored:

**Option 1: Check in your main app**
```dart
final storage = GetStorage();
print('User ID: ${storage.read('userId')}');
print('Token: ${storage.read('token')}');
```

**Option 2: Look at test app logs**
- The test app shows what it found on startup

---

## 🎉 Benefits

### ✅ **Real Testing**
- Tests with actual user credentials
- Receives notifications for real user
- No need to manually enter credentials

### ✅ **Automatic**
- Loads credentials on startup
- No configuration needed
- Works immediately after login

### ✅ **Flexible**
- Can still manually edit if needed
- Falls back to test values if not logged in
- Works for any user

---

## 🔐 Security Note

**The token is loaded but not displayed in the UI for security.**

You'll see:
- ✅ User ID: `12345` (visible)
- ✅ Token: `***` (hidden in logs, but used for connection)

---

## 📊 Storage Keys Used

| Key | Alternative Key | Purpose |
|-----|----------------|---------|
| `userId` | `user_id` | User identifier |
| `token` | `auth_token` | Authentication token |

The app checks both formats to ensure compatibility.

---

## 🚀 Quick Start

### To test with your real credentials:

1. **Login to your main app** (if not already)
   ```bash
   flutter run lib/main.dart
   # Login with your credentials
   ```

2. **Run the test app**
   ```bash
   flutter run test/notification_visual_test.dart
   ```

3. **Check the logs** - Should show:
   ```
   ✅ Loaded User ID from storage: YOUR_ID
   ✅ Loaded Auth Token from storage
   ```

4. **Click CONNECT** - Uses your real credentials!

---

## 🔧 Troubleshooting

### "No User ID found in storage"

**Cause:** You haven't logged in to the main app yet

**Solution:**
1. Run your main app: `flutter run lib/main.dart`
2. Login with your credentials
3. Close and restart the test app

### "Using default test values"

**Cause:** Storage keys don't match

**Solution:**
Check what keys your app uses for storage:
```dart
// In your login code, you might have:
storage.write('userId', user.id);  // or 'user_id'?
storage.write('token', authToken); // or 'auth_token'?
```

Make sure it matches one of these formats.

---

## 💡 Pro Tip

**Want to test different users?**

1. Login as User A in main app
2. Run test app - sees User A credentials
3. Logout and login as User B in main app
4. Restart test app - now sees User B credentials

**Or manually edit** the User ID field in the test app!

---

## ✨ Summary

- ✅ **Automatically loads** real userId and token from GetStorage
- ✅ **No manual entry** needed if you're logged in
- ✅ **Shows what it found** in the logs
- ✅ **Falls back** to test values if nothing stored
- ✅ **Secure** - token not displayed but used for connection

**Now you're testing with REAL credentials! 🎉**
