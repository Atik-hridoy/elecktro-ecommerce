import 'package:elecktro_ecommerce/app/modules/home/widget/product_card.dart';
import 'package:elecktro_ecommerce/app/modules/profile/account%20options/wishlist/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Import your ProductCard widget
// import 'package:elecktro_ecommerce/widgets/product_card.dart';
// Import the controller
// import 'package:elecktro_ecommerce/controllers/wishlist_controller.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get or create the controller instance
    final WishlistController controller = Get.put(WishlistController());

    return Scaffold(
      appBar: _buildAppBar(controller),
      body: Obx(() {
        if (controller.wishlistItems.isEmpty) {
          return _buildEmptyWishlist(context);
        }

        return _buildWishlistGrid(controller);
      }),
    );
  }

  /// Build the app bar with wishlist count
  PreferredSizeWidget _buildAppBar(WishlistController controller) {
    return AppBar(
      title: Obx(() => Text('Wish list (${controller.wishlistCount})')),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Get.back(),
      ),
      elevation: 4,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      iconTheme: const IconThemeData(color: Colors.black),
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
      ),
      toolbarTextStyle: const TextStyle(
        color: Colors.black,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
      ),
      actions: [
        Obx(() {
          if (controller.wishlistItems.isNotEmpty) {
            return PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'clear') {
                  _showClearConfirmationDialog(controller);
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'clear',
                  child: Row(
                    children: [
                      Icon(Icons.clear_all),
                      SizedBox(width: 8),
                      Text('Clear All'),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  /// Build the main wishlist grid
  Widget _buildWishlistGrid(WishlistController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: controller.wishlistItems.length,
        itemBuilder: (context, index) {
          final item = controller.wishlistItems[index];
          return ProductCard(
            productId: item.productId,
            name: item.name,
            brand: item.brand,
            price: item.price,
            imageUrl: item.imageUrl,
            discount: item.discount,
            rating: item.rating,
            reviewCount: item.reviewCount,
            showRating: true,
            showDiscountBadge: item.discount != null,
            isFavorite: true, // Always true since this is wishlist
            showAddToCart: true,
            onFavoriteTap: () {
              _showRemoveConfirmationDialog(controller, item);
            },
            onAddToCart: () {
              controller.addToCart(item);
            },
          );
        },
      ),
    );
  }

  /// Build empty wishlist state
  Widget _buildEmptyWishlist(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 24),
            Text(
              'Your wishlist is empty',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Save items you like to your wishlist.\nReview them anytime and easily move them to your bag.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {
                // Navigate to home or products page
                Get.back(); // Or navigate to your home page
              },
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text('Continue Shopping'),
            ),
          ],
        ),
      ),
    );
  }

  /// Show confirmation dialog before removing item from wishlist
  void _showRemoveConfirmationDialog(WishlistController controller, WishlistItem item) {
    Get.dialog(
      AlertDialog(
        title: const Text('Remove from Wishlist'),
        content: Text('Are you sure you want to remove "${item.name}" from your wishlist?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Get.back();
              controller.removeFavorite(item.productId);
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  /// Show confirmation dialog before clearing all wishlist items
  void _showClearConfirmationDialog(WishlistController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear Wishlist'),
        content: const Text('Are you sure you want to remove all items from your wishlist? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Get.back();
              controller.clearWishlist();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Get.theme.colorScheme.error,
              foregroundColor: Get.theme.colorScheme.onError,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}