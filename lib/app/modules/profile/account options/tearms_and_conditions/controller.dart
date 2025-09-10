import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TearmsAndConditionsController extends GetxController {
  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool isAccepted = false.obs;
  final RxString lastUpdated = '2024-01-15'.obs;
  final RxList<Map<String, String>> termsSections = <Map<String, String>>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadTermsAndConditions();
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
  void _loadTermsAndConditions() {
    isLoading.value = true;
    
    // Simulate loading terms and conditions
    Future.delayed(const Duration(seconds: 1), () {
      termsSections.addAll([
        {'title': '1. Acceptance of Terms', 'content': 'By using our app, you agree to be bound by these Terms and Conditions.'},
        {'title': '2. User Accounts', 'content': 'You are responsible for maintaining the confidentiality of your account information.'},
        {'title': '3. Product Information', 'content': 'We strive to provide accurate product information, but we do not guarantee its accuracy.'},
        {'title': '4. Pricing and Payments', 'content': 'All prices are subject to change. Payment must be made in full before shipment.'},
        {'title': '5. Shipping and Delivery', 'content': 'We aim to deliver products within the estimated timeframes but delays may occur.'},
        {'title': '6. Returns and Refunds', 'content': 'Products can be returned within 30 days of delivery in original condition.'},
        {'title': '7. Privacy Policy', 'content': 'Your use of our app is also governed by our Privacy Policy.'},
        {'title': '8. Intellectual Property', 'content': 'All content on this app is the property of Elecktro E-commerce.'},
        {'title': '9. Limitation of Liability', 'content': 'We shall not be liable for any indirect or consequential damages.'},
        {'title': '10. Governing Law', 'content': 'These terms are governed by the laws of the jurisdiction in which we operate.'},
      ]);
      isLoading.value = false;
    });
  }
  
  // Public methods
  void acceptTerms() {
    isAccepted.value = true;
    Get.snackbar(
      'Terms Accepted',
      'You have accepted the Terms and Conditions',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void declineTerms() {
    isAccepted.value = false;
    Get.dialog(
      AlertDialog(
        title: const Text('Terms Declined'),
        content: const Text('You must accept the Terms and Conditions to continue using our services.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  void downloadTerms() {
    // Logic to download terms as PDF
    Get.snackbar(
      'Download Terms',
      'Terms and Conditions PDF download started',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void printTerms() {
    // Logic to print terms
    Get.snackbar(
      'Print Terms',
      'Terms and Conditions sent to printer',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void shareTerms() {
    // Logic to share terms
    Get.snackbar(
      'Share Terms',
      'Terms and Conditions share dialog opened',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
