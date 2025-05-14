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
        borderRadius: BorderRadius.circular(15), 
      ),
      minimumSize: const Size(double.infinity, 35), 
      ),
      child: Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontSize: 12, 
        fontFamily: 'Metropolis-Medium',
        color: textColor ?? Theme.of(context).scaffoldBackgroundColor, 
      ),
      ),
    );
  }
}