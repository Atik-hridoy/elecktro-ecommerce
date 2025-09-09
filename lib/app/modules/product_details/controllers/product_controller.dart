import 'package:get/get.dart';

/// Manages the state for the ProductDetailsView.
class ProductDetailsController extends GetxController {
  // --- Product Data Properties ---
  final RxString productId = ''.obs;
  final RxString name = ''.obs;
  final RxString brand = ''.obs;
  final RxString price = ''.obs;
  final RxString imageUrl = ''.obs;
  final RxString discount = ''.obs;

  // --- UI State ---
  final isLoading = true.obs;
  final RxInt quantity = 1.obs;
  final RxInt selectedSizeIndex = 3.obs;
  final RxInt selectedColorIndex = 0.obs;
  final RxInt selectedImageIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadProductDetailsFromParameters();
  }

  void _loadProductDetailsFromParameters() {
    try {
      isLoading.value = true;
      final parameters = Get.parameters;
      productId.value = parameters['productId'] ?? 'N/A';
      name.value = parameters['name'] ?? 'Product Not Found';
      brand.value = parameters['brand'] ?? 'N/A';
      price.value = parameters['price'] ?? '--';
      imageUrl.value = parameters['imageUrl'] ?? '';
      discount.value = parameters['discount'] ?? '';
    } catch (e) {
      Get.snackbar('Error', 'Failed to load product details: ${e.toString()}');
      name.value = 'Error Loading Product';
    } finally {
      isLoading.value = false;
    }
  }

  // --- UI Actions ---
  void selectSize(int index) => selectedSizeIndex.value = index;
  void selectColor(int index) => selectedColorIndex.value = index;
  void selectImage(int index) => selectedImageIndex.value = index;
  void incrementQuantity() => quantity.value++;
  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  // --- Business Logic Actions ---
  void onBuyNow() {
    Get.snackbar('Info', 'Buy Now clicked for ${name.value}');
  }

  void onAddToCart() {
    Get.snackbar('Success', '${name.value} added to cart');
  }
}
