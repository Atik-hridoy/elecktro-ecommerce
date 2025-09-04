import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReusableBottomNavBar extends StatefulWidget {
  final Widget sv1;
  final Widget sv2;
  final Widget sv3;
  final Widget sv4;
  final Function(int)? onTap;
  final int currentIndex;
  final Color? backgroundColor;
  final Color? activeColor;
  final Color? inactiveColor;
  final double? height;

  const ReusableBottomNavBar({
    Key? key,
    required this.sv1,
    required this.sv2,
    required this.sv3,
    required this.sv4,
    this.onTap,
    this.currentIndex = 0,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
    this.height = 85,  // Increased from 70 to 80
  }) : super(key: key);

  @override
  State<ReusableBottomNavBar> createState() => _ReusableBottomNavBarState();
}

class _ReusableBottomNavBarState extends State<ReusableBottomNavBar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (widget.onTap != null) {
      widget.onTap!(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = widget.activeColor ?? theme.primaryColor;
    final inactiveColor = widget.inactiveColor ?? Colors.grey.shade600;
    final backgroundColor = widget.backgroundColor ?? const Color.fromARGB(255, 71, 29, 29); // Light ash color

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / 4;
          return Row(
            children: [
              _buildNavItem(widget.sv1, 0, activeColor, inactiveColor, itemWidth),
              _buildNavItem(widget.sv2, 1, activeColor, inactiveColor, itemWidth),
              _buildNavItem(widget.sv3, 2, activeColor, inactiveColor, itemWidth),
              _buildNavItem(widget.sv4, 3, activeColor, inactiveColor, itemWidth),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNavItem(Widget icon, int index, Color activeColor, Color inactiveColor, double width) {
    final isActive = _currentIndex == index;
    
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        width: width,
        padding: const EdgeInsets.only(top: 4, bottom: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated background highlight
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isActive ? activeColor.withOpacity(0.1) : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Icon with color transition
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOutBack,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        isActive ? activeColor : inactiveColor, 
                        BlendMode.srcIn
                      ),
                      child: icon,
                    ),
                  ),
                  // Ripple effect
                  if (isActive)
                    Positioned.fill(
                      child: AnimatedOpacity(
                        opacity: isActive ? 0.2 : 0,
                        duration: const Duration(milliseconds: 400),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: activeColor,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Animated indicator with negative margin to pull up
            const SizedBox(height: 0),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isActive ? 24 : 0,
              height: isActive ? 3 : 0,
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Example usage in your main app
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  
  // Your page widgets
  final List<Widget> _pages = [
    const Center(child: Text('Home Page', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Categories Page', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Cart Page', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Profile Page', style: TextStyle(fontSize: 24))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: ReusableBottomNavBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          activeColor: Colors.blue,
          inactiveColor: Colors.grey,
          backgroundColor: Colors.white,
          // Using SVG icons from assets
          sv1: SvgPicture.asset(
            'assets/icons/home/sv1.svg',
            colorFilter: ColorFilter.mode(
              _selectedIndex == 0 ? Colors.blue : Colors.grey,
              BlendMode.srcIn,
            ),
          ),
          sv2: SvgPicture.asset(
            'assets/icons/home/sv2.svg',
            colorFilter: ColorFilter.mode(
              _selectedIndex == 1 ? Colors.blue : Colors.grey,
              BlendMode.srcIn,
            ),
          ),
          sv3: SvgPicture.asset(
            'assets/icons/home/sv3.svg',
            colorFilter: ColorFilter.mode(
              _selectedIndex == 2 ? Colors.blue : Colors.grey,
              BlendMode.srcIn,
            ),
          ),
          sv4: SvgPicture.asset(
            'assets/icons/home/sv4.svg',
            colorFilter: ColorFilter.mode(
              _selectedIndex == 3 ? Colors.blue : Colors.grey,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

