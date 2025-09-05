import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/core/navigation/navigation_service.dart';
import 'package:elecktro_ecommerce/app/modules/home/controllers/home_controller.dart';
import '../controllers/cart_controller.dart';
import '../../home/widget/navbar.dart';
import 'cart_widget.dart';
import 'appbar.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Obx(() => controller.cartItems.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [
                // Row with Checkbox and Text showing how many cards are listed
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0), // Reduced vertical space
                  child: Row(
                    children: [
                      // Checkbox with custom color (gray color)
                      Checkbox(
                        value: controller.isChecked.value, // Use the observable value
                        onChanged: (bool? value) {
                          controller.toggleCheckbox(value); // Toggle the checkbox state
                        },
                        activeColor: const Color(0xFF929292), // Set checkbox color to gray (#929292)
                        checkColor: Colors.white, // White check mark inside checkbox
                      ),
                      Text(
                        '${controller.cartItems.length} Items in Cart', // Display number of items
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          height: 1.2, // Reduced line height to 1.2
                          letterSpacing: -0.5, // Letter spacing adjusted
                        ),
                      ),
                    ],
                  ),
                ),
                // Divider under the total items text
                Divider(
                  color: Colors.grey.shade300, // Divider color
                  thickness: 1, // Divider thickness
                  indent: 16, // Indentation for the start of the divider
                  endIndent: 16, // Indentation for the end of the divider
                ),
                // List of Cart Product Cards
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = controller.cartItems[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8), // Reduced bottom padding
                        child: CartProductCard(
                          productName: item['name'] ?? 'Product',
                          brand: item['brand'] ?? 'Brand',
                          size: item['size'] ?? 'M',
                          color: item['color'] ?? 'Black',
                          currentPrice: '\$${item['price']?.toStringAsFixed(2) ?? '0.00'}',
                          originalPrice: item['originalPrice'] != null 
                              ? '\$${item['originalPrice']?.toStringAsFixed(2)}' 
                              : null,
                          imagePath: item['image'],
                          onAddToCart: () {
                            // Increase quantity
                            controller.updateQuantity(index, (item['quantity'] ?? 1) + 1);
                          },
                        ),
                      );
                    },
                  ),
                ),
                // Cart total and checkout card
                if (controller.cartItems.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Left side: Subtotal
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Subtotal',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                Obx(() => Text(
                                  '\$${controller.totalAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                )),
                              ],
                            ),
                            // Right side: Checkout Button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF044D37),
                                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                // Handle checkout
                              },
                              child: const Text(
                                'Check Out',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      bottomNavigationBar: buildBottomNavigationBar(),
      )
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
