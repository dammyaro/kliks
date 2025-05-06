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
        fontFamily: 'Metropolis-ExtraBold',
        fontSize: 18.sp, 
        letterSpacing: -2,
      ),
      bodyMedium: TextStyle(
        color: Colors.black,
        fontFamily: 'Metropolis-SemiBold',
        fontSize: 16.sp, 
        letterSpacing: -2,
      ),
      bodySmall: TextStyle(
        color: Colors.black.withOpacity(0.8),
        fontFamily: 'Metropolis-Regular',
        fontSize: 14.sp, 
        letterSpacing: 0,
      ),
      labelSmall: TextStyle(
        color: Colors.black.withOpacity(0.46),
        fontFamily: 'Metropolis-Regular',
        fontSize: 14.sp, 
        letterSpacing: 0,
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
        fontFamily: 'Metropolis-ExtraBold',
        fontSize: 16.sp, 
        letterSpacing: -2,
      ),
      bodyMedium: TextStyle(
        color: Colors.white,
        fontFamily: 'Metropolis-SemiBold',
        fontSize: 16.sp, 
        letterSpacing: -2,
      ),
      bodySmall: TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontFamily: 'Metropolis-Regular',
        fontSize: 14.sp, 
        letterSpacing: 0,
      ),
      labelSmall: TextStyle(
        color: Colors.white.withOpacity(0.46),
        fontFamily: 'Metropolis-Regular',
        fontSize: 14.sp, 
        letterSpacing: 0,
      ),
    ),
  );
}