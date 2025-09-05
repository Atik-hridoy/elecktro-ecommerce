import 'package:flutter/material.dart';

class CartProductCard extends StatefulWidget {
  final String productName;
  final String brand;
  final String size;
  final String color;
  final String currentPrice;
  final String? originalPrice;
  final String? imagePath;
  final Widget? productImage;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final VoidCallback? onRemoveFromCart;
  final List<PopupMenuEntry>? menuItems;
  final Color? backgroundColor;
  final double? width;
  final double? height;

  const CartProductCard({
    super.key,
    required this.productName,
    required this.brand,
    required this.size,
    required this.color,
    required this.currentPrice,
    this.originalPrice,
    this.imagePath,
    this.productImage,
    this.onTap,
    this.onAddToCart,
    this.onRemoveFromCart,
    this.menuItems,
    this.backgroundColor,
    this.width,
    this.height,
  });

  @override
  _CartProductCardState createState() => _CartProductCardState();
}

class _CartProductCardState extends State<CartProductCard> {
  int quantity = 1; // Starting quantity for the product
  bool isChecked = false; // To manage checkbox state

  // Increment quantity
  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  // Decrement quantity
  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  // Toggle the checkbox state
  void _toggleCheckbox(bool? value) {
    setState(() {
      isChecked = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.width ?? double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: IntrinsicHeight(
          child: Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? Colors.white,
              borderRadius: BorderRadius.circular(12), // More rectangular corners
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Product Image Section wrapped in a Stack
                Stack(
                  children: [
                    Container(
                      width: 100, // Slightly wider image container
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          bottomLeft: Radius.circular(6),
                        ),
                      ),
                      child: _buildProductImage(),
                    ),
                    // Checkbox over the image at the top-left (shifted closer to the edge)
                    Positioned(
                      top: 4, // Adjusted value to move the checkbox closer to the top
                      left: 4, // Adjusted value to move the checkbox closer to the left
                      child: Checkbox(
                        value: isChecked,
                        onChanged: _toggleCheckbox,
                        activeColor: Colors.grey, // Gray color for the checkbox
                        checkColor: Colors.white, // White check mark
                      ),
                    ),
                  ],
                ),

                // Product Details Section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Top row with product name and menu
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.productName,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      height: 1.5,
                                      color: Colors.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${widget.brand} / ${widget.size} / ${widget.color}',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      height: 1.5,
                                      color: Colors.grey.shade600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            // Add the 3-dot options button at the top-right corner
                            PopupMenuButton(
                              icon: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 120),
                              itemBuilder: (context) => widget.menuItems ?? [],
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Bottom section with price and actions
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Dynamically build the product image
  Widget _buildProductImage() {
  if (widget.productImage != null) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        bottomLeft: Radius.circular(12),
      ),
      child: Center( // <-- Center the image
        child: widget.productImage!,
      ),
    );
  } else if (widget.imagePath != null) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        bottomLeft: Radius.circular(12),
      ),
      child: Center( // <-- Center the image
        child: Image.asset(
          widget.imagePath!,
          fit: BoxFit.contain, // <-- Use contain to prevent cropping
          width: 60, // optional: adjust width
          height: 60, // optional: adjust height
        ),
      ),
    );
  } else {
    return const Center(
      child: Icon(
        Icons.image,
        color: Colors.grey,
        size: 32,
      ),
    );
  }
}


  // Dynamically build the price section
  Widget _buildPriceSection() {
    return Row(
      children: [
        Text(
          widget.currentPrice,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600, // Bold for price
            fontSize: 16, // Increased font size
            height: 1.5,
            letterSpacing: -0.0015,
            color: Colors.black,
          ),
        ),
        if (widget.originalPrice != null) ...[ 
          const SizedBox(width: 8),
          Text(
            widget.originalPrice!,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 14, // Increased font size
              height: 1.5,
              letterSpacing: -0.0015,
              color: Colors.red.shade400,
              decoration: TextDecoration.lineThrough,
              decorationColor: Colors.red.shade400,
            ),
          ),
        ],
      ],
    );
  }

  // Dynamically build the action buttons (like favorite and add to cart)
  Widget _buildQuantitySection() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Decrease button
          GestureDetector(
            onTap: _decrementQuantity,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.remove,
                color: Colors.black,
                size: 16,
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Quantity display
          Text(
            '$quantity',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          // Add button
          GestureDetector(
            onTap: _incrementQuantity,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
