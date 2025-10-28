import 'package:elecktro_ecommerce/app/modules/category/services/get_product_service.dart';
import 'package:get/get.dart';
import '../category/controller.dart';

class CategoryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryController>(() => CategoryController());
    Get.lazyPut<ProductService>(() => ProductService());
  }
}