import 'package:flutter/material.dart';
import 'package:kliks/core/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final textStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      fontSize: 45.sp,
      fontWeight: FontWeight.bold,
      fontFamily: 'Metropolis-ExtraBold',
      letterSpacing: 0,
      height: 1,
      color: Colors.black, 
    );
    final subTextStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      fontSize: 14.sp,
      fontFamily: 'Metropolis-Regular',
      letterSpacing: -1,
      height: 1.2,
      color: Colors.black, 
    );

    return Scaffold(
      backgroundColor: const Color(0xFFBBD953), 
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.08, bottom: 20.0),
            child: Center(
              child: Image.asset(
                'assets/logo-inner.png',
                height: screenHeight * 0.08,
                width: screenWidth * 0.15,
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Connect,\n',
                    style: textStyle,
                  ),
                  TextSpan(
                    text: 'Network\n& Earn',
                    style: textStyle,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Image.asset(
                'assets/images/onboarding_image.png',
                fit: BoxFit.cover,
                height: screenHeight * 0.5,
                width: double.infinity,
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: screenHeight * 0.05,
                  left: 20.0,
                  right: 20.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.signup),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize:
                            Size(screenWidth * 0.9, screenHeight * 0.07),
                      ),
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Metropolis-SemiBold',
                          letterSpacing: -1,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    OutlinedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.guestApp),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize:
                            Size(screenWidth * 0.9, screenHeight * 0.07),
                      ),
                      child: Text(
                        'Continue as Guest',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Metropolis-SemiBold',
                          letterSpacing: -1,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}