import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();
  
  final _storage = GetStorage();
  final String _isLoggedInKey = 'is_logged_in';
  
  final RxBool _isLoggedIn = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Load login state from storage
    _isLoggedIn.value = _storage.read(_isLoggedInKey) ?? false;
  }
  
  bool get isLoggedIn => _isLoggedIn.value;
  
  // Call this when user successfully logs in
  void login() {
    _isLoggedIn.value = true;
    _storage.write(_isLoggedInKey, true);
  }
  
  // Call this when user logs out
  void logout() {
    _isLoggedIn.value = false;
    _storage.write(_isLoggedInKey, false);
  }
}