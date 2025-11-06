import 'package:elecktro_ecommerce/app/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountSettingsController extends GetxController {
  // Observable variables
  final RxBool isLoading = false.obs;
  final RxString currentLanguage = 'en'.obs;
  
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
  
  void deleteAccount() {
    // Logic to delete account - API call would go here
    print('Account deletion requested');
    // Add API call here to delete account
    // await accountService.deleteAccount();
  }
}
