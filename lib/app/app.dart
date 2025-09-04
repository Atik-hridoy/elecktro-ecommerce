import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import 'package:elecktro_ecommerce/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:elecktro_ecommerce/app/providers/language_provider.dart';
import 'package:elecktro_ecommerce/app/theme/app_theme.dart';
import 'package:elecktro_ecommerce/app/widgets/responsive_layout.dart';
import 'package:responsive_framework/responsive_framework.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, _) {
          return GetMaterialApp(
            title: 'Elecktro',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            
            // Localization
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('es'), // Spanish
            ],
            locale: languageProvider.locale,
            localeResolutionCallback: (locale, supportedLocales) {
              if (supportedLocales.contains(locale)) {
                return locale;
              }
              return const Locale('en');
            },
            
            // Responsive framework
            builder: (context, child) => ResponsiveBreakpoints.builder(
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
            
            // Routes
            initialRoute: AppPages.initial,
            getPages: AppPages.routes,
          );
        },
      ),
    );
  }
}
