// lib/app/modules/profile/account options/order_history/bindings.dart
import 'package:elecktro_ecommerce/app/modules/profile/account%20options/order_history/history_controller.dart';
import 'package:elecktro_ecommerce/app/modules/profile/account%20options/order_history/services/order_service.dart';
import 'package:get/get.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize the service first
    Get.lazyPut<OrderService>(() => OrderService());
    // Then initialize the controller
    Get.lazyPut<HistoryController>(() => HistoryController());
  }
}