import 'package:elecktro_ecommerce/app/modules/home/services/get_category_on_home_view_service.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<ProductCategoryService>(
      () => ProductCategoryService(),
    );
  }
}
