import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToOnboarding();
  }

  Future<void> _navigateToOnboarding() async {
    try {
      // Wait for 3 seconds
      await Future.delayed(const Duration(seconds: 3));
      
      // Navigate to onboarding screen
      Get.offAllNamed(Routes.onboarding);
    } catch (e) {
      // If there's an error, try again after a short delay
      await Future.delayed(const Duration(seconds: 1));
      _navigateToOnboarding();
    }
  }
}
