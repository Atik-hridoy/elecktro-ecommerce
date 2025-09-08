import 'package:get/get.dart';

import 'cnontroller.dart';


class SuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuccessController>(() => SuccessController());
  }
}
