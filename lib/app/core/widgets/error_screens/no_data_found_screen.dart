import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoDataFoundScreen extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback? onAction;
  final String? actionButtonText;
  final IconData? icon;

  const NoDataFoundScreen({
    Key? key,
    this.title,
    this.message,
    this.onAction,
    this.actionButtonText,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // No Data Icon
            Icon(
              icon ?? Icons.inbox_rounded,
              size: 120,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            
            // Title
            Text(
              title ?? 'no_data_found'.tr,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            
            // Message
            Text(
              message ?? 'no_data_available'.tr,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Action Button
            if (onAction != null)
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add, color: Colors.white),
                label: Text(
                  actionButtonText ?? 'add_new'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF044D37),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
