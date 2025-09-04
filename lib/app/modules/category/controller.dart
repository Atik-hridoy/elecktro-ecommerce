import 'package:get/get.dart';
import 'package:flutter/material.dart'; // Added import statement for Colors

class CategoryController extends GetxController {
  // Categories data
  final categories = <Map<String, dynamic>>[].obs;
  final filteredCategories = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with sample data
    categories.addAll([
      {'title': 'Electronics', 'bgColor': Colors.blue, 'badge': 'New', 'hasSpecial': false},
      {'title': 'Fashion', 'bgColor': Colors.pink, 'badge': 'Sale', 'hasSpecial': true},
      {'title': 'Home', 'bgColor': Colors.orange, 'badge': '', 'hasSpecial': false},
      {'title': 'Beauty', 'bgColor': Colors.purple, 'badge': '30%', 'hasSpecial': true},
      {'title': 'Sports', 'bgColor': Colors.green, 'badge': '', 'hasSpecial': false},
      {'title': 'Books', 'bgColor': Colors.brown, 'badge': '', 'hasSpecial': false},
      {'title': 'Toys', 'bgColor': Colors.red, 'badge': 'Hot', 'hasSpecial': true},
    ]);
    filteredCategories.assignAll(categories);
  }

  void searchCategories(String query) {
    if (query.isEmpty) {
      filteredCategories.assignAll(categories);
    } else {
      filteredCategories.value = categories
          .where((category) => 
              category['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}