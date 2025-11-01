class CreateReviewModel {
  final String productId;
  final String comment;
  final int rating;

  CreateReviewModel({
    required this.productId,
    required this.comment,
    required this.rating,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'comment': comment,
      'rating': rating,
    };
  }
}

class CreateReviewResponse {
  final bool success;
  final String message;
  final int statusCode;
  final ReviewData? data;

  CreateReviewResponse({
    required this.success,
    required this.message,
    required this.statusCode,
    this.data,
  });

  factory CreateReviewResponse.fromJson(Map<String, dynamic> json) {
    return CreateReviewResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      data: json['data'] != null ? ReviewData.fromJson(json['data']) : null,
    );
  }
}

class ReviewData {
  final String userId;
  final String productId;
  final List<String>? images;
  final int rating;
  final String comment;
  final String id;
  final String createdAt;
  final String updatedAt;

  ReviewData({
    required this.userId,
    required this.productId,
    this.images,
    required this.rating,
    required this.comment,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      userId: json['userId'] ?? '',
      productId: json['productId'] ?? '',
      images: json['images'] != null 
          ? List<String>.from(json['images']) 
          : null,
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      id: json['_id'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
