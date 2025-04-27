import 'package:flutter/material.dart';
import 'package:kliks/core/theme_config.dart';
import 'package:kliks/features/onboarding/splash_screen.dart';
import 'package:kliks/core/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Set the design size (width x height)
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Kliks',
          theme: ThemeConfig.lightTheme, // Apply light theme
          darkTheme: ThemeConfig.darkTheme, // Apply dark theme
          themeMode: ThemeMode.system, // Use system theme by default
          initialRoute: AppRoutes.splash, // Set initial route
          // routes: {
          //   AppRoutes.splash: (context) => const SplashScreen(),
          //   AppRoutes.onboarding: (context) => const OnboardingPage(),
          //   // Add other routes here
          // },
          home: const SplashScreen(),
          onGenerateRoute: AppRoutes.generateRoute,
        );
      },
      );
  }
}