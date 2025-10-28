class CategoryModel {
  final String id;
  final String name;
  final String thumbnail;
  final List<SubCategoryModel> subCategories;

  CategoryModel({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.subCategories,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      subCategories: (json['subCategory'] as List<dynamic>?)
              ?.map((sub) => SubCategoryModel.fromJson(sub))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'thumbnail': thumbnail,
      'subCategory': subCategories.map((x) => x.toJson()).toList(),
    };
  }
}

class SubCategoryModel {
  final String id;
  final String name;
  final String categoryId;
  final String thumbnail;

  SubCategoryModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.thumbnail,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      categoryId: json['categoryId'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'categoryId': categoryId,
      'thumbnail': thumbnail,
    };
  }
}