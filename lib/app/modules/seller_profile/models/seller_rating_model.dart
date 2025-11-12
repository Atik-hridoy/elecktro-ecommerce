class SellerRatingModel {
  final bool success;
  final String message;
  final SellerRatingData? data;

  SellerRatingModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory SellerRatingModel.fromJson(Map<String, dynamic> json) {
    return SellerRatingModel(
      success: json['success'] ?? true,
      message: json['message'] ?? '',
      data: json['data'] != null ? SellerRatingData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class SellerRatingData {
  final double averageRating;
  final int totalReviews;

  SellerRatingData({
    required this.averageRating,
    required this.totalReviews,
  });

  factory SellerRatingData.fromJson(Map<String, dynamic> json) {
    return SellerRatingData(
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'averageRating': averageRating,
      'totalReviews': totalReviews,
    };
  }

  // Helper method to get rating display text
  String get ratingText {
    return averageRating.toStringAsFixed(1);
  }

  // Helper method to get reviews count text
  String get reviewsText {
    if (totalReviews == 0) {
      return 'No reviews';
    } else if (totalReviews == 1) {
      return '1 review';
    } else {
      return '$totalReviews reviews';
    }
  }

  // Helper method to check if seller has good rating
  bool get hasGoodRating => averageRating >= 4.0;

  // Helper method to get rating percentage (for progress bars)
  double get ratingPercentage => (averageRating / 5.0) * 100;
}
