import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/model/update_profile_model.dart';
import '../views/services/update_profile_service.dart';

class AccountController extends GetxController {
  // Services
  final UpdateProfileService _profileService = UpdateProfileService();
  
  // Loading state
  final RxBool isLoading = false.obs;
  
  // User profile data
  final RxString fullName = 'Asad Ujjaman'.obs;
  final RxString email = 'asad@example.com'.obs;
  final RxString phone = '+1 234 567 8900'.obs;
  final RxString address = '20 Cooper Square, New York'.obs;
  final RxString gender = 'Male'.obs;
  final RxString dateOfBirth = '17 Dec, 1990'.obs;
  final RxString password = '••••••••'.obs;

  // Form controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Initialize form controllers with current values
    fullNameController.text = fullName.value.split(" ").first;
    lastNameController.text = fullName.value.split(" ").last;
    emailController.text = email.value;
    phoneController.text = phone.value;
    addressController.text = address.value;
    genderController.text = gender.value;
    passwordController.text = password.value;
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;
      
      // Create the profile model from form data
      final profileData = UpdateProfileModel(
        firstName: fullNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        gender: genderController.text.trim().toLowerCase(),
        address: addressController.text.trim(), // Include address in the update
      );

      // Call the update service
      final response = await _profileService.updateProfile(
        profileData: profileData,
        // If you have an image file, pass it here
        // profileImage: imageFile,
      );

      if (response['success'] == true) {
        // Update local state on success
        fullName.value = '${profileData.firstName} ${profileData.lastName}';
        email.value = emailController.text.trim();
        phone.value = phoneController.text.trim();
        address.value = addressController.text.trim();
        gender.value = genderController.text.trim();
        
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          backgroundColor: Colors.green[50],
          colorText: Colors.green[800],
        );
        
        // Optionally navigate back
        Get.back();
      } else {
        throw Exception(response['error'] ?? 'Failed to update profile');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red[50],
        colorText: Colors.red[800],
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updatePassword(String newPassword) {
    if (newPassword.length >= 8) {
      password.value = '•' * 8; // Mask password

      Get.snackbar(
        'Success',
        'Password updated successfully',
        backgroundColor: Colors.green[50],
        colorText: Colors.green[800],
      );
    } else {
      Get.snackbar(
        'Error',
        'Password must be at least 8 characters long',
        backgroundColor: Colors.red[50],
        colorText: Colors.red[800],
      );
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    genderController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
