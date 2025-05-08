import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kliks/core/theme_config.dart';

class ThemeWrapper extends StatelessWidget {
  final Widget child;
  
  const ThemeWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: ThemeConfig.systemOverlayStyle(context),
      child: child,
    );
  }
}