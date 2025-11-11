import 'package:elecktro_ecommerce/app/core/navigation/navigation_service.dart';
import 'package:elecktro_ecommerce/app/core/switching_language_facilities/my_translations.dart';
import 'package:elecktro_ecommerce/app/modules/auth/controllers/authSignInController.dart';
import 'package:elecktro_ecommerce/app/modules/home/controllers/home_controller.dart';
import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import 'package:elecktro_ecommerce/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'app/providers/language_provider.dart';
import 'app/theme/app_theme.dart';
import 'app/widgets/responsive_layout.dart';
import 'app/core/socket_facility/notification_overlay.dart';
import 'app/core/socket_facility/socket_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage
  await GetStorage.init();

  // Initialize socket from stored credentials (if user is logged in)
  await SocketInitializer.initializeFromStorage();

  // Register HTTP client
  Get.put(Dio());

  // Initialize controllers
  Get.put(HomeController());
  Get.put(AuthSignInController());
  
  // Initialize services
  await Get.putAsync(() => NavigationService.init());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), 
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return ChangeNotifierProvider(
          create: (_) => LanguageProvider(),
          child: Consumer<LanguageProvider>(
            builder: (context, languageProvider, _) {
              return GetMaterialApp(
            title: 'Elecktro',
            debugShowCheckedModeBanner: false,
            
            // Add this for global notification snackbars
            scaffoldMessengerKey: NotificationOverlay().scaffoldMessengerKey,
            
            locale: languageProvider.locale,
            
            // GetX Translations
            translations: MyTranslations(),
            fallbackLocale: const Locale('en', 'US'),
            
            theme: AppTheme.lightTheme.copyWith(
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                },
              ),
            ),
            
            // Localization
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'US'), // English
              Locale('es', 'ES'), // Spanish
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              if (supportedLocales.contains(locale)) {
                return locale;
              }
              return const Locale('en', 'US');
            },
            
            // Responsive framework
            builder: (context, child) => ResponsiveLayout(
              child: Directionality(
                textDirection: languageProvider.isRTL() 
                    ? TextDirection.rtl 
                    : TextDirection.ltr,
                child: child!,
              ),
            ),
            
            // Routes - No transitions
            initialRoute: AppPages.initial,
            getPages: AppPages.routes,
            defaultTransition: Transition.noTransition,
            transitionDuration: Duration.zero,
              );
            },
          ),
        );
      },
    );
  }
}