import 'package:flutter/material.dart';
import 'package:kliks/features/main_app/main_app_page.dart';
import 'package:kliks/features/onboarding/auth/email_verification_page.dart';
import 'package:kliks/features/onboarding/auth/login_page.dart';
import 'package:kliks/features/onboarding/auth/signup_page.dart';
import 'package:kliks/features/onboarding/onboarding_page.dart';
import 'package:kliks/features/onboarding/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String emailVerification = '/email-verification';
  static const String mainApp = '/main-app';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupPage());
      case emailVerification:
        return MaterialPageRoute(builder: (_) => const EmailVerificationPage());
      case mainApp:
        return MaterialPageRoute(builder: (_) => const MainAppPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ));
    }
  }
}