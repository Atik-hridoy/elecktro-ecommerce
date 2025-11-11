import 'package:get/get.dart';
import 'services/about_service.dart';
import 'package:elecktro_ecommerce/app/core/switching_language_facilities/localization_service.dart';

class AboutController extends GetxController {
  // Observable variables
  final RxBool isLoading = false.obs;
  final RxString aboutUsContent = ''.obs;
  final RxString errorMessage = ''.obs;
  final RxString appVersion = '1.0.0'.obs;
  final RxString companyName = 'Elecktro E-commerce'.obs;
  final RxString companyEmail = 'support@elecktro.com'.obs;
  final RxString companyWebsite = 'www.elecktro.com'.obs;
  
  // Service instance for API calls
  final AboutService _aboutService = AboutService();
  
  @override
  void onInit() {
    super.onInit();
    fetchAboutUsContent();
    
    // Listen for language changes and refresh content (if service is available)
    try {
      final localizationService = Get.find<LocalizationService>();
      ever(localizationService.currentLanguage, (_) {
        fetchAboutUsContent();
      });
    } catch (e) {
      print('⚠️ LocalizationService not found, language change listener not set up');
    }
  }
  
  @override
  void onReady() {
    super.onReady();
  }
  
  @override
  void onClose() {
    super.onClose();
  }
  
  // Private methods
  Future<void> fetchAboutUsContent() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final result = await _aboutService.fetchAboutUsContent();
      
      if (result['success'] == true) {
        aboutUsContent.value = result['data']['content'] ?? 'No content available';
        errorMessage.value = '';
      } else {
        errorMessage.value = result['message'] ?? 'Failed to load content';
        aboutUsContent.value = 'Unable to load About Us content at this time.';
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      aboutUsContent.value = 'Unable to load About Us content at this time.';
      print('❌ Controller error: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Public methods
  Future<void> refreshAboutUs() async {
    await fetchAboutUsContent();
  }
  
  void contactSupport() {
    // Logic to contact support
    // Add your email launch logic here
    Get.snackbar(
      'Contact Support',
      'Email client would open with: ${companyEmail.value}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void visitWebsite() {
    // Logic to visit company website
    Get.snackbar(
      'Visit Website',
      'Browser would open: ${companyWebsite.value}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void shareApp() {
    // Logic to share the app
    Get.snackbar(
      'Share App',
      'Share dialog would open',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
