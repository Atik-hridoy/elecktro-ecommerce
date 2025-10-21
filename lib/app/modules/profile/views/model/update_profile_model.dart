class UpdateProfileModel {
  final String firstName;
  final String lastName;
  final String gender;
  final String address;

  UpdateProfileModel({
    required this.firstName,
    required this.lastName,
    this.gender = '',
    this.address = '',
  });

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'address': address,
    };
  }

  // Create model from JSON
  factory UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileModel(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      gender: json['gender'] ?? '',
      address: json['address'] ?? '',
    );
  }

  // Create a copy of the model with updated fields
  UpdateProfileModel copyWith({
    String? firstName,
    String? lastName,
    String? gender,
    String? address,
  }) {
    return UpdateProfileModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      address: address ?? this.address,
    );
  }
}