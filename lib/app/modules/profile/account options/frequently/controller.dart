import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FrequentlyController extends GetxController {
  // Observable variables
  final RxBool isLoading = false.obs;
  final RxList<Map<String, String>> frequentItems = <Map<String, String>>[].obs;
  final RxString selectedItem = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadFrequentItems();
  }
  
  @override
  void onReady() {
    super.onReady();
  }
  
  @override
  void onClose() {
    super.onClose();
  }
  
  // Private methods
  void _loadFrequentItems() {
    isLoading.value = true;
    
    // Simulate loading frequent items
    Future.delayed(const Duration(seconds: 1), () {
      frequentItems.addAll([
        {'title': 'Quick Order', 'description': 'Order your most frequently purchased items'},
        {'title': 'Recent Searches', 'description': 'View and repeat your recent product searches'},
        {'title': 'Favorite Categories', 'description': 'Browse your most visited product categories'},
        {'title': 'Saved Addresses', 'description': 'Manage your frequently used delivery addresses'},
        {'title': 'Quick Payment', 'description': 'Use your saved payment methods for faster checkout'},
        {'title': 'Recurring Orders', 'description': 'Set up automatic repeat orders for essential items'},
      ]);
      isLoading.value = false;
    });
  }
  
  // Public methods
  void selectItem(String title) {
    selectedItem.value = title;
    Get.snackbar(
      'Item Selected',
      'You selected: $title',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void addToFavorites(String title) {
    // Logic to add item to favorites
    Get.snackbar(
      'Added to Favorites',
      '$title has been added to your favorites',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void removeFromFavorites(String title) {
    // Logic to remove item from favorites
    Get.snackbar(
      'Removed from Favorites',
      '$title has been removed from your favorites',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void shareItem(String title) {
    // Logic to share item
    Get.snackbar(
      'Share Item',
      'Sharing: $title',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
