import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elecktro_ecommerce/app/modules/auth/controllers/otpController.dart';

class OtpView extends StatefulWidget {
  final String email;
  final bool isRegistration;

  const OtpView({Key? key, required this.email, required this.isRegistration})
    : super(key: key);

  @override
  _OtpViewState createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  late final OtpController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      OtpController(email: widget.email, isRegistration: widget.isRegistration),
    );
  }

  @override
  void dispose() {
    Get.delete<OtpController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFE6F8F3),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            // Top Image - Responsive
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.02,
                ),
                child: Image.asset(
                  'assets/auth/auth1.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Form Section - Responsive
            Expanded(
              flex: 4,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth > 600 ? 48 : screenWidth * 0.06,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background Image
                        Positioned.fill(
                          child: Image.asset(
                            'assets/auth/auth2.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        // Form Content
                        Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 400,
                              maxHeight: constraints.maxHeight * 0.95,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Logo
                                  SvgPicture.asset(
                                    'assets/icons/Group 290580.svg',
                                    width: screenWidth > 600 ? 110 : 94.84,
                                    height: screenWidth > 600 ? 145 : 128.32,
                                  ),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.02,
                                  ),

                                  // Title
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'otp_verification'.tr,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: const Color(0xFF09B782),
                                        fontSize: screenWidth > 600 ? 28 : 24,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.01,
                                  ),

                                  // Subtitle
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Text(
                                        '${'enter_otp_sent'.tr}\n${controller.email}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: const Color(0xFF606060),
                                          fontSize: screenWidth > 600 ? 16 : 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.03,
                                  ),

                                  // OTP Input Fields
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: List.generate(
                                        5,
                                        (index) => Container(
                                          width: screenWidth > 600 ? 65 : 55,
                                          height: screenWidth > 600 ? 70 : 60,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE6E6E6),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color: const Color(0xFFE0E0E0),
                                              width: 1,
                                            ),
                                          ),
                                          child: TextFormField(
                                            controller: controller
                                                .otpControllers[index],
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            maxLength: 1,
                                            onChanged: (value) =>
                                                controller.onOtpChange(
                                                  index,
                                                  value,
                                                  context,
                                                ),
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

                                  // Error Message
                                  Obx(() {
                                    final errorMessage =
                                        controller.errorMessage.value;
                                    return errorMessage.isNotEmpty
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                              top: constraints.maxHeight * 0.02,
                                            ),
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

                                  SizedBox(
                                    height: constraints.maxHeight * 0.02,
                                  ),

                                  // Resend OTP
                                  Obx(() {
                                    final canResend =
                                        controller.canResend.value;
                                    final remainingTime =
                                        controller.remainingTime.value;
                                    return TextButton(
                                      onPressed: canResend
                                          ? controller.resendOtp
                                          : null,
                                      child: Text(
                                        canResend
                                            ? 'resend_otp'.tr
                                            : '${'resend_otp_in'.tr}${remainingTime}s',
                                        style: TextStyle(
                                          color: canResend
                                              ? const Color(0xFF09B782)
                                              : Colors.grey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    );
                                  }),

                                  SizedBox(
                                    height: constraints.maxHeight * 0.02,
                                  ),

                                  // Verify Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 48,
                                    child: Obx(() {
                                      final isLoading =
                                          controller.isLoading.value;
                                      return ElevatedButton(
                                        onPressed: isLoading
                                            ? null
                                            : () => controller.verifyOtp(),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF09B782,
                                          ),
                                          disabledBackgroundColor:
                                              Colors.grey[300],
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: isLoading
                                            ? const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2,
                                                    ),
                                              )
                                            : Text(
                                                'verify_otp'.tr,
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                      );
                                    }),
                                  ),

                                  SizedBox(
                                    height: constraints.maxHeight * 0.01,
                                  ),

                                  // Back to Login
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text(
                                      'back_to_login'.tr,
                                      style: const TextStyle(
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
