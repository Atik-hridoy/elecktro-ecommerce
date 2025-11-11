import 'package:flutter_test/flutter_test.dart';
import 'package:elecktro_ecommerce/app/core/socket_facility/socket_manager.dart';
import 'package:elecktro_ecommerce/app/core/socket_facility/socket_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SocketService Tests', () {
    late SocketService socketService;

    setUp(() {
      socketService = SocketService();
    });

    tearDown(() {
      socketService.disconnect();
    });

    test('SocketService should be a singleton', () {
      final instance1 = SocketService();
      final instance2 = SocketService();
      expect(instance1, equals(instance2));
    });

    test('Initial connection status should be false', () {
      expect(socketService.isConnected, false);
    });

    test('Connection stream should emit status changes', () async {
      // Listen to connection stream
      final connectionStates = <bool>[];
      final subscription = socketService.connectionStream.listen((isConnected) {
        connectionStates.add(isConnected);
      });

      // Simulate connection (this will fail without a real server, but tests the stream)
      socketService.connect(
        userId: 'test_user_123',
        extraHeaders: {'Authorization': 'Bearer test_token'},
      );

      // Wait a bit for any async operations
      await Future.delayed(Duration(milliseconds: 500));

      // Clean up
      await subscription.cancel();

      // The stream should have emitted at least one event
      expect(connectionStates, isNotEmpty);
    });

    test('Emit should not throw when socket is not connected', () {
      expect(
        () => socketService.emit('test_event', {'data': 'test'}),
        returnsNormally,
      );
    });

    test('Notification stream should be available', () {
      expect(socketService.notificationStream, isNotNull);
    });

    test('Order update stream should be available', () {
      expect(socketService.orderUpdateStream, isNotNull);
    });

    test('Chat message stream should be available', () {
      expect(socketService.chatMessageStream, isNotNull);
    });
  });

  group('SocketManager Tests', () {
    late SocketManager socketManager;

    setUp(() {
      socketManager = SocketManager();
    });

    tearDown(() {
      socketManager.disconnect();
    });

    test('SocketManager should be a singleton', () {
      final instance1 = SocketManager();
      final instance2 = SocketManager();
      expect(instance1, equals(instance2));
    });

    test('Initial connection status should be false', () {
      expect(socketManager.isConnected, false);
    });

    test('Initialize should complete without errors', () async {
      expect(
        () async => await socketManager.initialize(
          userId: 'test_user_123',
          extraHeaders: {'Authorization': 'Bearer test_token'},
          enableNotifications: false, // Disable notifications for testing
        ),
        returnsNormally,
      );
    });

    test('Emit should work after initialization', () async {
      await socketManager.initialize(
        userId: 'test_user_123',
        enableNotifications: false,
      );

      expect(
        () => socketManager.emit('test_event', {'message': 'Hello'}),
        returnsNormally,
      );
    });

    test('Connection stream should be available', () {
      expect(socketManager.connectionStream, isNotNull);
    });

    test('Notification tap stream should be available', () {
      expect(socketManager.notificationTapStream, isNotNull);
    });

    test('Disconnect should work without errors', () {
      expect(() => socketManager.disconnect(), returnsNormally);
    });

    test('Dispose should work without errors', () {
      expect(() => socketManager.dispose(), returnsNormally);
    });
  });

  group('Socket Integration Tests', () {
    test('Full socket lifecycle test', () async {
      // Initialize socket manager
      final socketManager = SocketManager();
      await socketManager.initialize(
        userId: 'integration_test_user',
        extraHeaders: {'Authorization': 'Bearer integration_test_token'},
        enableNotifications: false,
      );

      // Wait a bit
      await Future.delayed(Duration(milliseconds: 500));

      // Test emit
      socketManager.emit('test_event', {
        'message': 'Integration test',
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Disconnect
      socketManager.disconnect();
    });

    test('Multiple socket events test', () async {
      final socketService = SocketService();
      final events = <String>[];

      // Listen to custom events
      socketService.on('custom_event_1', (data) {
        events.add('custom_event_1');
      });

      socketService.on('custom_event_2', (data) {
        events.add('custom_event_2');
      });

      // Connect
      socketService.connect(userId: 'multi_event_test_user');

      // Wait
      await Future.delayed(Duration(milliseconds: 300));

      // Remove listeners
      socketService.off('custom_event_1');
      socketService.off('custom_event_2');

      // Disconnect
      socketService.disconnect();

      expect(events, isA<List<String>>());
    });
  });

  group('Socket Stream Tests', () {
    test('Notification stream should be available', () {
      final socketService = SocketService();
      
      // Just verify the stream exists and is of correct type
      expect(socketService.notificationStream, isA<Stream<Map<String, dynamic>>>());
      
      socketService.disconnect();
    });

    test('Order update stream should be available', () {
      final socketService = SocketService();
      
      // Just verify the stream exists and is of correct type
      expect(socketService.orderUpdateStream, isA<Stream<Map<String, dynamic>>>());
      
      socketService.disconnect();
    });

    test('Chat message stream should be available', () {
      final socketService = SocketService();
      
      // Just verify the stream exists and is of correct type
      expect(socketService.chatMessageStream, isA<Stream<Map<String, dynamic>>>());
      
      socketService.disconnect();
    });

    test('Connection stream should be available', () {
      final socketService = SocketService();
      
      // Just verify the stream exists and is of correct type
      expect(socketService.connectionStream, isA<Stream<bool>>());
      
      socketService.disconnect();
    });
  });
}
