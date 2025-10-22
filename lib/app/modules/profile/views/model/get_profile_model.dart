class GetProfileModel {
  final bool success;
  final String message;
  final int statusCode;
  final ProfileData data;

  GetProfileModel({
    required this.success,
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory GetProfileModel.fromJson(Map<String, dynamic> json) {
    return GetProfileModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      statusCode: json['statusCode'] as int,
      data: ProfileData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class ProfileData {
  final String firstName;
  final String lastName;
  final String registrationNo;
  final String gender;
  final String address;

  ProfileData({
    required this.firstName,
    required this.lastName,
    required this.registrationNo,
    required this.gender,
    required this.address,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      registrationNo: json['registrationNo'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      address: json['address'] as String? ?? '',
    );
  }
}
