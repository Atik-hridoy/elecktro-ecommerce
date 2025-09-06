import 'package:flutter/material.dart';

class CheckoutConstants {
  // Colors
  static const Color primaryColor = Color(0xFF4CAF50);
  static const Color secondaryColor = Color(0xFFFFC107);
  static const Color errorColor = Color(0xFFE53935);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color dividerColor = Color(0xFFE0E0E0);
  
  // Text Styles
  static const TextStyle titleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );
  
  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 14,
    color: textSecondary,
  );
  
  static const TextStyle priceStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );
  
  // Sizes
  static const double defaultPadding = 16.0;
  static const double cardRadius = 12.0;
  static const double buttonHeight = 56.0;
  
  // Default values
  static const String defaultCurrency = '\$';
  static const String defaultVatText = 'VAT included';
  static const String defaultNoteText = 'N/A';
}
