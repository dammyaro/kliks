import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/custom_navbar.dart';
import 'package:kliks/shared/widgets/text_form_widget.dart';
import 'package:kliks/shared/widgets/button.dart';

class UpdateEmailPage extends StatefulWidget {
  const UpdateEmailPage({super.key});

  @override
  State<UpdateEmailPage> createState() => _UpdateEmailPageState();
}

class _UpdateEmailPageState extends State<UpdateEmailPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isValidEmail = false;

  void _validateEmail(String? value) {
    final email = value ?? '';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    setState(() {
      _isValidEmail = emailRegex.hasMatch(email);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomNavBar(title: 'Change email'),
            SizedBox(height: 10.h),
            Text(
              'Enter a valid email address',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 15.sp,
                fontFamily: 'Metropolis-SemiBold',
              ),
            ),
            SizedBox(height: 20.h),
            TextFormWidget(
              name: 'email',
              controller: _emailController,
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
              onChanged: _validateEmail,
              suffixIcon: _isValidEmail
                  ? Icon(Icons.verified, color: const Color(0xffbbd953))
                  : null,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(value)) {
                  return 'Enter a valid email address';
                }
                return null;
              },
            ),
            SizedBox(height: 32.h),
            CustomButton(
              text: 'Continue',
              onPressed: _isValidEmail ? () {
                // Handle continue logic
              } : null,
              backgroundColor: const Color(0xffbbd953),
              textStyle: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                fontFamily: 'Metropolis-SemiBold',
                color: Colors.black,
              ),
              // height: 45.h,
            ),
          ],
        ),
      ),
    );
  }
}