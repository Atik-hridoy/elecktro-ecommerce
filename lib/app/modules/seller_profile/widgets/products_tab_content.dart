import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/widget/product_card.dart';
import '../../../core/network/app_urls.dart';
import '../controllers/seller_profile_controller.dart';

class ProductsTabContent extends StatelessWidget {
  final SellerProfileController? controller;
  
  const ProductsTabContent({Key? key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = controller ?? Get.find<SellerProfileController>();
    
    return Obx(() {
      if (ctrl.isLoadingProducts.value) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading products...'),
            ],
          ),
        );
      }
      
      if (ctrl.productsErrorMessage.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                ctrl.productsErrorMessage.value,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (ctrl.seller.value?.id != null) {
                    ctrl.fetchSellerProducts(ctrl.seller.value!.id);
                  }
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }
      
      if (ctrl.sellerProducts.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No products available',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        );
      }
      
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Categories Section
            if (ctrl.sellerCategories.isNotEmpty) ...[
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              _buildCategoryChipsFromAPI(ctrl),
              const SizedBox(height: 20),
            ],
            
            // Products Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Products (${ctrl.sellerProducts.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Products Grid
            _buildProductsGrid(ctrl.sellerProducts),
          ],
        ),
      );
    });
  }
  
  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search in Cartup',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey[600], size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.tune, color: Colors.grey[700], size: 20),
        ),
      ],
    );
  }
  
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 90,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCategoryChip('Computers', Icons.computer),
          _buildCategoryChip('Phone', Icons.phone_android),
          _buildCategoryChip('Server Tool', Icons.dns),
          _buildCategoryChip('Accessories', Icons.headphones),
          _buildCategoryChip('Camera', Icons.camera_alt),
        ],
      ),
    );
  }
  
  Widget _buildCategoryChipsFromAPI(SellerProfileController ctrl) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ctrl.sellerCategories.length,
        itemBuilder: (context, index) {
          final category = ctrl.sellerCategories[index];
          final isSelected = ctrl.selectedCategoryId.value == category.id;
          
          return GestureDetector(
            onTap: () => ctrl.selectCategory(
              isSelected ? null : category.id
            ),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF00BFA5) : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: const Color(0xFF00BFA5), width: 2)
                          : null,
                    ),
                    child: category.thumbnail != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              category.thumbnail!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.category, 
                                       size: 28, 
                                       color: isSelected ? Colors.white : Colors.black87),
                            ),
                          )
                        : Icon(Icons.category, 
                               size: 28, 
                               color: isSelected ? Colors.white : Colors.black87),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 70,
                    child: Text(
                      category.name,
                      style: TextStyle(
                        fontSize: 11,
                        color: isSelected ? const Color(0xFF00BFA5) : Colors.black87,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildCategoryChip(String label, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProductsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Best Products',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Text(
                'Select Category',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey[700]),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildProductsGrid(List products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product);
      },
    );
  }
  
  Widget _buildProductCard(dynamic product) {
    // Format image URL
    String? imageUrl;
    if (product.images != null && product.images.isNotEmpty) {
      final imagePath = product.images.first;
      imageUrl = imagePath.startsWith('http') 
          ? imagePath 
          : '${AppUrls.baseImageUrl}${imagePath.startsWith('/') ? imagePath.substring(1) : imagePath}';
    }
    
    // Get price from first size variant
    String price = '\$0.00';
    if (product.sizeType != null && product.sizeType.isNotEmpty) {
      final firstVariant = product.sizeType.first;
      price = '\$${firstVariant.price ?? 0}';
    }
    
    return ProductCard(
      product: product,
      name: product.name ?? 'Unknown Product',
      brand: product.brand ?? '',
      price: price,
      imageUrl: imageUrl,
      rating: product.rating?.toDouble() ?? 0.0,
      reviewCount: product.reviewCount ?? 0,
      productId: product.id ?? '',
      showAddToCart: true,
    );
  }
}
