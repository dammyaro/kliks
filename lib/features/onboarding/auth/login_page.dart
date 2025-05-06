import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/gestures.dart'; 
import 'package:kliks/core/routes.dart';
import 'package:kliks/shared/widgets/button.dart'; 
import 'package:kliks/shared/widgets/icon_button.dart'; 

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false; 
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
      
      Navigator.pushReplacementNamed(context, AppRoutes.mainApp); 
    }
  }

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
              SizedBox(height: 10.h), 
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 24.sp, 
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Metropolis-ExtraBold',
                  letterSpacing: 0,
                ),
              ),
              SizedBox(height: 8.h), 
              Text(
                'Log in to your account to continue.',
                style: Theme.of(context).textTheme.bodySmall, 
              ),
              SizedBox(height: 18.h), 
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: Theme.of(context).textTheme.labelSmall, 
                        contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w), 
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.03), 
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.r), 
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r), 
                          borderSide: BorderSide(color: Color(0xFF3B3B3B).withOpacity(0.2)), 
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.r), 
                          borderSide: const BorderSide(color: Color(0xFFBBD953)), 
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h), 
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: Theme.of(context).textTheme.labelSmall, 
                        contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w), 
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.03), 
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r), 
                          borderSide: const BorderSide(color: Color(0xFF3B3B3B)), 
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r), 
                          borderSide: BorderSide(color: Color(0xFF3B3B3B).withOpacity(0.2)), 
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r), 
                          borderSide: const BorderSide(color: Color(0xFFBBD953)), 
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
              SizedBox(height: 40.h), 
              CustomButton(
                text: 'Sign In', 
                onPressed: _login, 
              ),
              SizedBox(height: 20.h), 
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
                      style: Theme.of(context).textTheme.labelSmall, 
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
              SizedBox(height: 20.h), 
              IconButtonWidget(
                text: 'Continue with Google',
                imagePath: 'assets/google_logo.png', 
                onPressed: () {
                  
                  Navigator.pushReplacementNamed(context, AppRoutes.mainApp);
                },
              ),
              SizedBox(height: 20.h), 
              IconButtonWidget(
                text: 'Continue with Apple',
                imagePath: Theme.of(context).brightness == Brightness.dark
                    ? 'assets/apple_logo_white.png'
                    : 'assets/apple_logo_black.png', 
                onPressed: () {
                  
                  Navigator.pushReplacementNamed(context, AppRoutes.mainApp);
                },
              ),
              SizedBox(height: 40.h), 
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