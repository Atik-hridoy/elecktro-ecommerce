import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import 'package:elecktro_ecommerce/app/modules/auth/controllers/authController.dart';

class ProductDetailsController extends GetxController {
  // Product data
  final product = {}.obs;
  final isLoading = true.obs;
  final isProcessing = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadProductDetails();
  }
  
  // Check if user is logged in
  bool get isUserLoggedIn => AuthController.to.isLoggedIn;

  // Load product details
  Future<void> loadProductDetails() async {
    try {
      isLoading.value = true;
      // TODO: Implement actual product details loading
      // product.value = await ProductRepository.getProductDetails(productId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load product details');
    } finally {
      isLoading.value = false;
    }
  }

  // Handle buy now action
  void onBuyNow() {
    if (!isUserLoggedIn) {
      // If user is not logged in, navigate to auth screen
      Get.toNamed(Routes.auth, arguments: {'redirectTo': Routes.checkout});
      return;
    }
    // Proceed to checkout if user is logged in
    Get.toNamed(Routes.checkout);
  }
  
  // Handle add to cart action
  void onAddToCart() {
    if (!isUserLoggedIn) {
      // If user is not logged in, navigate to auth screen
      Get.toNamed(Routes.auth, arguments: {'redirectTo': Routes.cart});
      return;
    }
    // Add to cart logic here
    Get.snackbar(
      'Success',
      'Product added to cart',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}
