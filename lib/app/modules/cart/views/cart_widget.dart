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
    // Screen scaling
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    var widthScale = screenWidth / 375;
    var heightScale = screenHeight / 812;
    
    // Extra reduction for small screens
    final isSmallScreen = screenHeight < 700;
    if (isSmallScreen) {
      widthScale = widthScale * 0.85;
      heightScale = heightScale * 0.75;
    }
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0 * heightScale, horizontal: 0),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12 * widthScale),
        side: BorderSide(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0 * widthScale),
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
            _buildProductImage(widthScale, heightScale),
            SizedBox(width: 12 * widthScale),

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
                          style: TextStyle(
                            fontSize: 16 * widthScale,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (widget.onRemoveFromCart != null)
                        IconButton(
                          icon: Icon(Icons.close, size: 20 * widthScale),
                          onPressed: widget.onRemoveFromCart,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          iconSize: 20 * widthScale,
                        ),
                    ],
                  ),

                  // Brand
                  if (widget.brand != null)
                    Padding(
                      padding: EdgeInsets.only(top: 2 * heightScale, bottom: 4 * heightScale),
                      child: Text(
                        widget.brand!,
                        style: TextStyle(
                          fontSize: 12 * widthScale,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),

                  // Size and Color
                  Wrap(
                    spacing: 8 * widthScale,
                    runSpacing: 4 * heightScale,
                    children: [
                      if (widget.size.isNotEmpty)
                        _buildAttributeChip('${'size'.tr}: ${widget.size}', widthScale, heightScale),
                      if (widget.color.isNotEmpty)
                        _buildAttributeChip('${'color'.tr}: ${widget.color}', widthScale, heightScale),
                    ],
                  ),

                  // Price and Quantity
                  SizedBox(height: 8 * heightScale),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: _buildPriceSection(widthScale)),
                      _buildQuantitySection(widthScale, heightScale),
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
  Widget _buildPriceSection(double widthScale) {
    return Text(
      '\$${widget.price.toStringAsFixed(2)}',
      style: TextStyle(
        fontSize: 16 * widthScale,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  // Dynamically build the action buttons (like favorite and add to cart)
  Widget _buildProductImage(double widthScale, double heightScale) {
    return Container(
      width: 80 * widthScale,
      height: 80 * heightScale,
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

  Widget _buildQuantitySection(double widthScale, double heightScale) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8 * widthScale, 
        vertical: 4 * heightScale
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20 * widthScale),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrease button
          IconButton(
            icon: Icon(Icons.remove, size: 18 * widthScale),
            onPressed: _decrementQuantity,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          
          // Quantity
          Text(
            '$_quantity',
            style: TextStyle(
              fontSize: 16 * widthScale,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          // Increase button
          IconButton(
            icon: Icon(Icons.add, size: 18 * widthScale),
            onPressed: _incrementQuantity,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributeChip(String label, double widthScale, double heightScale) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8 * widthScale, vertical: 4 * heightScale),
      margin: EdgeInsets.only(right: 4 * widthScale, bottom: 4 * heightScale),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12 * widthScale),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12 * widthScale,
          color: Colors.grey[800],
        ),
      ),
    );
  }
}