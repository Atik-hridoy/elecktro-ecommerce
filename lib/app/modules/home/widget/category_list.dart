import 'package:flutter/material.dart';
import 'package:elecktro_ecommerce/app/modules/home/models/get_category_on_home_view.dart';

/// A responsive widget that displays a list of categories.
///
/// On small screens, it shows a horizontally scrollable list.
/// On larger screens, it displays a wrapping grid of all categories.
class CategoryList extends StatelessWidget {
  final List<CategoryModel> categories;
  final Function(String categoryId)? onCategoryTap;
  final String? selectedCategoryId;

  const CategoryList({
    super.key, 
    required this.categories,
    this.onCategoryTap,
    this.selectedCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    // Screen scaling
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var heightScale = screenHeight / 812;
    var widthScale = screenWidth / 375;
    
    // Extra reduction for small screens
    final isSmallScreen = screenHeight < 700;
    if (isSmallScreen) {
      heightScale = heightScale * 0.75;
      widthScale = widthScale * 0.85;
    }
    
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
                  title: category.name,
                  thumbnail: category.thumbnail,
                  categoryId: category.id,
                  isSelected: selectedCategoryId == category.id,
                );
              }).toList(),
            ),
          );
        }
        // For smaller screens, display the horizontal list.
        else {
          return SizedBox(
            height: 120 * heightScale, // Responsive height
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16 * widthScale),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return _buildCategoryItem(
                  context: context,
                  title: category.name,
                  thumbnail: category.thumbnail,
                  categoryId: category.id,
                  isSelected: selectedCategoryId == category.id,
                  heightScale: heightScale,
                  widthScale: widthScale,
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
    required String thumbnail,
    required String categoryId,
    bool isSelected = false,
    double heightScale = 1.0,
    double widthScale = 1.0,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 80 * widthScale, // Responsive width
      child: Material(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(12 * widthScale),
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (onCategoryTap != null) {
              onCategoryTap!(categoryId);
            }
          },
          child: Padding(
            padding: EdgeInsets.all(4.0 * widthScale),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // The thumbnail container
                Container(
                  width: 60 * widthScale,
                  height: 60 * heightScale,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF044D37).withOpacity(0.2) : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16 * widthScale),
                    border: isSelected ? Border.all(color: const Color(0xFF044D37), width: 2) : null,
                    image: thumbnail.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(thumbnail),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: thumbnail.isEmpty
                      ? Icon(Icons.category, size: 30 * widthScale, color: Colors.black)
                      : null,
                ),
                SizedBox(height: 8 * heightScale),
                // The category title text
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall?.copyWith(fontSize: 12 * widthScale),
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