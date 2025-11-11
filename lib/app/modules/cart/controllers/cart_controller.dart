import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/modules/cart/models/cart_model.dart';
import 'package:elecktro_ecommerce/app/modules/product_details/services/add_to_card_service.dart';
import 'package:elecktro_ecommerce/app/modules/product_details/model/add_to_cart.dart';
import 'package:elecktro_ecommerce/app/routes/app_pages.dart';

class CartController extends GetxController {
  static CartController get to => Get.find();
  
  final CartService _cartService = CartService();
  
  // Cart data
  final Rxn<CartModel> cart = Rxn<CartModel>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  
  // Getter for cart items count
  int get itemCount => cart.value?.products.length ?? 0;
  
  // Getter for total amount
  double get totalAmount => cart.value?.totalAmount ?? 0.0;
  
  // Observable for select all checkbox
  final RxBool isAllSelected = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }
  
  // Prepare cart data for checkout
  Map<String, dynamic> prepareCheckoutData() {
    if (cart.value == null || cart.value!.products.isEmpty) {
      return {
        'cartItems': [],
        'totalAmount': 0.0,
        'itemCount': 0,
      };
    }

    return {
      'cartItems': cart.value!.products.map((item) => {
            'id': item.productId, // Use productId as id for checkout compatibility
            'productId': item.productId,
            'name': item.name ?? 'Product',
            'brand': item.brand ?? 'Brand',
            'size': item.size,
            'quantity': item.quantity,
            'price': item.price,
            'originalPrice': item.price, // Add originalPrice for checkout display
            'profit': item.profit,
            'color': item.color,
            'images': item.images,
            'image': item.images.isNotEmpty ? item.images.first : '',
          }).toList(),
      'totalAmount': cart.value!.totalAmount,
      'itemCount': cart.value!.products.length,
      'subtotal': cart.value!.totalAmount,
      // Add any additional checkout metadata
      'directCheckout': false, // This is from cart, not direct product purchase
    };
  }

  // Navigate to checkout
  void navigateToCheckout() {
    if (cart.value == null || cart.value!.products.isEmpty) {
      Get.snackbar(
        'empty_cart'.tr,
        'add_items_to_cart_first'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    final checkoutData = prepareCheckoutData();
    print('🛒 Navigating to checkout with data: $checkoutData');
    
    // Navigate to checkout screen with the prepared data
    Get.toNamed(Routes.checkout, arguments: checkoutData);
  }

  // Fetch cart data from API
  Future<void> fetchCart() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      print('Fetching cart data...');
      final response = await _cartService.getCart();
      print('Cart API Response: $response');
      
      if (response['success'] == true) {
        print('Cart data received, parsing...');
        // The actual cart data is in response['data']['data']
        final cartData = response['data'] is Map && response['data']['data'] != null 
            ? response['data']['data'] 
            : response['data'];
            
        cart.value = CartModel.fromJson(cartData);
        print('Cart items count: ${cart.value?.products.length ?? 0}');
        if (cart.value?.products.isEmpty ?? true) {
          print('Cart is empty or no products found in the response');
        }
      } else {
        errorMessage.value = response['message'] ?? 'failed_load_cart'.tr;
      }
    } catch (e) {
      errorMessage.value = 'error_loading_cart'.tr;
    } finally{
      isLoading.value = false;
    }
  }
  
  // Add item to cart
  Future<void> addToCart(String productId, {
    required String size,
    required String color,
    int quantity = 1,
    double price = 0.0,
    List<String> images = const [],
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final response = await _cartService.addToCart(
        AddToCartModel(
          productId: productId,
          size: size,
          price: price,
          quantity: quantity,
          color: color,
          images: images,
        ),
      );
      
      if (response['success'] == true) {
        await fetchCart(); // Refresh cart data
        Get.snackbar('success'.tr, 'item_added_to_cart'.tr);
      } else {
        errorMessage.value = response['message'] ?? 'failed_add_to_cart'.tr;
      }
    } catch (e) {
      errorMessage.value = 'error_adding_to_cart'.tr;
    } finally {
      isLoading.value = false;
    }
  }
  
  // Remove item from cart
  Future<void> removeFromCart(String itemId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // TODO: Implement remove from cart API call
      // For now, just update the local state
      if (cart.value != null) {
        cart.value = cart.value!.copyWith(
          products: cart.value!.products.where((item) => item.id != itemId).toList(),
        );
      }
    } catch (e) {
      errorMessage.value = 'error_removing_item'.tr;
    } finally {
      isLoading.value = false;
    }
  }
  
  // Increment item quantity by 1
  Future<void> incrementQuantity(String cartItemId) async {
    try {
      errorMessage.value = '';
      
      print('➕ Incrementing quantity for cart item: $cartItemId');
      
      // Optimistically update local state first for better UX
      if (cart.value != null) {
        final updatedProducts = cart.value!.products.map((item) {
          if (item.id == cartItemId) {
            return item.copyWith(quantity: item.quantity + 1);
          }
          return item;
        }).toList();
        
        cart.value = cart.value!.copyWith(products: updatedProducts);
      }
      
      // Then update on server
      final response = await _cartService.incrementQuantity(cartItemId);
      
      if (response['success'] == true) {
        print('✅ Quantity incremented successfully');
        // Refresh cart data from server to sync
        await fetchCart();
      } else {
        errorMessage.value = response['message'] ?? 'Failed to increase quantity';
        Get.snackbar('error'.tr, errorMessage.value);
        // Revert on failure
        await fetchCart();
      }
    } catch (e) {
      print('❌ Error incrementing quantity: $e');
      errorMessage.value = 'error_updating_quantity'.tr;
      Get.snackbar('error'.tr, errorMessage.value);
      // Revert on error
      await fetchCart();
    }
  }
  
  // Decrement item quantity by 1
  Future<void> decrementQuantity(String cartItemId) async {
    try {
      errorMessage.value = '';
      
      print('➖ Decrementing quantity for cart item: $cartItemId');
      
      // Optimistically update local state first for better UX
      if (cart.value != null) {
        final cartItem = cart.value!.products.firstWhereOrNull(
          (item) => item.id == cartItemId
        );
        
        // Don't decrement below 1
        if (cartItem != null && cartItem.quantity <= 1) {
          Get.snackbar('error'.tr, 'Quantity cannot be less than 1');
          return;
        }
        
        final updatedProducts = cart.value!.products.map((item) {
          if (item.id == cartItemId) {
            return item.copyWith(quantity: item.quantity - 1);
          }
          return item;
        }).toList();
        
        cart.value = cart.value!.copyWith(products: updatedProducts);
      }
      
      // Then update on server
      final response = await _cartService.decrementQuantity(cartItemId);
      
      if (response['success'] == true) {
        print('✅ Quantity decremented successfully');
        // Refresh cart data from server to sync
        await fetchCart();
      } else {
        errorMessage.value = response['message'] ?? 'Failed to decrease quantity';
        Get.snackbar('error'.tr, errorMessage.value);
        // Revert on failure
        await fetchCart();
      }
    } catch (e) {
      print('❌ Error decrementing quantity: $e');
      errorMessage.value = 'error_updating_quantity'.tr;
      Get.snackbar('error'.tr, errorMessage.value);
      // Revert on error
      await fetchCart();
    }
  }
  
  // Update item quantity to a specific value
  Future<void> updateQuantity(String productId, int newQuantity) async {
    try {
      errorMessage.value = '';
      
      if (newQuantity < 1) {
        Get.snackbar('error'.tr, 'Quantity cannot be less than 1');
        return;
      }
      
      print('🔄 Updating quantity for product: $productId to $newQuantity');
      
      // Find the cart item by productId
      if (cart.value != null) {
        final cartItem = cart.value!.products.firstWhereOrNull(
          (item) => item.productId == productId
        );
        
        if (cartItem == null) {
          print('❌ Cart item not found for product: $productId');
          return;
        }
        
        final currentQuantity = cartItem.quantity;
        final difference = newQuantity - currentQuantity;
        
        // Optimistically update local state first for better UX
        final updatedProducts = cart.value!.products.map((item) {
          if (item.productId == productId) {
            return item.copyWith(quantity: newQuantity);
          }
          return item;
        }).toList();
        
        cart.value = cart.value!.copyWith(products: updatedProducts);
        
        // Update on server by calling increment/decrement multiple times
        // or implement a direct update API call if available
        if (difference > 0) {
          // Need to increment
          for (int i = 0; i < difference; i++) {
            await _cartService.incrementQuantity(cartItem.id);
          }
        } else if (difference < 0) {
          // Need to decrement
          for (int i = 0; i < difference.abs(); i++) {
            await _cartService.decrementQuantity(cartItem.id);
          }
        }
        
        print('✅ Quantity updated successfully');
        // Refresh cart data from server to sync
        await fetchCart();
      }
    } catch (e) {
      print('❌ Error updating quantity: $e');
      errorMessage.value = 'error_updating_quantity'.tr;
      Get.snackbar('error'.tr, errorMessage.value);
      // Revert on error
      await fetchCart();
    }
  }
  
  // Clear entire cart
  Future<void> clearCart() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      print('🗑️ Clearing entire cart...');
      
      final response = await _cartService.clearCart();
      
      if (response['success'] == true) {
        print('✅ Cart cleared successfully');
        cart.value = null; // Clear local cart data
        Get.snackbar('success'.tr, 'Cart cleared successfully');
      } else {
        errorMessage.value = response['message'] ?? 'Failed to clear cart';
        Get.snackbar('error'.tr, errorMessage.value);
      }
    } catch (e) {
      print('❌ Error clearing cart: $e');
      errorMessage.value = 'Error clearing cart';
      Get.snackbar('error'.tr, errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
  
  // Toggle select all items
  void toggleSelectAll(bool? value) {
    isAllSelected.value = value ?? false;
    // TODO: Update individual item selection state if needed
  }
  
  // Toggle item selection
  void toggleItemSelection(String itemId) {
    // TODO: Implement individual item selection logic
  }
}
