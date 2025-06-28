import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/core/providers/auth_provider.dart';
import 'package:kliks/shared/widgets/custom_navbar.dart';
import 'package:kliks/shared/widgets/text_form_widget.dart';
import 'package:kliks/shared/widgets/button.dart';
import 'package:provider/provider.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;

  Future<void> _handleUpdate() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New passwords do not match')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.changePassword(
      oldPassword: _currentPasswordController.text,
      password: _newPasswordController.text,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to change password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomNavBar(title: 'Password'),
            SizedBox(height: 10.h),
            Text(
              'Enter your current password',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 16.sp,
                fontFamily: 'Metropolis-SemiBold',
              ),
            ),
            SizedBox(height: 20.h),
            TextFormWidget(
              name: 'current_password',
              controller: _currentPasswordController,
              labelText: 'Current password',
              obscureText: !_showCurrent,
              suffixIcon: IconButton(
                icon: Icon(
                  _showCurrent ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: theme.iconTheme.color?.withOpacity(0.5),
                ),
                onPressed: () {
                  setState(() {
                    _showCurrent = !_showCurrent;
                  });
                },
              ),
            ),
            SizedBox(height: 6.h),
            GestureDetector(
              onTap: () {
                // Handle forgot password logic
              },
              child: Text(
                "Can't remember?",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.blue,
                  fontSize: 12.sp,
                  fontFamily: 'Metropolis-Regular',
                ),
              ),
            ),
            SizedBox(height: 18.h),
            TextFormWidget(
              name: 'new_password',
              controller: _newPasswordController,
              labelText: 'New password',
              obscureText: !_showNew,
              suffixIcon: IconButton(
                icon: Icon(
                  _showNew ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: theme.iconTheme.color?.withOpacity(0.5),
                ),
                onPressed: () {
                  setState(() {
                    _showNew = !_showNew;
                  });
                },
              ),
            ),
            SizedBox(height: 18.h),
            TextFormWidget(
              name: 'confirm_password',
              controller: _confirmPasswordController,
              labelText: 'Confirm new password',
              obscureText: !_showConfirm,
              suffixIcon: IconButton(
                icon: Icon(
                  _showConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: theme.iconTheme.color?.withOpacity(0.5),
                ),
                onPressed: () {
                  setState(() {
                    _showConfirm = !_showConfirm;
                  });
                },
              ),
            ),
            SizedBox(height: 32.h),
            CustomButton(
              text: 'Continue',
              onPressed: _isLoading ? null : _handleUpdate,
              isLoading: _isLoading,
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