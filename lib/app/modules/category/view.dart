import 'package:elecktro_ecommerce/app/core/navigation/navigation_service.dart';
import 'package:elecktro_ecommerce/app/modules/home/controllers/home_controller.dart';
import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/core/widgets/error_screens/no_data_found_screen.dart';
import 'controller.dart';
import '../home/widget/category_list.dart';
import '../home/widget/product_card.dart';
import '../home/widget/navbar.dart';

class CategoryView extends GetView<CategoryController> {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationService = NavigationService.to;
    
    // Screen scaling
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    var widthScale = screenWidth / 375;
    var heightScale = screenHeight / 812;
    
    // Extra reduction for small screens
    final isSmallScreen = screenHeight < 700;
    if (isSmallScreen) {
      widthScale = widthScale * 0.85;
      heightScale = heightScale * 0.75; // 25% smaller on small screens
    }
    
    // AppBar height - calculated to fit all elements without overflow
    // Need enough space for: top padding + search box + category list + spacing
    // With heightScale reduction (0.75), we need higher base to compensate
    final appBarHeight = isSmallScreen ? 240.0 : 220.0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            appBarHeight * heightScale,
          ), // Responsive height based on screen
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                // Search Box
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    16 * widthScale, 
                    60 * heightScale, 
                    16 * widthScale, 
                    10 * heightScale
                  ),
                  child: SizedBox(
                    height: 48 * heightScale,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'search_products'.tr,
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12 * widthScale),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                      suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
                              onPressed: () {
                                controller.searchProducts('');
                              },
                            )
                          : GestureDetector(
                              onTap: () => _showFilterBottomSheet(context),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.filter_list,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'filters'.tr,
                                      style: TextStyle(color: Color(0xFF044D37)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      ),
                      suffixIconConstraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 32,
                      ),
                    ),
                      onChanged: (value) {
                        controller.searchProducts(value);
                      },
                    ),
                  ),
                ),

                // Category List
                
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Align(alignment: Alignment.centerLeft),
                ),
          
                Expanded(
                  child: Obx(
                    () => CategoryList(
                      categories: Get.find<HomeController>().categories.toList(),
                      onCategoryTap: (categoryId) {
                        controller.filterProductsByCategory(categoryId);
                      },
                      selectedCategoryId: controller.currentCategoryId.value,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16), // Reduced bottom padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Products Header
              Obx(() => Padding(
                padding: EdgeInsets.fromLTRB(
                  16 * widthScale, 
                  16 * heightScale, 
                  16 * widthScale, 
                  8 * heightScale
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller.currentCategoryId.value != null
                          ? '${'filtered_products'.tr} (${controller.filteredProducts.length})'
                          : '${'all_products'.tr} (${controller.filteredProducts.length})',
                      style: TextStyle(
                        fontSize: 18 * widthScale,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (controller.currentCategoryId.value != null || controller.searchQuery.value.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          controller.clearAllFilters();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'clear_filters'.tr,
                          style: TextStyle(
                            color: Color(0xFF044D37),
                            fontSize: 14 * widthScale,
                          ),
                        ),
                      ),
                  ],
                ),
              )),

              // Products Grid
              Obx(() {
                if (controller.isLoadingProducts.value) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  );
                }

                final items = controller.filteredProducts;
                if (items.isEmpty) {
                  return NoDataFoundScreen(
                    title: 'no_products_found'.tr,
                    message: controller.searchQuery.value.isNotEmpty
                        ? 'try_different_search'.tr
                        : 'no_products_in_category'.tr,
                    icon: Icons.shopping_bag_outlined,
                    onAction: controller.currentCategoryId.value != null || controller.searchQuery.value.isNotEmpty
                        ? () => controller.clearAllFilters()
                        : null,
                    actionButtonText: 'clear_filters'.tr,
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16 * widthScale,
                    vertical: 8 * heightScale,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: isSmallScreen ? 0.68 : 0.7,
                    crossAxisSpacing: 12 * widthScale,
                    mainAxisSpacing: 16 * heightScale,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final product = items[index];
                    final imageUrl = product.images.isNotEmpty ? product.images.first : null;
                    final price = product.sizeType.isNotEmpty ? product.sizeType.first.price : 0.0;
                    final discount = product.sizeType.isNotEmpty ? product.sizeType.first.discount : 0.0;
                    final priceText = price > 0 ? '\$${price.toStringAsFixed(0)}' : '';

                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          Routes.productDetails,
                          arguments: product, // Pass the full product object
                        );
                      },
                      
                      child: ProductCard(
                        product: product,
                        productId: product.id,
                        name: product.name,
                        brand: product.brand,
                        price: priceText,
                        discount: discount.toString(),
                        imageUrl: imageUrl,
                        onFavoriteTap: () {},
                        isFavorite: false,
                      ),
                    );
                  },
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        ),
        bottomNavigationBar: Obx(() {
          // Observe the current index from HomeController
          final currentIndex = Get.find<HomeController>().selectedIndex.value;
          return ReusableNavBar(
            currentIndex: currentIndex,
            onTap: navigationService.handleNavigation,
            activeColor: const Color(0xFF044D37),
            inactiveColor: Colors.grey,
            backgroundColor: Colors.white,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined, size: 24),
                activeIcon: const Icon(Icons.home, size: 24),
                label: 'home'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.category_outlined, size: 24),
                activeIcon: const Icon(Icons.category, size: 24),
                label: 'categories'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.shopping_cart_outlined, size: 24),
                activeIcon: const Icon(Icons.shopping_cart, size: 24),
                label: 'cart'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline, size: 24),
                activeIcon: const Icon(Icons.person, size: 24),
                label: 'profile'.tr,
              ),
            ],
          );
        }),
      ),
    );
  }
  
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'filters'.tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.clearAllFilters();
                      Navigator.pop(context);
                    },
                    child: Text('clear_all'.tr),
                  ),
                ],
              ),
              const Divider(),
              
              // Filter Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    // Sort By
                    Text(
                      'sort_by'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => Wrap(
                      spacing: 8,
                      children: [
                        _buildChip('default'.tr, controller.sortBy.value == 'default', () {
                          controller.updateSort('default');
                        }),
                        _buildChip('price_low_to_high'.tr, controller.sortBy.value == 'price_low', () {
                          controller.updateSort('price_low');
                        }),
                        _buildChip('price_high_to_low'.tr, controller.sortBy.value == 'price_high', () {
                          controller.updateSort('price_high');
                        }),
                        _buildChip('highest_rated'.tr, controller.sortBy.value == 'rating', () {
                          controller.updateSort('rating');
                        }),
                      ],
                    )),
                    
                    const SizedBox(height: 20),
                    
                    // Price Range
                    Text(
                      'price_range'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => RangeSlider(
                      values: RangeValues(controller.minPrice.value, controller.maxPrice.value),
                      min: 0,
                      max: 10000,
                      divisions: 100,
                      labels: RangeLabels(
                        '\$${controller.minPrice.value.toInt()}',
                        '\$${controller.maxPrice.value.toInt()}',
                      ),
                      onChanged: (values) {
                        controller.updatePriceRange(values.start, values.end);
                      },
                    )),
                    Obx(() => Text(
                      '\$${controller.minPrice.value.toInt()} - \$${controller.maxPrice.value.toInt()}',
                      style: const TextStyle(color: Colors.grey),
                    )),
                    
                    const SizedBox(height: 20),
                    
                    // Rating
                    Text(
                      'minimum_rating'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => Wrap(
                      spacing: 8,
                      children: [
                        _buildChip('all_ratings'.tr, controller.minRating.value == 0, () {
                          controller.updateMinRating(0);
                        }),
                        _buildChip('4+ ⭐', controller.minRating.value == 4, () {
                          controller.updateMinRating(4);
                        }),
                        _buildChip('3+ ⭐', controller.minRating.value == 3, () {
                          controller.updateMinRating(3);
                        }),
                      ],
                    )),
                    
                    const SizedBox(height: 20),
                    
                    // Brands
                    Text(
                      'brands'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() {
                      final brands = controller.availableBrands;
                      if (brands.isEmpty) {
                        return Text('no_brands_available'.tr, style: const TextStyle(color: Colors.grey));
                      }
                      return Wrap(
                        spacing: 8,
                        children: brands.map((brand) {
                          return _buildChip(
                            brand,
                            controller.selectedBrands.contains(brand),
                            () => controller.toggleBrand(brand),
                          );
                        }).toList(),
                      );
                    }),
                  ],
                ),
              ),
              
              // Apply Button
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF044D37),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'apply_filters'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected ? const Color(0xFF044D37) : Colors.grey[200],
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}