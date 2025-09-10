import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/modules/support/controller.dart';

class SupportBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupportController>(
      () => SupportController(),
    );
  }
}
