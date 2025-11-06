import 'package:elecktro_ecommerce/app/core/navigation/navigation_service.dart';
import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:elecktro_ecommerce/app/modules/profile/controllers/account_edit_controller.dart';
import 'package:elecktro_ecommerce/app/modules/notification/notification_controller.dart';
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
    return Builder(
      builder: (context) => SingleChildScrollView(
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
                  return Container(
                    height: 200,
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        controller.error.value,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
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
            SizedBox(
              height: 240,
              child: Obx(() {
                final isLoading = homeController.isLoadingPopularProducts.value;
                final products = homeController.filteredPopularProducts;

                // Show skeleton loader or actual products
                return Skeletonizer(
                  enabled: isLoading,
                  child: products.isEmpty && !isLoading
                      ? Center(
                          child: Text(
                            homeController.searchQuery.value.isEmpty
                                ? 'no_popular_products'.tr
                                : '${'no_products_for_search'.tr} "${homeController.searchQuery.value}"',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: isLoading ? 5 : products.length,
                          itemBuilder: (context, index) {
                            if (isLoading) {
                              // Show skeleton cards
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: ProductCard(
                                  name: 'Loading Product Name',
                                  productId: 'skeleton-$index',
                                  brand: 'Loading Brand',
                                  price: '\$999',
                                  imageUrl: '',
                                  rating: 4.5,
                                  reviewCount: 100,
                                ),
                              );
                            }

                            final product = products[index];
                            final price = product.sizeType.isNotEmpty
                                ? product.sizeType.first.price.toString()
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
                                imageUrl: imageUrl,
                                rating: product.rating,
                                reviewCount: product.reviewCount,
                              ),
                            );
                          },
                        ),
                );
              }),
            ),

            const SizedBox(height: 24),

            // You may like Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'you_may_like'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // You may like products
            SizedBox(
              height: 240,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 6, // Total number of products
                itemBuilder: (context, index) {
                  // List of recommended products
                  const recommendedProducts = [
                    {
                      'id': 'prod_006',
                      'name': 'Wireless Keyboard',
                      'brand': 'KeyMaster',
                      'price': '\$59',
                      'imageUrl': 'assets/images/6.jpeg',
                    },
                    {
                      'id': 'prod_007',
                      'name': 'Gaming Mouse',
                      'brand': 'GameGear',
                      'price': '\$79',
                      'imageUrl': 'assets/images/7.jpeg',
                    },
                    {
                      'id': 'prod_008',
                      'name': 'USB Hub',
                      'brand': 'PortPlus',
                      'price': '\$25',
                      'imageUrl': 'assets/images/8.jpeg',
                    },
                    {
                      'id': 'prod_009',
                      'name': 'Laptop Stand',
                      'brand': 'ErgoTech',
                      'price': '\$35',
                      'imageUrl': 'assets/images/1.jpeg',
                    },
                    {
                      'id': 'prod_010',
                      'name': 'Screen Protector',
                      'brand': 'ShieldMax',
                      'price': '\$12',
                      'imageUrl': 'assets/images/2.jpeg',
                    },
                    {
                      'id': 'prod_011',
                      'name': 'Laptop Sleeve',
                      'brand': 'UrbanGear',
                      'price': '\$25',
                      'imageUrl': 'assets/images/3.jpeg',
                    },
                  ];

                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ProductCard(
                      productId: recommendedProducts[index]['id'] as String,
                      name: recommendedProducts[index]['name'] as String,
                      brand: recommendedProducts[index]['brand'] as String,
                      price: recommendedProducts[index]['price'] as String,
                      imageUrl: recommendedProducts[index]['imageUrl'],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(
              height: 20,
            ), // Adjusted bottom padding to prevent overflow
          ],
        ),
      ),
    );
  }
}
