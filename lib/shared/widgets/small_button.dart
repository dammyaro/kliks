import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  const SmallButton({
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
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColor, 
      foregroundColor: textColor ?? Theme.of(context).scaffoldBackgroundColor, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), 
      ),
      minimumSize: const Size(double.infinity, 30), 
      ),
      child: Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontSize: 12, 
        fontWeight: FontWeight.bold,
        color: textColor ?? Theme.of(context).scaffoldBackgroundColor, 
      ),
      ),
    );
  }
}