import 'package:flutter/material.dart';
import 'package:qr_app/login/presentation/pages/login_page.dart';
import 'package:qr_app/scanner/presentation/pages/base_page.dart';
import 'package:qr_app/core/presentation/pages/splash_page.dart';

class AppRouter {
  static const String initial = '/';
  static const String login = '/login';
  static const String scanner = '/scanner';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => const BiometricPage(),
        );
      case scanner:
        return MaterialPageRoute(
          builder: (_) => const BasePage(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  static void navigateToScanner(BuildContext context) {
    Navigator.pushReplacementNamed(context, scanner);
  }
}
