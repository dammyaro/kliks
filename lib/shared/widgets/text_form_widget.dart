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
  final bool multiline; // New attribute for multiline support
  final double? contentHeight; // New attribute for adjustable height

  const TextFormWidget({
    super.key,
    required this.name,
    required this.controller,
    required this.labelText,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.multiline = false, // Default is false
    this.contentHeight, // Optional height parameter
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      controller: controller,
      obscureText: obscureText,
      keyboardType: multiline ? TextInputType.multiline : keyboardType,
      maxLines: multiline ? 5 : 1,
      style: TextStyle(
        fontSize: 14.sp,
        fontFamily: 'Metropolis-SemiBold',
        color: Colors.grey[500],
        letterSpacing: 0,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
        alignLabelWithHint: multiline,
        contentPadding: EdgeInsets.symmetric(
          vertical: contentHeight ?? (multiline ? 20.h : 14.h), // Use contentHeight if provided
          horizontal: 20.w,
        ),
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