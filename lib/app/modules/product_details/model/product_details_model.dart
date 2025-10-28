import 'dart:convert';

ProductResponse productResponseFromJson(String str) =>
    ProductResponse.fromJson(json.decode(str));

String productResponseToJson(ProductResponse data) =>
    json.encode(data.toJson());

class ProductResponse {
  final bool? success;
  final String? message;
  final int? statusCode;
  final Product? data;

  ProductResponse({
    this.success,
    this.message,
    this.statusCode,
    this.data,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) => ProductResponse(
        success: json["success"],
        message: json["message"],
        statusCode: json["statusCode"],
        data: json["data"] != null ? Product.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "statusCode": statusCode,
        "data": data?.toJson(),
      };
}

class Product {
  final String? id;
  final String? sellerId;
  final String? category;
  final Category? categoryId;
  final String? subCategory;
  final String? subCategoryId;
  final List<String>? images;
  final String? name;
  final String? model;
  final String? brand;
  final List<String>? color;
  final List<SizeType>? sizeType;
  final String? specialCategory;
  final String? overview;
  final String? highlights;
  final String? techSpecs;
  final bool? isDeleted;
  final String? status;
  final int? totalStock;
  final int? rating;
  final int? reviewCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Product({
    this.id,
    this.sellerId,
    this.category,
    this.categoryId,
    this.subCategory,
    this.subCategoryId,
    this.images,
    this.name,
    this.model,
    this.brand,
    this.color,
    this.sizeType,
    this.specialCategory,
    this.overview,
    this.highlights,
    this.techSpecs,
    this.isDeleted,
    this.status,
    this.totalStock,
    this.rating,
    this.reviewCount,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["_id"],
        sellerId: json["sellerId"],
        category: json["category"],
        categoryId: json["categoryId"] != null
            ? Category.fromJson(json["categoryId"])
            : null,
        subCategory: json["subCategory"],
        subCategoryId: json["subCategoryId"],
        images: json["images"] != null
            ? List<String>.from(json["images"].map((x) => x))
            : [],
        name: json["name"],
        model: json["model"],
        brand: json["brand"],
        color: json["color"] != null
            ? List<String>.from(json["color"].map((x) => x))
            : [],
        sizeType: json["sizeType"] != null
            ? List<SizeType>.from(
                json["sizeType"].map((x) => SizeType.fromJson(x)))
            : [],
        specialCategory: json["specialCategory"],
        overview: json["overview"] ?? "",
        highlights: json["highlights"] ?? "",
        techSpecs: json["techSpecs"] ?? "",
        isDeleted: json["isDeleted"],
        status: json["status"],
        totalStock: json["totalStock"],
        rating: json["rating"],
        reviewCount: json["reviewCount"],
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "sellerId": sellerId,
        "category": category,
        "categoryId": categoryId?.toJson(),
        "subCategory": subCategory,
        "subCategoryId": subCategoryId,
        "images": images,
        "name": name,
        "model": model,
        "brand": brand,
        "color": color,
        "sizeType": sizeType?.map((x) => x.toJson()).toList(),
        "specialCategory": specialCategory,
        "overview": overview,
        "highlights": highlights,
        "techSpecs": techSpecs,
        "isDeleted": isDeleted,
        "status": status,
        "totalStock": totalStock,
        "rating": rating,
        "reviewCount": reviewCount,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class Category {
  final String? id;
  final String? name;
  final List<String>? subCategory;
  final String? thumbnail;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Category({
    this.id,
    this.name,
    this.subCategory,
    this.thumbnail,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"],
        name: json["name"],
        subCategory: json["subCategory"] != null
            ? List<String>.from(json["subCategory"].map((x) => x))
            : [],
        thumbnail: json["thumbnail"],
        isDeleted: json["isDeleted"],
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "subCategory": subCategory,
        "thumbnail": thumbnail,
        "isDeleted": isDeleted,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class SizeType {
  final String? size;
  final int? price;
  final int? quantity;
  final int? discount;
  final int? purchasePrice;
  final int? profit;
  final String? id;

  SizeType({
    this.size,
    this.price,
    this.quantity,
    this.discount,
    this.purchasePrice,
    this.profit,
    this.id,
  });

  factory SizeType.fromJson(Map<String, dynamic> json) => SizeType(
        size: json["size"],
        price: json["price"],
        quantity: json["quantity"],
        discount: json["discount"],
        purchasePrice: json["purchasePrice"],
        profit: json["profit"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "size": size,
        "price": price,
        "quantity": quantity,
        "discount": discount,
        "purchasePrice": purchasePrice,
        "profit": profit,
        "_id": id,
      };
}
