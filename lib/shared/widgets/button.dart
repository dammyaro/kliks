import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final BoxConstraints? constraints;
  final bool? hasBorder;
  final bool isLoading;
  final Widget? loadingIndicator;
  final double? height;
  final double? borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.textStyle,
    this.constraints,
    this.hasBorder,
    this.isLoading = false,
    this.loadingIndicator,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
        foregroundColor: textColor ?? Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 30),
          side: hasBorder == true
              ? const BorderSide(color: Colors.grey, width: 1)
              : BorderSide.none,
        ),
        minimumSize: Size(double.infinity, height ?? 50),
      ),
      child: ConstrainedBox(
        constraints: constraints ?? const BoxConstraints(),
        child: isLoading
            ? Center(
                child: loadingIndicator ??
                    SizedBox(
                      height: (height != null && height! > 0) ? height! * 0.6 : 24,
                      width: (height != null && height! > 0) ? height! * 0.6 : 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
              )
            : Text(
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