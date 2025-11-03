import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'get_faq_service.dart';

class FaqController extends GetxController {
  // Observable variables
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> faqItems = <Map<String, dynamic>>[].obs;
  final RxString searchQuery = ''.obs;
  final RxList<Map<String, dynamic>> filteredFaqItems = <Map<String, dynamic>>[].obs;
  final RxSet<int> expandedItems = <int>{}.obs;
  
  // Service
  final GetFaqService _faqService = GetFaqService();
  
  @override
  void onInit() {
    super.onInit();
    _loadFaqItems();
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
  Future<void> _loadFaqItems() async {
    try {
      isLoading.value = true;
      
      // Fetch FAQs from API
      final faqs = await _faqService.getFaqs();
      
      // Map API response to local format
      faqItems.clear();
      for (var faq in faqs) {
        faqItems.add({
          'question': faq['question'] ?? faq['title'] ?? 'No question',
          'answer': faq['answer'] ?? faq['description'] ?? 'No answer available',
          'category': faq['category'] ?? 'General',
          'isExpanded': false,
        });
      }
      
      filteredFaqItems.assignAll(faqItems);
      print('Loaded ${faqItems.length} FAQs from API');
    } catch (e) {
      print('Error loading FAQs: $e');
      
      // Fallback to sample data if API fails
      _loadSampleFaqItems();
      
      Get.snackbar(
        'Notice',
        'Using sample FAQ data. Please check your connection.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Fallback method with sample data
  void _loadSampleFaqItems() {
    faqItems.addAll([
      {
        'question': 'How do I create an account?',
        'answer': 'To create an account, click on the "Sign Up" button and fill in your details including name, email, and password.',
        'category': 'Account',
        'isExpanded': false,
      },
      {
        'question': 'How can I reset my password?',
        'answer': 'Click on "Forgot Password" on the login screen and enter your email address. You will receive a password reset link.',
        'category': 'Account',
        'isExpanded': false,
      },
      {
        'question': 'What payment methods do you accept?',
        'answer': 'We accept credit cards, debit cards, PayPal, and other popular payment methods.',
        'category': 'Payment',
        'isExpanded': false,
      },
      {
        'question': 'How long does shipping take?',
        'answer': 'Standard shipping takes 3-5 business days. Express shipping is available for 1-2 business days.',
        'category': 'Shipping',
        'isExpanded': false,
      },
      {
        'question': 'What is your return policy?',
        'answer': 'You can return items within 30 days of delivery. Items must be in original condition with tags attached.',
        'category': 'Returns',
        'isExpanded': false,
      },
      {
        'question': 'How do I track my order?',
        'answer': 'You can track your order by going to "My Orders" in your account and clicking on the order number.',
        'category': 'Orders',
        'isExpanded': false,
      },
    ]);
    filteredFaqItems.assignAll(faqItems);
  }
  
  // Public methods
  void toggleItemExpansion(int index) {
    if (expandedItems.contains(index)) {
      expandedItems.remove(index);
    } else {
      expandedItems.add(index);
    }
  }
  
  void searchFaq(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredFaqItems.assignAll(faqItems);
    } else {
      filteredFaqItems.assignAll(
        faqItems.where((item) =>
          item['question'].toString().toLowerCase().contains(query.toLowerCase()) ||
          item['answer'].toString().toLowerCase().contains(query.toLowerCase()) ||
          item['category'].toString().toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }
  
  void filterByCategory(String category) {
    if (category == 'All') {
      filteredFaqItems.assignAll(faqItems);
    } else {
      filteredFaqItems.assignAll(
        faqItems.where((item) => item['category'] == category),
      );
    }
  }
  
  void contactSupport() {
    // Logic to contact support
    Get.snackbar(
      'Contact Support',
      'Redirecting to support page...',
      snackPosition: SnackPosition.BOTTOM,
    );
    Get.toNamed('/support');
  }
  
  void rateFaqHelpful(int index, bool isHelpful) {
    // Logic to rate FAQ as helpful or not
    String message = isHelpful ? 'Thank you for your feedback!' : 'We\'ll improve this answer.';
    Get.snackbar(
      'Feedback Received',
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
