import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'controller.dart';
import '../home/widget/category_list.dart';
import '../home/widget/product_card.dart';
import '../home/widget/navbar.dart';

class CategoryView extends GetView<CategoryController> {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200), // Increased height to accommodate both search and categories
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              // Search Box
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search categories...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.filter_list, color: Colors.grey, size: 20),
                          SizedBox(width: 5),
                          Text('Filters', style: TextStyle(color: Color(0xFF044D37))),
                        ],
                      ),
                    ),
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 32,
                    ),
                  ),
                  onChanged: (value) {
                    controller.searchCategories(value);
                  },
                ),
              ),
              
              // Category List
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  
                  
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Obx(
                  () => CategoryList(
                    categories: controller.filteredCategories.toList(),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 85), // Space for bottom navigation bar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Products Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'All Products',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        color: Color(0xFF044D37),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Products Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
              ),
              itemCount: 10, // Number of product cards
              itemBuilder: (context, index) {
                return ProductCard(
                  name: 'Product ${index + 1}',
                  brand: 'Brand ${index + 1}',
                  price: '\$${(index + 1) * 99}.99',
                  bgColor: Colors.primaries[index % Colors.primaries.length].withOpacity(0.7),
                  onFavoriteTap: () {},
                  isFavorite: false,
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
          // Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ReusableBottomNavBar(
              currentIndex: 1, // Category tab is active
              onTap: (index) {
                if (index == 0) {
                  Get.offAllNamed('/home');
                } else if (index == 1) {
                  // Already on categories
                } else if (index == 2) {
                  Get.offAllNamed('/cart');
                } else if (index == 3) {
                  Get.offAllNamed('/profile');
                }
              },
              sv1: SvgPicture.asset(
                'assets/icons/home/sv1.svg',
                width: 24,
                height: 24,
              ),
              sv2: SvgPicture.asset(
                'assets/icons/home/sv2.svg',
                width: 24,
                height: 24,
              ),
              sv3: SvgPicture.asset(
                'assets/icons/home/sv3.svg',
                width: 24,
                height: 24,
              ),
              sv4: SvgPicture.asset(
                'assets/icons/home/sv4.svg',
                width: 24,
                height: 24,
              ),
            ),
          ),
        ],
      )
    );
  }
}