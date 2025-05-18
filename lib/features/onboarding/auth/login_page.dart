import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/gestures.dart'; 
import 'package:kliks/core/routes.dart';
import 'package:kliks/shared/widgets/button.dart'; 
import 'package:kliks/shared/widgets/icon_button.dart'; 
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:kliks/shared/widgets/text_form_widget.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/auth_provider.dart';

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
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      try {
        final success = await authProvider.login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        if (success) {
          if (authProvider.isVerified) {
            Navigator.pushReplacementNamed(context, AppRoutes.mainApp);
          } else {
            Navigator.pushReplacementNamed(context, AppRoutes.emailVerification);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login failed. Please check your credentials.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
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
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14.sp),
              ),
              SizedBox(height: 18.h), 
              FormBuilder(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormWidget(
                              name: 'email',
                              controller: _emailController,
                              labelText: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                            ),
                    SizedBox(height: 20.h), 
                    TextFormWidget(
                              name: 'password',
                              controller: _passwordController,
                              labelText: 'Password',
                              obscureText: !_isPasswordVisible,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Theme.of(context).iconTheme.color?.withOpacity(0.3),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
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
                isLoading: _isLoading,
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
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 14.sp),
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