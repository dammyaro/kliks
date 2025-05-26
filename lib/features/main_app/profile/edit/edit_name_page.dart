import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/text_form_widget.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/auth_provider.dart';

class EditNamePage extends StatefulWidget {
  const EditNamePage({super.key});

  @override
  State<EditNamePage> createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name cannot be empty';
    }
    // Accepts letters, spaces, hyphens, apostrophes, and periods. No numbers or special chars.
    final nameRegExp = RegExp(r"^[A-Za-zÀ-ÖØ-öø-ÿ'’.\- ]{2,50}$");
    if (!nameRegExp.hasMatch(value.trim())) {
      return 'Enter a valid name (letters, spaces, hyphens, apostrophes, periods)';
    }
    // Ensure at least two words (first and last name)
    final parts = value.trim().split(RegExp(r'\s+'));
    if (parts.length < 2) {
      return 'Please enter both first and last name';
    }
    // Each part should be at least 2 characters
    if (parts.any((part) => part.isEmpty)) {
      return 'Each name part should be at least 1 characters';
    }
    return null;
  }

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
    if (!_formKey.currentState!.validate()) return;
    final newName = nameController.text.trim();
    setState(() => _isLoading = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.updateProfile(field: 'fullname', value: newName);
    setState(() => _isLoading = false);
    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update name')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Form(
            key: _formKey,
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
                          'Name',
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
                  'What is your name?',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 15.sp,
                        fontFamily: 'Metropolis-SemiBold',
                      ),
                ),
                SizedBox(height: 20.h),
                TextFormWidget(
                  controller: nameController,
                  labelText: 'Name',
                  name: 'name',
                  validator: _validateName,
                ),
                SizedBox(height: 10.h),
                Text(
                  'Your name can only be changed once every 7 days',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}