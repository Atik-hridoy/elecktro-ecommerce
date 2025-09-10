import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import 'package:elecktro_ecommerce/app/modules/home/controllers/home_controller.dart';

class NavigationService extends GetxService {
  static NavigationService get to => Get.find();
  
  HomeController? _homeController;
  
  @override
  void onInit() {
    super.onInit();
    // Try to get HomeController, but don't fail if it's not available yet
    try {
      _homeController = Get.find<HomeController>();
    } catch (e) {
      // HomeController not initialized yet, we'll handle this in handleNavigation
      print('HomeController not initialized yet: $e');
    }
  }
  
  // Handle navigation based on tab index
  void handleNavigation(int index) {
    // Try to get HomeController if not already available
    if (_homeController == null) {
      try {
        _homeController = Get.find<HomeController>();
      } catch (e) {
        print('HomeController still not available: $e');
        // Continue with navigation without updating HomeController
        _handleRouteNavigation(index);
        return;
      }
    }
    
    _homeController!.updateIndex(index);
  
  switch (index) {
    case 0: // Home
      if (Get.currentRoute != Routes.home) {
        Get.offAllNamed(Routes.home);
      }
      break;
    case 1: // Categories
      if (Get.currentRoute != Routes.category) {
        Get.offAllNamed(Routes.category);
      }
      break;
    case 2: // Cart
      if (Get.currentRoute != Routes.cart) {
        Get.toNamed(Routes.cart);
      }
      break;
    case 3: // Profile
      if (Get.currentRoute != Routes.profile) {
        Get.offAllNamed(Routes.profile);
      }
      break;
  }
}
  
  // Handle route navigation when HomeController is not available
  void _handleRouteNavigation(int index) {
    switch (index) {
      case 0: // Home
        if (Get.currentRoute != Routes.home) {
          Get.offAllNamed(Routes.home);
        }
        break;
      case 1: // Categories
        if (Get.currentRoute != Routes.category) {
          Get.offAllNamed(Routes.category);
        }
        break;
      case 2: // Cart
        if (Get.currentRoute != Routes.cart) {
          Get.toNamed(Routes.cart);
        }
        break;
      case 3: // Profile
        if (Get.currentRoute != Routes.profile) {
          Get.offAllNamed(Routes.profile);
        }
        break;
    }
  }
  
  // Get the current tab index
  int getCurrentIndex() {
    return _homeController?.selectedIndex.value ?? 0;
  }
  
  // Check if current route is active
  bool isCurrentRoute(String routeName) {
    return Get.currentRoute == routeName;
  }
  
  // Initialize the service
  static Future<NavigationService> init() async {
    return Get.put(NavigationService(), permanent: true);
  }
}
