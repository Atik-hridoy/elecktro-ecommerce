import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import 'package:elecktro_ecommerce/app/modules/home/controllers/home_controller.dart';

class NavigationService extends GetxService {
  static NavigationService get to => Get.find();
  
  late final HomeController _homeController;
  
  @override
  void onInit() {
    super.onInit();
    _homeController = Get.find<HomeController>();
  }
  
  // Handle navigation based on tab index
  void handleNavigation(int index) {
    _homeController.updateIndex(index);
    
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
      case 2: // Cart (show as overlay)
        if (!Get.isDialogOpen!) {
          Get.toNamed(Routes.cart);
        }
        break;
      case 3: // Profile
        // Handle profile navigation if needed
        break;
    }
  }
  
  // Get the current tab index
  int getCurrentIndex() {
    return _homeController.selectedIndex.value;
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
