// In lib/app/modules/auth/bindings/bindings.dart
import 'package:elecktro_ecommerce/app/core/stroage/storage_services.dart';
import 'package:elecktro_ecommerce/app/modules/auth/controllers/authSignUpController.dart';
import 'package:elecktro_ecommerce/app/modules/auth/controllers/otpController.dart';
import 'package:get/get.dart';
import '../controllers/authSignInController.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthSignInController>(() => AuthSignInController());
    Get.lazyPut<AuthSignUpController>(() => AuthSignUpController());
    // OtpController will be created when needed with the email from Get.arguments
    Get.lazyPut<OtpController>(() {
      final email = LocalStorage.myEmail;
      return OtpController(email: email);
    }, fenix: true);
  }
}