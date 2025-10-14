import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/modules/profile/account%20options/about/controller.dart';

class AboutBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AboutController>(
      () => AboutController(),
    );
  }
}
