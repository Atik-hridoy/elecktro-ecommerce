import 'package:elecktro_ecommerce/app/core/util/app_logger.dart';
import 'package:get/get.dart';

import '../views/services/get_profile_service.dart';
import '../views/model/get_profile_model.dart';

class ProfileController extends GetxController {
  // Services
  final GetProfileService _profileService = Get.find<GetProfileService>();

  // User information
  var name = ''.obs;
  var address = ''.obs;
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
        // Update the name and address from the API response
        final fullName = '${profileData.data.firstName} ${profileData.data.lastName}'.trim();
        name.value = fullName;
        address.value = profileData.data.address;
        
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
    required String newAddress,
  }) {
    // This method can be updated later to handle profile updates
    // For now, just update the local values
    if (newName.isNotEmpty) {
      name.value = newName;
    }
    if (newAddress.isNotEmpty) {
      address.value = newAddress;
    }
  }
  
  // Refresh profile data
  Future<void> refreshProfile() async {
    await fetchProfileData();
  }
}
