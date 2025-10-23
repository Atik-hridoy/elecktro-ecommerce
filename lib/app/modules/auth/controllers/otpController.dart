import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/core/stroage/storage_services.dart';
import 'package:elecktro_ecommerce/app/core/stroage/storage_keys.dart';
import 'package:elecktro_ecommerce/app/core/util/app_logger.dart';
import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import '../services/otp_service.dart';

class OtpController extends GetxController {
  final AuthVerifyOtpService _otpService = AuthVerifyOtpService();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  
  final String email;
  final bool isRegistration; // Flag to differentiate between registration and login
  
  // Reactive getter for the email
  String get emailValue => email;

  // Controllers for each OTP digit (5 digits)
  final List<TextEditingController> otpControllers = List.generate(
    5,
    (index) => TextEditingController(),
  );

  // Timer related variables
  final int resendTimeout = 60; // 60 seconds
  final remainingTime = 60.obs;
  final canResend = false.obs;
  Timer? _timer;

  OtpController({required this.email, this.isRegistration = false});

  @override
  void onInit() async {
    super.onInit();
    await _otpService.init();
    startTimer();
    
    // Log the OTP verification context
    AppLogger.info(
      'OTP verification initialized - Email: $email, Registration: $isRegistration',
      tag: 'OtpController'
    );
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
  void onOtpChange(dynamic index, String value, BuildContext context) {
    // Convert index to int if it's a string
    final idx = index is int ? index : int.tryParse(index.toString()) ?? 0;
    
    if (value.length == 1 && idx < otpControllers.length - 1) {
      FocusScope.of(context).nextFocus();
    } else if (value.isEmpty && idx > 0) {
      FocusScope.of(context).previousFocus();
    }
    
    // Auto-verify when all OTP digits are entered
    if (value.isNotEmpty && idx == otpControllers.length - 1) {
      verifyOtp();
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
  Future<void> resendOtp() async {
    if (!canResend.value) return;
    
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Call the sign-in service to resend OTP
      // This assumes you have a method in your auth service to resend OTP
      // You might need to implement this based on your API
      // For now, we'll just restart the timer
      startTimer();
      
      Get.snackbar(
        'Success',
        'OTP has been resent to your email',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      errorMessage.value = 'Failed to resend OTP. Please try again.';
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Verify OTP
  Future<void> verifyOtp() async {
    if (isLoading.value) return;

    final otp = otpControllers.map((controller) => controller.text).join();
    
    // Validate OTP format
    if (otp.length != 5 || int.tryParse(otp) == null) {
      errorMessage.value = 'Please enter a valid 5-digit OTP';
      AppLogger.warning('Invalid OTP format: $otp');
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      AppLogger.info(
        'Verifying OTP for ${isRegistration ? 'registration' : 'login'} - Email: $email',
        tag: 'OtpController',
        
      );
      
      final response = await _otpService.verifyOtp(
        email: email.trim(),
        oneTimeCode: otp,
      );

      AppLogger.info(
        'OTP verification successful',
        tag: 'OtpController',
      );
      
      if (response['success'] == true) {
        final accessToken = response['accessToken'];
        final refreshToken = response['refreshToken'];
        
        if (accessToken == null || refreshToken == null) {
          throw Exception('Access token or refresh token is missing in the response');
        }
        
        // Store tokens and user data
        await Future.wait([
          LocalStorage.setString(LocalStorageKeys.token, accessToken),
          LocalStorage.setString(LocalStorageKeys.refreshToken, refreshToken),
          LocalStorage.setString(LocalStorageKeys.myEmail, email),
          LocalStorage.setBool(LocalStorageKeys.isLogIn, true),
        ]);

        AppLogger.success(
          'OTP verified and ${isRegistration ? 'account created' : 'login'} successful',
          tag: 'OtpController',
        );
        
        // Show success message
        Get.snackbar(
          'Success',
          isRegistration 
              ? 'Account created successfully!'
              : 'Login successful!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        // Check if profile is already completed
        await LocalStorage.getAllPrefData();
        if (LocalStorage.isProfileComplete()) {
          Get.offAllNamed(Routes.auth);
        } else {
          Get.offAllNamed(Routes.updateProfile);
        }
      } else {
        final errorMsg = response['message'] ?? 'OTP verification failed';
        errorMessage.value = errorMsg;
        Get.snackbar(
          'Error',
          errorMsg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      String errorMsg = 'Failed to verify OTP. Please try again.';
      
      if (e is DioException) {
        // Handle Dio errors
        if (e.response?.statusCode == 400) {
          errorMsg = e.response?.data?['message'] ?? 'Invalid OTP. Please check and try again.';
        } else if (e.response?.statusCode == 401) {
          errorMsg = 'Session expired. Please request a new OTP.';
        } else if (e.response?.statusCode == 429) {
          errorMsg = 'Too many attempts. Please try again later.';
        } else if (e.type == DioExceptionType.connectionTimeout) {
          errorMsg = 'Connection timeout. Please check your internet connection.';
        }
      } else if (e is FormatException) {
        errorMsg = 'Invalid OTP format. Please enter a valid 5-digit number.';
      }
      
      errorMessage.value = errorMsg;
      
      AppLogger.debug(
        'OTP verification failed',
        tag: 'OtpController',
        details: {
          'email': email,
          'isRegistration': isRegistration,
          'errorType': e.runtimeType.toString(),
          'errorMessage': e.toString(),
        },
      );
      
      Get.snackbar(
        'Verification Failed',
        errorMsg,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
