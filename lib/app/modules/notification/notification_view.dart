import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({Key? key}) : super(key: key);

  Widget _buildMoreOptionsButton() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.black),
      onSelected: (value) {
        if (value == 'mark_all_read') {
          controller.markAllAsRead();
        } else if (value == 'clear_all') {
          controller.clearAllNotifications();
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 'mark_all_read',
          child: Text('mark_all_read'.tr),
        ),
        PopupMenuItem(
          value: 'clear_all',
          child: Text('clear_all_notifications'.tr),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        shadowColor: Colors.black.withOpacity(0.1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'notifications'.tr,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Row(
            children: [
              _buildMoreOptionsButton(),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_off,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'no_notifications_yet'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'notifications_show_here'.tr,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => controller.refreshNotifications(),
                  icon: const Icon(Icons.refresh),
                  label: Text('refresh'.tr),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            controller.refreshNotifications();
          },
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            itemCount: controller.notifications.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return NotificationCard(
                notification: notification,
                onMorePressed: () => controller.showNotificationOptions(context, notification),
                onTap: () {
                  // Handle notification tap - you can navigate to detail page here
                  if (notification.isHighlighted) {
                    controller.markAsRead(notification.id);
                  }
                },
              );
            },
          ),
        );
      }),
    );
  }
}

// Notification Card Widget
class NotificationCard extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onMorePressed;
  final VoidCallback? onTap;

  const NotificationCard({
    Key? key,
    required this.notification,
    required this.onMorePressed,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notification.isHighlighted 
                ? Colors.green.shade50 
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: notification.isHighlighted 
                ? Border.all(color: Colors.green.shade200, width: 1)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (notification.isHighlighted)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 8, top: 4),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: notification.isHighlighted 
                                ? FontWeight.w700 
                                : FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onMorePressed,
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 20,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.only(
                left: notification.isHighlighted ? 16 : 0,
              ),
              child: Text(
                notification.message,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.4,
                  fontWeight: notification.isHighlighted 
                      ? FontWeight.w500 
                      : FontWeight.normal,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.only(
                left: notification.isHighlighted ? 16 : 0,
              ),
              child: Text(
                notification.time,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}