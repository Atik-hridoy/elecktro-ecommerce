import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/core/navigation/navigation_service.dart';
import 'package:elecktro_ecommerce/app/modules/cart/views/appbar.dart';
import 'package:elecktro_ecommerce/app/modules/home/widget/navbar.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light, // Ensures dark icons for light status bar
        systemNavigationBarColor: Colors.white, // Optional: set navigation bar color
        systemNavigationBarIconBrightness: Brightness.dark, // Dark navigation icons
      ),
      child: Scaffold(
      appBar: RoundedAppBar(
  title: 'My Account',
  height: 60.0,
  borderRadius: 20.0,
  backgroundColor: Colors.white,
  textColor: Colors.black,
  elevation: 4.0,
  shadowColor: const Color(0x33000000),
  showBackButton: false,
),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Header Section
            Container(
              width: double.infinity, // Make it full width
              padding: const EdgeInsets.all(16), // Match the menu items padding
              margin: const EdgeInsets.only(bottom: 16), // Space between profile card & menu items
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Profile Picture
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/profile/profile_picture.jpg', // Replace with actual path
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade300,
                            child: const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Name
                  const Text(
                    'Asad Ujjaman',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Address
                  Text(
                    '20 Cooper Square, N...',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Menu Items
            _buildMenuItem(
              icon: Icons.favorite_outline,
              title: 'Wish list',
              onTap: () {
                // Navigate to wish list
                print('Navigate to wish list');
              },
            ),
            
            _buildMenuItem(
              icon: Icons.shopping_cart_outlined,
              title: 'Dealing History',
              onTap: () {
                // Navigate to dealing history
                print('Navigate to dealing history');
              },
            ),
            
            _buildMenuItem(
              icon: Icons.settings_outlined,
              title: 'Account Setting',
              onTap: () {
                // Navigate to account settings
                print('Navigate to account settings');
              },
            ),
            
            _buildMenuItem(
              icon: Icons.info_outline,
              title: 'About',
              onTap: () {
                // Navigate to about
                print('Navigate to about');
              },
            ),
            
            _buildMenuItem(
              icon: Icons.work_outline,
              title: 'Work Functionality',
              onTap: () {
                // Navigate to work functionality
                print('Navigate to work functionality');
              },
            ),
            
            _buildMenuItem(
              icon: Icons.description_outlined,
              title: 'Terms & Conditions',
              onTap: () {
                // Navigate to terms
                print('Navigate to terms');
              },
            ),
            
            _buildMenuItem(
              icon: Icons.help_outline,
              title: 'FAQ',
              onTap: () {
                // Navigate to FAQ
                print('Navigate to FAQ');
              },
            ),
            
            _buildMenuItem(
              icon: Icons.support_outlined,
              title: 'Support',
              onTap: () {
                // Navigate to support
                print('Navigate to support');
              },
            ),
            
            _buildMenuItem(
              icon: Icons.logout,
              title: 'Log Out',
              textColor: Colors.red,
              showArrow: false,
              onTap: () {
                _showLogoutDialog(context);
              },
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: ReusableNavBar(
        currentIndex: 3, // Profile tab is active
        onTap: (index) {
          // Handle navigation in the home controller
          Get.find<NavigationService>().handleNavigation(index);
        },
        activeColor: const Color(0xFF044D37),
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
      ),
      )
    );
  }

  // Helper method for building menu items
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Color? textColor,
    bool showArrow = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      height: 56, // Adjusted height for consistency
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: textColor ?? Colors.grey.shade700,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor ?? Colors.black87,
          ),
        ),
        trailing: showArrow
            ? const Icon(Icons.arrow_forward_ios, size: 16)
            : null,
        onTap: onTap,
      ),
    );
  }

  // Logout dialog method
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle logout logic here
                // You can call your controller method here
                // controller.logout();
                print('User logged out');
              },
              child: const Text(
                'Log Out',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
