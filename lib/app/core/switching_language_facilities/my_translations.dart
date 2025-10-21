// ignore: depend_on_referenced_packages
import 'package:get/get.dart';

class MyTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        // 🌐 English (US)
        'en_US': {
          // 🔹 Auth
          'welcome_back': 'Welcome Back!',
          'enter_email': 'Please enter your email to continue',
          'email': 'Email',
          'email_required': 'Email is required',
          'invalid_email': 'Please enter a valid email',
          'continue': 'Continue',
          'send_otp': 'Send OTP',
        },

                  // 🇪🇸 Spanish (ES)
        'es_ES': {
          // 🔹 Auth
          'welcome_back': '¡Bienvenido de nuevo!',
          'enter_email': 'Por favor ingresa tu correo para continuar',
          'email': 'Correo electrónico',
          'email_required': 'El correo electrónico es obligatorio',
          'invalid_email': 'Por favor ingresa un correo válido',
          'continue': 'Continuar',
          'send_otp': 'Enviar OTP',
        }

  };

}