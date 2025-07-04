import 'package:flutter/material.dart';
import 'package:kliks/core/providers/main_app_navigation_provider.dart';
import 'package:kliks/core/theme_config.dart';
import 'package:kliks/core/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:device_preview/device_preview.dart';
import 'package:kliks/shared/widgets/theme_wrapper.dart';
import 'package:kliks/core/di/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/auth_provider.dart';
import 'package:kliks/core/providers/follow_provider.dart';
import 'package:kliks/core/providers/privacy_provider.dart';
import 'package:kliks/core/services/privacy_service.dart';
import 'package:kliks/core/providers/notifications_provider.dart';
import 'package:kliks/core/providers/event_provider.dart';
import 'package:kliks/core/providers/saved_events_provider.dart';
import 'package:kliks/core/providers/transaction_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kliks/core/services/fcm_token_service.dart';
import 'package:kliks/core/providers/checked_in_events_provider.dart';
import 'package:kliks/core/providers/organizer_live_events_provider.dart';
import 'package:kliks/core/providers/search_filter_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as fln;
import 'package:another_flushbar/flushbar.dart';


final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupLocator();

  // Initialize local notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Create notification channel (Android 8.0+)
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'default_channel_id',
    'General',
    description: 'General notifications',
    importance: Importance.max,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // iOS: Request permissions explicitly (for older iOS versions)
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();

  // Print FCM token on startup (moved to onTokenRefresh below)
  // String? token = await messaging.getToken();
  // if (token != null) print('FCM Token: $token');

  // Register token with backend and listen for refresh
  FcmTokenService().listenForTokenRefresh();
  FirebaseMessaging.instance.onTokenRefresh.listen((token) {
    print('FCM Token (onTokenRefresh): $token');
    FcmTokenService().registerTokenWithBackend();
  });

  // Handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print('Received a message in the foreground!');
    print('Message data: \\${message.data}');
    if (message.notification != null) {
      print('Message also contained a notification: \\${message.notification}');
    }
    // Push-triggered refresh for notifications
    final context = navigatorKey.currentContext;
    if (context != null) {
      final notificationsProvider = Provider.of<NotificationsProvider>(context, listen: false);
      notificationsProvider.fetchMyNotifications(limit: 50, forceReload: true);
      // Show top snack bar for local notification
      final notif = message.notification;
      if (notif != null) {
        showTopNotification(
          context,
          notif.title ?? 'Notification',
          notif.body ?? '',
        );
      }
    }
    // Show local notification in foreground
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    AppleNotification? apple = message.notification?.apple;
    if (notification != null && (android != null || apple != null)) {
      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: fln.DarwinNotificationDetails(),
        ),
      );
    }
  });

  // Handle notification tap when app is in background
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('App opened from background by a notification: \${message.data}');
    // Navigate to the Activity page
    final context = navigatorKey.currentContext;
    if (context != null) {
      Provider.of<MainAppNavigationProvider>(context, listen: false).setIndex(4);
    }
  });

  // Handle notification tap when app is launched from terminated state
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      print('App opened from terminated state by a notification: \${message.data}');
      // Navigate to the Activity page
      final context = navigatorKey.currentContext;
      if (context != null) {
        Provider.of<MainAppNavigationProvider>(context, listen: false).setIndex(4);
      }
    }
  });

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
        ChangeNotifierProvider(create: (_) => FollowProvider()),
        ChangeNotifierProvider(
          create: (context) => PrivacyProvider(
            PrivacyService(
              locator(),
              Provider.of<AuthProvider>(context, listen: false),
            ),
          )..loadSettings(),
        ),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => SavedEventsProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => CheckedInEventsProvider()),
        ChangeNotifierProvider(create: (_) => OrganizerLiveEventsProvider()),
        ChangeNotifierProvider(create: (_) => MainAppNavigationProvider()),
        ChangeNotifierProvider(create: (_) => SearchFilterProvider()),
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
            navigatorKey: navigatorKey,
          );
        },
      ),
    );
  }
}

void showTopNotification(BuildContext context, String title, String message) {
  Flushbar(
    title: title,
    message: message,
    duration: Duration(seconds: 3),
    flushbarPosition: FlushbarPosition.TOP,
    backgroundColor: Colors.black87,
    margin: EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    icon: Icon(Icons.notifications, color: Colors.yellow),
  ).show(context);
}