import 'package:elecktro_ecommerce/app/modules/home/controllers/bookmark_controller.dart';
import 'package:elecktro_ecommerce/app/modules/home/services/bookmark_service.dart';
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
    Get.lazyPut<BookmarkController>(
      () => BookmarkController(),
      fenix: true, // Keep the controller alive so it maintains state
    );
    Get.lazyPut<BookmarkService>(
      () => BookmarkService(),
    );
  }
}
