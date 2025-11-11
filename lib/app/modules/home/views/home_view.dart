import 'package:elecktro_ecommerce/app/core/navigation/navigation_service.dart';
import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:elecktro_ecommerce/app/modules/profile/controllers/account_edit_controller.dart';
import 'package:elecktro_ecommerce/app/modules/notification/notification_controller.dart';
import 'package:elecktro_ecommerce/app/modules/category/controller.dart';
import 'package:elecktro_ecommerce/app/core/widgets/error_screens/network_error_screen.dart';
import 'package:elecktro_ecommerce/app/core/widgets/error_screens/server_error_screen.dart';
import 'package:elecktro_ecommerce/app/core/widgets/error_screens/something_went_wrong_screen.dart';
import '../widget/appbar.dart';
import '../widget/product_card.dart';
import '../widget/banner_card.dart';
import '../widget/category_list.dart';
import '../widget/navbar.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller if not already initialized
    final homeController = Get.find<HomeController>();
    final accountController = Get.isRegistered<AccountController>()
        ? Get.find<AccountController>()
        : Get.put(AccountController());
    
    // Initialize NotificationController if not already initialized
    final notificationController = Get.isRegistered<NotificationController>()
        ? Get.find<NotificationController>()
        : Get.put(NotificationController());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Obx(() => Scaffold(
        appBar: homeController.selectedIndex.value == 0
            ? CustomAppBar(
                userName: accountController.fullName.value.isNotEmpty
                    ? accountController.fullName.value
                    : 'guest'.tr,
                phoneNumber: accountController.phone.value,
                searchHint: 'search_products'.tr,
                hasUnreadNotifications: notificationController.unreadCount > 0,
                onNotificationTap: () {
                  Get.toNamed(Routes.notification);
                },
                onProfileTap: () {
                  Get.toNamed(Routes.profile);
                },
                onSearchChanged: (query) {
                  homeController.searchProducts(query);
                },
              )
            : null,
        body: _buildHomePage(homeController),
        bottomNavigationBar: Obx(() {
          // Observe the current index from HomeController
          final currentIndex = Get.find<HomeController>().selectedIndex.value;
          return ReusableNavBar(
            currentIndex: currentIndex,
            onTap: NavigationService.to.handleNavigation,
            activeColor: const Color(
              0xFF044D37,
            ), // Green color from your design
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
      )),
    );
  }

  // Home page body structure
  Widget _buildHomePage(HomeController homeController) {
    return Obx(() {
      final screenHeight = Get.height;
      final heightScale = screenHeight / 812;
      final productListHeight = 240.0 * heightScale;
      // Show Network Error Screen
      if (homeController.hasNetworkError.value) {
        return NetworkErrorScreen(
          onRetry: () {
            homeController.fetchBanners();
            homeController.fetchCategories();
            homeController.fetchPopularProducts();
          },
        );
      }
      
      // Show Server Error Screen
      if (homeController.hasServerError.value) {
        return ServerErrorScreen(
          onRetry: () {
            homeController.fetchBanners();
            homeController.fetchCategories();
            homeController.fetchPopularProducts();
          },
        );
      }
      
      return Builder(
        builder: (context) => Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              // Banner Section with auto-sliding
              GetBuilder<HomeController>(
                builder: (controller) {
                  if (controller.isLoading.value) {
                    return const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  
                  if (controller.error.isNotEmpty) {
                    return SomethingWentWrongScreen(
                      message: controller.error.value,
                      onRetry: () => controller.fetchBanners(),
                    );
                  }
                
                if (controller.banners.isEmpty) {
                  return const SizedBox.shrink();
                }
                
                return BannerCard(
                  key: const ValueKey('banner_slider'),
                  items: controller.banners,
                  currentIndex: controller.currentBannerIndex.value,
                  onPageChanged: (index) {
                    controller.updateBannerIndex(index);
                  },
                );
              },
            ),
            const SizedBox(height: 16),

            // Category Section
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              clipBehavior: Clip.antiAlias,
              elevation: 1,
              child: Obx(() => CategoryList(
                    categories: homeController.categories.toList(),
                  )),
            ),

            const SizedBox(height: 24),

            // Popular Products Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'popular_products'.tr,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      if (homeController.searchQuery.value.isNotEmpty)
                        Text(
                          '${homeController.filteredPopularProducts.length} ${'results_found'.tr}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                  if (homeController.searchQuery.value.isEmpty)
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'view_all'.tr,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: () => homeController.clearSearch(),
                      child: Text(
                        'clear'.tr,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              )),
            ),

            const SizedBox(height: 16),

            // Popular Products Grid
            Obx(() {
              final isLoading = homeController.isLoadingPopularProducts.value;
              final products = homeController.filteredPopularProducts;

              // Show error state only when no search query (empty popular products)
              if (products.isEmpty && !isLoading && homeController.searchQuery.value.isEmpty) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.inbox_rounded,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'no_popular_products'.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'check_back_later'.tr,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
              
              // If searching and no results, show empty space (floating card will appear)
              if (products.isEmpty && !isLoading && homeController.searchQuery.value.isNotEmpty) {
                return const SizedBox(height: 240);
              }

              // Show products list
              return SizedBox(
                height: productListHeight,
                child: Skeletonizer(
                  enabled: isLoading,
                  child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: isLoading ? 5 : products.length,
                          itemBuilder: (context, index) {
                            if (isLoading) {
                              // Show skeleton cards
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: ProductCard(
                                  name: '',
                                  productId: 'skeleton-$index',
                                  brand: '',
                                  price: '',
                                  imageUrl: '',
                                ),
                              );
                            }

                            final product = products[index];
                            final price = product.sizeType.isNotEmpty
                                ? product.sizeType.first.price.toString()
                                : '0';
                            final discount = product.sizeType.isNotEmpty
                                ? product.sizeType.first.discount.toString()
                                : '0';
                            final imageUrl = product.images.isNotEmpty
                                ? product.images.first
                                : '';

                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: ProductCard(
                                product: product,
                                name: product.name,
                                productId: product.id,
                                brand: product.brand,
                                price: '\$$price',
                                discount: discount,
                                imageUrl: imageUrl,
                                rating: product.rating,
                                reviewCount: product.reviewCount,
                              ),
                            );
                          },
                        ),
                  ),
                );
              }),

            const SizedBox(height: 24),

            // Size-wise Products Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'all_products'.tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // All Products Grid
            Obx(() {
              final categoryController = Get.find<CategoryController>();
              final products = categoryController.products;
              final isLoading = categoryController.isLoadingProducts.value;

              if (isLoading) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        name: '',
                        productId: 'skeleton-$index',
                        brand: '',
                        price: '',
                        imageUrl: '',
                      );
                    },
                  ),
                );
              }

              if (products.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Text(
                      'no_products_available'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final price = product.sizeType.isNotEmpty
                        ? product.sizeType.first.price.toString()
                        : '0';
                    final discount = product.sizeType.isNotEmpty
                        ? product.sizeType.first.discount.toString()
                        : '0';
                    final imageUrl = product.images.isNotEmpty
                        ? product.images.first
                        : '';

                    return ProductCard(
                      product: product,
                      name: product.name,
                      productId: product.id,
                      brand: product.brand,
                      price: '\$$price',
                      discount: discount,
                      imageUrl: imageUrl,
                      rating: product.rating,
                      reviewCount: product.reviewCount,
                    );
                  },
                ),
              );
            }),

            const SizedBox(
              height: 20,
            ), // Adjusted bottom padding to prevent overflow
          ],
        ),
      ),
      
      // Floating error card for search results
      Obx(() {
        final isLoading = homeController.isLoadingPopularProducts.value;
        final products = homeController.filteredPopularProducts;
        final hasSearchQuery = homeController.searchQuery.value.isNotEmpty;
        
        // Only show floating card when searching and no results found
        if (hasSearchQuery && products.isEmpty && !isLoading) {
          return Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'no_results_found'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${'no_products_for_search'.tr} "${homeController.searchQuery.value}"',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => homeController.clearSearch(),
                    icon: const Icon(Icons.clear, size: 18),
                    label: Text('clear_search'.tr),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF044D37),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      }),
    ],
        ),
      );
    });
  }
}
