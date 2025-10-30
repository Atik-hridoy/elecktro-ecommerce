class CartProduct {
  final String id;
  final String productId;
  final List<String> images;
  final String size;
  final double price;
  final int quantity;
  final String color;
  final String? name;
  final String? brand;
  final double profit;

  CartProduct({
    required this.id,
    required this.productId,
    required this.images,
    required this.size,
    required this.price,
    required this.quantity,
    required this.color,
    this.name,
    this.brand,
    this.profit = 0.0,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      id: json['_id'] ?? '',
      productId: json['productId'] is String 
          ? json['productId'] 
          : (json['productId']?['_id'] ?? ''),
      images: List<String>.from(
        json['productId'] is Map 
            ? (json['productId']['images'] ?? []) 
            : []
      ),
      size: json['size'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
      color: json['color'] ?? '',
      profit: (json['profit'] ?? 0).toDouble(),
      name: json['productId'] is Map ? json['productId']['name'] : null,
      brand: json['productId'] is Map ? json['productId']['brand'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'size': size,
      'price': price,
      'quantity': quantity,
      'color': color,
      'profit': profit,
    };
  }

  CartProduct copyWith({
    String? id,
    String? productId,
    List<String>? images,
    String? size,
    double? price,
    int? quantity,
    String? color,
    String? name,
    String? brand,
    double? profit,
  }) {
    return CartProduct(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      images: images ?? this.images,
      size: size ?? this.size,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      color: color ?? this.color,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      profit: profit ?? this.profit,
    );
  }
}

class CartModel {
  final String id;
  final String userId;
  final List<CartProduct> products;
  final double totalAmount;
  final DateTime createdAt;
  final DateTime updatedAt;

  CartModel({
    required this.id,
    required this.userId,
    required this.products,
    required this.totalAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      products: (json['products'] as List? ?? [])
          .map((item) => CartProduct.fromJson(item))
          .toList(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'products': products.map((p) => p.toJson()).toList(),
      'totalAmount': totalAmount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  CartModel copyWith({
    String? id,
    String? userId,
    List<CartProduct>? products,
    double? totalAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CartModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      products: products ?? this.products,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
