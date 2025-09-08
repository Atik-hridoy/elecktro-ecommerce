import 'package:elecktro_ecommerce/app/modules/auth/bindings/bindings.dart';
import 'package:elecktro_ecommerce/app/modules/auth/views/authview.dart';
import 'package:elecktro_ecommerce/app/modules/auth/views/otpView.dart';
import 'package:elecktro_ecommerce/app/modules/cart/bindings/bindings.dart';
import 'package:elecktro_ecommerce/app/modules/cart/views/cart_view.dart';
import 'package:elecktro_ecommerce/app/modules/category/bindings.dart';
import 'package:elecktro_ecommerce/app/modules/category/view.dart';
import 'package:elecktro_ecommerce/app/modules/checkOut/bindings/checkout_binding.dart';
import 'package:elecktro_ecommerce/app/modules/checkOut/views/checkout_view.dart';
import 'package:elecktro_ecommerce/app/modules/checkOut/views/paymentCard_view.dart';
import 'package:elecktro_ecommerce/app/modules/home/bindings/home_binding.dart';
import 'package:elecktro_ecommerce/app/modules/home/views/home_view.dart';
import 'package:elecktro_ecommerce/app/modules/onboarding/onboarding_binding.dart';
import 'package:elecktro_ecommerce/app/modules/onboarding/onboarding_view.dart';
import 'package:elecktro_ecommerce/app/modules/product_details/bindings.dart';
import 'package:elecktro_ecommerce/app/modules/profile/bindings/profile_binding.dart';
import 'package:elecktro_ecommerce/app/modules/profile/views/profile_view.dart';
import 'package:elecktro_ecommerce/app/modules/splash/splash_binding.dart';
import 'package:elecktro_ecommerce/app/modules/splash/splash_view.dart';
import 'package:elecktro_ecommerce/app/modules/product_details/product_view.dart';
import 'package:get/get.dart';

import '../modules/success/bindings.dart';
import '../modules/success/view.dart';

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
    GetPage(
      name: Routes.category,
      page: () => CategoryView(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: Routes.cart,
      page: () => CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.productDetails,
      page: () => const ProductDetailsView(),
      binding: ProductDetailsBinding(),
    ),
    GetPage(
      name: Routes.checkout,
      page: () => const CheckoutView(),
      binding: CheckoutBinding(),
    ),
    GetPage(
      name: Routes.paymentCard,
      page: () => const PaymentCardView(),
      binding: CheckoutBinding(),
    ),
    GetPage(
      name: Routes.success,
      page: () => const SuccessView(),
      binding: SuccessBinding(),
    ),
    GetPage(
      name: Routes.auth,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.otp,
      page: () => const OtpView(),
      binding: AuthBinding(),
    ),

  ];
}
