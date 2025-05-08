import 'package:flutter/material.dart';
import 'package:kliks/core/theme_config.dart';
import 'package:kliks/core/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:device_preview/device_preview.dart';
import 'package:kliks/shared/widgets/theme_wrapper.dart';

void main() => runApp(
  DevicePreview(
    enabled: true,
    builder: (context) => const MyApp(), 
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), 
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          useInheritedMediaQuery: true,
          locale: DevicePreview.locale(context), 
          builder: (context, child) {
            // Combine DevicePreview's builder with our ThemeWrapper
            return DevicePreview.appBuilder(
              context,
              ThemeWrapper(
                child: child!,
              ),
            );
          },
          debugShowCheckedModeBanner: false,
          title: 'Kliks',
          theme: ThemeConfig.lightTheme.copyWith(
            appBarTheme: ThemeConfig.lightTheme.appBarTheme?.copyWith(
              systemOverlayStyle: ThemeConfig.systemOverlayStyleLight,
            ),
          ), 
          darkTheme: ThemeConfig.darkTheme.copyWith(
            appBarTheme: ThemeConfig.darkTheme.appBarTheme?.copyWith(
              systemOverlayStyle: ThemeConfig.systemOverlayStyleDark,
            ),
          ),
          themeMode: ThemeMode.system, 
          initialRoute: AppRoutes.splash, 
          onGenerateRoute: AppRoutes.generateRoute,
        );
      },
    );
  }
}