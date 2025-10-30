import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/core/navigation/navigation_service.dart';
import 'package:elecktro_ecommerce/app/modules/home/controllers/home_controller.dart';
import 'package:elecktro_ecommerce/app/modules/cart/views/cart_widget.dart';
import 'package:elecktro_ecommerce/app/modules/home/widget/navbar.dart';
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
          title: 'My Cart',
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
            return Center(
              child: Text(
                controller.errorMessage.value,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (controller.itemCount == 0) {
            return const Center(
              child: Text('Your cart is empty'),
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
                      '${controller.itemCount} Items in Cart',
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
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(controller.errorMessage.value),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => controller.fetchCart(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  final products = controller.cart.value?.products ?? [];
                  
                  if (products.isEmpty) {
                    return const Center(
                      child: Text('Your cart is empty'),
                    );
                  }
                  
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final item = products[index];
                      return CartProductCard(
                        key: ValueKey(item.id),
                        productName: item.name ?? 'Product',
                        brand: item.brand ?? 'Generic',
                        size: item.size.isNotEmpty ? item.size : 'One Size',
                        color: item.color.isNotEmpty ? item.color : 'Black',
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
                        const Text(
                          'Total:',
                          style: TextStyle(
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
                          Get.snackbar('Checkout', 'Proceeding to checkout');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Proceed to Checkout',
                          style: TextStyle(
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
    });
  }
}
