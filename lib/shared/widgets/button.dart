import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColor, // Default to theme's primary color
      foregroundColor: textColor ?? Theme.of(context).scaffoldBackgroundColor, // Default to white text
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30), // Rounded corners
      ),
      minimumSize: const Size(double.infinity, 50), // Full-width button
      ),
      child: Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontSize: 16, // Adjust font size as needed
        fontWeight: FontWeight.bold,
        color: textColor ?? Theme.of(context).scaffoldBackgroundColor, // Default to white text
      ),
      ),
    );
  }
}