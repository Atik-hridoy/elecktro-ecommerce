import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/core/stroage/storage_services.dart';
import 'package:elecktro_ecommerce/app/core/stroage/storage_keys.dart';
import 'package:elecktro_ecommerce/app/modules/auth/services/sugnup_service.dart';
import 'package:elecktro_ecommerce/app/routes/app_pages.dart';

class AuthSignUpController extends GetxController {
  final AuthCreateUserService _authService = AuthCreateUserService();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isLoggedIn = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await _authService.init();
    // Check if user is already logged in
    isLoggedIn.value = LocalStorage.isLogIn;
  }

  // Register new user with email
  Future<void> registerUser(String email) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _authService.registerSeller(email: email);

      if (response['success'] == true) {
        // Navigate to OTP verification screen
        Get.toNamed(Routes.otp, arguments: {'email': email});
      } else {
        errorMessage.value = response['message'] ?? 'Registration failed';
        Get.snackbar(
          'Error', 
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again.';
      Get.snackbar(
        'Error', 
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Call this when user successfully logs in
  void login(String token, String refreshToken, String email) async {
    await LocalStorage.setString(LocalStorageKeys.token, token);
    await LocalStorage.setString(LocalStorageKeys.refreshToken, refreshToken);
    await LocalStorage.setString(LocalStorageKeys.myEmail, email);
    await LocalStorage.setBool(LocalStorageKeys.isLogIn, true);
    isLoggedIn.value = true;
  }
  
  // Call this when user logs out
  Future<void> logout() async {
    await LocalStorage.removeAllPrefData();
    isLoggedIn.value = false;
    Get.offAllNamed(Routes.authSignIn);
  }
}