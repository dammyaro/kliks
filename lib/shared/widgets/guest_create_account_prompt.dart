import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/button.dart'; // Import the CustomButton widget
import 'package:flutter/gestures.dart'; // Import for TapGestureRecognizer
import 'package:kliks/core/routes.dart';

class GuestCreateAccountPrompt extends StatelessWidget {
  const GuestCreateAccountPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w), // Add horizontal padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
            crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
            children: [
              // Logo
              Image.asset(
                Theme.of(context).brightness == Brightness.light
                    ? 'assets/logo-inner.png'
                    : 'assets/logo-dark.png',
                height: 60.h, // Adjust logo height dynamically
                width: 60.w,  // Adjust logo width dynamically
              ),
              SizedBox(height: 20.h), // Spacing between logo and text

              // Main Text
              Text(
                'Create, Attend & Earn',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontFamily: 'Metropolis-ExtraBold',
                      fontSize: 24.sp, // Adjust font size
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h), // Spacing between main text and subtext

              // Subtext
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'Create, book spots, attend events and earn\nrewards, all in one app. ',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 16.sp, // Adjust font size
                          ),
                    ),
                    TextSpan(
                      text: 'Join Kliks now!',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 14.sp, // Adjust font size
                            fontFamily: 'Metropolis-ExtraBold',
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.h), // Spacing before the button

              // Create Account Button
              CustomButton(
                text: 'Create an Account',
                onPressed: () {
                  // Handle create account action
                  Navigator.pushNamed(context, '/signup'); // Navigate to signup page
                },
                backgroundColor: const Color(0xffbbd953), // Always use this background color
                textColor: Colors.black, // Black text color
              ),
              SizedBox(height: 40.h), // Add spacing before the text
              Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Already have an account? ',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 16.sp,
                        ),
                      ),
                      TextSpan(
                        text: 'Sign in',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Handle sign-in navigation
                            Navigator.pushNamed(context, AppRoutes.login);
                          },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40.h), // Add spacing before the divider
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: const Color(0xFF3B3B3B),
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text(
                      'Or sign up with',
                      style: Theme.of(context).textTheme.labelSmall, // Use bodySmall from theme config
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: const Color(0xFF3B3B3B),
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h), // Add spacing before the buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google Button
                  SizedBox(
                    width: 50.w, // Reduced width for the Google button
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle Google sign-up action
                        Navigator.pushNamed(context, '/signup'); // Navigate to signup page
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[500], // Grey background
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r), // Rounded corners
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h), // Vertical padding
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/google_logo.png', // Google icon path
                            height: 24.h,
                            width: 24.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w), // Spacing between buttons

                  // Apple Button
                  SizedBox(
                    width: 50.w, // Reduced width for the Apple button
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle Apple sign-up action
                        Navigator.pushNamed(context, '/signup'); // Navigate to signup page
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[500], // Grey background
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r), // Rounded corners
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h), // Vertical padding
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/apple_logo_black.png', // Apple icon path
                            height: 24.h,
                            width: 24.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}