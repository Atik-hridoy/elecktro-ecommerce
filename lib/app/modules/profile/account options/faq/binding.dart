import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/modules/profile/account%20options/faq/controller.dart';

class FaqBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FaqController>(
      () => FaqController(),
    );
  }
}
