// File: lib/modules/profile/controllers/profile_info_controller.dart

import 'package:elecktro_ecommerce/app/core/util/app_logger.dart';
import 'package:elecktro_ecommerce/app/core/stroage/storage_services.dart';
import 'package:elecktro_ecommerce/app/modules/update_profile/update_profile_service.dart';
import 'package:elecktro_ecommerce/app/modules/update_profile/update_profile_model.dart';
//import 'package:elecktro_ecommerce/app/modules/profile/views/services/update_profile_service.dart';
import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ProfileInfoController extends GetxController {
  // 🔹 Form key
  final formKey = GlobalKey<FormState>();

  // 🔹 Text controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final addressController = TextEditingController();

  // 🔹 Services
  final UpdateProfileService _profileService = Get.put<UpdateProfileService>(UpdateProfileService());

  // 🔹 Reactive variables
  final selectedGender = ''.obs;
  final isLoading = false.obs;

  // 🔹 Gender options
  final List<String> genderOptions = [
    'male'.tr,
    'female'.tr,
    'other'.tr,
  ];

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    addressController.dispose();
    super.onClose();
  }

  // 🔹 Load initial data
  void _loadInitialData() {
    // Load any initial data if needed
  }

  // 🔹 Validation
  String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'first_name_required'.tr;
    }
    if (value.trim().length < 2) {
      return 'first_name_min_length'.tr;
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'last_name_required'.tr;
    }
    if (value.trim().length < 2) {
      return 'last_name_min_length'.tr;
    }
    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'address_required'.tr;
    }
    if (value.trim().length < 10) {
      return 'address_min_length'.tr;
    }
    return null;
  }

  // 🔹 Submit form
  void submitForm() {
    if (formKey.currentState!.validate()) {
      updateProfile();
    }
  }

  // 🔹 Update profile
  Future<void> updateProfile() async {
    try {
      isLoading.value = true;

      // Create profile model
      final profileData = UpdateProfileModel(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        gender: selectedGender.value,
        address: addressController.text.trim(), // Default value, can be made dynamic if needed
      );

      // Log the data being sent
      AppLogger.info('Sending profile update data', tag: 'ProfileUpdate');
      
      // Call the update service
      final response = await _profileService.updateProfile(profileData: profileData);
      
      // Log the response received

      if (response['success'] == true) {
        // Update local state on success
        // fullName.value = '${profileData.firstName} ${profileData.lastName}';
        // email.value = emailController.text.trim();
        // phone.value = phoneController.text.trim();
        // address.value = addressController.text.trim();
        // gender.value = genderController.text.trim();
        
        // Mark profile as completed
        await LocalStorage.markProfileAsCompleted();
        
        AppLogger.success('Profile updated successfully', tag: 'ProfileUpdate');
        Get.snackbar(
          'success'.tr,
          'profile_update_success'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        Get.offAllNamed(Routes.home);
      } else {
        final errorMessage = response['message'] ?? 'update_failed'.tr;
        AppLogger.error('Profile update failed: $errorMessage', tag: 'ProfileUpdate');
        throw Exception(errorMessage);
      }
    } catch (error, stackTrace) {
      AppLogger.error(
        'Error updating profile', 
        tag: 'ProfileUpdate',
        error: error,
        stackTrace: stackTrace,
      );
      
      Get.snackbar(
        'error'.tr,
        error.toString().tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 🔹 Reset / Clear
  void clearForm() {
    firstNameController.clear();
    lastNameController.clear();
    addressController.clear();
    selectedGender.value = '';
  }

  // 🔹 Check if form has changes
  bool get hasChanges {
    return firstNameController.text.isNotEmpty ||
        lastNameController.text.isNotEmpty ||
        selectedGender.value.isNotEmpty ||
        addressController.text.isNotEmpty;
  }
}