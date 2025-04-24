import 'package:flutter/material.dart';
import 'package:kliks/core/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Add any initialization logic here
    await Future.delayed(const Duration(seconds: 2));
    
    // Check if user is logged in (pseudo-code)
    // final isLoggedIn = await AuthService.isLoggedIn();
    // if (isLoggedIn) {
    //   Navigator.pushReplacementNamed(context, AppRoutes.mainApp);
    // } else {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/logo.svg'), // Replace with your logo
      ),
    );
  }
}