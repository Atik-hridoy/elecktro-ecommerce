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

  final List<String> sizes = ['S', 'M', 'L', 'XL'];
  final List<Color> colors = [const Color(0xFF4CAF50), const Color(0xFF9E9E9E)];

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
                  controller.name.value, 
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 4),
                
                Text(
                  controller.brand.value, 
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
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
                        const Text(
                          'Protect the AirTag that\'s keeping track of all your important things. The Otterbox Rugged Case for AirTag provides durable protection from drops and dings. The AirTag that\'s attached to your keys and your pack is buffered from all that bouncing and banging around as you go about your day simply best on the move and AirTag from all that bouncing and banging around.',
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
                        _buildHighlightItem('Drop tested: 10ft (3m)'),
                        _buildHighlightItem('Dust-resistant rugged protection'),
                        _buildHighlightItem('Includes two carabiners'),
                        _buildHighlightItem('Includes lanyard for hands-free carrying'),
                        _buildHighlightItem('Hassle-free customer service'),
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
                _buildReviewItem('Hadi H', 'Just the thing', 'I loved this dress so much as soon I got it I knew I had to buy it in another color. I am 5\'3 about 155lbs and I carry all my weight to my upper body. When I put it on I felt like it slimmed me put and I got so many compliments.', 4.9, 'Aug 14, 2021'),
                const SizedBox(height: 16),
                _buildReviewItem('Kim Shine', '', 'I loved this dress so much as soon I got it I knew I had to buy it in another color. I am 5\'3 about 155lbs and I carry all my weight to my upper body. When I put it on I felt like it slimmed me put and I got so many compliments.', 4.9, ''),
                const SizedBox(height: 16),
                _buildReviewItem('Matilda Brown', 'Just the thing', 'I loved this dress so much as soon I got it I knew I had to buy it in another color. I am 5\'3 about 155lbs and I carry all my weight to my upper body. When I put it on I felt like it slimmed me put and I got so many compliments.', 4.9, 'Aug 14, 2021'),
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
      child: imageUrl.isEmpty
          ? const Icon(Icons.image_not_supported_outlined, size: 64, color: Colors.white)
          : isNetwork
              ? Image.network(imageUrl, fit: BoxFit.contain)
              : Image.asset(imageUrl, fit: BoxFit.contain),
    );
  }

  Widget _buildImageThumbnails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) {
        return GestureDetector(
          onTap: () => setState(() => selectedImageIndex = index),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF3C3C41),
              borderRadius: BorderRadius.circular(12),
              border: selectedImageIndex == index ? Border.all(color: Colors.blue, width: 2) : null,
            ),
          ),
        );
      }),
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
        ...List.generate(colors.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => selectedColorIndex = index),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colors[index],
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                child: Text(name.split(' ').map((e) => e[0]).join(''), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    if (title.isNotEmpty)
                      Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(rating.toString(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(review, style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.4)),
          const SizedBox(height: 12),
          Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            shadowColor: Colors.black.withValues(alpha: 0.2),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[100]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.photo_camera, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Text('Photos from review', style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                                image: const DecorationImage(
                                  image: NetworkImage('https://via.placeholder.com/80x80'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.1)],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (date.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(date, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          ],
        ],
      ),
    );
  }
}
