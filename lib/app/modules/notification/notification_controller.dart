import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/core/network/app_urls.dart';
import 'package:elecktro_ecommerce/app/core/stroage/storage_services.dart';
import 'package:elecktro_ecommerce/app/core/util/app_logger.dart';
import 'package:elecktro_ecommerce/app/modules/notification/services/get_notification.dart';


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
  final Dio _dio = Dio();
  final RxList<NotificationItem> notifications = <NotificationItem>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<Map<String, dynamic>> _getNotifications() async {
    try {
      final token = LocalStorage.token;
      if (token.isEmpty) {
        AppLogger.error(
          'No authentication token found',
          tag: 'NotificationService',
          error: 'Token is empty',
        );
        return {
          'success': false,
          'message': 'Authentication required',
          'data': null,
        };
      }

      AppLogger.debug(
        'Fetching notifications...',
        tag: 'NotificationService',
        details: {'action': 'fetch_notifications'},
      );
      
      AppLogger.debug(
        'Token: ${token.substring(0, 10)}...',
        tag: 'NotificationService',
        details: {'token': '${token.substring(0, 10)}...'},
      );
      
      final apiUrl = '${AppUrls.baseUrl}${AppUrls.getNotification}';
      AppLogger.debug(
        'URL: $apiUrl',
        tag: 'NotificationService',
        details: {'url': apiUrl},
      );

      final response = await _dio.get(
        apiUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ).timeout(const Duration(seconds: 30));

      AppLogger.debug(
        'Response: ${response.statusCode}',
        tag: 'NotificationService',
        details: <String, Object>{
          'statusCode': response.statusCode ?? 0,
          'statusMessage': response.statusMessage ?? 'No status message',
        },
      );
      
      if (response.data != null) {
        if (response.data is Map) {
          AppLogger.debug(
            'Response data',
            tag: 'NotificationService',
            details: Map<String, Object>.from(response.data as Map),
          );
        } else {
          AppLogger.debug(
            'Response data',
            tag: 'NotificationService',
            details: <String, Object>{'data': response.data.toString()},
          );
        }
      }

      return {
        'success': true,
        'message': 'Notifications fetched successfully',
        'data': response.data,
      };
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';
      if (e.response != null) {
        errorMessage = 'Server responded with ${e.response?.statusCode}: ${e.response?.statusMessage}';
        AppLogger.error(
          'API Error Response',
          tag: 'NotificationService',
          error: e,
        );
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Receive timeout';
      } else if (e.type == DioExceptionType.sendTimeout) {
        errorMessage = 'Send timeout';
      }
      AppLogger.error(
        errorMessage,
        tag: 'NotificationService',
        error: e,
      );
      return {
        'success': false,
        'message': errorMessage,
        'data': null,
      };
    } catch (e) {
      AppLogger.error(
        'Unexpected error occurred',
        tag: 'NotificationService',
        error: e,
      );
      return {
        'success': false,
        'message': 'An unexpected error occurred: $e',
        'data': null,
      };
    }
  }

  void loadNotifications() async {
    isLoading.value = true;

    try {
      final response = await _getNotifications();
      
      if (response['success'] == true && response['data'] != null) {
        // Navigate through the nested response structure
        final responseData = response['data'] as Map<String, dynamic>;
        final resultData = responseData['data'] as Map<String, dynamic>?;
        final results = resultData?['result'] as List<dynamic>? ?? [];
        
        AppLogger.debug(
          'Processing ${results.length} notifications',
          tag: 'NotificationService',
          details: {'results': results},
        );

        notifications.value = results.map<NotificationItem>((item) {
          try {
            // Extract message or use default
            String message = item['message']?.toString() ?? 
                           item['content']?.toString() ?? 
                           item['description']?.toString() ?? 
                           'No message available';
            
            // Format order status messages
            String title = item['title']?.toString() ?? 'Order Update';
            
            // Special handling for order status messages
            if (message.contains('ORD#')) {
              message = message.replaceAll('\n', ' ').trim();
              
              // If title is not provided, use a default based on message content
              if (title == 'Order Update') {
                if (message.toLowerCase().contains('processed')) {
                  title = 'Order Processed';
                } else if (message.toLowerCase().contains('shipped')) {
                  title = 'Order Shipped';
                } else if (message.toLowerCase().contains('delivered')) {
                  title = 'Order Delivered';
                }
              }
              
              // Format the order number for better readability
              final orderNumber = RegExp(r'ORD#[A-Z0-9]+').firstMatch(message)?.group(0) ?? '';
              if (orderNumber.isNotEmpty) {
                message = message.replaceAll(orderNumber, '\n$orderNumber\n');
              }
            }

            return NotificationItem(
              id: item['_id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
              title: title,
              message: message.trim(),
              time: item['createdAt'] != null
                  ? _formatDateTime(item['createdAt'].toString())
                  : _formatDateTime(DateTime.now().toIso8601String()),
              isHighlighted: !(item['isRead'] ?? item['read'] ?? false),
            );
          } catch (e) {
            AppLogger.error(
              'Error parsing notification item',
              tag: 'NotificationService',
              error: e,
              stackTrace: StackTrace.current,
            );
            // Return a default notification item in case of parsing error
            return NotificationItem(
              id: 'error-${DateTime.now().millisecondsSinceEpoch}',
              title: 'Order Update',
              message: 'Your order status has been updated',
              time: _formatDateTime(DateTime.now().toIso8601String()),
              isHighlighted: true,
            );
          }
        }).toList();
      } else {
        AppLogger.warning(
          'No notifications found or invalid response format',
          tag: 'NotificationService',
          
        );
        notifications.clear();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch notifications',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[50],
        colorText: Colors.red[800],
      );
      notifications.clear();
    } finally {
      isLoading.value = false;
    }
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

  Future<void> markAsRead(String id) async {
    try {
      final index = notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        // Update UI optimistically
        final updated = notifications[index];
        notifications[index] = NotificationItem(
          id: updated.id,
          title: updated.title,
          message: updated.message,
          time: updated.time,
          isHighlighted: false,
        );
        notifications.refresh();

        // Call the API to mark as read
        final notificationService = Get.find<GetNotificationService>();
        final result = await notificationService.markNotificationAsRead(id);

        if (result['success'] != true) {
          // Revert UI if API call fails
          notifications[index] = updated;
          notifications.refresh();
          
          Get.snackbar(
            'Error',
            result['error']?.toString() ?? 'Failed to mark notification as read',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red[50],
            colorText: Colors.red[800],
          );
        }
      }
    } catch (e) {
      AppLogger.error(
        'Error marking notification as read',
        tag: 'NotificationService',
        error: e,
        stackTrace: StackTrace.current,
      );
      
      Get.snackbar(
        'Error',
        'An error occurred while marking the notification as read',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[50],
        colorText: Colors.red[800],
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

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      isLoading.value = true;
      // Update local state first for better UX
      notifications.value = notifications.map((n) => NotificationItem(
        id: n.id,
        title: n.title,
        message: n.message,
        time: n.time,
        isHighlighted: false,
      )).toList();

      final notificationService = GetNotificationService();
      final response = await notificationService.markAllNotificationsAsRead();
      
      if (response['success'] == true) {
        Get.snackbar(
          'Success', 
          response['message'] ?? 'All notifications marked as read',
          snackPosition: SnackPosition.BOTTOM, 
          backgroundColor: Colors.green, 
          colorText: Colors.white
        );
      } else {
        // Revert local changes if API call fails
        notifications.refresh();
        throw Exception(response['error'] ?? 'Failed to mark notifications as read');
      }
    } catch (e) {
      AppLogger.error('Error marking all notifications as read', tag: 'NotificationController', error: e);
      Get.snackbar(
        'Error', 
        'Failed to mark notifications as read: ${e.toString().replaceAll('Exception: ', '')}',
        snackPosition: SnackPosition.BOTTOM, 
        backgroundColor: Colors.red, 
        colorText: Colors.white
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to format date time
  String _formatDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.tryParse(dateTimeString)?.toLocal() ?? DateTime.now();
      // Format: Oct 31, 2023 14:30
      return '${_getMonthName(dateTime.month)} ${dateTime.day}, ${dateTime.year} ${_formatTime(dateTime)}';
    } catch (e) {
      return DateTime.now().toLocal().toString().substring(0, 16);
    }
  }

  String _getMonthName(int month) {
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return monthNames[month - 1];
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final period = dateTime.hour < 12 ? 'AM' : 'PM';
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}
