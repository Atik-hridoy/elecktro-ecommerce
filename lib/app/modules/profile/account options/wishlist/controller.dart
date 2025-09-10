import 'package:get/get.dart';

// Data model for wishlist items
class WishlistItem {
  final String productId;
  final String name;
  final String brand;
  final String price;
  final String? originalPrice;
  final String? imageUrl;
  final String? discount;
  final double rating;
  final int reviewCount;

  WishlistItem({
    required this.productId,
    required this.name,
    required this.brand,
    required this.price,
    this.originalPrice,
    this.imageUrl,
    this.discount,
    this.rating = 0.0,
    this.reviewCount = 0,
  });
}

// Controller to manage wishlist state
class WishlistController extends GetxController {
  // Observable list of favorite product IDs
  final RxList<String> _favoriteIds = <String>[].obs;
  
  // Observable list of wishlist items
  final RxList<WishlistItem> _wishlistItems = <WishlistItem>[].obs;

  // Getters
  List<String> get favoriteIds => _favoriteIds;
  List<WishlistItem> get wishlistItems => _wishlistItems;

  @override
  void onInit() {
    super.onInit();
    // Initialize with some sample data
    _initializeSampleData();
  }

  void _initializeSampleData() {
    final sampleItems = [
      WishlistItem(
        productId: '1',
        name: 'TiKii Tracker',
        brand: 'Tikii',
        price: '\$16.30',
        originalPrice: '\$6.00',
        imageUrl: 'assets/images/tikii_tracker.png', // Replace with actual image
        discount: '15',
        rating: 4.5,
        reviewCount: 128,
      ),
      WishlistItem(
        productId: '2',
        name: 'Oppo A35 mobile...',
        brand: 'Oppo',
        price: '\$2500',
        imageUrl: 'assets/images/oppo_a35.png', // Replace with actual image
        rating: 4.2,
        reviewCount: 89,
      ),
      WishlistItem(
        productId: '3',
        name: 'CMF Buds By Noth...',
        brand: 'Tribute',
        price: '\$562',
        imageUrl: 'assets/images/cmf_buds.png', // Replace with actual image
        rating: 4.0,
        reviewCount: 45,
      ),
      WishlistItem(
        productId: '4',
        name: 'Nippon TV 40in',
        brand: 'Nippon',
        price: '\$500',
        imageUrl: 'assets/images/nippon_tv.png', // Replace with actual image
        rating: 4.3,
        reviewCount: 67,
      ),
      WishlistItem(
        productId: '5',
        name: 'Vivo Y29',
        brand: 'Vivo',
        price: '\$220',
        imageUrl: 'assets/images/vivo_y29.png', // Replace with actual image
        rating: 4.1,
        reviewCount: 112,
      ),
      WishlistItem(
        productId: '6',
        name: 'Lenovo IdeaPad Sli...',
        brand: 'Lenovo',
        price: '\$220',
        imageUrl: 'assets/images/lenovo_ideapad.png', // Replace with actual image
        rating: 4.4,
        reviewCount: 93,
      ),
    ];

    _wishlistItems.addAll(sampleItems);
    _favoriteIds.addAll(sampleItems.map((item) => item.productId));
  }

  /// Toggle favorite status for a product
  void toggleFavorite(String productId) {
    if (_favoriteIds.contains(productId)) {
      removeFavorite(productId);
    } else {
      addToFavorites(productId);
    }
  }

  /// Add product to favorites/wishlist
  void addToFavorites(String productId) {
    if (!_favoriteIds.contains(productId)) {
      _favoriteIds.add(productId);
      // In a real app, you'd fetch the product details from API
      // For now, we'll just add the ID
    }
  }

  /// Remove product from favorites/wishlist
  void removeFavorite(String productId) {
    _favoriteIds.remove(productId);
    _wishlistItems.removeWhere((item) => item.productId == productId);
    
    // Show feedback to user
    Get.snackbar(
      'Removed from Wishlist',
      'Item has been removed from your wishlist',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  /// Check if product is in favorites
  bool isFavorite(String productId) {
    return _favoriteIds.contains(productId);
  }

  /// Add item to cart
  void addToCart(WishlistItem item) {
    // In a real app, this would add to cart service/controller
    Get.snackbar(
      'Added to Cart',
      '${item.name} has been added to your cart',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Get.theme.colorScheme.primaryContainer,
      colorText: Get.theme.colorScheme.onPrimaryContainer,
    );
  }

  /// Get wishlist item count
  int get wishlistCount => _wishlistItems.length;

  /// Clear all wishlist items
  void clearWishlist() {
    _wishlistItems.clear();
    _favoriteIds.clear();
  }

  /// Add new item to wishlist (used when adding from other screens)
  void addToWishlist(WishlistItem item) {
    if (!_favoriteIds.contains(item.productId)) {
      _favoriteIds.add(item.productId);
      _wishlistItems.add(item);
      
      Get.snackbar(
        'Added to Wishlist',
        '${item.name} has been added to your wishlist',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Get.theme.colorScheme.primaryContainer,
        colorText: Get.theme.colorScheme.onPrimaryContainer,
      );
    }
  }
}