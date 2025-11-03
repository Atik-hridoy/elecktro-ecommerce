class SellerProfileModel {
  final bool success;
  final String message;
  final SellerProfileData? data;

  SellerProfileModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory SellerProfileModel.fromJson(Map<String, dynamic> json) {
    return SellerProfileModel(
      success: json['success'] ?? true,
      message: json['message'] ?? '',
      data: json['data'] != null ? SellerProfileData.fromJson(json['data']) : null,
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

class SellerProfileData {
  final String id;
  final String registrationNo;
  final String? email;
  final String? phone;
  final String? image;
  final String? address;
  final String? shopName;
  final String firstName;
  final String lastName;

  SellerProfileData({
    required this.id,
    required this.registrationNo,
    this.email,
    this.phone,
    this.image,
    this.address,
    this.shopName,
    required this.firstName,
    required this.lastName,
  });

  factory SellerProfileData.fromJson(Map<String, dynamic> json) {
    // Format image URL if it exists and is not already a full URL
    String? formattedImage;
    if (json['image'] != null && json['image'].toString().isNotEmpty) {
      final imagePath = json['image'].toString();
      if (imagePath.startsWith('http')) {
        formattedImage = imagePath;
      } else {
        // Import AppUrls at the top: import '../../../core/network/app_urls.dart';
        const baseImageUrl = 'http://10.10.7.62:7010/';
        formattedImage = '$baseImageUrl${imagePath.startsWith('/') ? imagePath.substring(1) : imagePath}';
      }
    }
    
    return SellerProfileData(
      id: json['_id'] ?? '',
      registrationNo: json['registrationNo'] ?? '',
      email: json['email'],
      phone: json['phone'],
      image: formattedImage,
      address: json['address'],
      shopName: json['shopName'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'registrationNo': registrationNo,
      'email': email,
      'phone': phone,
      'image': image,
      'address': address,
      'shopName': shopName,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  // Helper method to get full name
  String get fullName => '$firstName $lastName'.trim();

  // Helper method to get initials
  String get initials {
    final first = firstName.isNotEmpty ? firstName[0] : '';
    final last = lastName.isNotEmpty ? lastName[0] : '';
    return '$first$last'.toUpperCase();
  }

  // Helper method to get display name (shop name or full name)
  String get displayName {
    if (shopName?.isNotEmpty ?? false) {
      return shopName!;
    }
    return fullName;
  }
}
