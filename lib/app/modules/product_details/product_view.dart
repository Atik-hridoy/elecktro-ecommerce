import 'package:elecktro_ecommerce/app/modules/product_details/custom%20widget/sellercard.dart';
import 'package:elecktro_ecommerce/app/modules/product_details/widgets/product_build_row_review_item.dart';
import 'package:elecktro_ecommerce/app/modules/product_details/widgets/add_review_dialog.dart';
import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/modules/product_details/controllers/product_controller.dart';

// This view is restored to the original user-provided style, with dynamic data connected.
class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  late final ProductDetailsController controller;

  // Local UI state from the original design
  int selectedSizeIndex = 3;
  int selectedColorIndex = 0;
  int quantity = 1;
  int selectedImageIndex = 0;

  // Get available sizes from the product
  List<String>? get _availableSizes {
    if (controller.product.value?.sizeType == null || controller.product.value!.sizeType.isEmpty) return null;
    return controller.product.value!.sizeType
        .map((sizeType) => sizeType.size ?? 'One Size')
        .where((size) => size.isNotEmpty)
        .toList();
  }
  
  // Get available colors from the product
  List<Color> get _availableColors {
    final colors = controller.product.value?.color;
    if (colors == null || colors.isEmpty) {
      debugPrint('No colors available, using default grey');
      return [Colors.grey];
    }
    
    debugPrint('Raw color strings: $colors');
    
    // Convert color strings to Color objects
    return colors.map((colorString) {
      try {
        // Handle null or empty string
        if (colorString.isEmpty) return Colors.grey;
        
        String hexColor = colorString.trim().toUpperCase();
        
        // Remove '#' if present
        if (hexColor.startsWith('#')) {
          hexColor = hexColor.substring(1);
        }
        
        // Try to match common color names
        final colorMap = <String, Color>{
          'RED': Colors.red,
          'GREEN': Colors.green,
          'BLUE': Colors.blue,
          'YELLOW': Colors.yellow,
          'BLACK': Colors.black,
          'WHITE': Colors.white,
          'GRAY': Colors.grey,
          'GREY': Colors.grey,
          'ORANGE': Colors.orange,
          'PURPLE': Colors.purple,
          'PINK': Colors.pink,
          'BROWN': Colors.brown,
          'CYAN': Colors.cyan,
          'TEAL': Colors.teal,
          'AMBER': Colors.amber,
        };
        
        // Check if it's a named color
        if (colorMap.containsKey(hexColor)) {
          return colorMap[hexColor]!;
        }
        
        // Handle 3-digit hex (e.g., 'F00' for red)
        if (hexColor.length == 3) {
          hexColor = 'FF' + hexColor.split('').map((c) => c * 2).join();
        }
        // Handle 6-digit hex (add FF for full opacity)
        else if (hexColor.length == 6) {
          hexColor = 'FF$hexColor';
        }
        // Handle 8-digit hex (already has alpha)
        else if (hexColor.length != 8) {
          debugPrint('Invalid hex color length: $hexColor');
          return Colors.grey;
        }
        
        // Parse the hex color
        final colorInt = int.tryParse(hexColor, radix: 16);
        if (colorInt == null) {
          debugPrint('Failed to parse hex color: $hexColor');
          return Colors.grey;
        }
        
        final color = Color(colorInt);
        debugPrint('Converted $colorString to $color');
        return color;
      } catch (e) {
        debugPrint('Error parsing color "$colorString": $e');
        return Colors.grey;
      }
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    controller = Get.find<ProductDetailsController>();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      if (controller.name.value.contains('Not Found')) {
        return Scaffold(body: Center(child: Text(controller.name.value)));
      }

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: _buildBody(),
        bottomNavigationBar: _buildBottomBar(),
      );
    });
  }

  AppBar _buildAppBar() {
    return AppBar(
        backgroundColor: Colors.white,
        elevation: 10,
        shadowColor: Colors.black.withValues(alpha: 0.8),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Product Details',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true);
  }

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMainProductImage(),
                const SizedBox(height: 16),
                _buildImageThumbnails(),
                
                // Product Info Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        controller.product.value?.name ?? '', 
                        style: const TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.black,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      
                      // Brand with icon
                      Row(
                        children: [
                          Icon(Icons.verified, size: 14, color: Colors.blue[700]),
                          const SizedBox(width: 4),
                          Text(
                            controller.product.value?.brand ?? '', 
                            style: TextStyle(
                              fontSize: 13, 
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // --- Seller Information Card ---
                      Obx(() => SellerCard(
                        seller: controller.seller.value,
                        rating: controller.rating.value,
                        reviewCount: controller.reviewCount.value,
                        onTap: () {
                          // Navigate to seller profile page
                          Get.toNamed(
                            Routes.sellerProfile,
                            arguments: {
                              'seller': controller.seller.value,
                              'rating': controller.rating.value,
                              'reviewCount': controller.reviewCount.value,
                            },
                          );
                        },
                      )),
                      const SizedBox(height: 20),
                      
                      // --- Price, Size & Color Card ---
                      Card(
                        elevation: 2,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              _buildPriceAndQuantity(),
                              const Divider(height: 32),
                              _buildSizeSelector(),
                              const SizedBox(height: 20),
                              _buildColorSelector(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // --- Overview Card ---
                      Card(
                        elevation: 2,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.description_outlined, size: 20, color: Colors.grey[700]),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Overview', 
                                    style: TextStyle(
                                      fontSize: 16, 
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    )
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                controller.product.value?.overview ?? '',
                                style: TextStyle(
                                  fontSize: 14, 
                                  color: Colors.grey[700], 
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // --- Highlights & Specs Card ---
                      Card(
                        elevation: 2,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.star_outline, size: 20, color: Colors.grey[700]),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Highlights', 
                                    style: TextStyle(
                                      fontSize: 16, 
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    )
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              if (controller.product.value?.highlights != null)
                                if (controller.product.value!.highlights is Map)
                                  ...(controller.product.value!.highlights as Map<String, dynamic>).entries
                                      .map((entry) => _buildHighlightItem('${entry.key}: ${entry.value}'))
                                      .toList()
                                else if (controller.product.value!.highlights is String)
                                  _buildHighlightItem(controller.product.value!.highlights.toString())
                              else
                                _buildHighlightItem('No highlights available'),
                              const Divider(height: 32),
                              Row(
                                children: [
                                  Icon(Icons.settings_outlined, size: 20, color: Colors.grey[700]),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Tech Specs', 
                                    style: TextStyle(
                                      fontSize: 16, 
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    )
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildSpecRow('Form Factor', 'Hard Case'),
                              _buildSpecRow('Supported Devices', 'AirTag'),
                              _buildSpecRow('Material', 'Silicone'),
                              _buildSpecRow('Length', '1.6 in | 41 cm'),
                              _buildSpecRow('Width', '1.6 in | 41 cm'),
                              _buildSpecRow('Height', '0.4 in | 10 cm'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // --- Feedback Section ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Feedback', 
                            style: TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            )
                          ),
                          Row(
                            children: [
                              Obx(() => IconButton(
                                icon: controller.isLoadingReviews.value
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.refresh, size: 20),
                          onPressed: controller.isLoadingReviews.value
                              ? null
                              : () => controller.fetchReviewFeedback(),
                          tooltip: 'Refresh reviews',
                        )),
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              const Text('4.9/5', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Write Review Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AddReviewDialog(
                                onSubmit: (review, rating, images) async {
                                  // Submit review to backend
                                  final success = await controller.submitReview(
                                    reviewText: review,
                                    rating: rating,
                                    images: images,
                                  );
                                  
                                  if (success) {
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            );
                          },
                          icon: const Icon(Icons.rate_review),
                          label: const Text('Write a Review'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: Color(0xFF00BFA5)),
                            foregroundColor: const Color(0xFF00BFA5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Dynamic Reviews from Controller
                      Obx(() {
                        // Show loading indicator while fetching reviews
                        if (controller.isLoadingReviews.value) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        
                        if (controller.reviews.isEmpty) {
                          // Show message if no reviews
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                children: [
                                  Icon(Icons.rate_review_outlined, size: 48, color: Colors.grey[400]),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No reviews yet',
                                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Be the first to review this product!',
                                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        
                        // Show user reviews
                        return Column(
                          children: controller.reviews.map((review) {
                            return Column(
                              children: [
                                ProductBuildRowReviewItem(
                                  name: review['name'] ?? 'Anonymous',
                                  title: review['title'] ?? '',
                                  review: review['review'] ?? '',
                                  rating: (review['rating'] ?? 5.0).toDouble(),
                                  date: review['date'] ?? '',
                                  images: List<String>.from(review['images'] ?? []),
                                  userImage: review['userImage'],
                                ),
                                const SizedBox(height: 16),
                              ],
                            );
                          }).toList(),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool _isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    if (url.contains('placeholder.com') || url.contains('via.placeholder.com')) return false;
    return true;
  }

  Widget _buildMainProductImage() {
    final product = controller.product.value;
    final images = product?.images ?? [];
    
    if (images.isEmpty) {
      return Container(
        width: double.infinity,
        height: 300,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Icon(Icons.image_not_supported_outlined, size: 64, color: Colors.grey),
        ),
      );
    }
    
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: images.length,
              controller: PageController(viewportFraction: 0.9),
              onPageChanged: (index) {
                setState(() {
                  selectedImageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final imageUrl = images[index];
                final isNetwork = imageUrl.startsWith('http');
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _isValidImageUrl(imageUrl)
                        ? isNetwork
                            ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) => _buildImageError(),
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded / 
                                            loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                              )
                            : Image.asset(
                                imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) => _buildImageError(),
                              )
                        : _buildImageError(),
                  ),
                );
              },
            ),
          ),
          if (images.length > 1) _buildPageIndicator(images.length),
        ],
      ),
    );
  }
  
  Widget _buildPageIndicator(int length) {
    return SizedBox(
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(length, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: index == selectedImageIndex ? 20.0 : 8.0,
            height: 8.0,
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              color: index == selectedImageIndex 
                  ? const Color(0xFFFFC107) 
                  : Colors.grey[300],
            ),
          );
        }),
      ),
    );
  }
  
  Widget _buildImageError() {
    return Container(
      color: Colors.grey[100],
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.broken_image, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text('Could not load image', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnailError() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.broken_image, color: Colors.grey, size: 24),
      ),
    );
  }

  Widget _buildImageThumbnails() {
    final images = controller.product.value?.images ?? [];
    if (images.isEmpty) return const SizedBox.shrink();

    return Center(
      child: SizedBox(
        height: 70,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: images.length,
          itemBuilder: (context, index) {
            final imageUrl = images[index];
            final isNetwork = imageUrl.startsWith('http');
            final isSelected = selectedImageIndex == index;
            
            return GestureDetector(
              onTap: () => setState(() => selectedImageIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 60,
                height: 60,
                margin: EdgeInsets.only(
                  right: index < images.length - 1 ? 8 : 0,
                  left: index == 0 ? 8 : 0,
                  top: isSelected ? 0 : 5,
                ),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? const Color(0xFFFFC107) : Colors.grey[300]!,
                  width: isSelected ? 2.5 : 2,
                ),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: _isValidImageUrl(imageUrl)
                    ? isNetwork
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => _buildThumbnailError(),
                          )
                        : Image.asset(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => _buildThumbnailError(),
                          )
                    : _buildThumbnailError(),
              ),
            ),
          );
        },
      ),
    ),
    );
  }

  Widget _buildPriceAndQuantity() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() => Row(
          children: [
            Text(
              '\$${controller.currentDiscountedPrice.toStringAsFixed(2)}', // ✅ Dynamic discounted price
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(width: 8),
            if (controller.discount.value.isNotEmpty && controller.discount.value != '0')
              Text(
                '\$${controller.currentOriginalPrice.toStringAsFixed(2)}', // ✅ Dynamic original price
                style: TextStyle(fontSize: 16, color: Colors.grey[400], decoration: TextDecoration.lineThrough),
              ),
          ],
        )),
        Row(
          children: [
            IconButton(
              onPressed: controller.quantity > 1 
                  ? () => controller.updateQuantity(controller.quantity.value - 1)
                  : null, 
              icon: const Icon(Icons.remove)
            ),
            Obx(() => Text(
              '${controller.quantity.value}', 
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            )),
            IconButton(
              onPressed: () => controller.updateQuantity(controller.quantity.value + 1),
              icon: const Icon(Icons.add)
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSizeSelector() {
    final sizes = _availableSizes ?? ['S', 'M', 'L', 'XL'];
    
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select Size', 
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              )
            ),
            Text(
              controller.currentSize,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF00BFA5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(sizes.length, (index) {
            final isSelected = controller.selectedSizeIndex.value == index;
            return GestureDetector(
              onTap: () => controller.selectSize(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF00BFA5) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF00BFA5) : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: const Color(0xFF00BFA5).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ] : [],
                ),
                child: Text(
                  sizes[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    ));
  }

  Widget _buildColorSelector() {
    final colors = _availableColors;
    
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select Color', 
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              )
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${colors.length} ${colors.length > 1 ? 'Colors' : 'Color'}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(colors.length, (index) {
            final isSelected = controller.selectedColorIndex.value == index;
            return GestureDetector(
              onTap: () => controller.selectColor(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: colors[index],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey[300]!,
                    width: isSelected ? 3 : 2,
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: colors[index].withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ] : [],
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 24,
                      )
                    : null,
              ),
            );
          }),
        ),
      ],
    ));
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Buy Now Button
            Expanded(
              child: ElevatedButton(
                onPressed: () => controller.onBuyNow(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF3D00),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag_outlined, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Buy Now', 
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      )
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Add to Cart Button
            Expanded(
              child: Obx(() => ElevatedButton(
                onPressed: controller.isAddingToCart.value
                    ? null
                    : () async {
                        await controller.onAddToCart();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC107),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: controller.isAddingToCart.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 2,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_shopping_cart_outlined, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Add to Cart', 
                            style: TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            )
                          ),
                        ],
                      ),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String name, String title, String review, double rating, String date) {
    return ProductBuildRowReviewItem(name: name, title: title, review: review, rating: rating, date: date);
  }
}