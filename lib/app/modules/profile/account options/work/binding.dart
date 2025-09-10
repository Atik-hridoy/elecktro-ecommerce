import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/modules/profile/account%20options/work/controller.dart';

class WorkBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WorkController>(
      () => WorkController(),
    );
  }
}
