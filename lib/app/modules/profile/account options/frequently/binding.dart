import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/modules/profile/account%20options/frequently/controller.dart';

class FrequentlyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FrequentlyController>(
      () => FrequentlyController(),
    );
  }
}
