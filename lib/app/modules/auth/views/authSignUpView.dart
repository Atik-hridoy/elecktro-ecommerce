import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F8F3),
      body: GetBuilder<AuthSignUpController>(
        builder: (controller) => Stack(
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

            // Error Message
            if (_authController.errorMessage.isNotEmpty)
              Positioned(
                bottom: 140,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    _authController.errorMessage.value,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
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
                      top: 60,
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
                              'Create Account',
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
                              'Please enter your email to continue',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF606060),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Email Input Field
                            Container(
                              width: 330,
                              height: 52,
                              margin: const EdgeInsets.only(top: 24),
                              child: TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  } else if (!GetUtils.isEmail(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                decoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xFF09B782), width: 1.5),
                                  ),
                                  hintText: 'Enter your Email',
                                  hintStyle: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF9E9E9E),
                                    fontSize: 16,
                                  ),
                                  contentPadding: EdgeInsets.only(bottom: 8),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Sign Up Button
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _authController.registerUser(_emailController.text.trim());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF09B782),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: _authController.isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),

            // Sign In Link
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: TextButton(
                onPressed: () {
                  Get.offNamed(Routes.authSignIn);
                },
                child: const Text(
                  'Already have an account? Sign In',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xFF09B782),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
