import 'package:get/get.dart';
import '../category/controller.dart';

class CategoryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryController>(() => CategoryController());
  }
}