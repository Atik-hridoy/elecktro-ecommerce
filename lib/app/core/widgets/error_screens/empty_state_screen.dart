import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyStateScreen extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback? onAction;
  final String? actionButtonText;
  final IconData? icon;
  final Widget? customIcon;

  const EmptyStateScreen({
    Key? key,
    this.title,
    this.message,
    this.onAction,
    this.actionButtonText,
    this.icon,
    this.customIcon,
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
            // Empty State Icon
            if (customIcon != null)
              customIcon!
            else
              Icon(
                icon ?? Icons.shopping_bag_outlined,
                size: 120,
                color: Colors.grey[300],
              ),
            const SizedBox(height: 24),
            
            // Title
            Text(
              title ?? 'empty_state'.tr,
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
              message ?? 'nothing_here_yet'.tr,
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
              ElevatedButton(
                onPressed: onAction,
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
                child: Text(
                  actionButtonText ?? 'get_started'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
