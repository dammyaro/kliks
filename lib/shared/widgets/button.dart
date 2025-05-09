import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final BoxConstraints? constraints;
  final bool? hasBorder; // New attribute for border

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.textStyle,
    this.constraints,
    this.hasBorder, // Optional attribute
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
        foregroundColor: textColor ?? Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: hasBorder == true // Add border if hasBorder is true
              ? const BorderSide(color: Colors.grey, width: 1)
              : BorderSide.none,
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: ConstrainedBox(
        constraints: constraints ?? const BoxConstraints(),
        child: Text(
          text,
          style: textStyle ??
              Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor ?? Theme.of(context).scaffoldBackgroundColor,
                  ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}