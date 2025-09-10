import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountSettingsController extends GetxController {
  // Observable variables
  final RxBool isLoading = false.obs;
  
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
  
  void changePassword() {
    // Logic to change password
    Get.toNamed('/change-password');
  }
  
  void deleteAccount() {
    // Logic to delete account
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              // Add delete account logic here
              Get.snackbar(
                'Account Deleted',
                'Your account has been deleted successfully',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
