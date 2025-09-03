// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Elecktro';

  @override
  String get splashTitle => 'Bienvenido a Elecktro';

  @override
  String get splashSubtitle => 'Tu Tienda de Electrónica';

  @override
  String get loading => 'Cargando...';

  @override
  String get error => 'Ocurrió un error';

  @override
  String get retry => 'Reintentar';

  @override
  String get home => 'Inicio';

  @override
  String get categories => 'Categorías';

  @override
  String get cart => 'Carrito';

  @override
  String get profile => 'Perfil';
}
