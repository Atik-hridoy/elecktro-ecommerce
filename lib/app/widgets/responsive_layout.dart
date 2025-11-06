import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  
  const ResponsiveLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Simple wrapper without ResponsiveBreakpoints to avoid unmounted widget errors
    return child;
  }
}
