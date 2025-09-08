import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/modules/auth/controllers/authController.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F8F3),
      body: Stack(
        children: [
          // First Image
          Positioned(
            top: 65,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/auth/auth1.png',
                width: 366,
                height: 292,
                fit: BoxFit.contain,
              ),
            ),
          ),
          
          // Second Image
          Positioned(
            top: 360.5,
            left: 0,
            right: 0,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/auth/auth2.png',
                    width: 525,
                    height: 658.2,
                    fit: BoxFit.contain,
                  ),
                  Positioned(
                    top: 60,  // Adjust this value to position the SVG vertically
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/Group 290580.svg',
                          width: 94.84,
                          height: 128.32,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 16), // Space between SVG and text
                        const Text(
                          'Welcome Back!',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xFF09B782),
                            fontSize: 24,
                            fontWeight: FontWeight.w600, // SemiBold
                            height: 32 / 24, // line-height / font-size
                            letterSpacing: 0,
                          ),
                        ),
                        const SizedBox(height: 8), // Space between title and subtitle
                        const Text(
                          'Please Confirm your Mobile Phone Verification',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xFF606060),
                            fontSize: 14,
                            fontWeight: FontWeight.w400, // Regular
                            height: 21 / 14, // line-height / font-size
                            letterSpacing: 0,
                          ),
                        ),
                        const SizedBox(height: 24), // Space before phone input
                        Container(
                          width: 330, // Specified width
                          height: 52, // Specified height
                          margin: const EdgeInsets.only(top: 24), // Position from top (543px - 519px from previous elements)
                          child: TextField(
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF09B782), width: 1.5),
                              ),
                              hintText: 'Enter your Phone No.',
                              hintStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF9E9E9E),
                                fontSize: 16,
                              ),
                              contentPadding: const EdgeInsets.only(bottom: 8), // Adjust text position within the field
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        const SizedBox(height: 15), // Space between input and button
                        Container(
                          width: 355,
                          height: 48,
                          margin: const EdgeInsets.only(top: 24), // Position from top (619px - 595px from previous elements)
                          child: ElevatedButton(
                            onPressed: () {
                              Get.toNamed(Routes.otp);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF09B782),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 0),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Send OTP',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
