import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThemeConfig {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        color: Colors.black,
        fontFamily: 'Metropolis-Regular',
        fontSize: 18.sp, // Responsive font size
        letterSpacing: -2,
      ),
      bodyMedium: TextStyle(
        color: Colors.black,
        fontFamily: 'Metropolis-Regular',
        fontSize: 16.sp, // Responsive font size
        letterSpacing: -2,
      ),
      bodySmall: TextStyle(
        color: Colors.black.withOpacity(0.8),
        fontFamily: 'Metropolis-Regular',
        fontSize: 14.sp, // Responsive font size
        letterSpacing: 0,
      ),
      labelSmall: TextStyle(
        color: Colors.black.withOpacity(0.46),
        fontFamily: 'Metropolis-Regular',
        fontSize: 14.sp, // Responsive font size
        letterSpacing: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.blue),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Color(0xFF3B3B3B)), // Border color for light theme
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Color(0xFF3B3B3B)), // Border color for enabled state
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Color(0xFFBBD953), width: 2), // Border color for focused state
      ),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.black,
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        color: Colors.white,
        fontFamily: 'Metropolis-Regular',
        fontSize: 18.sp, // Responsive font size
      ),
      bodyMedium: TextStyle(
        color: Colors.white,
        fontFamily: 'Metropolis-Regular',
        fontSize: 16.sp, // Responsive font size
      ),
      bodySmall: TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontFamily: 'Metropolis-Regular',
        fontSize: 14.sp, // Responsive font size
        letterSpacing: 0,
      ),
      labelSmall: TextStyle(
        color: Colors.white.withOpacity(0.46),
        fontFamily: 'Metropolis-Regular',
        fontSize: 14.sp, // Responsive font size
        letterSpacing: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.blueGrey),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Color(0xFF3B3B3B)), // Border color for dark theme
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Color(0xFF3B3B3B)), // Border color for enabled state
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Color(0xFFBBD953), width: 2), // Border color for focused state
      ),
    ),
  );
}