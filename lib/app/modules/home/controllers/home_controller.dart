import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/routes/app_pages.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs; // Observable variable for the selected index
  var categories = [
    {
      'title': 'Best Offers',
      'bgColor': Colors.red,
      'badge': 'SPECIAL\nUP TO',
      'hasSpecial': true,
    },
    {
      'title': 'Computers',
      'bgColor': Colors.grey.shade300,
      'badge': '',
      'hasSpecial': false,
    },
    {
      'title': 'Phones',
      'bgColor': Colors.grey.shade300,
      'badge': '',
      'hasSpecial': false,
    },
    {
      'title': 'Server Tools',
      'bgColor': Colors.grey.shade300,
      'badge': '',
      'hasSpecial': false,
    },
    {
      'title': 'Accessories',
      'bgColor': Colors.grey.shade300,
      'badge': '',
      'hasSpecial': false,
    },
  ].obs;

  // Method to update selected index
  void updateIndex(int index) {
    if (index == 1) { // Assuming index 1 is for categories
      Get.toNamed(Routes.category);
    } else {
      selectedIndex.value = index;
    }
  }
  
}
