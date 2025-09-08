import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoundedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final Color textColor;
  final double elevation;
  final Color shadowColor;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;

  const RoundedAppBar({
    super.key,
    required this.title,
    this.height = 70.0,
    this.borderRadius = 20.0,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.elevation = 4.0,
    this.shadowColor = const Color(0x33000000),
    this.showBackButton = true,
    this.onBackPressed,
    this.actions,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: AppBar(
        title: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),

        centerTitle: true,
        elevation: elevation,
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        shadowColor: shadowColor,
        automaticallyImplyLeading: false,
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: onBackPressed ?? () => Get.back(),
              )
            : null,
        actions: actions,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}
