import 'package:flutter/material.dart';
import 'package:kliks/core/routes.dart';
import 'package:kliks/shared/widgets/button.dart'; 
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/gestures.dart'; 

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  static final TextEditingController _verificationCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
           SizedBox(height: 40.h), 
                Image.asset(
                Theme.of(context).brightness == Brightness.light
                  ? 'assets/logo-inner.png'
                  : 'assets/logo-dark.png',
                height: 80.h, 
                width: 60.w,  
                ),
            const SizedBox(height: 20),
            Text(
              'Check your mail',
               style: TextStyle(
                  fontSize: 24.sp, 
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Metropolis-ExtraBold',
                  letterSpacing: 0,
                ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12.sp,
                  ),
              children: [
                const TextSpan(
                text: 'We have sent a code to verify \nkunlearo@gmail.com ',
                ),
                TextSpan(
                text: 'Wrong Email?',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12.sp,
                    color: const Color(0xffbbd953),
                  ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                  
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
                      labelStyle: Theme.of(context).textTheme.labelSmall, 
                      contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w), 
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.03), 
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF3B3B3B)), 
                        borderRadius: BorderRadius.circular(30.r), 
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r), 
                        borderSide: BorderSide(color: Color(0xFF3B3B3B).withOpacity(0.2)), 
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r), 
                        borderSide: const BorderSide(color: Color(0xFFBBD953)), 
                      ),
                     
                      ),
                    ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12.sp,
                ),
              children: [
                const TextSpan(
                text: 'Didn\'t get an email? ',
                ),
                TextSpan(
                text: 'Resend',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12.sp,
                  color: const Color(0xffbbd953),
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                  
                  },
                ),
              ],
              ),
            ),
            
            
            const SizedBox(height: 30),
            CustomButton(
              text: 'Continue',
              onPressed: () {
                
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