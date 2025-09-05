import 'package:get/get.dart';

class ProfileController extends GetxController {
  // User information
  var name = 'John Doe'.obs;
  var email = 'john.doe@example.com'.obs;
  var phone = '+1 234 567 8900'.obs;
  var address = '123 Main St, City, Country'.obs;
  var profileImage = ''.obs;
  var isEditing = false.obs;

  // Toggle edit mode
  void toggleEdit() {
    isEditing.value = !isEditing.value;
  }

  // Update profile information
  void updateProfile({
    required String newName,
    required String newEmail,
    required String newPhone,
    required String newAddress,
  }) {
    name.value = newName;
    email.value = newEmail;
    phone.value = newPhone;
    address.value = newAddress;
    isEditing.value = false;
  }

  // Update profile picture
  void updateProfileImage(String imagePath) {
    profileImage.value = imagePath;
  }
}
