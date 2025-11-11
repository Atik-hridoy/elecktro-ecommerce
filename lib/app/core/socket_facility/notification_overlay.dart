import 'package:flutter/material.dart';

/// Global notification overlay service for showing snackbars
class NotificationOverlay {
  static final NotificationOverlay _instance = NotificationOverlay._internal();
  factory NotificationOverlay() => _instance;
  NotificationOverlay._internal();

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = 
      GlobalKey<ScaffoldMessengerState>();

  /// Show notification snackbar
  void showNotificationSnackbar({
    required String title,
    required String message,
    String? imageUrl,
    VoidCallback? onTap,
    Duration duration = const Duration(seconds: 4),
  }) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              if (imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.notifications, color: Colors.white, size: 40);
                    },
                  ),
                )
              else
                Icon(Icons.notifications, color: Colors.white, size: 40),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      message,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
            ],
          ),
        ),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: duration,
        elevation: 6,
      ),
    );
  }

  /// Show order notification snackbar
  void showOrderNotification({
    required String orderId,
    required String message,
    VoidCallback? onTap,
  }) {
    showNotificationSnackbar(
      title: 'Order Update',
      message: message,
      onTap: onTap,
    );
  }

  /// Show chat notification snackbar
  void showChatNotification({
    required String senderName,
    required String message,
    String? imageUrl,
    VoidCallback? onTap,
  }) {
    showNotificationSnackbar(
      title: senderName,
      message: message,
      imageUrl: imageUrl,
      onTap: onTap,
    );
  }

  /// Show product notification snackbar
  void showProductNotification({
    required String title,
    required String message,
    String? imageUrl,
    VoidCallback? onTap,
  }) {
    showNotificationSnackbar(
      title: title,
      message: message,
      imageUrl: imageUrl,
      onTap: onTap,
    );
  }
}
