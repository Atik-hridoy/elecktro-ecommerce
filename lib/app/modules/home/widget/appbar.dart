import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String phoneNumber;
  final String searchHint;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final Function(String)? onSearchChanged;
  final VoidCallback? onSearchTap;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? profileIcon;
  final Widget? notificationIcon;
  final bool showSearch;
  final TextEditingController? searchController;
  final bool hasUnreadNotifications;

  const CustomAppBar({
    super.key,
    required this.userName,
    required this.phoneNumber,
    this.searchHint = "Search in Cartup",
    this.onNotificationTap,
    this.onProfileTap,
    this.onSearchChanged,
    this.onSearchTap,
    this.backgroundColor,
    this.textColor,
    this.profileIcon,
    this.notificationIcon,
    this.showSearch = true,
    this.searchController,
    this.hasUnreadNotifications = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? Colors.white;
    final txtColor = textColor ?? Colors.black87;
    
    // Screen scaling
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final widthScale = screenWidth / 375;
    final heightScale = screenHeight / 812;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20 * widthScale),
          bottomRight: Radius.circular(20 * widthScale),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + (8 * heightScale),
        left: 16 * widthScale,
        right: 16 * widthScale,
        bottom: 12 * heightScale,
      ),
      child: Column(
        children: [
          // Top section with greeting and notification
          Row(
            children: [
              // Profile icon and greeting
              Expanded(
                child: GestureDetector(
                  onTap: onProfileTap,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 40 * widthScale,
                        height: 40 * widthScale,
                        child: SvgPicture.asset('assets/icons/Group 290580.svg'),
                      ),
                      SizedBox(width: 12 * widthScale),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello $userName',
                              style: TextStyle(
                                fontSize: 16 * widthScale,
                                fontWeight: FontWeight.w600,
                                color: txtColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              phoneNumber.length > 2
                                  ? '${'*' * (phoneNumber.length - 2)}${phoneNumber.substring(phoneNumber.length - 2)}'
                                  : phoneNumber,
                              style: TextStyle(
                                fontSize: 12 * widthScale,
                                color: txtColor.withOpacity(0.6),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12 * widthScale),
              // Notification icon
              Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: onNotificationTap,
                    child:
                        notificationIcon ??
                        SvgPicture.asset(
                          'assets/icons/home/notification.svg',
                          width: 24 * widthScale,
                          height: 24 * widthScale,
                        ),
                  ),
                  if (hasUnreadNotifications)
                    Positioned(
                      top: -2 * widthScale,
                      right: -2 * widthScale,
                      child: Container(
                        width: 10 * widthScale,
                        height: 10 * widthScale,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),

          // Search bar
          if (showSearch) ...[
            SizedBox(height: 16 * heightScale),
            GestureDetector(
              onTap: onSearchTap,
              child: Container(
                height: 48 * heightScale,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(20 * widthScale),
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 16 * widthScale),
                    Icon(Icons.search, color: Colors.grey.shade500, size: 20 * widthScale),
                    SizedBox(width: 12 * widthScale),
                    Expanded(
                      child: onSearchTap != null
                          ? Text(
                              searchHint,
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 14 * widthScale,
                              ),
                            )
                          : TextField(
                              controller: searchController,
                              onChanged: onSearchChanged,
                              decoration: InputDecoration(
                                hintText: searchHint,
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14 * widthScale,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24 * widthScale),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.zero,
                                filled: true,
                                fillColor: const Color(0xFFEEEEEE),
                              ),
                              style: TextStyle(color: txtColor, fontSize: 14 * widthScale),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Size get preferredSize {
    // Get screen height for scaling
    final screenHeight = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.height / 
                        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    final heightScale = screenHeight / 812;
    
    // Scale the appbar height based on screen size
    final baseHeight = showSearch ? 140.0 : 100.0;
    return Size.fromHeight(baseHeight * heightScale);
  }
}

// Example usage
class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        userName: "Asad101",
        phoneNumber: "+880155****63",
        searchHint: "Search in Cartup",
        onNotificationTap: () {
          print("Notification tapped");
        },
        onProfileTap: () {
          print("Profile tapped");
        },
        onSearchChanged: (value) {
          print("Search: $value");
        },
        searchController: _searchController,
        // Custom colors
        backgroundColor: Colors.white,
        textColor: Colors.black87,
        // Custom icons (optional)
        profileIcon: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.orange, Colors.green],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.shopping_bag, color: Colors.white, size: 20),
        ),
      ),
      body: const Center(
        child: Text('Your App Content Here', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}

// Alternative usage with search tap (instead of typing)
class ExampleWithSearchTap extends StatelessWidget {
  const ExampleWithSearchTap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        userName: "Asad101",
        phoneNumber: "+880155****63",
        onNotificationTap: () {
          // Handle notification tap
        },
        onSearchTap: () {
          // Navigate to search screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchScreen()),
          );
        },
      ),
      body: const Center(child: Text('Home Screen')),
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: const Center(child: Text('Search Screen')),
    );
  }
}
