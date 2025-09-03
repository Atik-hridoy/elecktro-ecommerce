import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'splash_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late final SplashController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SplashController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Centered app logo
          Center(
            child: Opacity(
              opacity: 1.0,
              child: SvgPicture.asset(
                'assets/icons/Group 290580.svg',
                width: 154.33,
                height: 192.29,
                placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(),
              ),
            ),
          ),
          // Loading indicator at the bottom center
          Positioned(
            bottom: 50.0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const SpinKitRipple(
                  color: Colors.green,
                  size: 80.0,
                  borderWidth: 4.0,
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Data is Loading',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0,
                    height: 1.0,  // 100% line-height
                    letterSpacing: 0.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}