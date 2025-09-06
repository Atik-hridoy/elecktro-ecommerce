import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/modules/product_details/product_controller.dart';

class ProductDetailsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductDetailsController>(() => ProductDetailsController());
  }
}