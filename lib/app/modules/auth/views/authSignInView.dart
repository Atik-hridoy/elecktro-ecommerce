import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import '../controllers/authSignInController.dart';

class AuthSignInView extends GetView<AuthSignInController> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F8F3),
      body: Obx(() {
        final controller = Get.find<AuthSignInController>();
        return Stack(
          children: [
          // Top Image
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
          
          // Form Section
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
                    top: 40,
                    child: SingleChildScrollView(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Form(
                          key: _formKey,
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
                                'Welcome Back!',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF09B782),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Subtitle
                              const Text(
                                'Enter your email to receive OTP',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF606060),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Error Message
                              if (controller.errorMessage.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Text(
                                    controller.errorMessage.value,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),

                              // Email Input Field
                              Container(
                                width: 330,
                                height: 52,
                                margin: const EdgeInsets.only(top: 8),
                                child: TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF09B782), width: 1.5),
                                    ),
                                    hintText: 'Enter your Email',
                                    hintStyle: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Color(0xFF9E9E9E),
                                      fontSize: 16,
                                    ),
                                    contentPadding: EdgeInsets.only(bottom: 8),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!GetUtils.isEmail(value)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 15),

                              // Login Button
                              Container(
                                width: double.infinity,
                                height: 48,
                                margin: const EdgeInsets.only(top: 24, bottom: 20),
                                child: ElevatedButton(
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : () {
                                          if (_formKey.currentState!.validate()) {
                                            controller.login(_emailController.text.trim());
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF09B782),
                                    disabledBackgroundColor: Colors.grey[300],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: controller.isLoading.value
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
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

                              const SizedBox(height: 20),

                              // Sign Up Link
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Don\'t have an account? ',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Color(0xFF606060),
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.offNamed(Routes.auth);
                                    },
                                    child: const Text(
                                      'Sign Up',
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ],
        );
      }),
    );
  }
}
