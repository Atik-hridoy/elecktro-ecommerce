import 'package:elecktro_ecommerce/app/modules/profile/views/model/update_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/services/update_profile_service.dart';
import '../views/services/get_profile_service.dart';


class AccountController extends GetxController {
  // Services
  final UpdateProfileService _profileService = UpdateProfileService();
  final GetProfileService _getProfileService = GetProfileService();
  
  // Loading state
  final RxBool isLoading = false.obs;
  
  // User profile data
  final RxString fullName = ''.obs;
  final RxString email = ''.obs;
  final RxString phone = ''.obs;
  final RxString address = ''.obs;
  final RxString gender = ''.obs;
  final RxString registrationNo = ''.obs;
  final RxString dateOfBirth = ''.obs;
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
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    try {
      isLoading.value = true;
      final profileData = await _getProfileService.getProfile();
      
      if (profileData != null) {
        // Update reactive variables with profile data
        fullName.value = '${profileData.data.firstName} ${profileData.data.lastName}';
        gender.value = profileData.data.gender;
        address.value = profileData.data.address;
        registrationNo.value = profileData.data.registrationNo;
        phone.value = profileData.data.phone;
        
        // Update form controllers
        fullNameController.text = profileData.data.firstName;
        lastNameController.text = profileData.data.lastName;
        genderController.text = profileData.data.gender;
        addressController.text = profileData.data.address;
        phoneController.text = profileData.data.phone;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;
      
      // Create the profile model from form data
      final profileData = UpdateProfileModelInsideApp(
        firstName: fullNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        gender: genderController.text.trim().toLowerCase(),
        address: addressController.text.trim(),
        phone: phoneController.text.trim(),
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