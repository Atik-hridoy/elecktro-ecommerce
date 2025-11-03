import 'package:elecktro_ecommerce/app/core/navigation/navigation_service.dart';
import 'package:elecktro_ecommerce/app/modules/home/controllers/home_controller.dart';
import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'controller.dart';
import '../home/widget/category_list.dart';
import '../home/widget/product_card.dart';
import '../home/widget/navbar.dart';

class CategoryView extends GetView<CategoryController> {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationService = NavigationService.to;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(
            220,
          ), // Increased height to accommodate both search and categories
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
                  padding: const EdgeInsets.fromLTRB(16, 60, 16, 10),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
                              onPressed: () {
                                controller.searchProducts('');
                              },
                            )
                          : Padding(
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
                                    'Filters',
                                    style: TextStyle(color: Color(0xFF044D37)),
                                  ),
                                ],
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
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller.currentCategoryId.value != null
                          ? 'Filtered Products (${controller.filteredProducts.length})'
                          : 'All Products (${controller.filteredProducts.length})',
                      style: const TextStyle(
                        fontSize: 18,
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
                        child: const Text(
                          'Clear Filters',
                          style: TextStyle(
                            color: Color(0xFF044D37),
                            fontSize: 14,
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
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: Text('No products found')),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
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
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 24),
                activeIcon: Icon(Icons.home, size: 24),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category_outlined, size: 24),
                activeIcon: Icon(Icons.category, size: 24),
                label: 'Categories',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined, size: 24),
                activeIcon: Icon(Icons.shopping_cart, size: 24),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline, size: 24),
                activeIcon: Icon(Icons.person, size: 24),
                label: 'Profile',
              ),
            ],
          );
        }),
      ),
    );
  }
}