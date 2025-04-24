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
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBBD953), // Set background color
      body: Center(
        child: Image.asset(
          'assets/logo.png',
          height: 100, // Adjust height
          width: 100,  // Adjust width
        ),
      ),
    );
  }
}