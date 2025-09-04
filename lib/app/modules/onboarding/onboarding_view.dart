import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'onboarding_controller.dart';

class OnboardingPage extends StatelessWidget {
  final Map<String, String> item;
  final Size screenSize;
  
  // Cache the SVG pictures
  final Map<String, SvgPicture> _cachedSvgs = {};

  OnboardingPage({
    Key? key,
    required this.item,
    required this.screenSize,
  }) : super(key: key) {
    // Pre-cache SVGs
    _cachedSvgs[item['image']!] = SvgPicture.asset(
      item['image']!,
      width: screenSize.width,
      fit: BoxFit.fitWidth,
      cacheColorFilter: true,
    );
    
    _cachedSvgs['assets/icons/Group 290580.svg'] = SvgPicture.asset(
      'assets/icons/Group 290580.svg',
      width: screenSize.width * 0.15,
      height: screenSize.width * 0.15,
      cacheColorFilter: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image Section
          SizedBox(
            width: screenSize.width,
            height: screenSize.height * 0.50,
            child: Stack(
              children: [
                // Background Image
                Positioned.fill(
                  child: _cachedSvgs[item['image']!] ?? const SizedBox(),
                ),
                // Overlay Image (Group 290580.svg)
                Positioned(
                  top: screenSize.height * 0.02,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: _cachedSvgs['assets/icons/Group 290580.svg'] ?? const SizedBox(),
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
      ),
    );
  }
}

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late final PageController _pageController;
  late final OnboardingController _controller = Get.find<OnboardingController>();
  late Size _screenSize;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 1.0,
      keepPage: true,
    );
    _controller.pageController = _pageController;
    
    // Set status bar color and brightness
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));
    
    // Start auto-scrolling when the view is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.startAutoScroll(_pageController);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    
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
                  controller: _pageController,
                  itemCount: OnboardingController.onboardingData.length,
                  onPageChanged: (index) {
                    _controller.currentPage.value = index;
                    _controller.startAutoScroll(_pageController);
                  },
                  physics: const PageScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  clipBehavior: Clip.none,
                  padEnds: false,
                  itemBuilder: (context, index) {
                    return OnboardingPage(
                      item: OnboardingController.onboardingData[index],
                      screenSize: _screenSize,
                    );
                  },
                ),
              ),
              
              // Page Indicator and Next Button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: GetBuilder<OnboardingController>(
                  id: 'indicator',
                  builder: (controller) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Page Indicator
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: OnboardingController.onboardingData.length,
                        effect: const WormEffect(
                          dotColor: Colors.white38,
                          activeDotColor: Colors.white,
                          dotWidth: 8,
                          dotHeight: 8,
                          spacing: 6,
                        ),
                        onDotClicked: (index) {
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                      
                      // Next/Get Started Button
                      _buildNextButton(controller),
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

  Widget _buildNextButton(OnboardingController controller) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Container(
        key: ValueKey(controller.currentPage.value),
        child: Material(
          elevation: 8,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: () {
              if (controller.currentPage.value < OnboardingController.onboardingData.length - 1) {
                controller.nextPage();
              } else {
                controller.navigateToHome();
              }
            },
            customBorder: const CircleBorder(),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: SvgPicture.asset(
                'assets/icons/onboarding/RoundArrrow.svg',
                width: 40,
                height: 40,
                cacheColorFilter: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}