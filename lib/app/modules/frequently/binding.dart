import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/modules/frequently/controller.dart';

class FrequentlyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FrequentlyController>(
      () => FrequentlyController(),
    );
  }
}
