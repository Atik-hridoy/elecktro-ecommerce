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
    
    // Screen scaling
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    var widthScale = screenWidth / 375;
    var heightScale = screenHeight / 812;
    
    // Extra reduction for small screens
    final isSmallScreen = screenHeight < 700;
    if (isSmallScreen) {
      widthScale = widthScale * 0.85;
      heightScale = heightScale * 0.75;
    }
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        appBar: RoundedAppBar(
          title: 'my_cart'.tr,
          height: 60.0 * heightScale,
          borderRadius: 20.0 * widthScale,
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
              // Cart items count, select all, and clear cart button
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0 * widthScale, 
                  vertical: 8.0 * heightScale
                ),
                child: Row(
                  children: [
                    Obx(() => Checkbox(
                          value: controller.isAllSelected.value,
                          onChanged: controller.toggleSelectAll,
                          activeColor: Colors.black,
                        )),
                    Text(
                      '${controller.itemCount} ${'items_in_cart'.tr}',
                      style: TextStyle(
                        fontSize: 16 * widthScale,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    // Clear Cart Button
                    TextButton.icon(
                      onPressed: () => _showClearCartDialog(context, controller),
                      icon: Icon(
                        Icons.delete_outline,
                        size: 18 * widthScale,
                        color: Colors.red,
                      ),
                      label: Text(
                        'clear_cart'.tr,
                        style: TextStyle(
                          fontSize: 14 * widthScale,
                          color: Colors.red,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8 * widthScale,
                          vertical: 4 * heightScale,
                        ),
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
                    padding: EdgeInsets.symmetric(horizontal: 16.0 * widthScale),
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
                        onQuantityChanged: (newQuantity) {
                          // Call controller with productId for PATCH request
                          controller.updateQuantity(item.productId, newQuantity);
                        },
                      );
                    },
                  );
                }),
              ),
              
              // Checkout section
              Container(
                padding: EdgeInsets.all(16.0 * widthScale),
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
                          style: TextStyle(
                            fontSize: 18 * widthScale,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Obx(() => Text(
                              '\$${controller.totalAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 20 * widthScale,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            )),
                      ],
                    ),
                    SizedBox(height: 16 * heightScale),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to checkout with cart data
                          controller.navigateToCheckout();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: 16 * heightScale),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30 * widthScale),
                          ),
                        ),
                        child: Text(
                          'proceed_to_checkout'.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16 * widthScale,
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

  /// Show confirmation dialog before clearing the entire cart
  void _showClearCartDialog(BuildContext context, CartController controller) {
    Get.dialog(
      AlertDialog(
        title: Text('clear_cart'.tr),
        content: Text('Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          FilledButton(
            onPressed: () async {
              Get.back();
              await controller.clearCart();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('clear'.tr),
          ),
        ],
      ),
    );
  }
}
