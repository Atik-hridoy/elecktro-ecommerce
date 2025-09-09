import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/modules/auth/bindings/bindings.dart';
import 'package:elecktro_ecommerce/app/modules/product_details/controllers/product_controller.dart';

class ProductDetailsBinding implements Bindings {
  @override
  void dependencies() {
    // Initialize auth bindings first
    AuthBinding().dependencies();
    
    // Then initialize product details controller
    Get.lazyPut<ProductDetailsController>(
      () => ProductDetailsController(),
    );
  }
}