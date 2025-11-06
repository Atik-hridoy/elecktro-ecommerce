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
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      backgroundColor: const Color(0xFFE6F8F3),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false, // Remove bottom padding to blend with screen edge
        child: Column(
          children: [
            // Top Image - Responsive with adaptive flex
            Expanded(
              flex: isSmallScreen ? 2 : 3,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: isSmallScreen ? screenHeight * 0.01 : screenHeight * 0.02,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: screenWidth > 600 ? 500 : screenWidth * 0.9,
                          maxHeight: constraints.maxHeight * 0.85,
                        ),
                        child: Image.asset(
                          'assets/auth/auth1.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Form Section - Responsive with adaptive flex
            Expanded(
              flex: isSmallScreen ? 5 : 4,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: double.infinity,
                    color: const Color(0xFFE6F8F3), // Match scaffold background
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background Image - Full width with top curves only
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(screenWidth > 600 ? 32 : 24),
                              topRight: Radius.circular(screenWidth > 600 ? 32 : 24),
                              bottomLeft: Radius.zero,
                              bottomRight: Radius.zero,
                            ),
                            child: Image.asset(
                              'assets/auth/auth2.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        // Form Content
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth > 600 ? 48 : screenWidth * 0.06,
                            ),
                            child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 400,
                            ),
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: isSmallScreen ? 8 : 16,
                                  ),
                                  // Logo - Flexible size
                                  LayoutBuilder(
                                    builder: (context, logoConstraints) {
                                      final logoSize = isSmallScreen ? 60.0 :
                                                      screenWidth > 600 ? 110.0 : 
                                                      screenWidth > 400 ? 95.0 : 80.0;
                                      return SvgPicture.asset(
                                        'assets/icons/Group 290580.svg',
                                        width: logoSize,
                                        height: logoSize * 1.35,
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height: isSmallScreen ? 8 : 16,
                                  ),

                                  // Title
                                  Text(
                                    'otp_verification'.tr,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: const Color(0xFF09B782),
                                      fontSize: isSmallScreen ? 20 : (screenWidth > 600 ? 28 : 24),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: isSmallScreen ? 4 : 8,
                                  ),

                                  // Subtitle
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Text(
                                      '${'enter_otp_sent'.tr}\n${controller.email}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: const Color(0xFF606060),
                                        fontSize: isSmallScreen ? 12 : (screenWidth > 600 ? 16 : 14),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: isSmallScreen ? 12 : 20,
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
                                          width: isSmallScreen ? 50 : (screenWidth > 600 ? 65 : 55),
                                          height: isSmallScreen ? 52 : (screenWidth > 600 ? 70 : 60),
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
                                              top: isSmallScreen ? 8 : 12,
                                            ),
                                            child: Text(
                                              errorMessage,
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: isSmallScreen ? 12 : 14,
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink();
                                  }),

                                  SizedBox(
                                    height: isSmallScreen ? 8 : 12,
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
                                    height: isSmallScreen ? 12 : 16,
                                  ),

                                  // Verify Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: isSmallScreen ? 44 : 48,
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
                                  SizedBox(
                                    height: isSmallScreen ? 8 : 16,
                                  ),
                                ],
                              ),
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
