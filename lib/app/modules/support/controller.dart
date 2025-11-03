import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'create_help_service.dart';

class SupportController extends GetxController {
  // Text Controllers
  final TextEditingController contactController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  
  // Service
  final CreateHelpService _helpService = CreateHelpService();
  
  // Observable variables
  final RxBool isLoading = false.obs;
  final RxString selectedIssueType = ''.obs;
  final RxString subject = ''.obs;
  final RxString message = ''.obs;
  final RxList<String> issueTypes = <String>[].obs;
  final RxList<Map<String, dynamic>> supportTickets = <Map<String, dynamic>>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadSupportData();
  }
  
  @override
  void onReady() {
    super.onReady();
  }
  
  @override
  void onClose() {
    contactController.dispose();
    messageController.dispose();
    super.onClose();
  }
  
  // Private methods
  void _loadSupportData() {
    isLoading.value = true;
    
    // Simulate loading support data
    Future.delayed(const Duration(seconds: 1), () {
      issueTypes.addAll([
        'Technical Issue',
        'Billing Problem',
        'Product Inquiry',
        'Shipping Question',
        'Account Issue',
        'Feature Request',
        'Bug Report',
        'Other',
      ]);
      
      supportTickets.addAll([
        {
          'id': 'TKT001',
          'subject': 'Login Problem',
          'status': 'Resolved',
          'date': '2024-01-10',
          'priority': 'High',
        },
        {
          'id': 'TKT002',
          'subject': 'Payment Failed',
          'status': 'In Progress',
          'date': '2024-01-12',
          'priority': 'Medium',
        },
        {
          'id': 'TKT003',
          'subject': 'Product Information',
          'status': 'Open',
          'date': '2024-01-14',
          'priority': 'Low',
        },
      ]);
      
      isLoading.value = false;
    });
  }
  
  // Public methods
  void selectIssueType(String type) {
    selectedIssueType.value = type;
  }
  
  void updateSubject(String value) {
    subject.value = value;
  }
  
  void updateMessage(String value) {
    message.value = value;
  }
  
  void submitTicket() {
    if (selectedIssueType.isEmpty || subject.isEmpty || message.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    // Simulate ticket submission
    isLoading.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      
      // Add new ticket to the list
      final newTicket = {
        'id': 'TKT${(supportTickets.length + 1).toString().padLeft(3, '0')}',
        'subject': subject.value,
        'status': 'Open',
        'date': DateTime.now().toString().split(' ')[0],
        'priority': 'Medium',
      };
      supportTickets.add(newTicket);
      
      // Clear form
      selectedIssueType.value = '';
      subject.value = '';
      message.value = '';
      
      Get.snackbar(
        'Success',
        'Your support ticket has been submitted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    });
  }
  
  void viewTicketDetails(String ticketId) {
    // Logic to view ticket details
    Get.snackbar(
      'Ticket Details',
      'Viewing details for ticket: $ticketId',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void closeTicket(String ticketId) {
    // Logic to close ticket
    Get.dialog(
      AlertDialog(
        title: const Text('Close Ticket'),
        content: const Text('Are you sure you want to close this ticket?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              // Update ticket status
              final ticketIndex = supportTickets.indexWhere((t) => t['id'] == ticketId);
              if (ticketIndex != -1) {
                supportTickets[ticketIndex]['status'] = 'Closed';
              }
              Get.snackbar(
                'Ticket Closed',
                'Ticket $ticketId has been closed',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  
  void callSupport() {
    // Logic to call support
    Get.snackbar(
      'Call Support',
      'Dialing support number...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void emailSupport() {
    // Logic to email support
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@elecktro.com',
      queryParameters: {
        'subject': 'Support Request',
      },
    );
    
    Get.snackbar(
      'Email Support',
      'Opening email client...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void liveChat() {
    // Logic to start live chat
    Get.snackbar(
      'Live Chat',
      'Connecting to live chat agent...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  Future<void> submitSupport() async {
    // Validate fields
    if (contactController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
      return;
    }
    
    // Validate email format
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(contactController.text.trim())) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
      return;
    }
    
    if (messageController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your message',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
      return;
    }
    
    try {
      // Call API
      isLoading.value = true;
      
      final response = await _helpService.createHelpRequest(
        email: contactController.text.trim(),
        message: messageController.text.trim(),
      );
      
      print('Help request created: $response');
      
      // Clear form
      contactController.clear();
      messageController.clear();
      
      // Show success message
      Get.snackbar(
        'Success',
        'Your support request has been submitted successfully. We will contact you soon.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF00BFA5),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );
      
      // Optionally go back
      Future.delayed(const Duration(seconds: 1), () {
        Get.back();
      });
    } catch (e) {
      print('Error submitting support request: $e');
      
      // Show error message
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
