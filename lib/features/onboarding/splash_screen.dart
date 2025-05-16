import 'package:flutter/material.dart';
import 'package:kliks/core/routes.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/auth_provider.dart';

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
    if (authProvider.isAuthenticated) {
      if (authProvider.isVerified) {
        Navigator.pushReplacementNamed(context, AppRoutes.mainApp);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.emailVerification);
      }
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    }
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