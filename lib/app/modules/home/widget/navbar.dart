import 'package:flutter/material.dart';

/// A reusable bottom navigation bar with customizable appearance and behavior.
///
/// This widget provides a consistent navigation experience across the app
/// with support for up to 4 navigation items.
class ReusableNavBar extends StatelessWidget {
  /// The current index of the selected [BottomNavigationBarItem].
  final int currentIndex;

  /// Called when one of the [items] is tapped.
  final ValueChanged<int> onTap;

  /// The color of the selected [BottomNavigationBarItem].
  final Color activeColor;

  /// The color of the unselected [BottomNavigationBarItem]s.
  final Color inactiveColor;

  /// The background color of the navigation bar.
  final Color backgroundColor;

  /// The elevation of the navigation bar.
  final double elevation;

  /// The border radius of the navigation bar.
  final BorderRadius? borderRadius;

  /// The list of navigation items to display.
  final List<BottomNavigationBarItem> items;

  /// Creates a reusable navigation bar.
  ///
  /// The [items] must have between 2 and 4 items.
  const ReusableNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
    required this.backgroundColor,
    required this.items,
    this.elevation = 8.0,
    this.borderRadius,
  })  : assert(items.length >= 2 && items.length <= 4, 'Must have between 2-4 items'),
        super(key: key);

  /// Creates a navigation bar with SVG icons.
  ///
  /// This factory constructor simplifies the creation of a navigation bar
  /// with SVG icons for each item.
  factory ReusableNavBar.svgIcons({
    required int currentIndex,
    required ValueChanged<int> onTap,
    required Color activeColor,
    required Color inactiveColor,
    required Color backgroundColor,
    required List<NavBarItem> items,
    double elevation = 8.0,
    BorderRadius? borderRadius,
  }) {
    return ReusableNavBar(
      currentIndex: currentIndex,
      onTap: onTap,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      backgroundColor: backgroundColor,
      elevation: elevation,
      borderRadius: borderRadius,
      items: items
          .map((item) => BottomNavigationBarItem(
                icon: item.icon,
                label: item.label,
                tooltip: item.label,
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBorderRadius = BorderRadius.only(
      topLeft: const Radius.circular(25),
      topRight: const Radius.circular(25),
    );

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius ?? defaultBorderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? defaultBorderRadius,
        child: Theme(
          data: theme.copyWith(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            backgroundColor: backgroundColor,
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            onTap: onTap,
            elevation: elevation,
            selectedItemColor: activeColor,
            unselectedItemColor: inactiveColor,
            selectedLabelStyle: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: theme.textTheme.labelSmall?.copyWith(
              fontSize: 12,
            ),
            showUnselectedLabels: true,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            items: items,
          ),
        ),
      ),
    );
  }
}

/// A model class representing a navigation bar item.
class NavBarItem {
  /// The widget to display as the icon.
  final Widget icon;

  /// The label text to display.
  final String label;

  /// Creates a navigation bar item.
  const NavBarItem({
    required this.icon,
    required this.label,
  });

  /// Creates a navigation bar item with an SVG icon.
  factory NavBarItem.svg({
    required String assetPath,
    required String label,
    required bool isActive,
    required Color activeColor,
    required Color inactiveColor,
    double size = 24,
  }) {
    return NavBarItem(
      icon: _SvgIcon(
        assetPath: assetPath,
        color: isActive ? activeColor : inactiveColor,
        size: size,
      ),
      label: label,
    );
  }
}

class _SvgIcon extends StatelessWidget {
  final String assetPath;
  final Color color;
  final double size;

  const _SvgIcon({
    required this.assetPath,
    required this.color,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        child: Image.asset(
          assetPath,
          package: null,
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

