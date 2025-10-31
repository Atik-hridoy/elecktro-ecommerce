class UpdateProfileModelInsideApp {
  final String firstName;
  final String lastName;
  final String gender;
  final String address;
  final String phone;
  final String? email;
  final String? profileImage;

  UpdateProfileModelInsideApp({
    required this.firstName,
    required this.lastName,
    this.gender = '',
    this.address = '',
    required this.phone,
    this.email,
    this.profileImage,
  });

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'address': address,
      'phone': phone,
      'email': email,
      'profileImage': profileImage,
    };
  }

  // Create model from JSON
  factory UpdateProfileModelInsideApp.fromJson(Map<String, dynamic> json) {
    return UpdateProfileModelInsideApp(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      gender: json['gender'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'],
      profileImage: json['profileImage'],
    );
  }

  // Create a copy of the model with updated fields
  UpdateProfileModelInsideApp copyWith({
    String? firstName,
    String? lastName,
    String? gender,
    String? address,
    String? phone,
    String? email,
    String? profileImage,
  }) {
    return UpdateProfileModelInsideApp(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}