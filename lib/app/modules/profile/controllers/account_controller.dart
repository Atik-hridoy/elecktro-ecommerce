import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
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

  void updateProfile({
    String? newName,
    String? newEmail,
    String? newPhone,
    String? newAddress,
    String? newGender,
    String? newDob,
  }) {
    if (newName != null && newName.isNotEmpty) fullName.value = newName;
    if (newEmail != null && newEmail.isNotEmpty) email.value = newEmail;
    if (newPhone != null && newPhone.isNotEmpty) phone.value = newPhone;
    if (newAddress != null && newAddress.isNotEmpty) address.value = newAddress;
    if (newGender != null && newGender.isNotEmpty) gender.value = newGender;
    if (newDob != null && newDob.isNotEmpty) dateOfBirth.value = newDob;

    Get.snackbar(
      'Success',
      'Profile updated successfully',
      backgroundColor: Colors.green[50],
      colorText: Colors.green[800],
    );
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
