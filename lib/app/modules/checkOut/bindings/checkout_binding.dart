import 'package:elecktro_ecommerce/app/modules/checkOut/controllers/card_controller.dart';
import 'package:get/get.dart';
import '../controllers/checkout_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckoutController>(
      () => CheckoutController(),
    );
    Get.lazyPut<CardController>(
      () => CardController(),
    );
  }
}
