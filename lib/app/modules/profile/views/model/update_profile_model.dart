class UpdateProfileModelInsideApp {
  final String firstName;
  final String lastName;
  final String gender;
  final String address;
  final String phone;

  UpdateProfileModelInsideApp({
    required this.firstName,
    required this.lastName,
    this.gender = '',
    this.address = '',
    required this.phone,
  });

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'address': address,
      'phone': phone,
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
    );
  }

  // Create a copy of the model with updated fields
  UpdateProfileModelInsideApp copyWith({
    String? firstName,
    String? lastName,
    String? gender,
    String? address,
    String? phone,
  }) {
    return UpdateProfileModelInsideApp(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      phone: phone ?? this.phone,
    );
  }
}