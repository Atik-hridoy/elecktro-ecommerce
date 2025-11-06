import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/modules/home/models/get_category_on_home_view.dart';
import 'package:elecktro_ecommerce/app/modules/category/models/get_product_details_models.dart';
import 'package:elecktro_ecommerce/app/modules/category/services/get_product_service.dart';
import 'package:elecktro_ecommerce/app/core/network/app_urls.dart';

class CategoryController extends GetxController {
  // Categories data
  final categories = <CategoryModel>[].obs;
  final filteredCategories = <CategoryModel>[].obs;

  // Products data for CategoryView grid
  final products = <ProductDetailModel>[].obs;
  final filteredProducts = <ProductDetailModel>[].obs;
  final isLoadingProducts = false.obs;
  bool _hasLoadedProducts = false;
  final currentCategoryId = Rxn<String>();
  final searchQuery = ''.obs;
  
  // Filter properties
  final minPrice = 0.0.obs;
  final maxPrice = 10000.0.obs;
  final selectedBrands = <String>[].obs;
  final minRating = 0.0.obs;
  final sortBy = 'default'.obs; // default, price_low, price_high, rating

  @override
  void onInit() {
    super.onInit();
    // Initialize with sample data
    filteredCategories.assignAll(categories);

    // Fetch products for grid
    fetchProducts();
  }

  void searchCategories(String query) {
    if (query.isEmpty) {
      filteredCategories.assignAll(categories);
    } else {
      filteredCategories.value = categories
          .where((category) => category.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  Future<void> fetchProducts() async {
    if (isLoadingProducts.value || _hasLoadedProducts) return;
    final service = Get.isRegistered<ProductService>()
        ? Get.put<ProductService>(ProductService())
        : Get.put(ProductService());
    try {
      isLoadingProducts.value = true;
      final res = await service.getProducts();
      final body = res.body;
      List dataList;
      if (body is Map<String, dynamic>) {
        dataList = (body['data'] ?? body['result'] ?? body['products'] ?? []) as List;
      } else if (body is List) {
        dataList = body;
      } else {
        dataList = [];
      }

      final mapped = dataList.map((e) {
        final m = ProductDetailModel.fromJson(e as Map<String, dynamic>);
        // Prefix images with baseImageUrl if relative
        final prefixedImages = m.images.map(_fullUrl).toList();
        return ProductDetailModel(
          id: m.id,
          sellerId: m.sellerId,
          category: m.category,
          categoryId: m.categoryId,
          subCategory: m.subCategory,
          subCategoryId: m.subCategoryId,
          images: prefixedImages,
          name: m.name,
          model: m.model,
          brand: m.brand,
          color: m.color,
          sizeType: m.sizeType,
          specialCategory: m.specialCategory,
          overview: m.overview,
          highlights: m.highlights,
          techSpecs: m.techSpecs,
          isDeleted: m.isDeleted,
          status: m.status,
          totalStock: m.totalStock,
          rating: m.rating,
          reviewCount: m.reviewCount,
          createdAt: m.createdAt,
          updatedAt: m.updatedAt,
          isBookmarked: m.isBookmarked,
        );
      }).toList();

      final Map<String, ProductDetailModel> byId = {
        for (final p in mapped) p.id: p,
      };
      products.assignAll(byId.values.toList());
      filteredProducts.assignAll(products); // Initialize filtered products with all products
      _hasLoadedProducts = true;
    } catch (_) {
      products.clear();
    } finally {
      isLoadingProducts.value = false;
    }
  }

  void filterProductsByCategory(String? categoryId) {
    currentCategoryId.value = categoryId;
    print('Filtering by category: $categoryId');
    print('Total products before filter: ${products.length}');
    _applyFilters();
    print('Filtered products count: ${filteredProducts.length}');
  }
  
  void searchProducts(String query) {
    searchQuery.value = query.toLowerCase();
    _applyFilters();
  }
  
  void _applyFilters() {
    var result = products.toList();
    
    // Filter by category
    if (currentCategoryId.value != null && currentCategoryId.value!.isNotEmpty) {
      result = result.where((product) => product.categoryId.id == currentCategoryId.value).toList();
    }
    
    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      result = result.where((product) {
        return product.name.toLowerCase().contains(searchQuery.value) ||
               product.brand.toLowerCase().contains(searchQuery.value) ||
               product.category.toLowerCase().contains(searchQuery.value);
      }).toList();
    }
    
    // Filter by price range
    result = result.where((product) {
      final price = product.sizeType.isNotEmpty ? product.sizeType.first.price : 0.0;
      return price >= minPrice.value && price <= maxPrice.value;
    }).toList();
    
    // Filter by brand
    if (selectedBrands.isNotEmpty) {
      result = result.where((product) => selectedBrands.contains(product.brand)).toList();
    }
    
    // Filter by rating
    if (minRating.value > 0) {
      result = result.where((product) => product.rating >= minRating.value).toList();
    }
    
    // Sort
    if (sortBy.value == 'price_low') {
      result.sort((a, b) {
        final priceA = a.sizeType.isNotEmpty ? a.sizeType.first.price : 0.0;
        final priceB = b.sizeType.isNotEmpty ? b.sizeType.first.price : 0.0;
        return priceA.compareTo(priceB);
      });
    } else if (sortBy.value == 'price_high') {
      result.sort((a, b) {
        final priceA = a.sizeType.isNotEmpty ? a.sizeType.first.price : 0.0;
        final priceB = b.sizeType.isNotEmpty ? b.sizeType.first.price : 0.0;
        return priceB.compareTo(priceA);
      });
    } else if (sortBy.value == 'rating') {
      result.sort((a, b) => b.rating.compareTo(a.rating));
    }
    
    filteredProducts.assignAll(result);
  }

  void clearCategoryFilter() {
    currentCategoryId.value = null;
    _applyFilters();
  }
  
  void clearAllFilters() {
    currentCategoryId.value = null;
    searchQuery.value = '';
    minPrice.value = 0.0;
    maxPrice.value = 10000.0;
    selectedBrands.clear();
    minRating.value = 0.0;
    sortBy.value = 'default';
    filteredProducts.assignAll(products);
  }
  
  // Get all unique brands
  List<String> get availableBrands {
    return products.map((p) => p.brand).where((b) => b.isNotEmpty).toSet().toList()..sort();
  }
  
  // Toggle brand selection
  void toggleBrand(String brand) {
    if (selectedBrands.contains(brand)) {
      selectedBrands.remove(brand);
    } else {
      selectedBrands.add(brand);
    }
    _applyFilters();
  }
  
  // Update price range
  void updatePriceRange(double min, double max) {
    minPrice.value = min;
    maxPrice.value = max;
    _applyFilters();
  }
  
  // Update rating filter
  void updateMinRating(double rating) {
    minRating.value = rating;
    _applyFilters();
  }
  
  // Update sort
  void updateSort(String sort) {
    sortBy.value = sort;
    _applyFilters();
  }

  bool isCategorySelected(String categoryId) => currentCategoryId.value == categoryId;

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
}