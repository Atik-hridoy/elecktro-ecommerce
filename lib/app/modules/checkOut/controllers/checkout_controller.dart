import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutController extends GetxController {
  // Cart items list (in a real app, this would come from a service)
  final RxList<Map<String, dynamic>> cartItems = <Map<String, dynamic>>[].obs;
  
  // Order summary values
  final RxDouble subtotal = 0.0.obs;
  final RxDouble deliveryFee = 5.99.obs; // Example fixed delivery fee
  
  // Computed total amount
  double get totalAmount => subtotal.value + deliveryFee.value;
  
  @override
  void onInit() {
    super.onInit();
    // In a real app, you would fetch cart items from a service
    _loadCartItems();
  }

  // Load cart items (mock data for example)
  void _loadCartItems() {
    // This is example data - in a real app, you would get this from your cart service
    final exampleItems = [
      {
        'id': '1',
        'name': 'Wireless Headphones',
        'brand': 'Sony',
        'price': 99.99,
        'originalPrice': 129.99,
        'quantity': 1,
        'size': 'One Size',
        'color': 'Black',
        'image': 'assets/images/headphones.jpg',
      },
      {
        'id': '2',
        'name': 'Smart Watch',
        'brand': 'Samsung',
        'price': 199.99,
        'quantity': 1,
        'size': 'M',
        'color': 'Silver',
        'image': 'assets/images/smartwatch.jpg',
      },
    ];
    
    cartItems.assignAll(exampleItems);
    _calculateSubtotal();
  }
  
  // Calculate subtotal based on cart items
  void _calculateSubtotal() {
    double total = 0.0;
    for (var item in cartItems) {
      total += (item['price'] as num).toDouble() * (item['quantity'] as int);
    }
    subtotal.value = total;
  }
  
  // Update item quantity
  void updateQuantity(int index, int newQuantity) {
    if (newQuantity > 0) {
      final item = cartItems[index];
      item['quantity'] = newQuantity;
      cartItems[index] = Map<String, dynamic>.from(item);
      _calculateSubtotal();
    } else {
      // Remove item if quantity is 0
      removeItem(index);
    }
  }
  
  // Remove item from cart
  void removeItem(int index) {
    if (index >= 0 && index < cartItems.length) {
      cartItems.removeAt(index);
      _calculateSubtotal();
    }
  }
  
  // Process checkout
  Future<void> processCheckout() async {
    // In a real app, you would process the payment and create an order
    // This is a placeholder for the checkout logic
    try {
      // Show loading
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Close loading dialog
      Get.back();
      
      // Show success message
      Get.snackbar(
        'Order Placed!',
        'Your order has been placed successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Clear cart and go to home or order confirmation
      cartItems.clear();
      Get.offAllNamed('/home');
      
    } catch (e) {
      // Close loading dialog if still open
      if (Get.isDialogOpen ?? false) Get.back();
      
      // Show error message
      Get.snackbar(
        'Error',
        'Failed to process your order. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
