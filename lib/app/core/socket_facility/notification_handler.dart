import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

/// Handler for processing and displaying instant notifications
class NotificationHandler {
  static final NotificationHandler _instance = NotificationHandler._internal();
  factory NotificationHandler() => _instance;
  NotificationHandler._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  final _notificationTapController = StreamController<String>.broadcast();

  Stream<String> get notificationTapStream => _notificationTapController.stream;

  /// Initialize local notifications
  Future<void> initialize() async {
    if (_isInitialized) return;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    _isInitialized = true;
  }

  /// Handle notification tap
  void _onNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null) {
      _notificationTapController.add(payload);
    }
  }

  /// Show notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    NotificationPriority priority = NotificationPriority.high,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'elecktro_channel',
      'Elecktro Notifications',
      channelDescription: 'Notifications for Elecktro E-commerce',
      importance: _getImportance(priority),
      priority: _getPriority(priority),
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  /// Show order notification
  Future<void> showOrderNotification({
    required String orderId,
    required String status,
    required String message,
  }) async {
    await showNotification(
      id: orderId.hashCode,
      title: 'Order Update',
      body: message,
      payload: 'order:$orderId',
      priority: NotificationPriority.high,
    );
  }

  /// Show chat notification
  Future<void> showChatNotification({
    required String chatId,
    required String senderName,
    required String message,
  }) async {
    await showNotification(
      id: chatId.hashCode,
      title: senderName,
      body: message,
      payload: 'chat:$chatId',
      priority: NotificationPriority.high,
    );
  }

  /// Show product notification
  Future<void> showProductNotification({
    required String productId,
    required String title,
    required String message,
  }) async {
    await showNotification(
      id: productId.hashCode,
      title: title,
      body: message,
      payload: 'product:$productId',
      priority: NotificationPriority.default_,
    );
  }

  /// Cancel notification
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  /// Get Android importance level
  Importance _getImportance(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.max:
        return Importance.max;
      case NotificationPriority.high:
        return Importance.high;
      case NotificationPriority.default_:
        return Importance.defaultImportance;
      case NotificationPriority.low:
        return Importance.low;
      case NotificationPriority.min:
        return Importance.min;
    }
  }

  /// Get Android priority level
  Priority _getPriority(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.max:
        return Priority.max;
      case NotificationPriority.high:
        return Priority.high;
      case NotificationPriority.default_:
        return Priority.defaultPriority;
      case NotificationPriority.low:
        return Priority.low;
      case NotificationPriority.min:
        return Priority.min;
    }
  }

  /// Dispose resources
  void dispose() {
    _notificationTapController.close();
  }
}

/// Notification priority levels
enum NotificationPriority {
  max,
  high,
  default_,
  low,
  min,
}
