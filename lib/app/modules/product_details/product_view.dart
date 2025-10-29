import 'package:elecktro_ecommerce/app/modules/product_details/custom%20widget/sellercard.dart';
import 'package:elecktro_ecommerce/app/modules/product_details/widgets/product_build_row_review_item.dart';
import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/core/network/app_urls.dart';
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

  final List<String> sizes = ['S', 'M', 'L', 'XL'];
  // Default colors to use if we run out of predefined colors
  final List<Color> defaultColors = [
    const Color(0xFF4CAF50), // Green
    const Color(0xFF9E9E9E), // Gray
    Colors.blue,
    Colors.red,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.teal,
    Colors.cyan,
  ];
  
  // Function to get a color by index, cycling through the default colors if needed
  Color _getColorByIndex(int index) {
    return defaultColors[index % defaultColors.length];
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMainProductImage(),
                const SizedBox(height: 16),
                _buildImageThumbnails(),
                const SizedBox(height: 24),
                Text(
                  controller.product.value?.name ?? '', 
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 4),
                
                Text(
                  controller.product.value?.brand ?? '', 
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                
                // --- Seller Information Card ---
                Obx(() => SellerCard(
                  seller: controller.seller.value,
                  rating: controller.rating.value,
                  reviewCount: controller.reviewCount.value,
                  onTap: () {
                    // Handle seller card tap
                    // You can navigate to seller profile page here
                    // Get.toNamed(Routes.sellerProfile, arguments: controller.seller.value.id);
                  },
                )),
                const SizedBox(height: 16),
                
                // --- Grouped into a Card ---
                Card(
                  elevation: 0,
                  color: Colors.grey[50],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildPriceAndQuantity(),
                        const SizedBox(height: 24),
                        _buildSizeSelector(),
                        const SizedBox(height: 16),
                        _buildColorSelector(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // --- Overview Card ---
                Card(
                  elevation: 0,
                  color: Colors.grey[50],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Overview:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        Text(
                          controller.product.value?.overview ?? '',
                          style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // --- Highlights & Specs Card ---
                Card(
                  elevation: 0,
                  color: Colors.grey[50],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Highlights:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 12),
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
                        const Text('Tech Specs:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 12),
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
                const SizedBox(height: 24),
                // --- Feedback Section (No Card, as reviews are already in cards) ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Feedback', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        const Text('4.9/5', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ProductBuildRowReviewItem(name: 'Hadi H', title: 'Just the thing', review: 'I loved this dress so much as soon I got it I knew I had to buy it in another color. I am 5\'3 about 155lbs and I carry all my weight to my upper body. When I put it on I felt like it slimmed me put and I got so many compliments.', rating: 4.9, date: 'Aug 14, 2021'),
                const SizedBox(height: 16),
                ProductBuildRowReviewItem(name: 'Kim Shine', title: '', review: 'I loved this dress so much as soon I got it I knew I had to buy it in another color. I am 5\'3 about 155lbs and I carry all my weight to my upper body. When I put it on I felt like it slimmed me put and I got so many compliments.', rating: 4.9, date: ''),
                const SizedBox(height: 16),
                ProductBuildRowReviewItem(name: 'Matilda Brown', title: 'Just the thing', review: 'I loved this dress so much as soon I got it I knew I had to buy it in another color. I am 5\'3 about 155lbs and I carry all my weight to my upper body. When I put it on I felt like it slimmed me put and I got so many compliments.', rating: 4.9, date: 'Aug 14, 2021'),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainProductImage() {
    final imageUrl = controller.imageUrl.value;
    final isNetwork = imageUrl.startsWith('http');
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(color: const Color(0xFF3C3C41), borderRadius: BorderRadius.circular(20)),
      child: imageUrl.isEmpty || imageUrl.contains('placeholder.com')
          ? const Icon(Icons.image_not_supported_outlined, size: 64, color: Colors.grey)
          : isNetwork
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    size: 64,
                    color: Colors.grey,
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                )
              : Image.asset(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    size: 64,
                    color: Colors.grey,
                  ),
                ),
    );
  }

  Widget _buildImageThumbnails() {
    final images = controller.product.value?.images ?? [];
    
    if (images.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(images.length, (index) {
          final imagePath = images[index];
          final imageUrl = imagePath.startsWith('http') 
              ? imagePath 
              : '${AppUrls.baseImageUrl}${imagePath.startsWith('/') ? imagePath.substring(1) : imagePath}';
              
          return GestureDetector(
            onTap: () => setState(() {
              selectedImageIndex = index;
              controller.imageUrl.value = imageUrl;
            }),
            child: Container(
              width: 60,
              height: 60,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selectedImageIndex == index
                      ? const Color(0xFFFFC107)
                      : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    color: Colors.grey,
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPriceAndQuantity() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              controller.price.value, // DYNAMIC DATA
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(width: 8),
            if (controller.discount.value.isNotEmpty)
              Text(
                '\$20.30', // Placeholder original price
                style: TextStyle(fontSize: 16, color: Colors.grey[400], decoration: TextDecoration.lineThrough),
              ),
          ],
        ),
        Row(
          children: [
            IconButton(onPressed: quantity > 1 ? () => setState(() => quantity--) : null, icon: const Icon(Icons.remove)),
            Text(quantity.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(onPressed: () => setState(() => quantity++), icon: const Icon(Icons.add)),
          ],
        ),
      ],
    );
  }

  Widget _buildSizeSelector() {
    return Row(
      children: [
        const Text('Size/Type:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(width: 16),
        ...List.generate(sizes.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => selectedSizeIndex = index),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: selectedSizeIndex == index ? Colors.blue : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    sizes[index],
                    style: TextStyle(color: selectedSizeIndex == index ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildColorSelector() {
    return Row(
      children: [
        const Text('Color:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(width: 16),
        ...List.generate(controller.product.value?.color?.length ?? 0, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => selectedColorIndex = index),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getColorByIndex(index),
                  shape: BoxShape.circle,
                  border: selectedColorIndex == index ? Border.all(color: Colors.black, width: 3) : Border.all(color: Colors.grey[300]!, width: 1),
                ),
              ),
            ),
          );
        }),
        const SizedBox(width: 8),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
          child: const Icon(Icons.add, color: Colors.blue),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Material(
      elevation: 10,
      color: Colors.grey[100],
      shadowColor: Colors.black.withValues(alpha: 0.8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => controller.onBuyNow(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF3D00),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Buy Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  controller.onAddToCart();
                  Get.toNamed(Routes.cart);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC107),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined),
                    SizedBox(width: 8),
                    Text('Add to Cart', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
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