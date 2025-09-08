import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/checkout_controller.dart';

class CartItemTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final int index;
  const CartItemTile({super.key, required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CheckoutController>();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF2D3748),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.local_offer,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] ?? 'T-Shirt',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item['brand'] ?? 'Trkil'} / ${item['size'] ?? 'XL'} / ${item['color'] ?? 'Black'}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '\$${(item['price'] ?? 16.30).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (item['originalPrice'] != null)
                      Text(
                        '\$${(item['originalPrice'] as num).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              PopupMenuButton(
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'remove', child: Text('Remove')),
                ],
                onSelected: (value) {
                  if (value == 'remove') controller.removeItem(index);
                },
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _qtyButton(Icons.remove, () => controller.updateQuantity(index, (item['quantity'] as int) - 1)),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      '${item['quantity'] ?? 1}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  _qtyButton(Icons.add, () => controller.updateQuantity(index, (item['quantity'] as int) + 1)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: icon == Icons.add ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 16),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
