// class OrderHistory {
//   final String id;
//   final String customerId;
//   final String sellerId;
//   final String orderNumber;
//   final List<OrderProduct> products;
//   final double totalPrice;
//   final double platformFee;
//   final double sellerAmount;
//   final String customerName;
//   final String email;
//   final String phoneNumber;
//   final String address;
//   final ShippingAddress shippingAddress;
//   final double shippingCost;
//   final double totalProfit;
//   final String paymentStatus;
//   final String deliveryStatus;
//   final String checkoutSessionId;
//   final String paymentIntentId;
//   final String refundId;
//   final double refundAmount;
//   final String refundReason;
//   final String trackingNumber;
//   final DateTime? estimatedDelivery;
//   final DateTime? deliveredAt;
//   final DateTime? cancelledAt;
//   final String cancelReason;
//   final String notes;

//   OrderHistory({
//     required this.id,
//     required this.customerId,
//     required this.sellerId,
//     required this.orderNumber,
//     required this.products,
//     required this.totalPrice,
//     required this.platformFee,
//     required this.sellerAmount,
//     required this.customerName,
//     required this.email,
//     required this.phoneNumber,
//     required this.address,
//     required this.shippingAddress,
//     required this.shippingCost,
//     required this.totalProfit,
//     required this.paymentStatus,
//     required this.deliveryStatus,
//     required this.checkoutSessionId,
//     required this.paymentIntentId,
//     required this.refundId,
//     required this.refundAmount,
//     required this.refundReason,
//     required this.trackingNumber,
//     this.estimatedDelivery,
//     this.deliveredAt,
//     this.cancelledAt,
//     required this.cancelReason,
//     required this.notes,
//   });

//   factory OrderHistory.fromJson(Map<String, dynamic> json) {
//     return OrderHistory(
//       id: json['_id'] as String,
//       customerId: json['customerId'] as String,
//       sellerId: json['sellerId'] as String,
//       orderNumber: json['orderNumber'] as String,
//       products: (json['products'] as List)
//           .map((product) => OrderProduct.fromJson(product))
//           .toList(),
//       totalPrice: (json['totalPrice'] as num).toDouble(),
//       platformFee: (json['platformFee'] as num).toDouble(),
//       sellerAmount: (json['sellerAmount'] as num).toDouble(),
//       customerName: json['customerName'] as String,
//       email: json['email'] as String,
//       phoneNumber: json['phoneNumber'] as String,
//       address: json['address'] as String,
//       shippingAddress: ShippingAddress.fromJson(
//           json['shippingAddress'] as Map<String, dynamic>),
//       shippingCost: (json['shippingCost'] as num).toDouble(),
//       totalProfit: (json['totalProfit'] as num).toDouble(),
//       paymentStatus: json['paymentStatus'] as String,
//       deliveryStatus: json['deliveryStatus'] as String,
//       checkoutSessionId: json['checkoutSessionId'] as String,
//       paymentIntentId: json['paymentIntentId'] as String,
//       refundId: json['refundId'] as String,
//       refundAmount: (json['refundAmount'] as num).toDouble(),
//       refundReason: json['refundReason'] as String,
//       trackingNumber: json['trackingNumber'] as String,
//       estimatedDelivery: json['estimatedDelivery'] != null
//           ? DateTime.parse(json['estimatedDelivery'] as String)
//           : null,
//       deliveredAt: json['deliveredAt'] != null
//           ? DateTime.parse(json['deliveredAt'] as String)
//           : null,
//       cancelledAt: json['cancelledAt'] != null
//           ? DateTime.parse(json['cancelledAt'] as String)
//           : null,
//       cancelReason: json['cancelReason'] as String,
//       notes: json['notes'] as String,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'customerId': customerId,
//       'sellerId': sellerId,
//       'orderNumber': orderNumber,
//       'products': products.map((product) => product.toJson()).toList(),
//       'totalPrice': totalPrice,
//       'platformFee': platformFee,
//       'sellerAmount': sellerAmount,
//       'customerName': customerName,
//       'email': email,
//       'phoneNumber': phoneNumber,
//       'address': address,
//       'shippingAddress': shippingAddress.toJson(),
//       'shippingCost': shippingCost,
//       'totalProfit': totalProfit,
//       'paymentStatus': paymentStatus,
//       'deliveryStatus': deliveryStatus,
//       'checkoutSessionId': checkoutSessionId,
//       'paymentIntentId': paymentIntentId,
//       'refundId': refundId,
//       'refundAmount': refundAmount,
//       'refundReason': refundReason,
//       'trackingNumber': trackingNumber,
//       'estimatedDelivery': estimatedDelivery?.toIso8601String(),
//       'deliveredAt': deliveredAt?.toIso8601String(),
//       'cancelledAt': cancelledAt?.toIso8601String(),
//       'cancelReason': cancelReason,
//       'notes': notes,
//     };
//   }
// }

// class OrderProduct {
//   final String productId;
//   final String sellerId;
//   final String productName;
//   final String size;
//   final String color;
//   final int quantity;
//   final double price;
//   final double discount;
//   final double totalPrice;
//   final double profit;
//   final double totalProfit;

//   OrderProduct({
//     required this.productId,
//     required this.sellerId,
//     required this.productName,
//     required this.size,
//     required this.color,
//     required this.quantity,
//     required this.price,
//     required this.discount,
//     required this.totalPrice,
//     required this.profit,
//     required this.totalProfit,
//   });

//   factory OrderProduct.fromJson(Map<String, dynamic> json) {
//     return OrderProduct(
//       productId: json['productId'] is Map
//           ? json['productId']['_id'] as String
//           : json['productId'] as String,
//       sellerId: json['sellerId'] as String,
//       productName: json['productName'] as String,
//       size: json['size'] as String,
//       color: json['color'] as String,
//       quantity: json['quantity'] as int,
//       price: (json['price'] as num).toDouble(),
//       discount: (json['discount'] as num).toDouble(),
//       totalPrice: (json['totalPrice'] as num).toDouble(),
//       profit: (json['profit'] as num).toDouble(),
//       totalProfit: (json['totalProfit'] as num).toDouble(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'productId': {'_id': productId},
//       'sellerId': sellerId,
//       'productName': productName,
//       'size': size,
//       'color': color,
//       'quantity': quantity,
//       'price': price,
//       'discount': discount,
//       'totalPrice': totalPrice,
//       'profit': profit,
//       'totalProfit': totalProfit,
//     };
//   }
// }

// class ShippingAddress {
//   final String line1;
//   final String line2;
//   final String city;
//   final String postalCode;
//   final String country;

//   ShippingAddress({
//     required this.line1,
//     required this.line2,
//     required this.city,
//     required this.postalCode,
//     required this.country,
//   });

//   factory ShippingAddress.fromJson(Map<String, dynamic> json) {
//     return ShippingAddress(
//       line1: json['line1'] as String,
//       line2: json['line2'] as String,
//       city: json['city'] as String,
//       postalCode: json['postalCode'] as String,
//       country: json['country'] as String,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'line1': line1,
//       'line2': line2,
//       'city': city,
//       'postalCode': postalCode,
//       'country': country,
//     };
//   }

//   String get formattedAddress => '$line1, $line2, $city, $postalCode, $country';
// }
