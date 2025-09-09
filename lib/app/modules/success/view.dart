import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/routes/app_pages.dart';

class SuccessView extends StatelessWidget {
  const SuccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // ElektroNic Logo and Shopping Bags (SVG)
              SvgPicture.asset(
                'assets/icons/Group 290580.svg',
                width: 200,
                height: 150,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 20),

              // ElektroNic Text


              const SizedBox(height: 40),

              // Congratulations Text
              const Text(
                'Congratulations',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),

              const SizedBox(height: 20),

              // Success Message
              const Text(
                'Your order has been successfully completed.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 30),

              // Order Details
              const Text(
                'you order 1 item with online payment, payment\namount \$20.30',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),

              const Spacer(flex: 2),

              // Buttons Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    // Back to Home Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.offAllNamed(Routes.home);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF09B782),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Back to Home',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Order History Button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Get.toNamed(Routes.orderHistory);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF09B782),
                          side: const BorderSide(color: Color(0xFF09B782)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'View Order History',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}