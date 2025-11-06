import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/core/network/app_urls.dart';
import '../models/cart_model.dart';

class CartProductCard extends StatefulWidget {
  final String productName;
  final String? brand;
  final String size;
  final String color;
  final double price;
  final int quantity;
  final List<String> images;
  final VoidCallback? onRemoveFromCart;
  final Function(int newQuantity)? onQuantityChanged;
  final bool isSelected;
  final Function(bool?)? onSelect;

  const CartProductCard({
    super.key,
    required this.productName,
    this.brand,
    this.size = 'One Size',
    this.color = 'Black',
    required this.price,
    this.quantity = 1,
    this.images = const [],
    this.onRemoveFromCart,
    this.onQuantityChanged,
    this.isSelected = false,
    this.onSelect,
  });

  @override
  State<CartProductCard> createState() => _CartProductCardState();

  factory CartProductCard.fromCartProduct({
    required CartProduct product,
    required VoidCallback onRemove,
    required Function(int) onQuantityChanged,
    bool isSelected = false,
    Function(bool?)? onSelect,
  }) {
    return CartProductCard(
      productName: product.name ?? 'product'.tr,
      brand: product.brand,
      size: product.size,
      color: product.color,
      price: product.price,
      quantity: product.quantity,
      images: product.images,
      onRemoveFromCart: onRemove,
      onQuantityChanged: onQuantityChanged,
      isSelected: isSelected,
      onSelect: onSelect,
    );
  }
}

class _CartProductCardState extends State<CartProductCard> {
  late int _quantity;
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _quantity = widget.quantity;
    _isChecked = widget.isSelected;
  }

  // Increment quantity
  void _incrementQuantity() {
    final newQuantity = _quantity + 1;
    setState(() {
      _quantity = newQuantity;
    });
    widget.onQuantityChanged?.call(newQuantity);
  }

  // Decrement quantity
  void _decrementQuantity() {
    if (_quantity > 1) {
      final newQuantity = _quantity - 1;
      setState(() {
        _quantity = newQuantity;
      });
      widget.onQuantityChanged?.call(newQuantity);
    }
  }

  // Toggle the checkbox state
  void _toggleCheckbox(bool? value) {
    if (value != null) {
      setState(() {
        _isChecked = value;
      });
      widget.onSelect?.call(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox
            if (widget.onSelect != null)
              Checkbox(
                value: _isChecked,
                onChanged: _toggleCheckbox,
                activeColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              )
            else
              const SizedBox(width: 40),

            // Product Image
            _buildProductImage(),
            const SizedBox(width: 12),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name and Remove Button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.productName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (widget.onRemoveFromCart != null)
                        IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: widget.onRemoveFromCart,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          iconSize: 20,
                        ),
                    ],
                  ),

                  // Brand
                  if (widget.brand != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2, bottom: 4),
                      child: Text(
                        widget.brand!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),

                  // Size and Color
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      if (widget.size.isNotEmpty)
                        _buildAttributeChip('${'size'.tr}: ${widget.size}'),
                      if (widget.color.isNotEmpty)
                        _buildAttributeChip('${'color'.tr}: ${widget.color}'),
                    ],
                  ),

                  // Price and Quantity
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildPriceSection(),
                      _buildQuantitySection(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dynamically build the price section
  Widget _buildPriceSection() {
    return Text(
      '\$${widget.price.toStringAsFixed(2)}',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  // Dynamically build the action buttons (like favorite and add to cart)
  Widget _buildProductImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: widget.images.isNotEmpty
          ? Image.network(
              '${AppUrls.baseImageUrl}${widget.images[0].startsWith('/') ? widget.images[0].substring(1) : widget.images[0]}',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image, color: Colors.grey),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                );
              },
            )
          : const Icon(Icons.image, color: Colors.grey),
    );
  }

  Widget _buildQuantitySection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrease button
          IconButton(
            icon: const Icon(Icons.remove, size: 18),
            onPressed: _decrementQuantity,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          
          // Quantity
          Text(
            '$_quantity',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          // Increase button
          IconButton(
            icon: const Icon(Icons.add, size: 18),
            onPressed: _incrementQuantity,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributeChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.only(right: 4, bottom: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[800],
        ),
      ),
    );
  }
}