import 'package:dio/dio.dart';
import 'package:elecktro_ecommerce/app/core/network/app_urls.dart';
import 'package:elecktro_ecommerce/app/core/stroage/storage_services.dart';
import 'package:elecktro_ecommerce/app/modules/product_details/model/product_details_model.dart';
import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/modules/category/models/get_product_details_models.dart';

/// Manages the state for the ProductDetailsView.
class ProductDetailsController extends GetxController {
  // --- Product Data Properties ---
  final RxString productId = ''.obs;
  final RxString name = ''.obs;
  final RxString brand = ''.obs;
  final RxString price = ''.obs;
  final RxString imageUrl = ''.obs;
  final RxString discount = ''.obs;
  final Rx<ProductResponse?> productResponse = Rx<ProductResponse?>(null);
  
  // --- Seller Information ---
  final seller = Seller(
    id: '',
    firstName: '',
    lastName: '',
  ).obs;
  final rating = 0.0.obs;
  final reviewCount = 0.obs;

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
      
      // Initialize seller from parameters or defaults
      seller.update((val) {
        val?.id = parameters['sellerId'] ?? '';
        val?.firstName = parameters['sellerFirstName'] ?? 'Seller';
        val?.lastName = parameters['sellerLastName'] ?? '';
      });
      
      // Parse rating and review count
      rating.value = double.tryParse(parameters['rating'] ?? '0.0') ?? 0.0;
      reviewCount.value = int.tryParse(parameters['reviewCount'] ?? '0') ?? 0;
      print('productId ID: ${productId.value}');

      getProductDetails();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load product details: ${e.toString()}');
      name.value = 'Error Loading Product';
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> getProductDetails() async {
    try {
      final dio = Dio();
      isLoading.value = true;
      final token = LocalStorage.token;
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.get(
        '${AppUrls.baseUrl}${AppUrls.getProductDetails}${productId.value}',
        options: Options(validateStatus: (status) => true),
      );

      if (response.statusCode == 200) {
        productResponse.value = ProductResponse.fromJson(response.data);
        print('Product Response: ${productResponse.value}');
        // Update seller information from the API response
        final sellerData = productResponse.value?.data?.sellerId;
        if (sellerData != null && sellerData is Map<String, dynamic>) {
          seller.update((val) {
            val?.id = sellerData['_id']?.toString() ?? '';
            val?.firstName = sellerData['firstName']?.toString() ?? 'Seller';
            val?.lastName = sellerData['lastName']?.toString() ?? '';
          });
        }
        
        // Update other product details
        if (productResponse.value?.data != null) {
          final product = productResponse.value!.data!;
          name.value = product.name ?? 'Product Not Found';
          brand.value = product.brand ?? 'N/A';
          
          // Update the first image as the main image if available
          if (product.images != null && product.images!.isNotEmpty) {
            // Prepend baseImageUrl if the path is not already a full URL
            final imagePath = product.images!.first;
            imageUrl.value = imagePath.startsWith('http') 
                ? imagePath 
                : '${AppUrls.baseImageUrl}${imagePath.startsWith('/') ? imagePath.substring(1) : imagePath}';
          }
        }
      } else {
        Get.snackbar('Error', 'Failed to load product details');
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Failed to load seller details: ${e.toString()}');
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
    Get.toNamed(Routes.auth);
  }

  void onAddToCart() {
    Get.snackbar('Success', '${name.value} added to cart');
  }
}