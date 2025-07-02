import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:kliks/core/routes.dart';
import 'package:kliks/shared/widgets/button.dart';
import 'package:kliks/shared/widgets/icon_button.dart';
import 'package:kliks/shared/widgets/text_form_widget.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/auth_provider.dart';

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

  bool _isLoading = false;

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
      setState(() => _isLoading = true);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      try {
        final success = await authProvider.register(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          referralCode: _referralCodeController.text.trim(),
          gender: "",
          dob: null,
        );
        if (success) {
          Navigator.pushReplacementNamed(context, AppRoutes.emailVerification);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7), child: Text('Registration failed. Please try again.'))),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7), child: Text('Error: $e'))),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  // TO DO: Add a method to handle the referral code paste action
  // TO DO: Add validations for Password to make sure the password has at least 8 characters, one uppercase letter and one special character

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
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
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters';
                                }
                                if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                  return 'Password must contain at least one uppercase letter';
                                }
                                if (!RegExp(r'[!@#\$&*~_.,%^()-]').hasMatch(value)) {
                                  return 'Password must contain at least one special character';
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
                        isLoading: _isLoading,
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
                        text: 'Sign in with Apple',
                        imagePath: Theme.of(context).brightness == Brightness.dark
                            ? 'assets/apple_logo_white.png'
                            : 'assets/apple_logo_black.png',
                        onPressed: () async {
                          final authProvider = Provider.of<AuthProvider>(context, listen: false);
                          final userCredential = await authProvider.signInWithApple();
                          if (userCredential != null) {
                            final idToken = await userCredential.user?.getIdToken();
                            final success = await authProvider.oAuthLoginWithApple(idToken: idToken ?? '');
                            if (success) {
                              Navigator.pushReplacementNamed(context, AppRoutes.mainApp);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7), child: Text('OAuth Apple login failed'))),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7), child: Text('Apple sign-in failed'))),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 20.h),
                      IconButtonWidget(
                        text: 'Sign in with Google',
                        imagePath: 'assets/google_logo.png',
                        onPressed: () async {
                          final authProvider = Provider.of<AuthProvider>(context, listen: false);
                          final userCredential = await authProvider.signInWithGoogleManual();
                          if (userCredential != null) {
                            final user = userCredential.user;
                            final accessToken = await userCredential.user?.getIdTokenResult();
                            final success = await authProvider.oAuthLoginWithGoogle(
                              idToken: accessToken?.token ?? '',
                            );
                            if (success) {
                              Navigator.pushReplacementNamed(context, AppRoutes.mainApp);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7), child: Text('OAuth login failed'))),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7), child: Text('Google sign-in failed'))),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 60.h),
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