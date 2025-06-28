import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/core/providers/auth_provider.dart';
import 'package:kliks/shared/widgets/custom_navbar.dart';
import 'package:kliks/shared/widgets/button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UpdateDobPage extends StatefulWidget {
  const UpdateDobPage({super.key});

  @override
  State<UpdateDobPage> createState() => _UpdateDobPageState();
}

class _UpdateDobPageState extends State<UpdateDobPage> {
  DateTime? _selectedDate;
  bool _isLoading = false;

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final initialDate = _selectedDate ?? DateTime(now.year - 18, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _handleUpdate() async {
    if (_selectedDate == null) return;

    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.updateProfile(
      field: 'dob',
      value: _selectedDate!.toIso8601String(),
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update date of birth')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateText = _selectedDate != null
        ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
        : 'Select date';

    return Scaffold(
      appBar: CustomNavBar(title: 'Your birthday'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32.h),
            Text(
              'Change your Date of birth',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 16.sp,
                fontFamily: 'Metropolis-SemiBold',
              ),
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: () => _pickDate(context),
              child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(color: const Color(0xffbbd953)),
              ),
              child: Row(
                children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(
                    'Date of birth',
                    style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 10.sp,
                    fontFamily: 'Metropolis-Regular',
                    color: theme.hintColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                    Text(
                      dateText,
                      style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 15.sp,
                      fontFamily: 'Metropolis-SemiBold',
                      color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Icon(Icons.calendar_today_outlined, size: 18.sp, color: theme.iconTheme.color),
                    ],
                  ),
                  ],
                ),
                ],
              ),
              ),
            ),
            SizedBox(height: 32.h),
            CustomButton(
              text: 'Update',
              onPressed: _selectedDate != null && !_isLoading ? _handleUpdate : null,
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