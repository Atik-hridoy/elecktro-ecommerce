import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Notification Item Model
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String time;
  final bool isHighlighted;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.isHighlighted,
  });
}

// Notification Controller
class NotificationController extends GetxController {
  final RxList<NotificationItem> notifications = <NotificationItem>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void loadNotifications() {
    isLoading.value = true;
    
    // Simulate API call delay
    Future.delayed(const Duration(milliseconds: 500), () {
      notifications.value = [
        NotificationItem(
          id: '1',
          title: 'Your order is submitted',
          message: "Your device 'Trkli Tracker' is in Panidns stage now",
          time: '2:30 am',
          isHighlighted: true,
        ),
        NotificationItem(
          id: '2164165',
          title: 'Your order 2164165 in processing',
          message: "Your device 'Trkli Tracker' isin Panidns stage now",
          time: '2:30 am',
          isHighlighted: false,
        ),
        NotificationItem(
          id: '2164165-2',
          title: 'Your order 2164165 in processing',
          message: "Your device 'Trkli Tracker' isin Panidns stage now",
          time: '2:30 am',
          isHighlighted: false,
        ),
        NotificationItem(
          id: '2164165-3',
          title: 'Your order 2164165 in processing',
          message: "Your device 'Trkli Tracker' isin Panidns stage now",
          time: '2:30 am',
          isHighlighted: false,
        ),
        NotificationItem(
          id: '2164165-4',
          title: 'Your order 2164165 in processing',
          message: "Your device 'Trkli Tracker' isin Panidns stage now",
          time: '2:30 am',
          isHighlighted: false,
        ),
        NotificationItem(
          id: '2164165-5',
          title: 'Your order 2164165 in processing',
          message: "Your device 'Trkli Tracker' isin Panidns stage now",
          time: '2:30 am',
          isHighlighted: false,
        ),
      ];
      
      isLoading.value = false;
    });
  }

  void deleteNotification(String id) {
    notifications.removeWhere((notification) => notification.id == id);
    Get.snackbar(
      'Deleted',
      'Notification deleted successfully',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade800,
    );
  }

  void markAsRead(String id) {
    final index = notifications.indexWhere((notification) => notification.id == id);
    if (index != -1) {
      final notification = notifications[index];
      notifications[index] = NotificationItem(
        id: notification.id,
        title: notification.title,
        message: notification.message,
        time: notification.time,
        isHighlighted: false, // Mark as read by removing highlight
      );
      
      Get.snackbar(
        'Marked as read',
        'Notification marked as read',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
      );
    }
  }

  void showNotificationOptions(BuildContext context, NotificationItem notification) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(
                Icons.mark_email_read, 
                color: notification.isHighlighted ? Colors.blue : Colors.grey,
              ),
              title: Text(
                notification.isHighlighted ? 'Mark as read' : 'Already read',
                style: TextStyle(
                  color: notification.isHighlighted ? Colors.black : Colors.grey,
                ),
              ),
              onTap: notification.isHighlighted ? () {
                Navigator.pop(context);
                markAsRead(notification.id);
              } : null,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                deleteNotification(notification.id);
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void refreshNotifications() {
    loadNotifications();
  }

  void clearAllNotifications() {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear All'),
        content: const Text('Are you sure you want to clear all notifications?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              notifications.clear();
              Get.back();
              Get.snackbar(
                'Cleared',
                'All notifications cleared',
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 2),
                backgroundColor: Colors.orange.shade100,
                colorText: Colors.orange.shade800,
              );
            },
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}