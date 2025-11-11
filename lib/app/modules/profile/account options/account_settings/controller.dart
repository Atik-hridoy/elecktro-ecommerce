import 'package:elecktro_ecommerce/app/providers/language_provider.dart';
import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/delete_account_service.dart';

class AccountSettingsController extends GetxController {
  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool isDeletingAccount = false.obs;
  final RxString currentLanguage = 'en'.obs;
  
  // Service
  final DeleteAccountService _deleteAccountService = DeleteAccountService();
  
  @override
  void onInit() {
    super.onInit();
    // Initialize any data or services here
    _loadAccountSettings();
    _loadSavedLanguage();
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
  
  // Load saved language preference
  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString('app_language') ?? 'en';
      currentLanguage.value = savedLanguage;
      
      // Update GetX locale if different from current
      final currentLocale = Get.locale?.languageCode ?? 'en';
      if (currentLocale != savedLanguage) {
        _updateLocale(savedLanguage);
      }
    } catch (e) {
      print('Error loading saved language: $e');
    }
  }
  
  // Update GetX locale
  void _updateLocale(String languageCode) {
    Locale locale;
    switch (languageCode) {
      case 'es':
        locale = const Locale('es', 'ES');
        break;
      case 'en':
      default:
        locale = const Locale('en', 'US');
        break;
    }
    Get.updateLocale(locale);
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
  
  Future<void> changeLanguage(String language) async {
    try {
      // Update observable
      currentLanguage.value = language;
      
      // Update GetX locale
      _updateLocale(language);
      
      // Save to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_language', language);
      
      // Update LanguageProvider to sync with Provider-based widgets
      final context = Get.context;
      if (context != null) {
        final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
        final locale = language == 'es' 
            ? const Locale('es', 'ES') 
            : const Locale('en', 'US');
        await languageProvider.setLocale(locale);
      }
      
      print('Language changed to: $language');
    } catch (e) {
      print('Error changing language: $e');
      Get.snackbar(
        'error'.tr,
        'Failed to change language',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  void navigateToChangePassword() {
    // Logic to navigate to change password screen
    Get.toNamed('/change-password');
    // Or you can show a dialog/bottom sheet here
  }
  
  Future<void> deleteAccount() async {
    try {
      isDeletingAccount.value = true;
      
      // Call the delete account service
      final result = await _deleteAccountService.deleteAccount();
      
      if (result['success'] == true) {
        // Show success message
        Get.snackbar(
          'account_deleted'.tr,
          'account_deleted_success'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 2),
        );
        
        // Wait a moment for the user to see the message
        await Future.delayed(const Duration(seconds: 1));
        
        // Navigate to login screen and clear all previous routes
        Get.offAllNamed(Routes.authSignIn);
      }
    } catch (e) {
      // Show error message
      Get.snackbar(
        'error'.tr,
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isDeletingAccount.value = false;
    }
  }
}
