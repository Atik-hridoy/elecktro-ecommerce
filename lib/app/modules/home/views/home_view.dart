import 'package:elecktro_ecommerce/app/core/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../widget/appbar.dart';
import '../widget/product_card.dart';
import '../widget/banner_card.dart';
import '../widget/category_list.dart';
import '../widget/navbar.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller if not already initialized
    final homeController = Get.find<HomeController>();

  
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        appBar: homeController.selectedIndex.value == 0
            ? CustomAppBar(
                userName: 'John Doe',
                phoneNumber: '+1 234 567 890',
                searchHint: 'Search products...',
                onNotificationTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notifications clicked')),
                  );
                },
                onProfileTap: () {
                  homeController.updateIndex(3); // Navigate to profile
                },
                onSearchChanged: (query) {
                  print('Search query: $query');
                },
              )
            : null,
        body: _buildHomePage(homeController),
        bottomNavigationBar: Obx(() {
          // Observe the current index from HomeController
          final currentIndex = Get.find<HomeController>().selectedIndex.value;
          return ReusableNavBar(
            currentIndex: currentIndex,
            onTap: NavigationService.to.handleNavigation,
          activeColor: const Color(0xFF044D37), // Green color from your design
          inactiveColor: Colors.grey,
          backgroundColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 24),
              activeIcon: Icon(Icons.home, size: 24),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined, size: 24),
              activeIcon: Icon(Icons.category, size: 24),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined, size: 24),
              activeIcon: Icon(Icons.shopping_cart, size: 24),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 24),
              activeIcon: Icon(Icons.person, size: 24),
              label: 'Profile',
            ),
          ],
        
        );
      },
        ),
      ),
    );
  
  }

  // Home page body structure
  Widget _buildHomePage(HomeController homeController) {
    return Builder(
      builder: (context) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add top padding to account for status bar
            SizedBox(height: MediaQuery.of(context).padding.top),
            // Banner Section
            const BannerCard(
              items: [
                'assets/banner/pic1.png',
                'assets/banner/pic2.png',
                'assets/banner/pic3.png',
                'assets/banner/pic4.png',
                'assets/banner/pic5.png',
              ],
              currentIndex: 0,
          ),
          const SizedBox(height: 16),

          // Category Section
          CategoryList(categories: homeController.categories),  // Use the controller's categories

          const SizedBox(height: 24),

          // Popular Products Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Popular Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () {},
                  child: const Text('View All', style: TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Popular Products Grid
          SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 6,
              itemBuilder: (context, index) {
                // List of product data
                // Define colors first
                final colors = [
                  Colors.blue[200]!,
                  Colors.purple[200]!,
                  Colors.red[200]!,
                  Colors.teal[200]!,
                  Colors.orange[200]!,
                ];

                // Ensure we have at least one color
                final color = colors.isNotEmpty 
                    ? colors[index % colors.length]
                    : Colors.grey[200]!;

                const products = [
                  {
                    'id': 'prod_001',
                    'name': 'Wireless Earbuds',
                    'brand': 'SoundBeats',
                    'price': '\$99',
                    'imageUrl': 'assets/images/1.jpeg',
                  },
                  {
                    'id': 'prod_002',
                    'name': 'Smart Watch',
                    'brand': 'TechWear',
                    'price': '\$199',
                    'imageUrl': 'assets/images/2.jpeg',
                  },
                  {
                    'id': 'prod_003',
                    'name': 'Bluetooth Speaker',
                    'brand': 'BoomAudio',
                    'price': '\$79',
                    'imageUrl': 'assets/images/3.jpeg',
                  },
                  {
                    'id': 'prod_004',
                    'name': 'Wireless Mouse',
                    'brand': 'ErgoTech',
                    'price': '\$39',
                    'imageUrl': 'assets/images/4.jpeg',
                  },
                  {
                    'id': 'prod_005',
                    'name': 'Power Bank',
                    'brand': 'ChargeIt',
                    'price': '\$49',
                    'imageUrl': 'assets/images/5.jpeg',
                  },
                ];

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ProductCard(
                    name: products[index]['name'] as String,
                    productId: products[index]['id'] as String,
                    brand: products[index]['brand'] as String,
                    price: products[index]['price'] as String,
                    imageUrl: products[index]['imageUrl'],
                    bgColor: color,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // You may like Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'You may like',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // You may like products
          Container(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 6, // Total number of products
              itemBuilder: (context, index) {
                // List of recommended products
                const recommendedProducts = [
                  {
                    'id': 'prod_006',
                    'name': 'Wireless Keyboard',
                    'brand': 'KeyMaster',
                    'price': '\$59',
                  },
                  {
                    'id': 'prod_007',
                    'name': 'Gaming Mouse',
                    'brand': 'GameGear',
                    'price': '\$79',
                  },
                  {
                    'id': 'prod_008',
                    'name': 'USB Hub',
                    'brand': 'PortPlus',
                    'price': '\$25',
                  },{
                    'id': 'prod_009',
                    'name': 'Laptop Stand',
                    'brand': 'ErgoTech',
                    'price': '\$35',
                  },
                  {
                    'id': 'prod_010',
                    'name': 'Screen Protector',
                    'brand': 'ShieldMax',
                    'price': '\$12',
                  },
                  {
                    'id': 'prod_011',
                    'name': 'Laptop Sleeve',
                    'brand': 'UrbanGear',
                    'price': '\$25',
                  },
                ];

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ProductCard(
                    productId: recommendedProducts[index]['id'] as String,
                    name: recommendedProducts[index]['name'] as String,
                    brand: recommendedProducts[index]['brand'] as String,
                    price: recommendedProducts[index]['price'] as String,
                    bgColor: Colors.grey[200]!,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20), // Adjusted bottom padding to prevent overflow
        ],
      ),
      )
    );
  }
}
