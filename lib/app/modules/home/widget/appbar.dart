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

  const CustomAppBar({
    Key? key,
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? Colors.white;
    final txtColor = textColor ?? Colors.black87;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
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
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      child: Column(
        children: [
          // Top section with greeting and notification
          Row(
            children: [
              // Profile icon and greeting
              GestureDetector(
                onTap: onProfileTap,
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      child: SvgPicture.asset(
                        'assets/icons/Group 290580.svg',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello $userName',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: txtColor,
                          ),
                        ),
                        Text(
                          phoneNumber.length > 2 
                              ? '${'*' * (phoneNumber.length - 2)}${phoneNumber.substring(phoneNumber.length - 2)}'
                              : phoneNumber,
                          style: TextStyle(
                            fontSize: 12,
                            color: txtColor.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Notification icon
              Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: onNotificationTap,
                    child: notificationIcon ??
                        SvgPicture.asset(
                          'assets/icons/home/notification.svg',
                          width: 24,
                          height: 24,
                        ),
                  ),
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.yellow,
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
            const SizedBox(height: 16),
            GestureDetector(
              onTap: onSearchTap,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Icon(
                      Icons.search,
                      color: Colors.grey.shade500,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: onSearchTap != null
                          ? Text(
                              searchHint,
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 14,
                              ),
                            )
                          : TextField(
                              controller: searchController,
                              onChanged: onSearchChanged,
                              decoration: InputDecoration(
                                hintText: searchHint,
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.zero,
                                filled: true,
                                fillColor: const Color(0xFFEEEEEE),
                              ),
                              style: TextStyle(
                                color: txtColor,
                                fontSize: 14,
                              ),
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
  Size get preferredSize => Size.fromHeight(showSearch ? 140 : 100);
}

// Example usage
class ExampleScreen extends StatefulWidget {
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
          child: const Icon(
            Icons.shopping_bag,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
      body: const Center(
        child: Text(
          'Your App Content Here',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

// Alternative usage with search tap (instead of typing)
class ExampleWithSearchTap extends StatelessWidget {
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
            MaterialPageRoute(
              builder: (context) => const SearchScreen(),
            ),
          );
        },
      ),
      body: const Center(child: Text('Home Screen')),
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: const Center(child: Text('Search Screen')),
    );
  }
}