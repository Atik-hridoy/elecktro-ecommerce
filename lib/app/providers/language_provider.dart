import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en', 'US');
  final String _prefKey = 'app_language'; // Use same key as AccountSettingsController

  Locale get locale => _locale;

  LanguageProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_prefKey) ?? 'en';
    _locale = languageCode == 'es' 
        ? const Locale('es', 'ES') 
        : const Locale('en', 'US');
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (!['en', 'es'].contains(locale.languageCode)) return;
    
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, locale.languageCode);
    notifyListeners();
  }

  bool isEnglish() => _locale.languageCode == 'en';
  
  bool isSpanish() => _locale.languageCode == 'es';
  
  bool isRTL() => false; // RTL support removed with Arabic
  
  List<Locale> get supportedLocales => const [
        Locale('en', 'US'),
        Locale('es', 'ES'),
      ];
}
