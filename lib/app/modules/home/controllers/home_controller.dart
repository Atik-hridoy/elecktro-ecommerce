import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs; // Observable variable for the selected index
  var currentBannerIndex = 0.obs; // Track current banner index
  Timer? _bannerTimer;
  var categories = [
    {
      'title': 'Best Offers',
      'bgColor': Colors.red,
      'badge': 'SPECIAL\nUP TO',
      'hasSpecial': true,
    },
    {
      'title': 'Computers',
      'bgColor': Colors.grey.shade300,
      'badge': '',
      'hasSpecial': false,
    },
    {
      'title': 'Phones',
      'bgColor': Colors.grey.shade300,
      'badge': '',
      'hasSpecial': false,
    },
    {
      'title': 'Server Tools',
      'bgColor': Colors.grey.shade300,
      'badge': '',
      'hasSpecial': false,
    },
    {
      'title': 'Accessories',
      'bgColor': Colors.grey.shade300,
      'badge': '',
      'hasSpecial': false,
    },
  ].obs;

  // Method to update selected index
  void updateIndex(int index) {
    selectedIndex.value = index;
  }
  
  // Get current index
  int get currentIndex => selectedIndex.value;
  
  @override
  void onInit() {
    super.onInit();
    _startBannerTimer();
  }
  
  @override
  void onClose() {
    _bannerTimer?.cancel();
    _isDisposed = true;
    super.onClose();
  }
  
  // Update banner index
  void updateBannerIndex(int index) {
    currentBannerIndex.value = index;
    _restartBannerTimer();
    update(); // Notify listeners about the change
  }
  
  // Start auto-slide timer
  void _startBannerTimer() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_isDisposed) {
        currentBannerIndex.value = _getNextBannerIndex();
        update();
      }
    });
  }
  
  bool _isDisposed = false;
  
  // Restart banner timer
  void _restartBannerTimer() {
    _bannerTimer?.cancel();
    _startBannerTimer();
  }
  
  // Get the next banner index safely
  int _getNextBannerIndex() {
    if (currentBannerIndex.value >= 4) {
      return 0;
    }
    return currentBannerIndex.value + 1;
  }
}
