import 'package:flutter/material.dart';
import 'package:kliks/core/routes.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFBBD953), // Set background color
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end, // Align content to the right
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0), // Add left and right padding of 20
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align content to the left
                children: [
                  SizedBox(height: screenHeight * 0.05), // Responsive spacing from the top
                  Image.asset(
                    'assets/logo-inner.png',
                    height: screenHeight * 0.1, // Adjust logo height dynamically
                    width: screenWidth * 0.2,  // Adjust logo width dynamically
                  ),
                  SizedBox(height: screenHeight * 0.02), // Responsive spacing between logo and text
                  const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Connect,\n',
                          style: TextStyle(
                            fontSize: 43,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Metropolis-ExtraBold',
                            letterSpacing: -2,
                            height: 1.2,
                            color: Colors.black, // Set text color to black
                          ),
                        ),
                        TextSpan(
                          text: 'Network & Earn',
                          style: TextStyle(
                            fontSize: 43,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Metropolis-ExtraBold',
                            letterSpacing: -2,
                            height: 1.2,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Create, book spots, attend events, and earn\nrewards, all in one app. ',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Metropolis-Regular',
                            letterSpacing: -1,
                            color: Colors.black, // Set text color to black
                          ),
                        ),
                        TextSpan(
                          text: 'Join Kliks now!',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Metropolis-Bold',
                            letterSpacing: -1,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05), // Responsive spacing
                  OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.signup),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black, // Button background color
                      side: const BorderSide(color: Colors.black), // Border color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Border radius
                      ),
                      minimumSize: Size(screenWidth * 0.9, screenHeight * 0.07), // Responsive button size
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Metropolis-Regular',
                        letterSpacing: -1,
                      ), // Text color
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02), // Responsive spacing
                  OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.guestApp),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black), // Border color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Border radius
                      ),
                      minimumSize: Size(screenWidth * 0.9, screenHeight * 0.07), // Responsive button size
                    ),
                    child: const Text(
                      'Continue as Guest',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Metropolis-Regular',
                        letterSpacing: -1,
                      ), // Text color
                    ),
                  ),
                ],
              ),
            ),
          ),
          Image.asset(
            'assets/images/onboarding_image.png',
            fit: BoxFit.cover, // Ensure the image covers the width
            height: screenHeight * 0.43, // Responsive height
            width: double.infinity, // Full width
          ),
        ],
      ),
    );
  }
}