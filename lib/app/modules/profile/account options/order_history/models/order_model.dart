class OrderModel {
  final String id;
  final String orderNumber;
  final String customerId;
  final String sellerId;
  final List<OrderProduct> products;
  final double totalPrice;
  final String paymentStatus;
  final String deliveryStatus;
  final String? address;
  final String? phoneNumber;
  final String? email;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.customerId,
    required this.sellerId,
    required this.products,
    required this.totalPrice,
    required this.paymentStatus,
    required this.deliveryStatus,
    this.address,
    this.phoneNumber,
    this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'],
      orderNumber: json['orderNumber'],
      customerId: json['customerId'],
      sellerId: json['sellerId'],
      products: (json['products'] as List)
          .map((product) => OrderProduct.fromJson(product))
          .toList(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      paymentStatus: json['paymentStatus'],
      deliveryStatus: json['deliveryStatus'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class OrderProduct {
  final String productId;
  final String sellerId;
  final String productName;
  final String size;
  final String color;
  final int quantity;
  final double price;
  final double discount;
  final double totalPrice;

  OrderProduct({
    required this.productId,
    required this.sellerId,
    required this.productName,
    required this.size,
    required this.color,
    required this.quantity,
    required this.price,
    required this.discount,
    required this.totalPrice,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      productId: json['productId'] is String 
          ? json['productId'] 
          : json['productId']?['_id'] ?? '',
      sellerId: json['sellerId'],
      productName: json['productName'],
      size: json['size'] ?? '',
      color: json['color'] ?? '',
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );
  }
}

class OrderResponse {
  final List<OrderModel> orders;
  final int page;
  final int limit;
  final int total;
  final int totalPage;

  OrderResponse({
    required this.orders,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPage,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return OrderResponse(
      orders: (data['orders'] as List?)
              ?.map((order) => OrderModel.fromJson(order))
              .toList() ??
          const <OrderModel>[],
      page: data['pagination']?['page'] ?? 1,
      limit: data['pagination']?['limit'] ?? 10,
      total: data['pagination']?['total'] ?? 0,
      totalPage: data['pagination']?['totalPage'] ?? 1,
    );
  }
}
