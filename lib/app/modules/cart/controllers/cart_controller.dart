import 'package:get/get.dart';

class CartController extends GetxController {
  static CartController get to => Get.find();
  
  // Add your cart logic here
  final RxList<Map<String, dynamic>> cartItems = <Map<String, dynamic>>[].obs;
  
  // Observable for checkbox state
  var isChecked = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Add sample data for testing
    if (cartItems.isEmpty) {
      addToCart({
        'id': '1',
        'name': 'Wireless Headphones',
        'brand': 'Sony',
        'price': 99.99,
        'originalPrice': 129.99,
        'size': 'One Size',
        'color': 'Black',
        'image': 'assets/icons/home/ex1.png',
      });
      
      addToCart({
        'id': '2',
        'name': 'Smart Watch',
        'brand': 'Samsung',
        'price': 199.99,
        'size': 'M',
        'color': 'Silver',
        'image': 'assets/icons/home/ex1.png',
 
      });
    }
  }
  
  // Add methods for cart operations
  void addToCart(Map<String, dynamic> product) {
    // Check if product already exists in cart
    final existingIndex = cartItems.indexWhere((item) => 
      item['id'] == product['id'] && 
      item['size'] == product['size'] && 
      item['color'] == product['color']
    );

    if (existingIndex >= 0) {
      // Update quantity if product exists
      updateQuantity(existingIndex, (cartItems[existingIndex]['quantity'] ?? 1) + 1);
    } else {
      // Add new product with quantity 1
      cartItems.add({
        ...product,
        'quantity': 1,
        'isFavorite': false,
      });
      update();
    }
  }
  
  void removeFromCart(int index) {
    if (index >= 0 && index < cartItems.length) {
      cartItems.removeAt(index);
      update();
    }
  }

  void toggleFavorite(int index) {
    if (index >= 0 && index < cartItems.length) {
      final item = cartItems[index];
      item['isFavorite'] = !(item['isFavorite'] ?? false);
      cartItems[index] = Map<String, dynamic>.from(item);
      update();
    }
  }

  void updateQuantity(int index, int newQuantity) {
    if (index >= 0 && index < cartItems.length && newQuantity > 0) {
      final item = cartItems[index];
      item['quantity'] = newQuantity;
      cartItems[index] = Map<String, dynamic>.from(item);
      update();
    }
  }

  // Toggle the checkbox state
  void toggleCheckbox(bool? value) {
    if (value != null) {
      isChecked.value = value;  // Update the checkbox state
    }
  }
  
  double get totalAmount {
    return cartItems.fold(0, (sum, item) => 
      sum + ((item['price'] as num).toDouble() * (item['quantity'] ?? 1))
    );
  }

  int get totalItems {
    return cartItems.fold(0, (int sum, item) => sum + ((item['quantity'] as int?) ?? 1));
  }
}
