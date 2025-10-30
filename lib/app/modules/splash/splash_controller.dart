import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/core/stroage/storage_services.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _decideStartDestination();
  }

  Future<void> _decideStartDestination() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      await LocalStorage.getAllPrefData();
      
      if (LocalStorage.token.isNotEmpty && LocalStorage.isLogIn) {
        // If logged in with valid token
        if (await LocalStorage.isProfileComplete()) {
          Get.offAllNamed(Routes.home);
        } else {
          Get.offAllNamed(Routes.updateProfile);
        }
      } else {
        // If not logged in or token invalid
        Get.offAllNamed(Routes.onboarding);
      }
    } catch (e) {
      await Future.delayed(const Duration(seconds: 1));
      _decideStartDestination();
    }
  }
}
