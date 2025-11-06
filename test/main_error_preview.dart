/// Temporary Main File for Error Screens Preview
/// 
/// HOW TO USE:
/// 1. Temporarily rename your current lib/main.dart to lib/main_backup.dart
/// 2. Copy this file to lib/main.dart
/// 3. Run: flutter run -d windows (or your device)
/// 4. After preview, restore lib/main_backup.dart to lib/main.dart
/// 
/// OR EASIER WAY:
/// Just run: flutter run -t test/main_error_preview.dart -d windows

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/core/widgets/error_screens/network_error_screen.dart';
import 'package:elecktro_ecommerce/app/core/widgets/error_screens/server_error_screen.dart';
import 'package:elecktro_ecommerce/app/core/widgets/error_screens/something_went_wrong_screen.dart';
import 'package:elecktro_ecommerce/app/core/widgets/error_screens/no_data_found_screen.dart';
import 'package:elecktro_ecommerce/app/core/widgets/error_screens/empty_state_screen.dart';
import 'package:elecktro_ecommerce/app/core/switching_language_facilities/my_translations.dart';

void main() {
  runApp(const ErrorScreensPreviewApp());
}

class ErrorScreensPreviewApp extends StatelessWidget {
  const ErrorScreensPreviewApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Error Screens Preview - Elecktro',
      translations: MyTranslations(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Poppins',
      ),
      home: const ErrorScreensListPage(),
    );
  }
}

class ErrorScreensListPage extends StatelessWidget {
  const ErrorScreensListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error Screens Preview'),
        backgroundColor: const Color(0xFF044D37),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              children: [
                Icon(Icons.info_outline, color: Colors.blue, size: 32),
                SizedBox(height: 8),
                Text(
                  'Error Screens Preview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Click on any card below to preview how error screens look in your app',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          _buildPreviewCard(
            context,
            title: '1. Network Error',
            description: 'Shows when there is no internet connection',
            icon: Icons.wifi_off_rounded,
            color: Colors.grey,
            onTap: () => _showPreview(
              context,
              'Network Error',
              NetworkErrorScreen(
                onRetry: () {
                  Get.back();
                  Get.snackbar(
                    'Retry Clicked',
                    'This would retry fetching data',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
              ),
            ),
          ),
          
          _buildPreviewCard(
            context,
            title: '2. Server Error',
            description: 'Shows when server returns 500, 502, 503 errors',
            icon: Icons.cloud_off_rounded,
            color: Colors.orange,
            onTap: () => _showPreview(
              context,
              'Server Error (500)',
              ServerErrorScreen(
                statusCode: 500,
                message: 'The server is experiencing issues. Please try again later.',
                onRetry: () {
                  Get.back();
                  Get.snackbar(
                    'Retry Clicked',
                    'This would retry the request',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
              ),
            ),
          ),
          
          _buildPreviewCard(
            context,
            title: '3. Something Went Wrong',
            description: 'Shows for unexpected errors with optional details',
            icon: Icons.error_outline_rounded,
            color: Colors.red,
            onTap: () => _showPreview(
              context,
              'Something Went Wrong',
              SomethingWentWrongScreen(
                message: 'Failed to load products',
                errorDetails: 'TimeoutException: Connection timeout after 30 seconds',
                onRetry: () {
                  Get.back();
                  Get.snackbar(
                    'Retry Clicked',
                    'This would retry loading products',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
              ),
            ),
          ),
          
          _buildPreviewCard(
            context,
            title: '4. No Data Found',
            description: 'Shows when search/filter returns no results',
            icon: Icons.inbox_rounded,
            color: Colors.blue,
            onTap: () => _showPreview(
              context,
              'No Data Found',
              NoDataFoundScreen(
                title: 'No Products Found',
                message: 'Try adjusting your filters or search terms',
                icon: Icons.shopping_bag_outlined,
                onAction: () {
                  Get.back();
                  Get.snackbar(
                    'Clear Filters',
                    'This would clear all filters',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
                actionButtonText: 'Clear Filters',
              ),
            ),
          ),
          
          _buildPreviewCard(
            context,
            title: '5. Empty State',
            description: 'Shows for empty cart, wishlist, orders, etc.',
            icon: Icons.shopping_bag_outlined,
            color: Colors.purple,
            onTap: () => _showPreview(
              context,
              'Empty State',
              EmptyStateScreen(
                title: 'Your Cart is Empty',
                message: 'Looks like you haven\'t added anything to your cart yet',
                icon: Icons.shopping_cart_outlined,
                onAction: () {
                  Get.back();
                  Get.snackbar(
                    'Start Shopping',
                    'This would navigate to products',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
                actionButtonText: 'Start Shopping',
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green[700]),
                    const SizedBox(width: 8),
                    const Text(
                      'All Screens Ready!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '✓ Network Error Screen\n'
                  '✓ Server Error Screen\n'
                  '✓ Something Went Wrong Screen\n'
                  '✓ No Data Found Screen\n'
                  '✓ Empty State Screen',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 36,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400], size: 28),
            ],
          ),
        ),
      ),
    );
  }

  void _showPreview(BuildContext context, String title, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(title),
            backgroundColor: const Color(0xFF044D37),
            foregroundColor: Colors.white,
          ),
          body: screen,
        ),
      ),
    );
  }
}
