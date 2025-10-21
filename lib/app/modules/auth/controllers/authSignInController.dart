import 'package:elecktro_ecommerce/app/core/stroage/storage_services.dart';
import 'package:elecktro_ecommerce/app/core/stroage/storage_keys.dart';
import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/login_service.dart';

class AuthSignInController extends GetxController {
  final _authService = AuthSignInService();
  
  // Storage keys
  static const String _isLoggedInKey = LocalStorageKeys.isLogIn;
  static const String _emailKey = LocalStorageKeys.myEmail;
  static const String _otpTokenKey = LocalStorageKeys.token;
  
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Handle login
  Future<void> login(String email) async {
    if (email.isEmpty) {
      errorMessage.value = 'Please enter your email';
      return;
    }

    if (!GetUtils.isEmail(email)) {
      errorMessage.value = 'Please enter a valid email';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      final response = await _authService.signInUser(email: email);
      
      if (response['success'] == true) {
        // Save email for OTP verification
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(LocalStorageKeys.myEmail, email);
        await LocalStorage.getAllPrefData(); // Refresh local storage data
        
        // Navigate to OTP screen
        Get.toNamed(
          Routes.otp,
          arguments: email,
        );
      } else {
        errorMessage.value = response['message'] ?? 'Failed to send OTP';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again.';
      print('Login error: $e');
    } finally {
      isLoading.value = false;
    }
  }
  }

  // Check if user is logged in
  bool get isLoggedIn => LocalStorage.isLogIn;

  // Get OTP token
  String? get otpToken => LocalStorage.token;
  
  // Set OTP token
  Future<void> setOtpToken(String token) async {
    LocalStorage.token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LocalStorageKeys.token, token);
  }
  
  // Complete login after OTP verification
  Future<void> completeLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(LocalStorageKeys.isLogIn, true);
    await LocalStorage.getAllPrefData(); // Refresh local storage data
    Get.offAllNamed(Routes.checkout);
  }
  
  // Get user email
  String? get userEmail => LocalStorage.myEmail;
  
  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(LocalStorageKeys.isLogIn, false);
    await prefs.remove(LocalStorageKeys.myEmail);
    await LocalStorage.getAllPrefData(); // Refresh local storage data
  }
