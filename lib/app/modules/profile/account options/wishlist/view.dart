import 'package:elecktro_ecommerce/app/modules/home/controllers/bookmark_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/core/network/app_urls.dart';
import 'package:elecktro_ecommerce/app/core/widgets/error_screens/empty_state_screen.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the BookmarkController
    final BookmarkController controller = Get.find<BookmarkController>();

    return Scaffold(
      appBar: _buildAppBar(controller),
      body: Obx(() {
        if (controller.bookmarks.isEmpty) {
          return _buildEmptyWishlist(context);
        }

        return _buildWishlistGrid(controller);
      }),
    );
  }

  /// Build the app bar with wishlist count
  PreferredSizeWidget _buildAppBar(BookmarkController controller) {
    return AppBar(
      title: Obx(() => Text('Wishlist (${controller.bookmarkedIds.length})')),
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
          if (controller.bookmarkedIds.isNotEmpty) {
            return IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => controller.getBookmarks(),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  /// Build the main wishlist grid
  // ... (keep the imports and class definition the same)

Widget _buildWishlistGrid(BookmarkController controller) {
  return Obx(() => Padding(
    padding: const EdgeInsets.all(16.0),
    child: controller.isBookmarksLoading
        ? const Center(child: CircularProgressIndicator())
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: controller.bookmarks.length,
            itemBuilder: (context, index) {
              final item = controller.bookmarks[index];
              final product = item['referenceId'] as Map<String, dynamic>? ?? {};
              final productId = product['_id']?.toString() ?? '';
              final productName = product['name']?.toString() ?? 'Product';
              final brand = product['brand']?.toString() ?? 'Brand';
              final images = (product['images'] as List<dynamic>?)?.cast<String>() ?? [];
              final sizes = (product['sizeType'] as List<dynamic>?) ?? [];
              final price = sizes.isNotEmpty ? (sizes[0]['price'] ?? 0).toString() : '0';
              final discount = sizes.isNotEmpty ? (sizes[0]['discount'] ?? 0).toString() : '0';

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Product image
                        Container(
                          height: constraints.maxWidth * 0.8,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            image: images.isNotEmpty 
                              ? DecorationImage(
                                  image: NetworkImage(
                                    '${AppUrls.baseImageUrl}${images[0].startsWith('/') ? images[0].substring(1) : images[0]}',
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          ),
                          child: images.isEmpty 
                            ? const Center(
                                child: Icon(Icons.image, size: 50, color: Colors.grey),
                              )
                            : null,
                        ),
                        // Product details
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      productName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      brand,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '\$$price',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      icon: const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 24,
                                      ),
                                      onPressed: () => _showRemoveConfirmationDialog(
                                          controller, item),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
  ));
}

  /// Build empty wishlist state
  Widget _buildEmptyWishlist(BuildContext context) {
    return EmptyStateScreen(
      title: 'wishlist_empty'.tr,
      message: 'save_items_wishlist'.tr,
      icon: Icons.favorite_border,
      onAction: () => Get.back(),
      actionButtonText: 'continue_shopping'.tr,
    );
  }

  /// Show confirmation dialog before removing item from wishlist
  void _showRemoveConfirmationDialog(BookmarkController controller, Map<String, dynamic> item) {
    // Debug: Print the entire item structure
    print('📋 Bookmark item structure: $item');
    
    final bookmarkId = item['_id']?.toString() ?? '';
    final productId = item['productId']?.toString() ?? '';
    final productName = item['name']?.toString() ?? 'this item';
    
    print('🔍 Extracted - Bookmark ID: $bookmarkId, Product ID: $productId');
    
    // Validate IDs before showing dialog
    if (bookmarkId.isEmpty) {
      print('❌ Warning: Bookmark ID is empty!');
      Get.snackbar(
        'Error',
        'Cannot remove bookmark: Invalid bookmark data',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return;
    }
    
    Get.dialog(
      AlertDialog(
        title: const Text('Remove from Wishlist'),
        content: Text('Are you sure you want to remove "$productName" from your wishlist?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Get.back();
              // Use deleteBookmark method to remove from list
              await controller.deleteBookmark(bookmarkId, productId);
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}