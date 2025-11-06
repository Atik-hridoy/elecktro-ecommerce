import 'package:elecktro_ecommerce/app/modules/home/controllers/bookmark_controller.dart';
import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import 'package:elecktro_ecommerce/app/modules/category/models/get_product_details_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class ProductCard extends StatelessWidget {
  final ProductDetailModel? product;
  final String name;
  final String brand;
  final String price;
  final String? imageUrl;
  final String? discount;
  final double rating;
  final int reviewCount;
  final bool showRating;
  final bool showDiscountBadge;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onAddToCart;
  final bool isFavorite;
  final bool showAddToCart;
  final String productId;
  final String? sellerName;
  final String? sellerAvatarUrl;

  const ProductCard({
    super.key,
    this.product,
    required this.name,
    required this.brand,
    required this.price,
    this.imageUrl,
    this.discount,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.showRating = true,
    this.showDiscountBadge = false,
    this.onFavoriteTap,
    this.onAddToCart,
    this.isFavorite = false,
    this.showAddToCart = true,
    required this.productId,
    this.sellerName,
    this.sellerAvatarUrl,
  });


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bookmarkController = Get.put<BookmarkController>(BookmarkController());
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Scale factor based on screen width (375 is base design width)
    var scale = screenWidth / 375;
    
    // For very small screens, reduce scale even more
    if (screenHeight < 700) {
      scale = scale * 0.85; // 15% smaller on small screens
    }
    
    // Responsive card width based on screen ratio
    final cardWidth = 180.0 * scale;

    void navigateToProductDetails() {
      if (product != null) {
        // If we have the full product model, pass it directly
        Get.toNamed(
          Routes.productDetails,
          arguments: product,
        );
      } else {
        // Fallback to individual properties
        final productData = {
          'id': productId,
          'name': name,
          'brand': brand,
          'price': price,
          'imageUrl': [imageUrl],
          'discount': discount,
          'rating': rating,
          'reviewCount': reviewCount,
          'sellerName': sellerName,
          'sellerAvatarUrl': sellerAvatarUrl,
        };
        
        Get.toNamed(
          Routes.productDetails,
          arguments: productData,
        );
      }
    }

    return SizedBox(
      width: cardWidth,
      child: Card(
      elevation: 1, // Use a non-zero elevation for a shadow effect
      color: colorScheme.surface, // Elevated cards use the surface color
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: navigateToProductDetails,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Use minimum space
          children: [
            // --- IMAGE SECTION ---
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.2, // More compact ratio for small screens
                  child: Container(
                    padding: EdgeInsets.zero,
                    color: colorScheme.surface,
                    child: _buildProductImage(),
                  ),
                ),
                // --- FAVORITE BUTTON ---
                Positioned(
  top: 4,
  right: 4,
  child: GetBuilder<BookmarkController>(
    builder: (controller) {
      final isBookmarked = controller.isBookmarked(productId);
      final isLoading = controller.isLoading(productId);
      
      return IconButton(
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                isBookmarked ? Icons.favorite : Icons.favorite_border,
                color: isBookmarked ? Colors.red : colorScheme.onSurfaceVariant,
              ),
        onPressed: () => controller.toggleBookmark(productId),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        iconSize: 24,
      );
    },
  ),
),
                // --- DISCOUNT BADGE ---
                if (showDiscountBadge && discount != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Badge(
                      backgroundColor: colorScheme.errorContainer,
                      textColor: colorScheme.onErrorContainer,
                      label: Text('$discount% OFF'),
                      largeSize: 20,
                    ),
                  ),
              ],
            ),
            // --- DETAILS SECTION ---
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 6.0 * scale,
                  vertical: 4.0 * scale,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top section with name and brand
                    Flexible(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              name,
                              style: textTheme.titleSmall?.copyWith(fontSize: 13 * scale),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: 1 * scale),
                          Text(
                            brand,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 12 * scale,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    
                    // Middle section with rating only
                    if (showRating)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2 * scale),
                        child: _buildRating(context, rating, reviewCount, scale),
                      ),
                    
                    // Bottom section with price and cart button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            price,
                            style: textTheme.labelLarge?.copyWith(
                              color: colorScheme.primary,
                              fontSize: 14 * scale,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (showAddToCart && onAddToCart != null)
                          IconButton.filledTonal(
                            onPressed: onAddToCart,
                            icon: const Icon(Icons.add_shopping_cart),
                            iconSize: 16 * scale,
                            padding: EdgeInsets.all(6 * scale),
                            constraints: BoxConstraints(
                              minWidth: 32 * scale,
                              minHeight: 32 * scale,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
        ),
      ),
    );
  }

  /// Builds the product image, handling network, asset, and placeholder cases.
  Widget _buildProductImage() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return const Center(child: Icon(Icons.image_not_supported_outlined, size: 32));
    }

    final isNetworkImage = imageUrl!.startsWith('http');

    if (isNetworkImage) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Center(child: Icon(Icons.broken_image_outlined, size: 32)),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    } else {
      return Image.asset(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Center(child: Icon(Icons.broken_image_outlined, size: 32)),
      );
    }
  }

  /// Builds the rating display row.
  Widget _buildRating(BuildContext context, double rating, int reviewCount, double scale) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(Icons.star, color: Colors.amber, size: 16 * scale),
        SizedBox(width: 4 * scale),
        Text(
          rating.toStringAsFixed(1),
          style: textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 12 * scale,
          ),
        ),
        SizedBox(width: 4 * scale),
        Text(
          '($reviewCount)',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontSize: 11 * scale,
          ),
        ),
      ],
    );
  }
}