import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elecktro_ecommerce/app/modules/auth/controllers/otpController.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F8F3),
      body: Stack(
        children: [
          // First Image (same as auth view)
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
          
          // Second Image with Content
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
                    top: 60,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/Group 290580.svg',
                              width: 94.84,
                              height: 128.32,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Enter OTP',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF09B782),
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                height: 32 / 24,
                                letterSpacing: 0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Please Confirm your Mobile Phone Verification',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF606060),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 21 / 14,
                                letterSpacing: 0,
                              ),
                            ),
                            const SizedBox(height: 24),
                    
                            // OTP Input Field
                            Container(
                              margin: const EdgeInsets.only(top: 24),
                              child: Form(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: List.generate(
                                    5, // Changed from 4 to 5 boxes
                                    (index) => Container(
                                      width: 55, // Slightly reduced width to fit 5 boxes
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE6E6E6), // Changed to #E6E6E6
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: const Color(0xFFE0E0E0),
                                          width: 1,
                                        ),
                                      ),
                                      child: TextFormField(
                                        controller: controller.otpControllers[index],
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        maxLength: 1,
                                        onChanged: (value) => controller.onOtpChange(index, value, context),
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        decoration: const InputDecoration(
                                          counterText: '',
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                          filled: true,
                                          fillColor: Color(0xFFE6E6E6), // Ensure the input field has the same color
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    
                            const SizedBox(height: 24),
                            
                            // Resend Code Timer
                            Obx(() => GestureDetector(
                              onTap: controller.canResend.value ? controller.resendOtp : null,
                              child: Text(
                                controller.canResend.value 
                                    ? 'Didn\'t receive code? Send again' 
                                    : 'Resend code in ${(controller.remainingTime.value ~/ 60).toString().padLeft(2, '0')}:${(controller.remainingTime.value % 60).toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: controller.canResend.value 
                                      ? const Color(0xFF09B782)
                                      : const Color(0xFF9E9E9E),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )),
                            
                            const SizedBox(height: 24),
                            
                            // Verify Button
                            Container(
                              width: 355,
                              height: 48,
                              margin: const EdgeInsets.only(top: 24),
                              child: ElevatedButton(
                                onPressed: controller.verifyOtp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF09B782),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 0),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Verify',
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