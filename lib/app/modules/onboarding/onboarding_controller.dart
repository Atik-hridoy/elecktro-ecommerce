import 'dart:async';
import 'package:flutter/material.dart';
import 'package:elecktro_ecommerce/app/core/stroage/storage_services.dart';
import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final currentPage = 0.obs;
  Timer? _autoScrollTimer;
  static const int autoScrollDuration = 5; // Increased from 3 to 5 seconds
  late PageController pageController;
  
  // Onboarding data with translations
  static List<Map<String, String>> get onboardingData => [
    {
      'image': 'assets/icons/onboarding/on1.webp',
      'title': 'online_order'.tr,
      'subtitle': 'online_order_subtitle'.tr,
    },
    {
      'image': 'assets/icons/onboarding/on2.webp',
      'title': 'easy_payment'.tr,
      'subtitle': 'easy_payment_subtitle'.tr,
    },
    {
      'image': 'assets/icons/onboarding/on3.webp',
      'title': 'fast_delivery'.tr,
      'subtitle': 'fast_delivery_subtitle'.tr,
    },
  ];

  // Debounce for page changes
  static const _debounceDuration = Duration(milliseconds: 300);
  Timer? _debounceTimer;

  void nextPage() {
    if (_debounceTimer?.isActive ?? false) return;
    
    _debounceTimer = Timer(_debounceDuration, () {});
    
    if (currentPage.value < onboardingData.length - 1) {
      currentPage.value++;
      _animateToPage(currentPage.value);
    } else {
      navigateToHome();
    }
  }
  
  void _animateToPage(int page) {
    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }
  
  void navigateToHome() async {
    _cancelTimers();
    await LocalStorage.getAllPrefData();
    
    if (LocalStorage.token.isNotEmpty && LocalStorage.isLogIn) {
      // If already logged in (returning user)
      if (await LocalStorage.isProfileComplete()) {
        Get.offAllNamed(Routes.home);
      } else {
        Get.offAllNamed(Routes.updateProfile);
      }
    } else {
      // New user, go to auth
      Get.offAllNamed(Routes.auth);
    }
  }
  
  // Start auto scroll timer
  void startAutoScroll(PageController pageController) {
    _cancelTimers();
    _autoScrollTimer = Timer.periodic(
      const Duration(seconds: autoScrollDuration), 
      (_) => _handleAutoScroll(pageController),
    );
  }
  
  void _handleAutoScroll(PageController pageController) {
    if (currentPage.value < onboardingData.length - 1) {
      currentPage.value++;
      _animateToPage(currentPage.value);
    } else {
      _cancelTimers();
    }
  }
  
  // Cancel all timers
  void _cancelTimers() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
    _debounceTimer?.cancel();
    _debounceTimer = null;
  }

  bool _isDisposed = false;

  @override
  void onClose() {
    if (!_isDisposed) {
      _cancelTimers();
      if (pageController.hasClients) {
        pageController.dispose();
      }
      _isDisposed = true;
    }
    super.onClose();
  }
}
