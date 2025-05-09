import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:kliks/core/routes.dart';
import 'package:kliks/shared/widgets/button.dart';
import 'package:kliks/shared/widgets/icon_button.dart';
import 'package:kliks/shared/widgets/text_form_widget.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isPasswordVisible = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _referralCodeController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _referralCodeController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (_formKey.currentState!.saveAndValidate()) {
      Navigator.pushReplacementNamed(context, AppRoutes.emailVerification);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(), // Enable smooth scrolling
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight, // Ensure it takes full height
                ),
                child: IntrinsicHeight(
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
                        'Welcome',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Metropolis-ExtraBold',
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Join our community. Fill in the details below\nto create your account.',
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
                            SizedBox(height: 20.h),
                            TextFormWidget(
                              name: 'confirm_password',
                              controller: _confirmPasswordController,
                              labelText: 'Retype password',
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
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20.h),
                            TextFormWidget(
                              name: 'referral_code',
                              controller: _referralCodeController,
                              labelText: 'Referral code',
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.paste_outlined,
                                  color: Color(0xFFBBD953),
                                ),
                                onPressed: () {
                                  Clipboard.getData(Clipboard.kTextPlain).then((value) {
                                    if (value != null) {
                                      _referralCodeController.text = value.text ?? '';
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.h),
                      CustomButton(
                        text: 'Continue',
                        onPressed: _signup,
                      ),
                      SizedBox(height: 20.h),
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
                             style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 14.sp),
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
                      IconButtonWidget(
                        text: 'Sign in with Google',
                        imagePath: 'assets/google_logo.png',
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, AppRoutes.mainApp);
                        },
                      ),
                      SizedBox(height: 20.h),
                      IconButtonWidget(
                        text: 'Sign in with Apple',
                        imagePath: Theme.of(context).brightness == Brightness.dark
                            ? 'assets/apple_logo_white.png'
                            : 'assets/apple_logo_black.png',
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, AppRoutes.mainApp);
                        },
                      ),
                      SizedBox(height: 20.h),
                      Center(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Already have an account? ',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14.sp),
                              ),
                              TextSpan(
                                text: 'Sign in',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                    ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
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
          },
        ),
      ),
    );
  }
}