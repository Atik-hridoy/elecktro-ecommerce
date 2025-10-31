import 'notification_controller.dart';
import 'package:get/get.dart';
import 'services/get_notification.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(
      () => NotificationController(),

    );
    Get.lazyPut<GetNotificationService>(
      () => GetNotificationService(),
    );
  }
}
