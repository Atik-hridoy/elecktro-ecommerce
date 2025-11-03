import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';

class AccountSettingsView extends GetView<AccountSettingsController> {
  const AccountSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Account Settings',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description Text
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: const Text(
                'Manage your account settings including language preferences, password, and account deletion.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF9E9E9E),
                  height: 1.6,
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Language Option
            InkWell(
              onTap: _showLanguageDialog,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.language,
                      size: 24,
                      color: Color(0xFF424242),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Language',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF424242),
                        ),
                      ),
                    ),
                    Obx(() => Text(
                      controller.currentLanguage.value == 'en' ? 'English' : 'Spanish',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Color(0xFF9E9E9E),
                      ),
                    )),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Color(0xFF9E9E9E),
                    ),
                  ],
                ),
              ),
            ),
            
            // Divider
            const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFE0E0E0),
              indent: 60,
            ),
            
            // Change Password Option
            InkWell(
              onTap: controller.navigateToChangePassword,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: const Row(
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 24,
                      color: Color(0xFF424242),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Change Password',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF424242),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Color(0xFF9E9E9E),
                    ),
                  ],
                ),
              ),
            ),
            
            // Divider
            const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFE0E0E0),
              indent: 60,
            ),
            
            // Delete Account Option
            InkWell(
              onTap: _showDeleteAccountDialog,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: const Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      size: 24,
                      color: Colors.red,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Delete Account',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Color(0xFF9E9E9E),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Language',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              
              // English Option
              Obx(() => InkWell(
                onTap: () {
                  if (controller.currentLanguage.value != 'en') {
                    controller.changeLanguage('en');
                    Get.back();
                    _showLanguageUpdatedSnackbar();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: controller.currentLanguage.value == 'en' 
                        ? const Color(0xFFE6F8F3) 
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: controller.currentLanguage.value == 'en'
                          ? const Color(0xFF044D37)
                          : const Color(0xFFE0E0E0),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'en',
                        groupValue: controller.currentLanguage.value,
                        onChanged: (value) {
                          if (value != null) {
                            controller.changeLanguage(value);
                            Get.back();
                            _showLanguageUpdatedSnackbar();
                          }
                        },
                        activeColor: const Color(0xFF044D37),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'English',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF424242),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
              
              const SizedBox(height: 12),
              
              // Spanish Option
              Obx(() => InkWell(
                onTap: () {
                  if (controller.currentLanguage.value != 'es') {
                    controller.changeLanguage('es');
                    Get.back();
                    _showLanguageUpdatedSnackbar();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: controller.currentLanguage.value == 'es' 
                        ? const Color(0xFFE6F8F3) 
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: controller.currentLanguage.value == 'es'
                          ? const Color(0xFF044D37)
                          : const Color(0xFFE0E0E0),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'es',
                        groupValue: controller.currentLanguage.value,
                        onChanged: (value) {
                          if (value != null) {
                            controller.changeLanguage(value);
                            Get.back();
                            _showLanguageUpdatedSnackbar();
                          }
                        },
                        activeColor: const Color(0xFF044D37),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Spanish',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF424242),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
              
              const SizedBox(height: 24),
              
              // Close Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF044D37),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          'Delete Account',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Color(0xFF424242),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              controller.deleteAccount();
              Get.back();
              // Show success message
              Get.snackbar(
                'Account Deleted',
                'Your account has been deleted successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red.withOpacity(0.9),
                colorText: Colors.white,
                margin: const EdgeInsets.all(16),
                borderRadius: 8,
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageUpdatedSnackbar() {
    Get.snackbar(
      'Language Updated',
      'Your language preference has been updated successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF044D37).withOpacity(0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }
}
