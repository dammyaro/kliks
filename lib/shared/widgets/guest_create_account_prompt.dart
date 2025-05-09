import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/button.dart'; 
import 'package:flutter/gestures.dart'; 
import 'package:kliks/core/routes.dart';

class GuestCreateAccountPrompt extends StatelessWidget {
  const GuestCreateAccountPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w), 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              
              Image.asset(
                Theme.of(context).brightness == Brightness.light
                    ? 'assets/logo-inner.png'
                    : 'assets/logo-dark.png',
                height: 60.h, 
                width: 60.w,  
              ),
              SizedBox(height: 20.h), 

              
              Text(
                'Create, Attend & Earn',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontFamily: 'Metropolis-ExtraBold',
                      fontSize: 24.sp, 
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h), 

              
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'Create, book spots, attend events and earn\nrewards, all in one app. ',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 16.sp, 
                          ),
                    ),
                    TextSpan(
                      text: 'Join Kliks now!',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 14.sp, 
                            fontFamily: 'Metropolis-ExtraBold',
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.h), 

              
              CustomButton(
                text: 'Create an Account',
                onPressed: () {
                  
                  Navigator.pushNamed(context, '/signup'); 
                },
                backgroundColor: const Color(0xffbbd953), 
                textColor: Colors.black, 
              ),
              SizedBox(height: 40.h), 
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
                            
                            Navigator.pushNamed(context, AppRoutes.login);
                          },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40.h), 
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
                      style: Theme.of(context).textTheme.labelSmall, 
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
              SizedBox(height: 20.h), 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  SizedBox(
                    width: 50.w, 
                    child: ElevatedButton(
                      onPressed: () {
                        
                        Navigator.pushNamed(context, '/signup'); 
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[500], 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r), 
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h), 
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/google_logo.png', 
                            height: 24.h,
                            width: 24.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w), 

                  
                  SizedBox(
                    width: 50.w, 
                    child: ElevatedButton(
                      onPressed: () {
                        
                        Navigator.pushNamed(context, '/signup'); 
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[500], 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r), 
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h), 
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/apple_logo_black.png', 
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