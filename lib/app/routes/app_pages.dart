import 'package:elecktro_ecommerce/app/modules/home/home_binding.dart';
import 'package:elecktro_ecommerce/app/modules/home/home_view.dart';
import 'package:elecktro_ecommerce/app/modules/onboarding/onboarding_binding.dart';
import 'package:elecktro_ecommerce/app/modules/onboarding/onboarding_view.dart';
import 'package:elecktro_ecommerce/app/modules/splash/splash_binding.dart';
import 'package:elecktro_ecommerce/app/modules/splash/splash_view.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
