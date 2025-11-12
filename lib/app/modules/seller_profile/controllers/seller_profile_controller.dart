import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/modules/category/models/get_product_details_models.dart';
import '../services/get_seller_profile_service.dart';
import '../services/get_seller_products_service.dart';
import '../services/get_seller_categories_service.dart';
import '../services/get_seller_rating_service.dart';
import '../models/seller_profile_model.dart';
import '../models/seller_category_model.dart';
import '../models/seller_rating_model.dart';

class SellerProfileController extends GetxController {
  // Services
  final GetSellerProfileService _sellerProfileService = GetSellerProfileService();
  final GetSellerProductsService _sellerProductsService = GetSellerProductsService();
  final GetSellerCategoriesService _sellerCategoriesService = GetSellerCategoriesService();
  final GetSellerRatingService _sellerRatingService = GetSellerRatingService();
  
  // Seller data from API
  final Rx<SellerProfileData?> sellerProfile = Rx<SellerProfileData?>(null);
  final Rx<SellerRatingData?> sellerRating = Rx<SellerRatingData?>(null);
  
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
  final RxBool isLoadingRating = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString productsErrorMessage = ''.obs;
  final RxString categoriesErrorMessage = ''.obs;
  final RxString ratingErrorMessage = ''.obs;
  
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
      
      // Fetch seller profile, categories, products, and rating from API if we have a seller ID
      if (sellerId != null && sellerId.isNotEmpty) {
        await fetchSellerProfile(sellerId);
        await fetchSellerCategories(sellerId);
        await fetchSellerProducts(sellerId);
        await fetchSellerRating(sellerId);
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
  
  /// Fetches seller rating from the API
  Future<void> fetchSellerRating(String sellerId) async {
    try {
      isLoadingRating.value = true;
      ratingErrorMessage.value = '';
      
      final response = await _sellerRatingService.getSellerRating(sellerId);
      
      if (response != null && response.success && response.data != null) {
        sellerRating.value = response.data;
        
        // Update legacy rating values for backward compatibility
        rating.value = response.data!.averageRating;
        reviewCount.value = response.data!.totalReviews;
        
        print('Seller rating loaded: ${response.data!.averageRating} (${response.data!.totalReviews} reviews)');
      } else {
        ratingErrorMessage.value = response?.message ?? 'Failed to load seller rating';
        print('Failed to load seller rating: ${ratingErrorMessage.value}');
      }
    } catch (e) {
      ratingErrorMessage.value = 'Failed to load seller rating: $e';
      print('Error loading seller rating: $e');
    } finally {
      isLoadingRating.value = false;
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
  
  // Get seller's rating (prioritize API data)
  double get sellerRatingValue {
    if (sellerRating.value != null) {
      return sellerRating.value!.averageRating;
    }
    return rating.value;
  }
  
  // Get seller's review count (prioritize API data)
  int get sellerReviewCount {
    if (sellerRating.value != null) {
      return sellerRating.value!.totalReviews;
    }
    return reviewCount.value;
  }
  
  // Get formatted rating text
  String get ratingText {
    if (sellerRating.value != null) {
      return sellerRating.value!.ratingText;
    }
    return rating.value.toStringAsFixed(1);
  }
  
  // Get formatted reviews text
  String get reviewsText {
    if (sellerRating.value != null) {
      return sellerRating.value!.reviewsText;
    }
    final count = reviewCount.value;
    if (count == 0) {
      return 'No reviews';
    } else if (count == 1) {
      return '1 review';
    } else {
      return '$count reviews';
    }
  }
  
  // Check if seller has good rating
  bool get hasGoodRating {
    if (sellerRating.value != null) {
      return sellerRating.value!.hasGoodRating;
    }
    return rating.value >= 4.0;
  }
}
