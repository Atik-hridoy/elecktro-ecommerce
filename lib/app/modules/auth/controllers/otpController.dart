import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/core/stroage/storage_services.dart';
import 'package:elecktro_ecommerce/app/core/stroage/storage_keys.dart';
import 'package:elecktro_ecommerce/app/core/util/app_logger.dart';
import 'package:elecktro_ecommerce/app/core/network/app_urls.dart';
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
    // Check if controller is still active
    if (isClosed) return;
    
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
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Check if controller is still active before updating state
      if (!isClosed) {
        if (remainingTime.value > 1) {
          remainingTime.value--;
        } else {
          _timer?.cancel();
          canResend.value = true;
        }
      } else {
        // Cancel timer if controller is closed
        timer.cancel();
      }
    });
  }

  // Resend OTP
  Future<void> resendOtp() async {
    if (!canResend.value) return;
    
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      AppLogger.info(
        'Resending OTP to email: $email',
        tag: 'OtpController',
      );
      
      // Call the resend OTP service with email
      final response = await _otpService.resendOtp(email: email.trim());
      
      if (response['success'] == true) {
        // Restart the timer after successful resend
        startTimer();
        
        AppLogger.success(
          'OTP resent successfully',
          tag: 'OtpController',
        );
        
        Get.snackbar(
          'success'.tr,
          response['message'] ?? 'otp_resent_success'.tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        // Handle failure
        final errorMsg = response['message'] ?? 'failed_resend_otp'.tr;
        errorMessage.value = errorMsg;
        
        AppLogger.warning(
          'Failed to resend OTP: $errorMsg',
          tag: 'OtpController',
        );
        
        Get.snackbar(
          'error'.tr,
          errorMsg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = 'failed_resend_otp'.tr;
      
      AppLogger.error(
        'Error resending OTP',
        error: e,
        tag: 'OtpController',
      );
      
      Get.snackbar(
        'error'.tr,
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
      errorMessage.value = 'please_enter_valid_otp'.tr;
      AppLogger.warning('Invalid OTP format: $otp');
      Get.snackbar(
        'error'.tr,
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
      
      // Call the OTP verification service
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
        final data = response['data'] as Map<String, dynamic>?;
        
        if (accessToken == null || refreshToken == null) {
          throw Exception('Access token or refresh token is missing in the response');
        }
        
        // Debug token information
        AppLogger.info(
          'Received tokens - Access: ${accessToken.toString().length} chars, Refresh: ${refreshToken.toString().length} chars',
          tag: 'OtpController',
        );
        
        // Check if profile is complete from API response
        final isProfileCompleteFromApi = data?['isProfileCompleted'] ?? false;
        
        AppLogger.debug(
          'Profile completion status from API',
          tag: 'OtpController',
          details: {
            'isProfileCompleted': isProfileCompleteFromApi,
          },
        );
        
        // Store tokens and user data
        await Future.wait([
          LocalStorage.setString(LocalStorageKeys.token, accessToken.toString().trim()),
          LocalStorage.setString(LocalStorageKeys.refreshToken, refreshToken.toString().trim()),
          LocalStorage.setString(LocalStorageKeys.myEmail, email),
          LocalStorage.setBool(LocalStorageKeys.isLogIn, true),
          LocalStorage.setBool(LocalStorageKeys.isProfileCompleted, isProfileCompleteFromApi),
        ]);
        
        // Verify tokens were stored correctly
        await LocalStorage.getAllPrefData();
        AppLogger.info(
          'Tokens stored - Access: ${LocalStorage.token.length} chars, Refresh: ${LocalStorage.refreshToken.length} chars',
          tag: 'OtpController',
        );
        
        // Test token validity immediately after storage
        await _testTokenValidity();

        AppLogger.success(
          'OTP verified and ${isRegistration ? 'account created' : 'login'} successful',
          tag: 'OtpController',
        );
        
        // Show success message
        Get.snackbar(
          'success'.tr,
          isRegistration 
              ? 'account_created_success'.tr
              : 'login_success'.tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        // Refresh local storage data to get the latest profile status
        await LocalStorage.getAllPrefData();
        
        // Add a small delay to ensure token is properly stored and loaded
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Verify token is properly loaded
        if (LocalStorage.token.isEmpty) {
          AppLogger.error(
            'Token not properly loaded after OTP verification',
            tag: 'OtpController',
          );
          throw Exception('Authentication token not properly stored');
        }
        
        AppLogger.debug(
          'Token verification after OTP',
          tag: 'OtpController',
          details: {
            'hasToken': LocalStorage.token.isNotEmpty,
            'tokenLength': LocalStorage.token.length,
            'isLoggedIn': LocalStorage.isLogIn,
          },
        );
        
        // Navigate based on the flow
        if (isRegistration) {
          // For registration flow, go to update profile (new user needs to complete profile)
          AppLogger.info(
            'New registration - navigating to update profile',
            tag: 'OtpController',
          );
          Get.offAllNamed(
            Routes.updateProfile,
            arguments: {
              'email': email,
              'isFirstTime': true,
            },
          );
        } else {
          // For login flow, existing user should go directly to home
          AppLogger.info(
            'Login successful - navigating to home',
            tag: 'OtpController',
          );
          Get.offAllNamed(Routes.home);
        }
      } else {
        // Handle verification failure
        final errorMsg = response['message'] ?? 'failed_verify_otp'.tr;
        errorMessage.value = errorMsg;
        Get.snackbar(
          'error'.tr,
          errorMsg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      String errorMsg = 'failed_verify_otp'.tr;
      
      if (e is DioException) {
        // Handle Dio errors
        if (e.response?.statusCode == 400) {
          errorMsg = e.response?.data?['message'] ?? 'invalid_otp_check'.tr;
        } else if (e.response?.statusCode == 401) {
          errorMsg = 'session_expired'.tr;
        } else if (e.response?.statusCode == 429) {
          errorMsg = 'too_many_attempts'.tr;
        } else if (e.type == DioExceptionType.connectionTimeout) {
          errorMsg = 'connection_timeout'.tr;
        }
      } else if (e is FormatException) {
        errorMsg = 'invalid_otp_format'.tr;
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
        'verification_failed'.tr,
        errorMsg,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Test token validity by making a simple API call
  Future<void> _testTokenValidity() async {
    try {
      AppLogger.info('Testing token validity immediately after OTP', tag: 'OtpController');
      
      final dio = Dio();
      final response = await dio.get(
        '${AppUrls.baseUrl}${AppUrls.getProfile}',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${LocalStorage.token}',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );
      
      if (response.statusCode == 200) {
        AppLogger.success('Token validation successful immediately after OTP', tag: 'OtpController');
      } else {
        AppLogger.warning('Token validation returned status: ${response.statusCode}', tag: 'OtpController');
      }
    } catch (e) {
      AppLogger.error('Token validation failed immediately after OTP', tag: 'OtpController', error: e);
      
      if (e is DioException && e.response?.statusCode == 403) {
        AppLogger.error('403 error immediately after OTP - token might be invalid format', tag: 'OtpController');
      }
    }
  }
}
