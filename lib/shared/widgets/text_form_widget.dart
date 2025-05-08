import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class TextFormWidget extends StatelessWidget {
  final String name; // Required for FormBuilderTextField
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;

  const TextFormWidget({
    super.key,
    required this.name,
    required this.controller,
    required this.labelText,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name, // Unique name for the field
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
       style: TextStyle(
          fontSize: 14.sp,
          fontFamily: 'Metropolis-SemiBold',
          color: const Color(0xFFBBD953),
        ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14.sp),
       
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
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }
}