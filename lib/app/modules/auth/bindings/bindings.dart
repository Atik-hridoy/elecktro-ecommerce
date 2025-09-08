import 'package:elecktro_ecommerce/app/modules/auth/controllers/authController.dart';
import 'package:elecktro_ecommerce/app/modules/auth/controllers/otpController.dart';
import 'package:get/get.dart';


class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpController>(
      () => OtpController(),
    );
    Get.lazyPut<AuthController>(
      () => AuthController(),
    );
  
  }
}