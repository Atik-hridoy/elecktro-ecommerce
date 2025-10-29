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
  final isLoadingProducts = false.obs;
  bool _hasLoadedProducts = false;

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
      _hasLoadedProducts = true;
    } catch (_) {
      products.clear();
    } finally {
      isLoadingProducts.value = false;
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
}