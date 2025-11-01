import 'package:flutter/material.dart';

class ProductBuildRowReviewItem extends StatelessWidget {
  const ProductBuildRowReviewItem({
    super.key, 
    required this.name, 
    required this.title, 
    required this.review, 
    required this.rating, 
    required this.date,
    this.images = const [],
  });

  final String name;
  final String title;
  final String review;
  final double rating;
  final String date;
  final List<String> images;

  @override
  Widget build(BuildContext context) {
       return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                child: Text(name.split(' ').map((e) => e[0]).join(''), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    if (title.isNotEmpty)
                      Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(rating.toString(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(review, style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.4)),
          if (images.isNotEmpty) ...[
            const SizedBox(height: 12),
            Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(12),
              shadowColor: Colors.black.withValues(alpha: 0.2),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[100]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.photo_camera, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 6),
                        Text('Photos from review', style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () {
                                // Show full image dialog
                                showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.network(
                                          images[index],
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              height: 200,
                                              color: Colors.grey[200],
                                              child: const Center(
                                                child: Icon(Icons.broken_image, size: 48),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    images[index],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.broken_image, color: Colors.grey),
                                      );
                                    },
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                                  loadingProgress.expectedTotalBytes!
                                              : null,
                                          strokeWidth: 2,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (date.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(date, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          ],
        ],
      ),
    );
  }
}