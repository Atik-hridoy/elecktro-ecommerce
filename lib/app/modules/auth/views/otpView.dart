import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elecktro_ecommerce/app/modules/auth/controllers/otpController.dart';

class OtpView extends GetView<OtpController> {
  final String email;
  
  const OtpView({super.key, required this.email});
  
  @override
  OtpController get controller => Get.put(OtpController(email: email), permanent: true);

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
                            // Logo
                            SvgPicture.asset(
                              'assets/icons/Group 290580.svg',
                              width: 94.84,
                              height: 128.32,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 16),

                            // Title
                            const Text(
                              'OTP Verification',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF09B782),
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Subtitle
                            Text(
                              'Enter the OTP sent to your email\n$email',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF606060),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
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
                                    5, // 5 OTP digits
                                    (index) => Container(
                                      width: 55,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE6E6E6),
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
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        decoration: const InputDecoration(
                                          counterText: '',
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Error Message
                            Obx(() {
                              final errorMessage = controller.errorMessage.value;
                              return errorMessage.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Text(
                                        errorMessage,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink();
                            }),

                            // Resend OTP
                            Obx(() {
                              final canResend = controller.canResend.value;
                              final remainingTime = controller.remainingTime.value;
                              return TextButton(
                                onPressed: canResend ? controller.resendOtp : null,
                                child: Text(
                                  canResend ? 'Resend OTP' : 'Resend OTP in ${remainingTime}s',
                                  style: TextStyle(
                                    color: canResend ? const Color(0xFF09B782) : Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }),

                            // Verify Button
                            Container(
                              width: double.infinity,
                              height: 48,
                              margin: const EdgeInsets.only(top: 24, bottom: 20),
                              child: Obx(() {
                                final isLoading = controller.isLoading.value;
                                return ElevatedButton(
                                  onPressed: isLoading ? null : () => controller.verifyOtp(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF09B782),
                                    disabledBackgroundColor: Colors.grey[300],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          'Verify OTP',
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                );
                              },
                            ),
                            ),

                            // Back to Login
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text(
                                'Back to Login',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF09B782),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
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