import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/core/stroage/storage_services.dart';
import 'package:elecktro_ecommerce/app/core/util/app_logger.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _decideStartDestination();
  }

  Future<void> _decideStartDestination() async {
    try {
      // Show splash for minimum duration
      await Future.delayed(const Duration(seconds: 2));
      
      // Load all stored data
      await LocalStorage.getAllPrefData();
      
      AppLogger.info(
        'Checking authentication status',
        tag: 'SplashController',
      );
      
      // Check if user has valid authentication
      if (_hasValidAuthentication()) {
        AppLogger.info(
          'Valid authentication found - navigating to home',
          tag: 'SplashController',
        );
        
        // Check if profile is complete
        if (LocalStorage.isProfileCompleted) {
          // User is fully authenticated and profile is complete - go to home
          Get.offAllNamed(Routes.home);
        } else {
          // User is authenticated but profile incomplete - go to update profile
          AppLogger.info(
            'Profile incomplete - navigating to update profile',
            tag: 'SplashController',
          );
          Get.offAllNamed(Routes.updateProfile);
        }
      } else {
        // No valid authentication - go to onboarding/auth
        AppLogger.info(
          'No valid authentication - navigating to onboarding',
          tag: 'SplashController',
        );
        Get.offAllNamed(Routes.onboarding);
      }
    } catch (e) {
      AppLogger.error(
        'Error in splash navigation decision',
        tag: 'SplashController',
        error: e,
      );
      
      // Fallback: wait and try again
      await Future.delayed(const Duration(seconds: 1));
      _decideStartDestination();
    }
  }
  
  /// Check if user has valid authentication
  bool _hasValidAuthentication() {
    final hasToken = LocalStorage.token.isNotEmpty;
    final isLoggedIn = LocalStorage.isLogIn;
    final hasEmail = LocalStorage.myEmail.isNotEmpty;
    
    AppLogger.info(
      'Authentication check - Token: $hasToken (${LocalStorage.token.length} chars), LoggedIn: $isLoggedIn, Email: $hasEmail',
      tag: 'SplashController',
    );
    
    // User must have token, be marked as logged in, and have email
    return hasToken && isLoggedIn && hasEmail;
  }
}
