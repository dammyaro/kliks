import 'package:flutter/material.dart';
import 'package:kliks/core/routes.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/auth_provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.checkAuthStatus();

    final String? token = await authProvider.token;

    if (token == null || token.isEmpty) {
      // No token, go to onboarding
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
      return;
    }

    try {
      if (JwtDecoder.isExpired(token)) {
        // Token expired, go to login
        Navigator.pushReplacementNamed(context, AppRoutes.login);
        return;
      }
    } catch (e) {
      // Invalid token, go to login
      Navigator.pushReplacementNamed(context, AppRoutes.login);
      return;
    }

    // Token exists and is valid, load profile then go to main page
    await authProvider.loadProfile();
    Navigator.pushReplacementNamed(context, AppRoutes.mainApp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBBD953),
      body: Center(
        child: Image.asset(
          'assets/logo.png',
          height: 100,
          width: 100,
        ),
      ),
    );
  }
}