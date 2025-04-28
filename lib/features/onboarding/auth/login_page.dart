import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/gestures.dart'; // Import for TapGestureRecognizer
import 'package:kliks/core/routes.dart';
import 'package:kliks/shared/widgets/button.dart'; // Import the CustomButton widget
import 'package:kliks/shared/widgets/icon_button.dart'; // Import the IconButtonWidget

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false; // Track password visibility
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      // Implement login logic
      Navigator.pushReplacementNamed(context, AppRoutes.mainApp); // Navigate to home page
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
                'Welcome Back',
                style: TextStyle(
                  fontSize: 24.sp, // Responsive font size
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Metropolis-ExtraBold',
                  letterSpacing: 0,
                ),
              ),
              SizedBox(height: 8.h), // Reduced spacing between "Welcome Back" and subtext
              Text(
                'Log in to your account to continue.',
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
                  ],
                ),
              ),
              SizedBox(height: 40.h), // Add spacing before the button
              CustomButton(
                text: 'Sign In', // Set the button text
                onPressed: _login, // Call the login function
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
                      'Or Sign in with',
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
                text: 'Continue with Google',
                imagePath: 'assets/google_logo.png', // Path to Google logo
                onPressed: () {
                  // Handle Google log-in
                },
              ),
              SizedBox(height: 20.h), // Add spacing before the buttons
              IconButtonWidget(
                text: 'Continue with Apple',
                imagePath: Theme.of(context).brightness == Brightness.dark
                    ? 'assets/apple_logo_white.png'
                    : 'assets/apple_logo_black.png', // Path to Apple logo based on theme
                onPressed: () {
                  // Handle Apple log-in
                },
              ),
              SizedBox(height: 20.h), // Add spacing before the text
              Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Don’t have an account? ',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextSpan(
                        text: 'Sign up',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Handle sign-up navigation
                            Navigator.pushNamed(context, AppRoutes.signup);
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