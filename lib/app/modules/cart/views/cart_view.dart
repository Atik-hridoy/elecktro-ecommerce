import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/core/navigation/navigation_service.dart';
import 'package:elecktro_ecommerce/app/modules/home/controllers/home_controller.dart';
import 'package:elecktro_ecommerce/app/modules/cart/views/cart_widget.dart';
import 'package:elecktro_ecommerce/app/modules/home/widget/navbar.dart';
import 'package:elecktro_ecommerce/app/core/widgets/error_screens/empty_state_screen.dart';
import 'package:elecktro_ecommerce/app/core/widgets/error_screens/something_went_wrong_screen.dart';
import '../controllers/cart_controller.dart';

import 'appbar.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        appBar: RoundedAppBar(
          title: 'my_cart'.tr,
          height: 60.0,
          borderRadius: 20.0,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          elevation: 4.0,
          shadowColor: const Color(0x33000000),
          showBackButton: false,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (controller.errorMessage.value.isNotEmpty) {
            return SomethingWentWrongScreen(
              message: controller.errorMessage.value,
              onRetry: () => controller.fetchCart(),
            );
          }

          if (controller.itemCount == 0) {
            return EmptyStateScreen(
              title: 'your_cart_empty'.tr,
              message: 'add_products_to_cart'.tr,
              icon: Icons.shopping_cart_outlined,
              onAction: () => Get.find<HomeController>().updateIndex(0),
              actionButtonText: 'start_shopping'.tr,
            );
          }

          return Column(
            children: [
              // Cart items count and select all
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Obx(() => Checkbox(
                          value: controller.isAllSelected.value,
                          onChanged: controller.toggleSelectAll,
                          activeColor: Colors.black,
                        )),
                    Text(
                      '${controller.itemCount} ${'items_in_cart'.tr}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Cart items list
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (controller.errorMessage.value.isNotEmpty) {
                    return SomethingWentWrongScreen(
                      message: controller.errorMessage.value,
                      onRetry: () => controller.fetchCart(),
                    );
                  }
                  
                  final products = controller.cart.value?.products ?? [];
                  
                  if (products.isEmpty) {
                    return EmptyStateScreen(
                      title: 'your_cart_empty'.tr,
                      message: 'add_products_to_cart'.tr,
                      icon: Icons.shopping_cart_outlined,
                      onAction: () => Get.find<HomeController>().updateIndex(0),
                      actionButtonText: 'start_shopping'.tr,
                    );
                  }
                  
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final item = products[index];
                      return CartProductCard(
                        key: ValueKey(item.id),
                        productName: item.name ?? 'product'.tr,
                        brand: item.brand ?? 'generic'.tr,
                        size: item.size.isNotEmpty ? item.size : 'one_size'.tr,
                        color: item.color.isNotEmpty ? item.color : 'black'.tr,
                        price: item.price,
                        quantity: item.quantity,
                        images: item.images,
                        onRemoveFromCart: () {
                          controller.removeFromCart(item.id);
                        },
                      );
                    },
                  );
                }),
              ),
              
              // Checkout section
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'total'.tr,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Obx(() => Text(
                              '\$${controller.totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle checkout
                          // Get.toNamed(Routes.CHECKOUT);
                          Get.snackbar('checkout'.tr, 'proceeding_to_checkout'.tr);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'proceed_to_checkout'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
        bottomNavigationBar: buildBottomNavigationBar(),
      ),
    );
  }

  Widget buildBottomNavigationBar() {
    return Obx(() {
      // Observe the current index from HomeController
      final currentIndex = Get.find<HomeController>().selectedIndex.value;
      return ReusableNavBar(
        currentIndex: currentIndex,
        onTap: NavigationService.to.handleNavigation,
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
    });
  }
}
