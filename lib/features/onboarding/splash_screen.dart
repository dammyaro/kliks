import 'package:flutter/material.dart';
import 'package:kliks/core/routes.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/auth_provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:geolocator/geolocator.dart';

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
    // 1. Check location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      // If still denied, show a dialog and do not proceed
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Location Required'),
            content: const Text('Location access is required to use this app.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        // Try again
        return _checkAuthAndNavigate();
      }
    }

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
    final profile = authProvider.profile;
    if (profile == null || (profile['fullname'] == null || profile['fullname'].toString().isEmpty) || (profile['username'] == null || profile['username'].toString().isEmpty)) {
      // Redirect to profile setup page
      Navigator.pushReplacementNamed(context, '/profile-setup');
      return;
    }
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