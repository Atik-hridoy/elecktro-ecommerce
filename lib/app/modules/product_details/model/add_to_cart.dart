class AddToCartModel {
  final String productId;
  final String size;
  final double price;
  final int quantity;
  final String color;
  final List<String> images; // Added images field

  AddToCartModel({
    required this.productId,
    required this.size,
    required this.price,
    required this.quantity,
    required this.color,
    this.images = const [], // Default to empty list
  });

  // Convert model to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'size': size,
      'price': price,
      'quantity': quantity,
      'color': color,
      'images': images, // Include images in JSON
    };
  }

  // Create model from JSON
  factory AddToCartModel.fromJson(Map<String, dynamic> json) {
    return AddToCartModel(
      productId: json['productId'] as String,
      size: json['size'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      color: json['color'] as String,
      images: List<String>.from(json['images'] ?? []), // Handle null case
    );
  }

  // Helper method to create a copy with some fields updated
  AddToCartModel copyWith({
    String? productId,
    String? size,
    double? price,
    int? quantity,
    String? color,
    List<String>? images,
  }) {
    return AddToCartModel(
      productId: productId ?? this.productId,
      size: size ?? this.size,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      color: color ?? this.color,
      images: images ?? this.images,
    );
  }

  @override
  String toString() {
    return 'AddToCartModel('
        'productId: $productId, '
        'size: $size, '
        'price: $price, '
        'quantity: $quantity, '
        'color: $color, '
        'images: $images)';
  }
}