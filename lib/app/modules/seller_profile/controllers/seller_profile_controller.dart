import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/modules/category/models/get_product_details_models.dart';
import '../services/get_seller_profile_service.dart';
import '../services/get_seller_products_service.dart';
import '../services/get_seller_categories_service.dart';
import '../models/seller_profile_model.dart';
import '../models/seller_category_model.dart';

class SellerProfileController extends GetxController {
  // Services
  final GetSellerProfileService _sellerProfileService = GetSellerProfileService();
  final GetSellerProductsService _sellerProductsService = GetSellerProductsService();
  final GetSellerCategoriesService _sellerCategoriesService = GetSellerCategoriesService();
  
  // Seller data from API
  final Rx<SellerProfileData?> sellerProfile = Rx<SellerProfileData?>(null);
  
  // Seller products and categories
  final RxList<ProductDetailModel> sellerProducts = <ProductDetailModel>[].obs;
  final RxList<SellerCategory> sellerCategories = <SellerCategory>[].obs;
  final Rx<String?> selectedCategoryId = Rx<String?>(null);
  
  // Seller data (legacy for backward compatibility)
  final Rx<Seller?> seller = Rx<Seller?>(null);
  final RxDouble rating = 0.0.obs;
  final RxInt reviewCount = 0.obs;
  
  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isLoadingProducts = false.obs;
  final RxBool isLoadingCategories = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString productsErrorMessage = ''.obs;
  final RxString categoriesErrorMessage = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadSellerData();
  }
  
  void _loadSellerData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Get seller data from arguments
      final args = Get.arguments;
      String? sellerId;
      
      if (args != null) {
        if (args is Map) {
          seller.value = args['seller'] as Seller?;
          rating.value = (args['rating'] as num?)?.toDouble() ?? 0.0;
          reviewCount.value = (args['reviewCount'] as int?) ?? 0;
          sellerId = seller.value?.id;
        } else if (args is Seller) {
          seller.value = args;
          sellerId = args.id;
        } else if (args is String) {
          // Direct seller ID passed
          sellerId = args;
        }
      }
      
      // Fetch seller profile, categories, and products from API if we have a seller ID
      if (sellerId != null && sellerId.isNotEmpty) {
        await fetchSellerProfile(sellerId);
        await fetchSellerCategories(sellerId);
        await fetchSellerProducts(sellerId);
      }
    } catch (e) {
      print('Error loading seller data: $e');
      errorMessage.value = 'Failed to load seller data';
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Fetches seller profile from the API
  Future<void> fetchSellerProfile(String sellerId) async {
    try {
      final response = await _sellerProfileService.getSellerProfile(sellerId);
      
      if (response != null && response.success && response.data != null) {
        sellerProfile.value = response.data;
        
        print('Seller profile loaded: ${response.data!.fullName}');
        print('Shop name: ${response.data!.shopName ?? "N/A"}');
        print('Registration No: ${response.data!.registrationNo}');
      } else {
        errorMessage.value = response?.message ?? 'Failed to load seller profile';
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      errorMessage.value = 'Failed to load seller profile: $e';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  /// Fetches seller categories from the API
  Future<void> fetchSellerCategories(String sellerId) async {
    try {
      isLoadingCategories.value = true;
      categoriesErrorMessage.value = '';
      
      final categories = await _sellerCategoriesService.getSellerCategories(sellerId);
      sellerCategories.assignAll(categories);
      
      print('Seller categories loaded: ${categories.length} items');
    } catch (e) {
      categoriesErrorMessage.value = 'Failed to load categories: $e';
      print('Error loading seller categories: $e');
    } finally {
      isLoadingCategories.value = false;
    }
  }
  
  /// Fetches seller products from the API
  Future<void> fetchSellerProducts(String sellerId) async {
    try {
      isLoadingProducts.value = true;
      productsErrorMessage.value = '';
      
      final products = await _sellerProductsService.getSellerProducts(sellerId);
      sellerProducts.assignAll(products);
      
      print('Seller products loaded: ${products.length} items');
    } catch (e) {
      productsErrorMessage.value = 'Failed to load products: $e';
      print('Error loading seller products: $e');
    } finally {
      isLoadingProducts.value = false;
    }
  }
  
  /// Select a category to filter products
  void selectCategory(String? categoryId) {
    selectedCategoryId.value = categoryId;
    // TODO: Filter products by category if needed
  }
  
  // Get seller's full name (prioritize API data)
  String get sellerName {
    if (sellerProfile.value != null) {
      return sellerProfile.value!.fullName;
    }
    if (seller.value == null) return 'Unknown Seller';
    return '${seller.value!.firstName} ${seller.value!.lastName}'.trim();
  }
  
  // Get seller's display name (shop name or full name)
  String get sellerDisplayName {
    if (sellerProfile.value != null) {
      return sellerProfile.value!.displayName;
    }
    return sellerName;
  }
  
  // Get seller's initials for avatar (prioritize API data)
  String get sellerInitials {
    if (sellerProfile.value != null) {
      return sellerProfile.value!.initials;
    }
    if (seller.value == null) return 'U';
    final firstName = seller.value!.firstName;
    final lastName = seller.value!.lastName;
    return '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'.toUpperCase();
  }
}
