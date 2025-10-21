// File: lib/core/switching_language_facilities/localization_service.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService extends GetxService {
  static LocalizationService get to => Get.find();
  
  // Observable current language
  final RxString currentLanguage = 'en'.obs;

  Future<LocalizationService> init() async {
    // Load saved language from shared preferences
    final prefs = Get.find<SharedPreferences>();
    String? languageCode = prefs.getString('language_code');
    
    if (languageCode != null) {
      currentLanguage.value = languageCode;
      // Update locale immediately on app start
      await Get.updateLocale(Locale(languageCode));
    } else {
      // Set default language
      currentLanguage.value = 'en';
      await prefs.setString('language_code', 'en');
    }
    
    return this;
  }

  Future<void> changeLanguage(String languageCode) async {
    if (currentLanguage.value == languageCode) return;
    
    // Update current language
    currentLanguage.value = languageCode;
    
    // Save to shared preferences
    final prefs = Get.find<SharedPreferences>();
    await prefs.setString('language_code', languageCode);
    
    // Update app locale
    await Get.updateLocale(Locale(languageCode));
  }

  Locale getCurrentLocale() {
    return Locale(currentLanguage.value);
  }

  bool isCurrentLanguage(String languageCode) {
    return currentLanguage.value == languageCode;
  }
  
  bool get isEnglish => currentLanguage.value == 'en';
  bool get isSpanish => currentLanguage.value == 'es';
}