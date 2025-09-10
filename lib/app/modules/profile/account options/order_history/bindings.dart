import 'package:elecktro_ecommerce/app/modules/profile/account%20options/order_history/history_controller.dart';
import 'package:get/get.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HistoryController());
  }
}