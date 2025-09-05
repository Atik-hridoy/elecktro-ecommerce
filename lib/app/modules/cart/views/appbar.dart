import 'package:flutter/material.dart';

class RoundedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final Color textColor;
  final double elevation;
  final Color shadowColor;

  const RoundedAppBar({
    Key? key,
    required this.title,
    this.height = 60.0,
    this.borderRadius = 20.0,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.elevation = 4.0,
    this.shadowColor = const Color(0x33000000),
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2), // Shadow position
          ),
        ],
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(borderRadius),
        ),
      ),
      child: AppBar(
        title: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400, // Regular weight
          ),
        ),
        centerTitle: true,
        elevation: elevation,
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        shadowColor: Colors.transparent, // No shadow from AppBar itself
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}
