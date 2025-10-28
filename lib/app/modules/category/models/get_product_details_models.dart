class ProductDetailModel {
  final String id;
  final Seller sellerId;
  final String category;
  final CategoryId categoryId;
  final String subCategory;
  final String subCategoryId;
  final List<String> images;
  final String name;
  final String model;
  final String brand;
  final List<String> color;
  final List<SizeType> sizeType;
  final String specialCategory;
  final String overview;
  final String highlights;
  final String techSpecs;
  final bool isDeleted;
  final String status;
  final int totalStock;
  final double rating;
  final int reviewCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isBookmarked;

  ProductDetailModel({
    required this.id,
    required this.sellerId,
    required this.category,
    required this.categoryId,
    required this.subCategory,
    required this.subCategoryId,
    required this.images,
    required this.name,
    required this.model,
    required this.brand,
    required this.color,
    required this.sizeType,
    required this.specialCategory,
    required this.overview,
    required this.highlights,
    required this.techSpecs,
    required this.isDeleted,
    required this.status,
    required this.totalStock,
    required this.rating,
    required this.reviewCount,
    required this.createdAt,
    required this.updatedAt,
    required this.isBookmarked,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      id: json['_id'] ?? '',
      sellerId: Seller.fromJson(json['sellerId'] ?? {}),
      category: json['category'] ?? '',
      categoryId: CategoryId.fromJson(json['categoryId'] ?? {}),
      subCategory: json['subCategory'] ?? '',
      subCategoryId: json['subCategoryId'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      name: json['name'] ?? '',
      model: json['model'] ?? '',
      brand: json['brand'] ?? '',
      color: List<String>.from(json['color'] ?? []),
      sizeType: (json['sizeType'] as List<dynamic>?)
              ?.map((e) => SizeType.fromJson(e))
              .toList() ??
          [],
      specialCategory: json['specialCategory'] ?? '',
      overview: json['overview'] ?? '',
      highlights: json['highlights'] ?? '',
      techSpecs: json['techSpecs'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      status: json['status'] ?? '',
      totalStock: json['totalStock'] ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      isBookmarked: json['isBookmarked'] ?? false,
    );
  }
}

class Seller {
  String id;
  String? image;
  String firstName;
  String lastName;

  Seller({
    required this.id,
    this.image,
    required this.firstName,
    required this.lastName,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['_id'] ?? '',
      image: json['image'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
    );
  }
}

class CategoryId {
  final String id;
  final String name;
  final List<String> subCategory;
  final String thumbnail;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryId({
    required this.id,
    required this.name,
    required this.subCategory,
    required this.thumbnail,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryId.fromJson(Map<String, dynamic> json) {
    return CategoryId(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      subCategory: List<String>.from(json['subCategory'] ?? []),
      thumbnail: json['thumbnail'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}

class SizeType {
  final String size;
  final double price;
  final int quantity;
  final double discount;
  final double purchasePrice;
  final double profit;
  final String id;

  SizeType({
    required this.size,
    required this.price,
    required this.quantity,
    required this.discount,
    required this.purchasePrice,
    required this.profit,
    required this.id,
  });

  factory SizeType.fromJson(Map<String, dynamic> json) {
    return SizeType(
      size: json['size'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? 0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      purchasePrice: (json['purchasePrice'] as num?)?.toDouble() ?? 0.0,
      profit: (json['profit'] as num?)?.toDouble() ?? 0.0,
      id: json['_id'] ?? '',
    );
  }
}
