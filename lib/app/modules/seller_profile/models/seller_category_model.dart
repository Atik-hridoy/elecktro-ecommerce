class SellerCategoriesModel {
  final bool success;
  final String message;
  final List<SellerCategory>? data;

  SellerCategoriesModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory SellerCategoriesModel.fromJson(Map<String, dynamic> json) {
    return SellerCategoriesModel(
      success: json['success'] ?? true,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => SellerCategory.fromJson(item))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.map((cat) => cat.toJson()).toList(),
    };
  }
}

class SellerCategory {
  final String id;
  final String name;
  final String? thumbnail;

  SellerCategory({
    required this.id,
    required this.name,
    this.thumbnail,
  });

  factory SellerCategory.fromJson(Map<String, dynamic> json) {
    // Format thumbnail URL if it exists and is not already a full URL
    String? formattedThumbnail;
    if (json['thumbnail'] != null && json['thumbnail'].toString().isNotEmpty) {
      final thumbnailPath = json['thumbnail'].toString();
      if (thumbnailPath.startsWith('http')) {
        formattedThumbnail = thumbnailPath;
      } else {
        const baseImageUrl = 'http://10.10.7.62:7010/';
        formattedThumbnail = '$baseImageUrl${thumbnailPath.startsWith('/') ? thumbnailPath.substring(1) : thumbnailPath}';
      }
    }
    
    return SellerCategory(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      thumbnail: formattedThumbnail,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'thumbnail': thumbnail,
    };
  }
}
