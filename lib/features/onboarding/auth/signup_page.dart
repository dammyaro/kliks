import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/gestures.dart'; // Import for TapGestureRecognizer
import 'package:flutter/services.dart'; // Import for Clipboard
import 'package:kliks/core/routes.dart';
import 'package:kliks/shared/widgets/button.dart'; // Import the CustomButton widget
import 'package:kliks/shared/widgets/icon_button.dart'; // Import the IconButtonWidget

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false; // Add this variable to track password visibility
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _referralCodeController = TextEditingController(); // Controller for referral code

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _referralCodeController.dispose(); // Dispose referral code controller
    super.dispose();
  }

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      // Implement signup logic
      Navigator.pushReplacementNamed(context, AppRoutes.emailVerification);
    }
  }

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
              SizedBox(height: 10.h), // Responsive spacing between logo and text
              Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 24.sp, // Responsive font size
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Metropolis-ExtraBold',
                  letterSpacing: 0,
                ),
              ),
              SizedBox(height: 8.h), // Reduced spacing between "Welcome" and subtext
              Text(
                'Join our community. Fill in the details below\nto create your account.',
                style: Theme.of(context).textTheme.bodySmall, // Use bodySmall from theme config
              ),
              SizedBox(height: 18.h), // Add spacing before form fields
              Form(
                key: _formKey,
                child: Column(
                    children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: Theme.of(context).textTheme.labelSmall, // Responsive label text size
                      contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w), // Adjust padding for height
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.03), // White background with 2% opacity
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.r), // Rounded corners
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r), // Rounded corners for enabled state
                        borderSide: BorderSide(color: Color(0xFF3B3B3B).withOpacity(0.2)), // Border color with 20% opacity
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.r), // Rounded corners for enabled state
                        borderSide: const BorderSide(color: Color(0xFFBBD953)), // Border color
                      ),
                      ),
                      validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                      },
                    ),
                    SizedBox(height: 20.h), // Add spacing between fields
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: Theme.of(context).textTheme.labelSmall, // Responsive label text size
                      contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w), // Adjust padding for height
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.03), // White background with 2% opacity
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r), // Rounded corners for enabled state
                      borderSide: const BorderSide(color: Color(0xFF3B3B3B)), // Border color
                      ),
                      enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r), // Rounded corners for enabled state
                      borderSide: BorderSide(color: Color(0xFF3B3B3B).withOpacity(0.2)), // Border color with 20% opacity
                      ),
                      focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r), // Rounded corners for enabled state
                      borderSide: const BorderSide(color: Color(0xFFBBD953)), // Border color
                      ),
                      suffixIcon: IconButton(
                      icon: Icon(
                      _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: Theme.of(context).iconTheme.color?.withOpacity(0.3),
                      ),
                      onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                      },
                      ),
                      ),
                      obscureText: !_isPasswordVisible,
                      validator: (value) {
                      if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                      }
                      if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                      }
                      return null;
                      },
                    ),
                    SizedBox(height: 20.h), // Add spacing between fields
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                      labelText: 'Retype password',
                      labelStyle: Theme.of(context).textTheme.labelSmall, // Responsive label text size
                      contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w), // Adjust padding for height
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.03), // White background with 2% opacity
                      border: OutlineInputBorder(
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
                      suffixIcon: IconButton(
                      icon: Icon(
                      _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: Theme.of(context).iconTheme.color?.withOpacity(0.3),
                      ),
                      onPressed: () {
                      setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                      });
                      },
                      ),
                      ),
                      obscureText: !_isPasswordVisible,
                      validator: (value) {
                      if (value != _passwordController.text) {
                      return 'Passwords do not match';
                      }
                      return null;
                      },
                    ),
                    SizedBox(height: 20.h), // Add spacing between fields
                    TextFormField(
                      controller: _referralCodeController,
                      decoration: InputDecoration(
                      labelText: 'Referral code',
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
                      suffixIcon: IconButton(
                        icon: Icon(
                        Icons.paste_outlined,
                        color: Color(0xFFBBD953),
                        ),
                        onPressed: () {
                        // Handle paste action
                        Clipboard.getData(Clipboard.kTextPlain).then((value) {
                          if (value != null) {
                          _referralCodeController.text = value.text ?? '';
                          }
                        });
                        },
                      ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h), // Add spacing before the button
              CustomButton(
                text: 'Continue', // Set the button text
                // onPressed: _signup, // Call the signup function
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.emailVerification);
                },
              ),
              SizedBox(height: 20.h), // Add spacing before the divider
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Color(0xFF3B3B3B),
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
                      color: Color(0xFF3B3B3B),
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h), // Add spacing before the buttons
              IconButtonWidget(
                text: 'Sign in with Google',
                imagePath: 'assets/google_logo.png', // Path to Google logo
                onPressed: () {
                  // Handle Google sign-in
                   Navigator.pushReplacementNamed(context, AppRoutes.mainApp);
                },
              ),
              SizedBox(height: 20.h), // Add spacing before the buttons
              IconButtonWidget(
                text: 'Sign in with Apple',
                imagePath: Theme.of(context).brightness == Brightness.dark
                    ? 'assets/apple_logo_white.png'
                    : 'assets/apple_logo_black.png', // Path to Apple logo based on theme
                onPressed: () {
                  // Handle Apple sign-in
                  Navigator.pushReplacementNamed(context, AppRoutes.mainApp);
                },
              ),
              SizedBox(height: 20.h), // Add spacing before the text
              Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Already have an account? ',
                        style: Theme.of(context).textTheme.bodySmall,
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
            ],
          ),
        ),
      ),
    );
  }
}