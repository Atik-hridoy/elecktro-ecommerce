import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/modules/profile/account%20options/tearms_and_conditions/controller.dart';

class TearmsAndConditionsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TearmsAndConditionsController>(
      () => TearmsAndConditionsController(),
    );
  }
}
