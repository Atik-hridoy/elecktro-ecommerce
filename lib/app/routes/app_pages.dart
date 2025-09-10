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
import 'package:elecktro_ecommerce/app/modules/notification/bindings.dart';
import 'package:elecktro_ecommerce/app/modules/notification/notification_view.dart';
import 'package:elecktro_ecommerce/app/modules/onboarding/onboarding_binding.dart';
import 'package:elecktro_ecommerce/app/modules/onboarding/onboarding_view.dart';
import 'package:elecktro_ecommerce/app/modules/profile/account%20options/order_history/bindings.dart';
import 'package:elecktro_ecommerce/app/modules/profile/account%20options/order_history/history_view.dart';
import 'package:elecktro_ecommerce/app/modules/product_details/bindings.dart';
import 'package:elecktro_ecommerce/app/modules/profile/bindings/profile_binding.dart';
import 'package:elecktro_ecommerce/app/modules/profile/views/account_view.dart';
import 'package:elecktro_ecommerce/app/modules/profile/views/profile_view.dart';
import 'package:elecktro_ecommerce/app/modules/splash/splash_binding.dart';
import 'package:elecktro_ecommerce/app/modules/splash/splash_view.dart';
import 'package:elecktro_ecommerce/app/modules/product_details/product_view.dart';
import 'package:elecktro_ecommerce/app/modules/profile/account%20options/wishlist/bindlings.dart';
import 'package:elecktro_ecommerce/app/modules/profile/account%20options/wishlist/view.dart';
import 'package:elecktro_ecommerce/app/modules/profile/account%20options/account_settings/view.dart';
import 'package:elecktro_ecommerce/app/modules/profile/account%20options/account_settings/binding.dart';
import 'package:elecktro_ecommerce/app/modules/about/view.dart';
import 'package:elecktro_ecommerce/app/modules/about/binding.dart';
import 'package:elecktro_ecommerce/app/modules/profile/account%20options/work/view.dart';
import 'package:elecktro_ecommerce/app/modules/profile/account%20options/work/binding.dart';
import 'package:elecktro_ecommerce/app/modules/frequently/view.dart';
import 'package:elecktro_ecommerce/app/modules/frequently/binding.dart';
import 'package:elecktro_ecommerce/app/modules/profile/account%20options/tearms_and_conditions/view.dart';
import 'package:elecktro_ecommerce/app/modules/profile/account%20options/tearms_and_conditions/binding.dart';
import 'package:elecktro_ecommerce/app/modules/profile/account%20options/faq/view.dart';
import 'package:elecktro_ecommerce/app/modules/profile/account%20options/faq/binding.dart';
import 'package:elecktro_ecommerce/app/modules/support/view.dart';
import 'package:elecktro_ecommerce/app/modules/support/binding.dart';
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
    GetPage(
      name: Routes.account,
      page: () => AccountView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.history,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: Routes.notification,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: Routes.wishlist,
      page: () => const WishlistView(),
      binding: WishlistBinding(),
    ),
    GetPage(
      name: Routes.accountSettings,
      page: () => const AccountSettingsView(),
      binding: AccountSettingsBinding(),
    ),
    GetPage(
      name: Routes.about,
      page: () => const AboutView(),
      binding: AboutBinding(),
    ),
    GetPage(
      name: Routes.work,
      page: () => const WorkView(),
      binding: WorkBinding(),
    ),
    GetPage(
      name: Routes.frequently,
      page: () => const FrequentlyView(),
      binding: FrequentlyBinding(),
    ),
    GetPage(
      name: Routes.termsAndConditions,
      page: () => const TearmsAndConditionsView(),
      binding: TearmsAndConditionsBinding(),
    ),
    GetPage(
      name: Routes.faq,
      page: () => const FaqView(),
      binding: FaqBinding(),
    ),
    GetPage(
      name: Routes.support,
      page: () => const SupportView(),
      binding: SupportBinding(),
    ),

  ];
}
