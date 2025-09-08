import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  // Controllers for each OTP digit (6 digits)
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  // Timer related variables
  final int resendTimeout = 60; // 60 seconds
  final remainingTime = 60.obs;
  final canResend = false.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  // Handle OTP input changes
  void onOtpChange(int index, String value, BuildContext context) {
    if (value.length == 1 && index < otpControllers.length - 1) {
      FocusScope.of(context).nextFocus();
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).previousFocus();
    }
  }

  // Start the countdown timer
  void startTimer() {
    canResend.value = false;
    remainingTime.value = resendTimeout;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.value > 1) {
        remainingTime.value--;
      } else {
        _timer?.cancel();
        canResend.value = true;
      }
    });
  }

  // Resend OTP
  void resendOtp() {
    if (canResend.value) {
      // TODO: Implement resend OTP logic
      startTimer();
    }
  }

  // Verify OTP
  void verifyOtp() {
    final otp = otpControllers.map((controller) => controller.text).join();
    if (otp.length == 5) {
      // TODO: Implement OTP verification logic
      Get.snackbar(
        'Success',
        'OTP verified successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        'Please enter a valid OTP',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
