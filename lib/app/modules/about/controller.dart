import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutController extends GetxController {
  // Observable variables
  final RxBool isLoading = false.obs;
  final RxString appVersion = '1.0.0'.obs;
  final RxString companyName = 'Elecktro E-commerce'.obs;
  final RxString companyEmail = 'support@elecktro.com'.obs;
  final RxString companyWebsite = 'www.elecktro.com'.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadAboutData();
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
  void _loadAboutData() {
    isLoading.value = true;
    
    // Simulate loading about data
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
    });
  }
  
  // Public methods
  void contactSupport() {
    // Logic to contact support
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: companyEmail.value,
      queryParameters: {
        'subject': 'Support Request from About Page',
      },
    );
    
    // Add your email launch logic here
    Get.snackbar(
      'Contact Support',
      'Email client would open with: ${companyEmail.value}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void visitWebsite() {
    // Logic to visit company website
    Get.snackbar(
      'Visit Website',
      'Browser would open: ${companyWebsite.value}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void shareApp() {
    // Logic to share the app
    Get.snackbar(
      'Share App',
      'Share dialog would open',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
