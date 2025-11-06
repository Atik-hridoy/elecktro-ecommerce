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
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'app/providers/language_provider.dart';
import 'app/theme/app_theme.dart';
import 'app/widgets/responsive_layout.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage
  await GetStorage.init();


  // Register HTTP client
  Get.put(Dio());

  // Initialize controllers
  Get.put(HomeController());
  Get.put(AuthSignInController());
  
  // Initialize services
  await Get.putAsync(() => NavigationService.init());
  
  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // Only enable in debug mode
      builder: (context) => const MyApp(),
    ),
  );
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
            
            // Device Preview Configuration
            useInheritedMediaQuery: true,
            locale: DevicePreview.locale(context) ?? languageProvider.locale,
            
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
            
            // Responsive framework with Device Preview
            builder: (context, child) => DevicePreview.appBuilder(
              context,
              ResponsiveBreakpoints.builder(
              child: ResponsiveLayout(
                child: Directionality(
                  textDirection: languageProvider.isRTL() 
                      ? TextDirection.rtl 
                      : TextDirection.ltr,
                  child: child!,
                ),
              ),
                breakpoints: [
                  const Breakpoint(start: 0, end: 450, name: MOBILE),
                  const Breakpoint(start: 451, end: 800, name: TABLET),
                  const Breakpoint(start: 801, end: 1920, name: 'DESKTOP'),
                ],
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