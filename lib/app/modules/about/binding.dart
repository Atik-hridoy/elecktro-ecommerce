import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/modules/about/controller.dart';

class AboutBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AboutController>(
      () => AboutController(),
    );
  }
}
