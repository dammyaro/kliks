import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/text_form_widget.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/auth_provider.dart';

class EditUsernamePage extends StatefulWidget {
  const EditUsernamePage({super.key});

  @override
  State<EditUsernamePage> createState() => _EditUsernamePageState();
}

class _EditUsernamePageState extends State<EditUsernamePage> {
  final TextEditingController usernameController = TextEditingController();
  bool _isLoading = false;

  Widget _buildDoneButton({required BuildContext context, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: _isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffbbd953),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      ),
      child: _isLoading
          ? SizedBox(
              width: 18.sp,
              height: 18.sp,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            )
          : Text(
              'Update',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black,
                    fontSize: 10.sp,
                    fontFamily: 'Metropolis-SemiBold',
                    letterSpacing: 0,
                  ),
            ),
    );
  }

  Future<void> _handleUpdate(BuildContext context) async {
    final newUsername = usernameController.text.trim();
    if (newUsername.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username cannot be empty')),
      );
      return;
    }
    setState(() => _isLoading = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.updateProfile(field: 'username',value: newUsername);
    setState(() => _isLoading = false);
    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update username')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar with back, title, and update button
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, size: 24.sp),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Username',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 18.sp,
                              fontFamily: 'Metropolis-SemiBold',
                              letterSpacing: 0,
                            ),
                      ),
                    ),
                  ),
                  _buildDoneButton(
                    context: context,
                    onPressed: () => _handleUpdate(context),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              Text(
                'Change your username',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 15.sp,
                      fontFamily: 'Metropolis-SemiBold',
                    ),
              ),
              SizedBox(height: 20.h),
              TextFormWidget(
                controller: usernameController,
                labelText: 'Username',
                name: 'username',
              ),
              SizedBox(height: 10.h),
              Text(
                'Your username can only be changed once every 7 days',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}