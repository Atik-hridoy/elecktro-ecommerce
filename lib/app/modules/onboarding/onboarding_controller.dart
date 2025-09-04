import 'dart:async';
import 'package:flutter/material.dart';
import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final currentPage = 0.obs;
  Timer? _timer;
  final int autoScrollDuration = 3; // seconds
  late PageController pageController;
  
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
      pageController.animateToPage(
        currentPage.value,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      navigateToHome();
    }
  }
  
  void navigateToHome() {
    _cancelTimer();
    Get.offAllNamed(Routes.home);
  }
  
  // Start auto scroll timer
  void startAutoScroll(PageController pageController) {
    _cancelTimer();
    _timer = Timer.periodic(Duration(seconds: autoScrollDuration), (_) {
      if (currentPage.value < onboardingData.length - 1) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _cancelTimer();
      }
    });
  }
  
  // Cancel the auto scroll timer
  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void onClose() {
    _cancelTimer();
    pageController.dispose();
    super.onClose();
  }
}
