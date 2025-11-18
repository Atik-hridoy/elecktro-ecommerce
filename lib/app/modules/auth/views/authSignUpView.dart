import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import '../controllers/authSignUpController.dart';

class AuthSignUpView extends StatefulWidget {
  const AuthSignUpView({super.key});

  @override
  State<AuthSignUpView> createState() => _AuthSignUpViewState();
}

class _AuthSignUpViewState extends State<AuthSignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final AuthSignUpController _authController = Get.find();

  @override
  void dispose() {
    _emailController.dispose();
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
        bottom: false,
        child: GetBuilder<AuthSignUpController>(
          builder: (controller) => Column(
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
                      color: const Color(0xFFE6F8F3),
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
                                  child: Form(
                                    key: _formKey,
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
                                          return Image.asset(
                                            'assets/icons/sundor logo.png',
                                            width: logoSize,
                                            height: logoSize * 1.35,
                                            fit: BoxFit.contain,
                                          );
                                        },
                                      ),
                                      SizedBox(
                                        height: isSmallScreen ? 8 : 16,
                                      ),

                                      // Title
                                      Text(
                                        'create_account'.tr,
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
                                      Text(
                                        'enter_email_continue'.tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: const Color(0xFF606060),
                                          fontSize: isSmallScreen ? 12 : (screenWidth > 600 ? 16 : 14),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(
                                        height: isSmallScreen ? 12 : 20,
                                      ),

                                      // Error Message
                                      Obx(() {
                                        if (_authController
                                            .errorMessage
                                            .isNotEmpty) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              bottom: isSmallScreen ? 8 : 12,
                                            ),
                                            child: Text(
                                              _authController.errorMessage.value,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: isSmallScreen ? 12 : 14,
                                              ),
                                            ),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      }),

                                    // Email Input Field
                                    TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'please_enter_email'.tr;
                                        } else if (!GetUtils.isEmail(value)) {
                                          return 'please_enter_valid_email'.tr;
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                      decoration: InputDecoration(
                                        enabledBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFFE0E0E0),
                                          ),
                                        ),
                                        focusedBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFF09B782),
                                            width: 1.5,
                                          ),
                                        ),
                                        hintText: 'enter_your_email'.tr,
                                        hintStyle: const TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Color(0xFF9E9E9E),
                                          fontSize: 16,
                                        ),
                                        contentPadding: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                      ),
                                      ),
                                      SizedBox(
                                        height: isSmallScreen ? 16 : 24,
                                      ),

                                      // Sign Up Button
                                      Obx(
                                        () => SizedBox(
                                          width: double.infinity,
                                          height: isSmallScreen ? 44 : 48,
                                        child: ElevatedButton(
                                          onPressed:
                                              _authController.isLoading.value
                                              ? null
                                              : () {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    _authController
                                                        .registerUser(
                                                          _emailController.text
                                                              .trim(),
                                                        );
                                                  }
                                                },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFF09B782,
                                            ),
                                            disabledBackgroundColor:
                                                Colors.grey[300],
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            elevation: 0,
                                          ),
                                          child: _authController.isLoading.value
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
                                                  'sign_up'.tr,
                                                  style: const TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(
                                        height: isSmallScreen ? 12 : 16,
                                      ),

                                      // Sign In Link
                                      TextButton(
                                        onPressed: () {
                                          Get.offNamed(Routes.authSignIn);
                                        },
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          minimumSize: Size.zero,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: Text(
                                          'already_have_account'.tr,
                                          textAlign: TextAlign.center,
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
      ),
    );
  }
}
