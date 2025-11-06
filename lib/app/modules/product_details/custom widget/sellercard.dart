import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/modules/category/models/get_product_details_models.dart';
import 'package:elecktro_ecommerce/app/core/network/app_urls.dart';

class SellerCard extends StatelessWidget {
  final Seller seller;
  final double rating;
  final int reviewCount;
  final VoidCallback? onTap;

  const SellerCard({
    Key? key,
    required this.seller,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if seller info is available
    final hasSellerInfo = seller.firstName.isNotEmpty || seller.lastName.isNotEmpty || seller.id.isNotEmpty;
    final sellerName = '${seller.firstName} ${seller.lastName}'.trim();
    final displayName = sellerName.isNotEmpty ? sellerName : 'unknown_seller'.tr;
    
    // Don't show card if no seller info at all
    if (!hasSellerInfo) {
      return const SizedBox.shrink();
    }
    
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: seller.id.isNotEmpty ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[200],
                backgroundImage: seller.image != null && seller.image!.isNotEmpty
                    ? NetworkImage(
                        seller.image!.startsWith('http')
                            ? seller.image!
                            : '${AppUrls.baseImageUrl}${seller.image!.startsWith('/') ? seller.image!.substring(1) : seller.image!}',
                      )
                    : null,
                child: seller.image == null || seller.image!.isEmpty
                    ? const Icon(Icons.store, color: Colors.grey, size: 24)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'seller'.tr,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${rating.toStringAsFixed(1)}/5',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '$reviewCount ${'reviews_count'.tr}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (seller.id.isNotEmpty)
                const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}