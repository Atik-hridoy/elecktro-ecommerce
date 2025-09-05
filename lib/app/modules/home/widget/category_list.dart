import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  
  const CategoryList({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _buildCategoryItem(
            title: category['title'],
            bgColor: category['bgColor'],
            badge: category['badge'],
            hasSpecial: category['hasSpecial'],
          );
        },
      ),
    );
  }

  Widget _buildCategoryItem({
    required String title,
    required Color bgColor,
    required String badge,
    required bool hasSpecial,
  }) {
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
            child: Center(
              child: hasSpecial
                  ? Text(
                      badge,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    )
                  : const Icon(Icons.category, size: 30, color: Colors.white),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
