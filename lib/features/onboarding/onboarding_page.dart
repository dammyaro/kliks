import 'package:flutter/material.dart';
import 'package:kliks/core/routes.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFBBD953), 
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end, 
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0), 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  SizedBox(height: screenHeight * 0.05), 
                  Image.asset(
                    'assets/logo-inner.png',
                    height: screenHeight * 0.1, 
                    width: screenWidth * 0.2,  
                  ),
                  SizedBox(height: screenHeight * 0.02), 
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
                            color: Colors.black, 
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
                            color: Colors.black, 
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
                  SizedBox(height: screenHeight * 0.05), 
                  OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.signup),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black, 
                      side: const BorderSide(color: Colors.black), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), 
                      ),
                      minimumSize: Size(screenWidth * 0.9, screenHeight * 0.07), 
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Metropolis-Regular',
                        letterSpacing: -1,
                      ), 
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02), 
                  OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.guestApp),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), 
                      ),
                      minimumSize: Size(screenWidth * 0.9, screenHeight * 0.07), 
                    ),
                    child: const Text(
                      'Continue as Guest',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Metropolis-Regular',
                        letterSpacing: -1,
                      ), 
                    ),
                  ),
                ],
              ),
            ),
          ),
          Image.asset(
            'assets/images/onboarding_image.png',
            fit: BoxFit.cover, 
            height: screenHeight * 0.43, 
            width: double.infinity, 
          ),
        ],
      ),
    );
  }
}