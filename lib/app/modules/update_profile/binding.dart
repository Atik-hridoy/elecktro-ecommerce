import 'package:elecktro_ecommerce/app/modules/update_profile/update_profile_controller.dart';
import 'package:get/get.dart';

class UpdateProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileInfoController>(
      () => ProfileInfoController(),
    );
  }
}