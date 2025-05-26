import 'dart:ui';
import 'package:flutter/material.dart';

class CustomBackdropFilter extends StatelessWidget {
  final Widget? child;

  const CustomBackdropFilter({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: Container(
        color: Colors.black.withOpacity(0.1),
        child: child,
      ),
    );
  }
}