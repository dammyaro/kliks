import 'package:flutter/material.dart';
import 'package:kliks/core/theme_config.dart';
import 'package:kliks/core/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:device_preview/device_preview.dart';
import 'package:kliks/shared/widgets/theme_wrapper.dart';
import 'package:kliks/core/di/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/auth_provider.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..checkAuthStatus()),
        // Add other providers here if needed
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812), 
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            navigatorObservers: [routeObserver],
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
              appBarTheme: ThemeConfig.lightTheme.appBarTheme.copyWith(
                systemOverlayStyle: ThemeConfig.systemOverlayStyleLight,
              ),
            ), 
            darkTheme: ThemeConfig.darkTheme.copyWith(
              appBarTheme: ThemeConfig.darkTheme.appBarTheme.copyWith(
                systemOverlayStyle: ThemeConfig.systemOverlayStyleDark,
              ),
            ),
            themeMode: ThemeMode.system, 
            initialRoute: AppRoutes.splash, 
            onGenerateRoute: AppRoutes.generateRoute,
          );
        },
      ),
    );
  }
}