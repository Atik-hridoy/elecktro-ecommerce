import 'package:flutter/material.dart';

/// A responsive widget that displays a list of categories.
///
/// On small screens, it shows a horizontally scrollable list.
/// On larger screens, it displays a wrapping grid of all categories.
class CategoryList extends StatelessWidget {
  final List<Map<String, dynamic>> categories;

  const CategoryList({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder to create a responsive UI that adapts to screen size.
    return LayoutBuilder(
      builder: (context, constraints) {
        // Define a breakpoint for switching between mobile and desktop layouts.
        const double mobileBreakpoint = 600;

        // For larger screens, display a wrapping grid.
        if (constraints.maxWidth >= mobileBreakpoint) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 12.0, // Horizontal space between items
              runSpacing: 12.0, // Vertical space between rows
              alignment: WrapAlignment.center,
              children: categories.map((category) {
                return _buildCategoryItem(
                  context: context,
                  title: category['title'],
                  bgColor: category['bgColor'],
                  badge: category['badge'],
                  hasSpecial: category['hasSpecial'],
                );
              }).toList(),
            ),
          );
        }
        // For smaller screens, display the horizontal list.
        else {
          return SizedBox(
            height: 120, // Set a fixed height for the horizontal list
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return _buildCategoryItem(
                  context: context,
                  title: category['title'],
                  bgColor: category['bgColor'],
                  badge: category['badge'],
                  hasSpecial: category['hasSpecial'],
                );
              },
            ),
          );
        }
      },
    );
  }

  /// Builds a single category item with Material 3 styling.
  Widget _buildCategoryItem({
    required BuildContext context,
    required String title,
    required Color bgColor,
    required String badge,
    required bool hasSpecial,
  }) {
    final textTheme = Theme.of(context).textTheme;

    // Determine a contrasting color for text/icons on the provided background color.
    final onBgColor = ThemeData.estimateBrightnessForColor(bgColor) == Brightness.dark
        ? Colors.white
        : Colors.black;

    return SizedBox(
      width: 80, // Fixed width for each item
      child: Material(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: Implement category tap navigation
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // The colored container for the icon or special badge text
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: hasSpecial
                        ? Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              badge,
                              textAlign: TextAlign.center,
                              style: textTheme.labelSmall?.copyWith(
                                color: onBgColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : Icon(Icons.category, size: 30, color: onBgColor),
                  ),
                ),
                const SizedBox(height: 8),
                // The category title text
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}