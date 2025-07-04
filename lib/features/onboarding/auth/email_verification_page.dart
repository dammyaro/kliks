import 'package:flutter/material.dart';
import 'package:kliks/core/routes.dart';
import 'package:kliks/shared/widgets/button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/auth_provider.dart';
import 'package:kliks/shared/widgets/text_form_widget.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final TextEditingController _verificationCodeController = TextEditingController();
  bool _isLoading = false;
  bool _isResending = false;

  String get _userEmail {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return authProvider.currentEmail ?? '';
  }

  Future<void> _verifyEmail() async {
    setState(() => _isLoading = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final otp = _verificationCodeController.text.trim();

    try {
      final success = await authProvider.verifyEmail(
        email: _userEmail,
        otp: otp,
      );
      if (success) {
        await authProvider.loadProfile();
        final profile = authProvider.profile;
        if (profile == null ||
            (profile['fullname'] == null || profile['fullname'].toString().isEmpty) ||
            (profile['username'] == null || profile['username'].toString().isEmpty)) {
          Navigator.pushReplacementNamed(context, '/profile-setup');
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.mainApp);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7), child: Text('Verification failed. Please try again.'))),
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

  Future<void> _resendOtp() async {
    setState(() => _isResending = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final success = await authProvider.resendOtp(email: _userEmail);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7), child: Text('OTP resent! Please check your email.'))),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7), child: Text('Failed to resend OTP.'))),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7), child: Text('Failed to resend OTP: $e'))),
      );
    } finally {
      setState(() => _isResending = false);
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
              // SizedBox(height: 40.h),
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
                        fontSize: 13.sp,
                      ),
                  children: [
                    TextSpan(
                      text: 'We have sent a code to verify \n$_userEmail ',
                    ),
                    TextSpan(
                      text: ' Wrong Email?',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 13.sp,
                            color: const Color(0xffbbd953),
                          ),
                        recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacementNamed(context, AppRoutes.signup);
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              TextFormWidget(
                name: 'verification_code',
                controller: _verificationCodeController,
                labelText: 'Verification code',
                
                // decoration: InputDecoration(
                //   labelText: 'Verification code',
                //   labelStyle: Theme.of(context).textTheme.labelSmall,
                //   contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
                //   filled: true,
                //   fillColor: Colors.white.withOpacity(0.03),
                  // border: OutlineInputBorder(
                  //   borderSide: const BorderSide(color: Color(0xFF3B3B3B)),
                  //   borderRadius: BorderRadius.circular(30.r),
                  // ),
                  // enabledBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(10.r),
                  //   borderSide: BorderSide(color: Color(0xFF3B3B3B).withOpacity(0.2)),
                  // ),
                  // focusedBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(10.r),
                  //   borderSide: const BorderSide(color: Color(0xFFBBD953)),
                  // ),
                //),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                      ),
                    children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Text(
                      'Didn\'t get an email? ',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: GestureDetector(
                      onTap: _isResending ? null : _resendOtp,
                      child: _isResending
                        ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          )
                        : Text(
                          'Resend',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 14.sp,
                              color: const Color(0xffbbd953),
                            ),
                          ),
                      ),
                    ),
                    
                  ],
                ),
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: 'Continue',
                onPressed: _verifyEmail,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}