import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widget/navbar.dart';
import '../widget/appbar.dart';
import '../widget/product_card.dart';
import '../widget/banner_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  // Your page widgets
  final List<Widget> _pages = [
    _buildHomePage(), // Updated home page with full structure
    const Center(child: Text('Categories', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Cart', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Profile', style: TextStyle(fontSize: 24))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Home page body structure
  static Widget _buildHomePage() {
    return Builder(
      builder: (context) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add top padding to account for status bar
            SizedBox(height: MediaQuery.of(context).padding.top),
            // Banner Section
            BannerCard(
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
            // Categories Section
            Container(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildCategoryItem(
                    "Best Offers", 
                    Colors.red, 
                    "SPECIAL\nUP TO",
                    true
                  ),
                  _buildCategoryItem("Computers", Colors.grey.shade300, "", false),
                  _buildCategoryItem("Phone", Colors.grey.shade300, "", false),
                  _buildCategoryItem("Server Tool", Colors.grey.shade300, "", false),
                  _buildCategoryItem("accessories", Colors.grey.shade300, "", false),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Popular Products Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular Products',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle View All tap
                    },
                    child: const Text(
                      'View All',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Popular Products Grid
            Container(
              height: 240, // Slightly increased height to accommodate the price
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 6, // Total number of products
                itemBuilder: (context, index) {
                  // List of product data
                  final products = [
                  {
                    'name': 'Trkil Tracker',
                    'brand': 'Trkil',
                    'price': '\$16.30',
                    'color': Colors.black,
                  },
                  {
                    'name': 'Oppo A35',
                    'brand': 'Osaka',
                    'price': '\$2500',
                    'color': Colors.blue.shade200,
                  },
                  {
                    'name': 'Smart Watch',
                    'brand': 'FitPro',
                    'price': '\$199',
                    'color': Colors.red.shade200,
                  },
                  {
                    'name': 'Wireless Earbuds',
                    'brand': 'Sonic',
                    'price': '\$129',
                    'color': Colors.purple.shade200,
                  },
                  {
                    'name': 'Laptop Stand',
                    'brand': 'ErgoTech',
                    'price': '\$39',
                    'color': Colors.teal.shade200,
                  },
                  {
                    'name': 'Power Bank',
                    'brand': 'ChargeIt',
                    'price': '\$49',
                    'color': Colors.orange.shade200,
                  },
                ];

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ProductCard(
                    name: products[index]['name'] as String,
                    brand: products[index]['brand'] as String,
                    price: products[index]['price'] as String,
                    bgColor: products[index]['color'] as Color,
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
                final recommendedProducts = [
                  {
                    'name': 'Wireless Mouse',
                    'brand': 'TechGear',
                    'price': '\$29',
                    'color': Colors.blueGrey.shade200,
                  },
                  {
                    'name': 'Bluetooth Speaker',
                    'brand': 'BoomSound',
                    'price': '\$89',
                    'color': Colors.indigo.shade200,
                  },
                  {
                    'name': 'Phone Stand',
                    'brand': 'MobiMount',
                    'price': '\$15',
                    'color': Colors.amber.shade200,
                  },
                  {
                    'name': 'USB-C Hub',
                    'brand': 'PortableTech',
                    'price': '\$45',
                    'color': Colors.green.shade200,
                  },
                  {
                    'name': 'Screen Protector',
                    'brand': 'ShieldMax',
                    'price': '\$12',
                    'color': Colors.brown.shade200,
                  },
                  {
                    'name': 'Laptop Sleeve',
                    'brand': 'UrbanGear',
                    'price': '\$25',
                    'color': Colors.grey.shade300,
                  },
                ];

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ProductCard(
                    name: recommendedProducts[index]['name'] as String,
                    brand: recommendedProducts[index]['brand'] as String,
                    price: recommendedProducts[index]['price'] as String,
                    bgColor: recommendedProducts[index]['color'] as Color,
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

  static Widget _buildCategoryItem(String title, Color bgColor, String badge, bool hasSpecial) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: hasSpecial 
                ? Stack(
                    children: [
                      const Center(
                        child: Icon(
                          Icons.local_offer,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            badge,
                            style: const TextStyle(
                              fontSize: 6,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: Icon(
                      Icons.category,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return 
    AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        appBar: _selectedIndex == 0 ? CustomAppBar(
          userName: 'John Doe',
          phoneNumber: '+1 234 567 890',
          searchHint: 'Search products...',
          onNotificationTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifications clicked')),
            );
          },
          onProfileTap: () {
            setState(() {
              _selectedIndex = 3; // Navigate to profile
            });
          },
          onSearchChanged: (query) {
            print('Search query: $query');
          },
        ) : null,
        body: _selectedIndex == 0 ? _buildHomePage() : _pages[_selectedIndex],
        bottomNavigationBar: ReusableBottomNavBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          activeColor: Colors.green,
          inactiveColor: Colors.grey,
          backgroundColor: Colors.white,
          // Using SVG icons from assets
          sv1: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _selectedIndex == 0 ? 36 : 32,
            height: _selectedIndex == 0 ? 36 : 32,
            child: SvgPicture.asset(
              'assets/icons/home/sv1.svg',
              color: _selectedIndex == 0 ? Colors.green : Colors.grey.shade800,
              width: _selectedIndex == 0 ? 36 : 32,
              height: _selectedIndex == 0 ? 36 : 32,
              fit: BoxFit.contain,
            ),
          ),
          sv2: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _selectedIndex == 1 ? 44 : 40,
            height: _selectedIndex == 1 ? 44 : 40,
            child: SvgPicture.asset(
              'assets/icons/home/sv2.svg',
              color: _selectedIndex == 1 ? Colors.green : Colors.grey.shade800,
              width: _selectedIndex == 1 ? 44 : 40,
              height: _selectedIndex == 1 ? 44 : 40,
              fit: BoxFit.contain,
            ),
          ),
          sv3: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _selectedIndex == 2 ? 36 : 32,
            height: _selectedIndex == 2 ? 36 : 32,
            child: SvgPicture.asset(
              'assets/icons/home/sv3.svg',
              color: _selectedIndex == 2 ? Colors.green : Colors.grey.shade800,
              width: _selectedIndex == 2 ? 36 : 32,
              height: _selectedIndex == 2 ? 36 : 32,
              fit: BoxFit.contain,
            ),
          ),
          sv4: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _selectedIndex == 3 ? 44 : 40,
            height: _selectedIndex == 3 ? 44 : 40,
            child: SvgPicture.asset(
              'assets/icons/home/sv4.svg',
              color: _selectedIndex == 3 ? Colors.green : Colors.grey.shade800,
              width: _selectedIndex == 3 ? 44 : 40,
              height: _selectedIndex == 3 ? 44 : 40,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
