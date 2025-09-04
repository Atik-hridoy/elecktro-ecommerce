import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'onboarding_controller.dart';

class OnboardingPage extends StatelessWidget {
  final Map<String, String> item;
  final Size screenSize;

  const OnboardingPage({
    Key? key,
    required this.item,
    required this.screenSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Image Section
        Container(
          width: screenSize.width,
          height: screenSize.height * 0.50,
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: SvgPicture.asset(
                  item['image']!,
                  width: screenSize.width,
                  fit: BoxFit.fitWidth,
                ),
              ),
              // Overlay Image (Group 290580.svg)
              Positioned(
                top: screenSize.height * 0.02,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset(
                    'assets/icons/Group 290580.svg',
                    width: screenSize.width * 0.15,
                    height: screenSize.width * 0.15,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Title and Subtitle
        const SizedBox(height: 130),
        Text(
          item['title']!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            height: 1.0,
            letterSpacing: 0.0,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            item['subtitle']!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.normal,
              fontFamily: 'Poppins',
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final pageController = PageController(
      viewportFraction: 1.0,
      keepPage: true,
    );
    
    // Cache the page controller
    controller.pageController = pageController;
    
    // Set status bar color and brightness
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));
    
    // Start auto-scrolling when the view is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.startAutoScroll(pageController);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: const Color(0xFF09B782),
        child: SafeArea(
          bottom: true,
          child: Column(
            children: [
              // PageView for onboarding screens
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: controller.onboardingData.length,
                  onPageChanged: (index) {
                    controller.currentPage.value = index;
                    controller.startAutoScroll(pageController);
                  },
                  physics: const PageScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  clipBehavior: Clip.none,
                  padEnds: false,
                  itemBuilder: (context, index) {
                    return OnboardingPage(
                      item: controller.onboardingData[index],
                      screenSize: screenSize,
                    );
                  },
                ),
              ),
              
              // Page Indicator and Next Button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: GetBuilder<OnboardingController>(
                  builder: (controller) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Page Indicator
                      SmoothPageIndicator(
                        controller: pageController,
                        count: controller.onboardingData.length,
                        effect: const WormEffect(
                          dotColor: Colors.white38,
                          activeDotColor: Colors.white,
                          dotWidth: 8,
                          dotHeight: 8,
                          spacing: 6,
                        ),
                        onDotClicked: (index) {
                          pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                      
                      // Next/Get Started Button
                      GestureDetector(
                        onTap: () {
                          if (controller.currentPage.value < controller.onboardingData.length - 1) {
                            controller.nextPage();
                          } else {
                            controller.navigateToHome();
                          }
                        },
                        child: Material(
                          elevation: 8,
                          shape: const CircleBorder(),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/onboarding/RoundArrrow.svg',
                              width: 70,
                              height: 70,
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
        ),
      ),
    );
  }
}