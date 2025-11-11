# Socket Testing Guide

This guide explains how to test the socket functionality in the elecktro-ecommerce app.

## Test File Location
- **Main Test File**: `test/socket_test.dart`

## Running the Tests

### Run All Socket Tests
```bash
flutter test test/socket_test.dart
```

### Run Specific Test Group
```bash
# Test only SocketService
flutter test test/socket_test.dart --name "SocketService Tests"

# Test only SocketManager
flutter test test/socket_test.dart --name "SocketManager Tests"

# Test only SocketChecker
flutter test test/socket_test.dart --name "SocketChecker Tests"

# Test integration
flutter test test/socket_test.dart --name "Socket Integration Tests"

# Test streams
flutter test test/socket_test.dart --name "Socket Stream Tests"
```

### Run All Tests in Project
```bash
flutter test
```

### Run with Verbose Output
```bash
flutter test test/socket_test.dart --verbose
```

## Test Coverage

The test suite covers:

### 1. **SocketService Tests**
- ✅ Singleton pattern verification
- ✅ Initial connection status
- ✅ Connection stream functionality
- ✅ Emit event handling
- ✅ Stream availability (notification, order, chat)

### 2. **SocketManager Tests**
- ✅ Singleton pattern verification
- ✅ Initialization process
- ✅ Event emission
- ✅ Stream availability
- ✅ Disconnect and dispose methods

### 3. **SocketChecker Tests**
- ✅ Status checking with storage
- ✅ UserId detection
- ✅ Token detection
- ✅ Missing data handling
- ✅ Socket initialization
- ✅ Test notification sending
- ✅ Debug mode enabling

### 4. **Integration Tests**
- ✅ Full socket lifecycle
- ✅ Multiple event handling
- ✅ Storage integration

### 5. **Stream Tests**
- ✅ Notification stream
- ✅ Connection stream
- ✅ Stream data emission

## Important Notes

⚠️ **Server Connection**: Most tests will work without a real socket server, but some connection-related tests may show warnings. This is expected behavior.

⚠️ **GetStorage**: Tests initialize GetStorage in memory, so they won't affect your actual app data.

⚠️ **Notifications**: Tests disable notifications by default to avoid permission issues during testing.

## Manual Testing

### Test Socket Connection Manually

1. **Check Socket Status**
```dart
import 'package:elecktro_ecommerce/app/core/socket_facility/socket_checker.dart';

// In your code
final status = await SocketChecker.checkSocketStatus();
print(status);
```

2. **Initialize Socket**
```dart
final success = await SocketChecker.initializeSocket();
print('Socket initialized: $success');
```

3. **Send Test Notification**
```dart
SocketChecker.sendTestNotification();
```

4. **Enable Debug Mode**
```dart
SocketChecker.enableDebugMode();
```

## Test with Real Server

To test with a real socket server:

1. Ensure your server is running
2. Update `AppUrls.socketUrl` in your app configuration
3. Run the tests:
```bash
flutter test test/socket_test.dart --dart-define=USE_REAL_SERVER=true
```

## Debugging Failed Tests

If tests fail:

1. **Check GetStorage initialization**
   - Ensure GetStorage is properly initialized
   
2. **Check imports**
   - Verify all socket facility files are imported correctly

3. **Check server URL**
   - Ensure `AppUrls.socketUrl` is configured

4. **Run with verbose output**
   ```bash
   flutter test test/socket_test.dart --verbose
   ```

## Adding More Tests

To add custom tests, follow this pattern:

```dart
test('Your test description', () async {
  // Arrange
  final socketManager = SocketManager();
  
  // Act
  await socketManager.initialize(userId: 'test_user');
  
  // Assert
  expect(socketManager.isConnected, isNotNull);
  
  // Cleanup
  socketManager.disconnect();
});
```

## CI/CD Integration

Add to your CI/CD pipeline:

```yaml
- name: Run Socket Tests
  run: flutter test test/socket_test.dart --coverage
```

## Coverage Report

Generate coverage report:

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

Then open `coverage/html/index.html` in your browser.

## Troubleshooting

### Issue: "GetStorage not initialized"
**Solution**: The test file already handles this in `setUpAll()`. If you still see this error, ensure you're running the full test file.

### Issue: "Socket connection timeout"
**Solution**: This is expected without a real server. The tests are designed to handle this gracefully.

### Issue: "Notification permission denied"
**Solution**: Tests disable notifications by default. If you need to test notifications, run on a real device with permissions granted.

## Next Steps

After running tests:
1. Review test output for any failures
2. Check coverage report to identify untested code
3. Add integration tests with your actual backend
4. Test on real devices for notification functionality
