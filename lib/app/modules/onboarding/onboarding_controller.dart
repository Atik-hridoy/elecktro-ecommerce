import 'dart:async';
import 'package:flutter/material.dart';
import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final currentPage = 0.obs;
  Timer? _autoScrollTimer;
  static const int autoScrollDuration = 5; // Increased from 3 to 5 seconds
  late PageController pageController;
  
  // Made final and static since it's constant data
  static const List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/icons/onboarding/on1.webp',
      'title': 'Online Order',
      'subtitle': 'Browse and shop your favorite products anytime, anywhere with just a few taps.',
    },
    {
      'image': 'assets/icons/onboarding/on2.webp',
      'title': 'Easy Payment',
      'subtitle': 'Choose from multiple secure payment methods for a smooth and hassle-free checkout.',
    },
    {
      'image': 'assets/icons/onboarding/on3.webp',
      'title': 'Fast Delivery',
      'subtitle': 'Get your orders delivered quickly and reliably, right to your doorstep.',
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
  
  void navigateToHome() {
    _cancelTimers();
    Get.offAllNamed(Routes.home);
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
