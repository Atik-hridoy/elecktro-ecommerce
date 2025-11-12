import 'dart:async';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/modules/home/services/get_category_on_home_view_service.dart';
import 'package:elecktro_ecommerce/app/modules/home/services/get_banner.dart';
import 'package:elecktro_ecommerce/app/modules/home/services/get_populer_product.dart';
import 'package:elecktro_ecommerce/app/modules/home/models/get_category_on_home_view.dart';
import 'package:elecktro_ecommerce/app/modules/category/models/get_product_details_models.dart';
import 'package:elecktro_ecommerce/app/core/network/app_urls.dart';
import 'package:elecktro_ecommerce/app/core/stroage/storage_services.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs; // Observable variable for the selected index
  var currentBannerIndex = 0.obs; // Track current banner index
  var banners = <Map<String, dynamic>>[].obs; // Store banner data with image URLs
  var isLoading = true.obs;
  var error = ''.obs;
  var hasNetworkError = false.obs;
  var hasServerError = false.obs;
  var isLoadingPopularProducts = false.obs;
  var searchQuery = ''.obs;
  
  Timer? _bannerTimer;
  final categories = <CategoryModel>[].obs;
  final popularProducts = <ProductDetailModel>[].obs;
  final filteredPopularProducts = <ProductDetailModel>[].obs;
  late final ProductCategoryService _categoryService;
  late final BannerService _bannerService;
  late final GetPopularProductService _popularProductService;

  // Method to update selected index
  void updateIndex(int index) {
    selectedIndex.value = index;
  }
  
  // Get current index
  int get currentIndex => selectedIndex.value;
  
  @override
  void onInit() {
    super.onInit();
    _categoryService = Get.isRegistered<ProductCategoryService>()
        ? Get.find<ProductCategoryService>()
        : Get.put(ProductCategoryService());
    _bannerService = Get.isRegistered<BannerService>()
        ? Get.find<BannerService>()
        : Get.put(BannerService());
    _popularProductService = Get.isRegistered<GetPopularProductService>()
        ? Get.find<GetPopularProductService>()
        : Get.put(GetPopularProductService());
    
    _initializeHomeData();
  }
  
  // Initialize home data - just load the home screen and fetch data
  Future<void> _initializeHomeData() async {
    try {
      // Load home screen immediately without aggressive auth checks
      print('Loading home screen...');
      
      // Just ensure storage is loaded
      await LocalStorage.getAllPrefData();
      
      // Small delay to let everything settle
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Proceed with data fetching - let individual services handle auth errors
      print('Fetching home data...');
      fetchCategories();
      fetchBanners();
      fetchPopularProducts();
      _startBannerTimer();
      
      print('Home screen loaded successfully');
    } catch (e) {
      print('Error initializing home data: $e');
      // Handle initialization error gracefully
      error.value = 'Failed to initialize home screen';
      isLoading.value = false;
    }
  }
  
  // Verify authentication with retry mechanism
  Future<bool> _verifyAuthenticationWithRetry() async {
    for (int attempt = 1; attempt <= 3; attempt++) {
      await LocalStorage.getAllPrefData();
      
      print('Authentication check attempt $attempt: Token=${LocalStorage.token.isNotEmpty}, LoggedIn=${LocalStorage.isLogIn}');
      
      if (LocalStorage.token.isNotEmpty && LocalStorage.isLogIn) {
        print('Authentication verified successfully on attempt $attempt');
        return true;
      }
      
      if (attempt < 3) {
        print('Authentication check failed, retrying in ${attempt * 500}ms...');
        await Future.delayed(Duration(milliseconds: attempt * 500));
      }
    }
    
    // Don't redirect immediately - let API calls handle 403 errors
    // This prevents conflicts when token exists but might be expired
    print('No valid authentication found after 3 attempts - letting API calls handle auth errors');
    
    // Only redirect if we're absolutely sure there's no token
    if (LocalStorage.token.isEmpty) {
      print('No token found, redirecting to auth');
      Get.offAllNamed('/auth');
      return false;
    }
    
    // Token exists but might be expired - let API calls handle it
    print('Token exists but might be expired - proceeding with API calls');
    return true;
  }
  
  @override
  void onClose() {
    _bannerTimer?.cancel();
    _isDisposed = true;
    super.onClose();
  }
  
  // Update banner index
  void updateBannerIndex(int index) {
    if (index >= 0 && index < banners.length) {
      currentBannerIndex.value = index;
    }
    _restartBannerTimer();
    update(); // Notify listeners about the change
  }
  
  // Get current banner image URL
  String get currentBannerImageUrl {
    if (banners.isEmpty || currentBannerIndex.value >= banners.length) {
      return '';
    }
    return banners[currentBannerIndex.value]['image_url'] ?? '';
  }
  
  // Fetch banners from API
  Future<void> fetchBanners() async {
    try {
      isLoading(true);
      error('');
      hasNetworkError(false);
      hasServerError(false);
      
      final bannerData = await _bannerService.getBanners();
      if (bannerData != null && bannerData.isNotEmpty) {
        banners.assignAll(bannerData);
      } else {
        banners.clear();
        error('failed_load_banners'.tr);
      }
    } catch (e) {
      final errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains('socket') || errorMessage.contains('network') || errorMessage.contains('connection')) {
        hasNetworkError(true);
      } else if (errorMessage.contains('500') || errorMessage.contains('502') || errorMessage.contains('503')) {
        hasServerError(true);
      } else {
        error('${'error_loading_banners'.tr}: $e');
      }
    } finally {
      isLoading(false);
    }
  }

  // Start auto-slide timer
  void _startBannerTimer() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_isDisposed && banners.isNotEmpty) {
        currentBannerIndex.value = _getNextBannerIndex();
        update();
      }
    });
  }
  
  bool _isDisposed = false;
  
  // Restart banner timer
  void _restartBannerTimer() {
    _bannerTimer?.cancel();
    _startBannerTimer();
  }
  
  // Get the next banner index safely
  int _getNextBannerIndex() {
    if (currentBannerIndex.value >= 4) {
      return 0;
    }
    return currentBannerIndex.value + 1;
  }

  Future<void> fetchCategories() async {
    try {
      final res = await _categoryService.getProductCategories();
      final body = res.body;
      if (body is Map<String, dynamic>) {
        final list = (body['data'] ?? body['categories'] ?? body['result']) as List?;
        if (list != null) {
          categories.assignAll(
            list.map((e) {
              final parsed = CategoryModel.fromJson(e as Map<String, dynamic>);
              return CategoryModel(
                id: parsed.id,
                name: parsed.name,
                thumbnail: _fullUrl(parsed.thumbnail),
                subCategories: parsed.subCategories,
              );
            }).toList(),
          );
        } else {
          categories.clear();
        }
      } else if (body is List) {
        categories.assignAll(
          body.map((e) {
            final parsed = CategoryModel.fromJson(e as Map<String, dynamic>);
            return CategoryModel(
              id: parsed.id,
              name: parsed.name,
              thumbnail: _fullUrl(parsed.thumbnail),
              subCategories: parsed.subCategories,
            );
          }).toList(),
        );
      } else {
        categories.clear();
      }
    } catch (e) {
      final errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains('socket') || errorMessage.contains('network') || errorMessage.contains('connection')) {
        hasNetworkError(true);
      } else if (errorMessage.contains('500') || errorMessage.contains('502') || errorMessage.contains('503')) {
        hasServerError(true);
      }
      categories.clear();
    }
  }

  String _fullUrl(String url) {
    if (url.isEmpty) return url;
    final lower = url.toLowerCase();
    if (lower.startsWith('http://') || lower.startsWith('https://')) return url;
    final base = AppUrls.baseImageUrl;
    if (base.endsWith('/') && url.startsWith('/')) {
      return base + url.substring(1);
    }
    if (!base.endsWith('/') && !url.startsWith('/')) {
      return '$base/$url';
    }
    return base + url;
  }

  // Fetch popular products from API
  Future<void> fetchPopularProducts() async {
    try {
      isLoadingPopularProducts(true);
      
      final products = await _popularProductService.getPopularProducts();
      
      // Update images to full URLs
      final updatedProducts = products.map((product) {
        final updatedImages = product.images.map((img) => _fullUrl(img)).toList();
        return ProductDetailModel(
          id: product.id,
          sellerId: product.sellerId,
          category: product.category,
          categoryId: product.categoryId,
          subCategory: product.subCategory,
          subCategoryId: product.subCategoryId,
          images: updatedImages,
          name: product.name,
          model: product.model,
          brand: product.brand,
          color: product.color,
          sizeType: product.sizeType,
          specialCategory: product.specialCategory,
          overview: product.overview,
          highlights: product.highlights,
          techSpecs: product.techSpecs,
          isDeleted: product.isDeleted,
          status: product.status,
          totalStock: product.totalStock,
          rating: product.rating,
          reviewCount: product.reviewCount,
          createdAt: product.createdAt,
          updatedAt: product.updatedAt,
          isBookmarked: product.isBookmarked,
        );
      }).toList();
      
      popularProducts.assignAll(updatedProducts);
      filteredPopularProducts.assignAll(updatedProducts);
      print('Popular products loaded: ${popularProducts.length}');
    } catch (e) {
      final errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains('socket') || errorMessage.contains('network') || errorMessage.contains('connection')) {
        hasNetworkError(true);
      } else if (errorMessage.contains('500') || errorMessage.contains('502') || errorMessage.contains('503')) {
        hasServerError(true);
      }
      popularProducts.clear();
      filteredPopularProducts.clear();
    } finally {
      isLoadingPopularProducts(false);
    }
  }

  // Search products
  void searchProducts(String query) {
    searchQuery.value = query;
    
    if (query.isEmpty) {
      // If search is empty, show all products
      filteredPopularProducts.assignAll(popularProducts);
    } else {
      // Filter products based on search query
      final lowerQuery = query.toLowerCase();
      final filtered = popularProducts.where((product) {
        final nameMatch = product.name.toLowerCase().contains(lowerQuery);
        final brandMatch = product.brand.toLowerCase().contains(lowerQuery);
        final categoryMatch = product.category.toLowerCase().contains(lowerQuery);
        final modelMatch = product.model.toLowerCase().contains(lowerQuery);
        
        return nameMatch || brandMatch || categoryMatch || modelMatch;
      }).toList();
      
      filteredPopularProducts.assignAll(filtered);
    }
    
    print('Search: "$query" - Found ${filteredPopularProducts.length} products');
  }

  // Clear search
  void clearSearch() {
    searchQuery.value = '';
    filteredPopularProducts.assignAll(popularProducts);
  }
}
