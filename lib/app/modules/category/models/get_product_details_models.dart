import '../../../core/network/app_urls.dart';

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
    this.sellerId = const Seller(),
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
      id: "${json['_id'] ?? ''}",
      sellerId: json['sellerId']  != null && json['sellerId']  is Map ?  Seller.fromJson(json['sellerId'] ?? {}) : Seller(),
      category: json['category'] ?? '',
      categoryId: CategoryId.fromJson(json['categoryId'] ?? {}),
      subCategory: json['subCategory'] ?? '',
      subCategoryId: json['subCategoryId'] ?? '',
      images: json['images'] != null && json['images'] is List ? (json['images'] as List).map((e) => e.toString()).toList() : [],
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

  ProductDetailModel copyWith({
    String? id,
    Seller? sellerId,
    String? category,
    CategoryId? categoryId,
    String? subCategory,
    String? subCategoryId,
    List<String>? images,
    String? name,
    String? model,
    String? brand,
    List<String>? color,
    List<SizeType>? sizeType,
    String? specialCategory,
    String? overview,
    String? highlights,
    String? techSpecs,
    bool? isDeleted,
    String? status,
    int? totalStock,
    double? rating,
    int? reviewCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isBookmarked,
  }) {
    return ProductDetailModel(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      category: category ?? this.category,
      categoryId: categoryId ?? this.categoryId,
      subCategory: subCategory ?? this.subCategory,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      images: images ?? List<String>.from(this.images),
      name: name ?? this.name,
      model: model ?? this.model,
      brand: brand ?? this.brand,
      color: color ?? List<String>.from(this.color),
      sizeType: sizeType ?? List<SizeType>.from(this.sizeType),
      specialCategory: specialCategory ?? this.specialCategory,
      overview: overview ?? this.overview,
      highlights: highlights ?? this.highlights,
      techSpecs: techSpecs ?? this.techSpecs,
      isDeleted: isDeleted ?? this.isDeleted,
      status: status ?? this.status,
      totalStock: totalStock ?? this.totalStock,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}

class Seller {
 final String id;
 final   String? image;
 final String firstName;
 final String lastName;

 const Seller({
     this.id = "",
    this.image = "",
     this.firstName = "",
     this.lastName = "",
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    // Format image URL if it exists and is not already a full URL
    String? formattedImage;
    if (json['image'] != null && json['image'].toString().isNotEmpty) {
      final imagePath = json['image'].toString();
      if (imagePath.startsWith('http')) {
        formattedImage = imagePath;
      } else {
        // Use base image URL from AppUrls
        formattedImage = '${AppUrls.baseImageUrl}${imagePath.startsWith('/') ? imagePath.substring(1) : imagePath}';
      }
    }
    
    return Seller(
      id: json['_id'] ?? '',
      image: formattedImage,
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
