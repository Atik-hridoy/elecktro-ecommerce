import 'package:elecktro_ecommerce/app/core/util/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/routes/app_pages.dart';

import '../views/services/get_profile_service.dart';
import '../views/model/get_profile_model.dart';

class ProfileController extends GetxController {
  // Services
  final GetProfileService _profileService = Get.put<GetProfileService>(GetProfileService());

  // User information
  var name = ''.obs;
  var email = ''.obs;
  var address = ''.obs;
  var profileImageUrl = ''.obs;
  var isLoading = false.obs;
  var error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfileData();
  }

  // Fetch profile data
  Future<void> fetchProfileData() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      AppLogger.info('Fetching profile data...');
      final profileData = await _profileService.getProfile();
      
      if (profileData != null && profileData.success) {
        // Update the user information from the API response
        final fullName = '${profileData.data.firstName} ${profileData.data.lastName}'.trim();
        name.value = fullName;
        email.value = profileData.data.email ?? ''; // Add this line to save email
        address.value = profileData.data.address;
        
        // Update profile image URL if available
        if (profileData.data.image.isNotEmpty) {
          profileImageUrl.value = profileData.data.image;
        }
        
        AppLogger.success('Profile data loaded successfully');
        AppLogger.debug('Name: $fullName', details: {'Name': fullName});
        AppLogger.debug('Address: ${profileData.data.address}', details: {'Address': profileData.data.address});
      } else {
        final errorMsg = profileData?.message ?? 'Failed to load profile';
        error.value = errorMsg;
        AppLogger.error('Failed to load profile: $errorMsg');
      }
    } catch (e, stackTrace) {
      final errorMsg = 'Error loading profile: $e';
      error.value = errorMsg;
      AppLogger.error(
        errorMsg,
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update profile information
  void updateProfile({
    required String newName,
    required String newEmail,
    required String newAddress,
  }) {
    // This method can be updated later to handle profile updates
    // For now, just update the local values
    if (newName.isNotEmpty) {
      name.value = newName;
    }
    if (newEmail.isNotEmpty) {
      email.value = newEmail;
    }
    if (newAddress.isNotEmpty) {
      address.value = newAddress;
    }
  }
  
  // Refresh profile data
  Future<void> refreshProfile() async {
    await fetchProfileData();
  }
  
  // Logout user
  Future<void> logout() async {
    try {
      isLoading.value = true;
      // Clear user data
      name.value = '';
      email.value = '';
      address.value = '';
      profileImageUrl.value = '';
      
      // Clear local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      // Navigate to auth screen
      Get.offAllNamed(Routes.authSignIn);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to logout: $e',
        backgroundColor: Colors.red[50],
        colorText: Colors.red[800],
      );
    } finally {
      isLoading.value = false;
    }
  }
}
