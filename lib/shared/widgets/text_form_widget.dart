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
  final Widget? prefixIcon; // <-- Added this line
  final TextInputType keyboardType;
  final bool multiline; // New attribute for multiline support
  final double? contentHeight; // New attribute for adjustable height
  final void Function(String?)? onChanged; // Optional onChanged attribute
  final bool enabled; // New attribute for enabling/disabling the text field

  const TextFormWidget({
    super.key,
    required this.name,
    required this.controller,
    required this.labelText,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon, // <-- Added this line
    this.keyboardType = TextInputType.text,
    this.multiline = false, // Default is false
    this.contentHeight, // Optional height parameter
    this.onChanged, // Optional onChanged parameter
    this.enabled = true, // Default is true
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      controller: controller,
      obscureText: obscureText,
      keyboardType: multiline ? TextInputType.multiline : keyboardType,
      maxLines: multiline ? 5 : 1,
      enabled: enabled,
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
        prefixIcon: prefixIcon, // <-- Added this line
      ),
      validator: validator,
      onChanged: onChanged, // Pass onChanged to FormBuilderTextField
    );
  }
}