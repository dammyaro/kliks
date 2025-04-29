import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kliks/core/routes.dart';
import 'package:kliks/shared/widgets/button.dart'; // Import the CustomButton widget
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/gestures.dart'; // Import for TapGestureRecognizer

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  static final TextEditingController _verificationCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w), // Add horizontal padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
           SizedBox(height: 40.h), // Responsive spacing from the top
                Image.asset(
                Theme.of(context).brightness == Brightness.light
                  ? 'assets/logo-inner.png'
                  : 'assets/logo-dark.png',
                height: 80.h, // Adjust logo height dynamically
                width: 60.w,  // Adjust logo width dynamically
                ),
            const SizedBox(height: 20),
            Text(
              'Check your mail',
               style: TextStyle(
                  fontSize: 24.sp, // Responsive font size
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Metropolis-ExtraBold',
                  letterSpacing: 0,
                ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
              style: Theme.of(context).textTheme.bodySmall,
              children: [
                const TextSpan(
                text: 'We have sent a code to verify \nkunlearo@gmail.com ',
                ),
                TextSpan(
                text: 'Wrong Email?',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    // fontWeight: FontWeight.bold,
                    color: const Color(0xffbbd953),
                  ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                  // Handle "Wrong Email?" click logic
                  },
                ),
              ],
              ),
            ),
            const SizedBox(height: 30),
            const SizedBox(height: 10),
           TextFormField(
                      controller: _verificationCodeController,
                      decoration: InputDecoration(
                      labelText: 'Verification code',
                      labelStyle: Theme.of(context).textTheme.labelSmall, // Responsive label text size
                      contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w), // Adjust padding for height
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.03), // White background with 2% opacity
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF3B3B3B)), // Border color
                        borderRadius: BorderRadius.circular(30.r), // Rounded corners
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r), // Rounded corners for enabled state
                        borderSide: BorderSide(color: Color(0xFF3B3B3B).withOpacity(0.2)), // Border color with 20% opacity
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r), // Rounded corners for enabled state
                        borderSide: const BorderSide(color: Color(0xFFBBD953)), // Border color
                      ),
                     
                      ),
                    ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
              style: Theme.of(context).textTheme.bodySmall,
              children: [
                const TextSpan(
                text: 'Didn\'t get an email? ',
                ),
                TextSpan(
                text: 'Resend',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xffbbd953),
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                  // Handle resend email logic
                  },
                ),
              ],
              ),
            ),
            
            
            const SizedBox(height: 30),
            CustomButton(
              text: 'Continue',
              onPressed: () {
                // Handle continue logic
               Navigator.pushReplacementNamed(context, AppRoutes.mainApp);
              },
            ),
          ],
        ),
      ),
    ),
    );
  }
}