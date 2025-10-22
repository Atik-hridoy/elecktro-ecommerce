import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../controllers/account_controller.dart';
import '../controllers/profile_controller.dart';
import '../views/services/get_profile_service.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Register Dio instance
    Get.put<Dio>(Dio(), permanent: true);
    
    // Register services
    Get.lazyPut<GetProfileService>(() => GetProfileService());
    
    // Register controllers
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
    
    Get.lazyPut<AccountController>(
      () => AccountController(),
    );
  }
}
