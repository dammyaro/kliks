import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';

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
        letterSpacing: 0,
      ),
      bodyMedium: TextStyle(
        color: Colors.black,
        fontFamily: 'Metropolis-SemiBold',
        fontSize: 16.sp, 
        letterSpacing: 0,
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
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.black.withOpacity(0.95),
      contentTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 12.sp,
        fontFamily: 'Metropolis-Medium',
        height: 1.6,
      ),
      actionTextColor: Color(0xffbbd953),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      width: 0.9 * window.physicalSize.width / window.devicePixelRatio,
      elevation: 8,
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
        letterSpacing: 0,
      ),
      bodyMedium: TextStyle(
        color: Colors.white,
        fontFamily: 'Metropolis-SemiBold',
        fontSize: 16.sp, 
        letterSpacing: 0,
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
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.white.withOpacity(0.95),
      contentTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 12.sp,
        fontFamily: 'Metropolis-Medium',
        height: 1.6,
      ),
      actionTextColor: Color(0xffbbd953),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      width: 0.9 * window.physicalSize.width / window.devicePixelRatio,
      elevation: 8,
    ),
  );

  // Status Bar Configurations
  static const SystemUiOverlayStyle systemOverlayStyleLight = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static const SystemUiOverlayStyle systemOverlayStyleDark = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  // Helper method for dynamic theming
  static SystemUiOverlayStyle systemOverlayStyle(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? systemOverlayStyleDark
        : systemOverlayStyleLight;
  }

}