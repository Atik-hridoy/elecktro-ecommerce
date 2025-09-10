import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkController extends GetxController {
  // Observable variables
  final RxBool isLoading = false.obs;
  final RxList<String> workFeatures = <String>[].obs;
  final RxString selectedFeature = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadWorkFeatures();
  }
  
  @override
  void onReady() {
    super.onReady();
  }
  
  @override
  void onClose() {
    super.onClose();
  }
  
  // Private methods
  void _loadWorkFeatures() {
    isLoading.value = true;
    
    // Simulate loading work features
    Future.delayed(const Duration(seconds: 1), () {
      workFeatures.addAll([
        'Remote Work',
        'Flexible Hours',
        'Project Management',
        'Team Collaboration',
        'Time Tracking',
        'Performance Analytics',
      ]);
      isLoading.value = false;
    });
  }
  
  // Public methods
  void selectFeature(String feature) {
    selectedFeature.value = feature;
    Get.snackbar(
      'Feature Selected',
      'You selected: $feature',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void startWork() {
    // Logic to start work
    Get.snackbar(
      'Work Started',
      'Your work session has started',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void pauseWork() {
    // Logic to pause work
    Get.snackbar(
      'Work Paused',
      'Your work session has been paused',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void completeWork() {
    // Logic to complete work
    Get.dialog(
      AlertDialog(
        title: const Text('Complete Work'),
        content: const Text('Are you sure you want to mark this work as completed?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Work Completed',
                'Your work has been marked as completed',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('Complete'),
          ),
        ],
      ),
    );
  }
}
