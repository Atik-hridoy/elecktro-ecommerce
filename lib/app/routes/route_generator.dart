import 'package:elecktro_ecommerce/app/modules/auth/views/authview.dart';
import 'package:elecktro_ecommerce/app/modules/cart/views/cart_view.dart';
import 'package:elecktro_ecommerce/app/modules/category/view.dart';
import 'package:elecktro_ecommerce/app/modules/checkOut/views/checkout_view.dart';
import 'package:elecktro_ecommerce/app/modules/checkOut/views/paymentCard_view.dart';
import 'package:elecktro_ecommerce/app/modules/profile/account%20options/faq/view.dart';
import 'package:elecktro_ecommerce/app/modules/home/views/home_view.dart';
import 'package:elecktro_ecommerce/app/modules/notification/notification_view.dart';
import 'package:elecktro_ecommerce/app/modules/onboarding/onboarding_view.dart';
import 'package:elecktro_ecommerce/app/modules/product_details/product_view.dart';
import 'package:elecktro_ecommerce/app/modules/profile/views/account_view.dart';
import 'package:elecktro_ecommerce/app/modules/profile/views/profile_view.dart';
import 'package:elecktro_ecommerce/app/modules/support/view.dart';
import 'package:elecktro_ecommerce/app/modules/profile/account%20options/tearms_and_conditions/view.dart';
import 'package:elecktro_ecommerce/app/modules/profile/account%20options/wishlist/view.dart';
import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:elecktro_ecommerce/app/modules/splash/splash_view.dart';

import '../modules/success/view.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case Routes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingView());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeView());
      case Routes.category:
        return MaterialPageRoute(builder: (_) => CategoryView());
      case Routes.cart:
        return MaterialPageRoute(builder: (_) => CartView());
      case Routes.profile:
        return MaterialPageRoute(builder: (_) => ProfileView());
      case Routes.productDetails:
        return MaterialPageRoute(builder: (_) => ProductDetailsView());
      case Routes.checkout:
        return MaterialPageRoute(builder: (_) => CheckoutView());
      case Routes.paymentCard:
        return MaterialPageRoute(builder: (_) => PaymentCardView());
      case Routes.success:
        return MaterialPageRoute(builder: (_) => SuccessView());
      case Routes.auth:
        return MaterialPageRoute(builder: (_) => AuthView());
      case Routes.account:
        return MaterialPageRoute(builder: (_) => AccountView());
      case Routes.notification:
        return MaterialPageRoute(builder: (_) => NotificationView());
      case Routes.wishlist:
        return MaterialPageRoute(builder: (_) => WishlistView());
      case Routes.termsAndConditions:
        return MaterialPageRoute(builder: (_) => TearmsAndConditionsView());
      case Routes.faq:
        return MaterialPageRoute(builder: (_) => FaqView());
      case Routes.support:
        return MaterialPageRoute(builder: (_) => SupportView());

      default:
        // If there is no such named route
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('Page not found'),
        ),
      );
    });
  }
}
