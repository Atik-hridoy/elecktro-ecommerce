// In lib/app/modules/auth/bindings/bindings.dart
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
      final args = Get.arguments;
      final email = args is Map ? args['email'] : (args is String ? args : '');
      final isRegistration = args is Map ? (args['isRegistration'] ?? false) : false;
      
      if (email == null || email.isEmpty) {
        throw Exception('Email is required for OTP verification');
      }
      
      return OtpController(
        email: email,
        isRegistration: isRegistration,
      );
    }, fenix: true);
  }
}