import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountSettingsController extends GetxController {
  // Observable variables
  final RxBool isLoading = false.obs;
  final RxString currentLanguage = 'en'.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Initialize any data or services here
    _loadAccountSettings();
  }
  
  @override
  void onReady() {
    super.onReady();
    // Called after the widget is rendered
  }
  
  @override
  void onClose() {
    // Clean up resources
    super.onClose();
  }
  
  // Private methods
  void _loadAccountSettings() {
    // Simulate loading account settings
    isLoading.value = true;
    
    // Add your logic to load account settings from API or database
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
    });
  }
  
  // Public methods
  void updateAccountSettings() {
    // Logic to update account settings
    Get.snackbar(
      'Success',
      'Account settings updated successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void changeLanguage(String language) {
    currentLanguage.value = language;
    // Add logic to save language preference to storage
    // LocalStorage.saveLanguage(language);
    print('Language changed to: $language');
  }
  
  void navigateToChangePassword() {
    // Logic to navigate to change password screen
    Get.toNamed('/change-password');
    // Or you can show a dialog/bottom sheet here
  }
  
  void deleteAccount() {
    // Logic to delete account - API call would go here
    print('Account deletion requested');
    // Add API call here to delete account
    // await accountService.deleteAccount();
  }
}
