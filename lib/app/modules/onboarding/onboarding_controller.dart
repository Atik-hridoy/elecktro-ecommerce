import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final currentPage = 0.obs;
  
  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/icons/onboarding/on1.svg',
      'title': 'Online Order',
      'subtitle': 'Browse and shop your favorite products anytime, anywhere with just a few taps.',
    },
    {
      'image': 'assets/icons/onboarding/on2.svg',
      'title': 'Easy Payment',
      'subtitle': 'Choose from multiple secure payment methods for a smooth and hassle-free checkout.',
    },
    {
      'image': 'assets/icons/onboarding/on3.svg',
      'title': 'Fast Delivery',
      'subtitle': 'Get your orders delivered quickly and reliably, right to your doorstep.',
    },
  ];

  void nextPage() {
    if (currentPage.value < onboardingData.length - 1) {
      currentPage.value++;
    } else {
      navigateToHome();
    }
  }
  
  void navigateToHome() {
    Get.offAllNamed(Routes.home);
  }
}
