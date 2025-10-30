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
        errorMessage.value = response['message'] ?? 'Failed to load cart';
        print('Error fetching cart: $errorMessage');
        Get.snackbar('Error', errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'An error occurred while loading cart';
      Get.snackbar('Error', errorMessage.value);
      // ignore: avoid_print
      print('Error fetching cart: $e');
    } finally {
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
        Get.snackbar('Success', 'Item added to cart');
      } else {
        errorMessage.value = response['message'] ?? 'Failed to add item to cart';
        Get.snackbar('Error', errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'An error occurred while adding to cart';
      Get.snackbar('Error', errorMessage.value);
      // ignore: avoid_print
      print('Error adding to cart: $e');
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
      errorMessage.value = 'An error occurred while removing item';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
  
  // Update item quantity
  Future<void> updateQuantity(String itemId, int newQuantity) async {
    try {
      if (newQuantity < 1) return;
      
      // TODO: Implement update quantity API call
      // For now, just update the local state
      if (cart.value != null) {
        final updatedProducts = cart.value!.products.map((item) {
          if (item.id == itemId) {
            return item.copyWith(quantity: newQuantity);
          }
          return item;
        }).toList();
        
        cart.value = cart.value!.copyWith(products: updatedProducts);
      }
    } catch (e) {
      errorMessage.value = 'An error occurred while updating quantity';
      Get.snackbar('Error', errorMessage.value);
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
