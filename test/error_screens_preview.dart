import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/core/widgets/error_screens/network_error_screen.dart';
import 'package:elecktro_ecommerce/app/core/widgets/error_screens/server_error_screen.dart';
import 'package:elecktro_ecommerce/app/core/widgets/error_screens/something_went_wrong_screen.dart';
import 'package:elecktro_ecommerce/app/core/widgets/error_screens/no_data_found_screen.dart';
import 'package:elecktro_ecommerce/app/core/widgets/error_screens/empty_state_screen.dart';
import 'package:elecktro_ecommerce/app/core/switching_language_facilities/my_translations.dart';

/// Error Screens Preview
/// 
/// This is a demo page to preview all error screens
/// Run this file to see how error screens look
/// 
/// To run: Create a temporary main.dart that uses this widget
void main() {
  runApp(const ErrorScreensPreviewApp());
}

class ErrorScreensPreviewApp extends StatelessWidget {
  const ErrorScreensPreviewApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Error Screens Preview',
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
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Click on any card to preview the error screen',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          
          _buildPreviewCard(
            context,
            title: 'Network Error',
            description: 'Shows when there is no internet connection',
            icon: Icons.wifi_off_rounded,
            color: Colors.grey,
            onTap: () => _showPreview(
              context,
              'Network Error',
              NetworkErrorScreen(
                onRetry: () {
                  Get.back();
                  Get.snackbar('Retry', 'Retry button clicked');
                },
              ),
            ),
          ),
          
          _buildPreviewCard(
            context,
            title: 'Server Error',
            description: 'Shows when server is not responding (500, 502, 503)',
            icon: Icons.cloud_off_rounded,
            color: Colors.orange,
            onTap: () => _showPreview(
              context,
              'Server Error',
              ServerErrorScreen(
                statusCode: 500,
                onRetry: () {
                  Get.back();
                  Get.snackbar('Retry', 'Retry button clicked');
                },
              ),
            ),
          ),
          
          _buildPreviewCard(
            context,
            title: 'Something Went Wrong',
            description: 'Shows for unexpected errors',
            icon: Icons.error_outline_rounded,
            color: Colors.red,
            onTap: () => _showPreview(
              context,
              'Something Went Wrong',
              SomethingWentWrongScreen(
                message: 'Failed to load data',
                errorDetails: 'Error: Timeout exception',
                onRetry: () {
                  Get.back();
                  Get.snackbar('Retry', 'Retry button clicked');
                },
              ),
            ),
          ),
          
          _buildPreviewCard(
            context,
            title: 'No Data Found',
            description: 'Shows when no data is available',
            icon: Icons.inbox_rounded,
            color: Colors.blue,
            onTap: () => _showPreview(
              context,
              'No Data Found',
              NoDataFoundScreen(
                title: 'No Products Found',
                message: 'Try adjusting your filters or search terms',
                onAction: () {
                  Get.back();
                  Get.snackbar('Action', 'Action button clicked');
                },
                actionButtonText: 'Clear Filters',
              ),
            ),
          ),
          
          _buildPreviewCard(
            context,
            title: 'Empty State',
            description: 'Shows for empty lists (cart, wishlist, etc.)',
            icon: Icons.shopping_bag_outlined,
            color: Colors.purple,
            onTap: () => _showPreview(
              context,
              'Empty State',
              EmptyStateScreen(
                title: 'Your Cart is Empty',
                message: 'Add some products to get started',
                onAction: () {
                  Get.back();
                  Get.snackbar('Action', 'Get Started clicked');
                },
                actionButtonText: 'Start Shopping',
              ),
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
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
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
          ),
          body: screen,
        ),
      ),
    );
  }
}
