import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widget/navbar.dart';
import '../widget/appbar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  // Your page widgets
  final List<Widget> _pages = [
    const Center(child: Text('Home Page', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Categories', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Cart', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Profile', style: TextStyle(fontSize: 24))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: _pages[_selectedIndex],
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
    );
  }
}
