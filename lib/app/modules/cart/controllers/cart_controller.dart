import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/modules/cart/models/cart_model.dart';
import 'package:elecktro_ecommerce/app/modules/product_details/services/add_to_card_service.dart';
import 'package:elecktro_ecommerce/app/modules/product_details/model/add_to_cart.dart';

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
      return {'cartItems': []};
    }

    return {
      'cartItems': cart.value!.products.map((item) => {
            'productId': item.productId,
            'size': item.size,
            'quantity': item.quantity,
            'profit': item.profit,
            'color': item.color,
          }).toList(),
    };
  }

  // Navigate to checkout
  void navigateToCheckout() {
    final checkoutData = prepareCheckoutData();
    // Navigate to checkout screen with the prepared data
    Get.toNamed('/checkout', arguments: checkoutData);
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
  
  // Update item quantity with API call
  Future<void> updateQuantity(String productId, int newQuantity) async {
    try {
      if (newQuantity < 1) {
        Get.snackbar('error'.tr, 'Quantity must be at least 1');
        return;
      }
      
      // Don't show full loading indicator, just update in background
      errorMessage.value = '';
      
      print('🔄 Updating quantity for product: $productId to $newQuantity');
      
      // Optimistically update local state first for better UX
      if (cart.value != null) {
        final updatedProducts = cart.value!.products.map((item) {
          if (item.productId == productId) {
            return item.copyWith(quantity: newQuantity);
          }
          return item;
        }).toList();
        
        cart.value = cart.value!.copyWith(products: updatedProducts);
      }
      
      // Then update on server
      final response = await _cartService.updateCartItemQuantity(productId, newQuantity);
      
      if (response['success'] == true) {
        print('✅ Quantity updated successfully');
        // Silently refresh cart data from server to sync
        await fetchCart();
      } else {
        errorMessage.value = response['message'] ?? 'Failed to update quantity';
        Get.snackbar('error'.tr, errorMessage.value);
        // Revert on failure
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
