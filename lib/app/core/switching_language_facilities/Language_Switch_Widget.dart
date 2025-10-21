// File: lib/core/switching_language_facilities/Language_Switch_Widget.dart
import 'package:elecktro_ecommerce/app/core/switching_language_facilities/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LanguageSwitch extends StatefulWidget {
  final Function(String)? onLanguageChanged;

  const LanguageSwitch({
    super.key,
    this.onLanguageChanged,
  });

  @override
  State<LanguageSwitch> createState() => _LanguageSwitchState();
}

class _LanguageSwitchState extends State<LanguageSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late LocalizationService _locService;

  @override
  void initState() {
    super.initState();
    _locService = Get.find<LocalizationService>();
    
    // Initialize animation based on current language
    final isEnglish = _locService.currentLanguage.value == 'en';
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: isEnglish ? 1.0 : 0.0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _toggleLanguage() async {
    final currentLang = _locService.currentLanguage.value;
    final isEnglish = currentLang == 'en';
    final newLang = isEnglish ? 'es' : 'en';
    
    // Animate
    if (isEnglish) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    
    // Change language
    await _locService.changeLanguage(newLang);
    
    // Optional callback
    widget.onLanguageChanged?.call(newLang);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isEnglish = _locService.currentLanguage.value == 'en';
      
      return GestureDetector(
        onTap: _toggleLanguage,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 110,
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: const Color(0xFFE6F8F3),
            border: Border.all(color: const Color(0xFF09B782), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                alignment: isEnglish
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF09B782),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF09B782).withOpacity(0.3),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                      child: Text(
                        isEnglish ? "🇬🇧" : "🇪🇸",
                        key: ValueKey(isEnglish),
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment:
                    isEnglish ? Alignment.centerRight : Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    isEnglish ? "EN" : "ES",
                    style: const TextStyle(
                      color: Color(0xFF09B782),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

// USAGE in AuthView:
// const LanguageSwitch()
// 
// Or with callback:
// LanguageSwitch(
//   onLanguageChanged: (lang) => print('Changed to: $lang'),
// )