import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gps_app/core/globals.dart';
import 'package:gps_app/core/helpers/enable_android_photo_picker.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/router/app_router.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/core/themes/theme_cubit.dart';
import 'package:gps_app/features/blogs/cubits/blogs_cubit.dart';
import 'package:gps_app/features/favorites/cubits/favorites_cubit.dart';
import 'package:gps_app/features/search/cubits/search_cubit/search_cubit.dart';
import 'package:gps_app/features/user/preferences/cubits/preferences/preferences_cubit.dart';
import 'package:gps_app/features/user/restaurant_details/cubits/restaurant_cubit.dart';
import 'package:gps_app/features/user/store_details/cubits/store_cubit.dart';
import 'package:gps_app/features/user/user_details/cubits/user_cubit.dart';
import 'package:gps_app/features/wishlist/cubits/wishes_cubit.dart';
import 'package:intl/intl_standalone.dart';

import 'firebase_options.dart';

// Background message handler — must be a top-level function.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Don't attempt to show flutter_local_notifications from here unless you
  // initialize the plugin in the background isolate (advanced).
  pr('Background message: ${message.messageId}', 'FCM');
}

// Local notifications plugin instance (shared).
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Android notification channel (used when creating notifications).
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // name
  description: 'This channel is used for important notifications.', // description
  importance: Importance.high,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Register background handler ONCE (before runApp)
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize flutter_local_notifications with platform-specific settings
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );

  final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
    // onDidReceiveLocalNotification: (id, title, body, payload) async {
    //   // iOS (<10) local notification tap handler (optional)
    // },
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
    macOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Called when user taps a notification created by flutter_local_notifications
      final payload = response.payload;
      pr('Local notification tapped. payload: $payload', 'FCM');
      // You can navigate using navigatorKey if needed.
    },
  );

  // Create Android notification channel (only if running on Android)
  if (Platform.isAndroid) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Continue with your current app initialization
  enableAndroidPhotoPicker();
  await initServiceLocator();
  await findSystemLocale();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/langs',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final t = 'FCM';

  @override
  void initState() {
    super.initState();

    // Kick off async setup without blocking initState
    // The methods themselves are async and handle awaiting internally.
    Future.microtask(() => _initializeNotifications());
  }

  Future<void> _initializeNotifications() async {
    await _requestPermissions();
    _setupForegroundMessageHandler();
    _setupInteractionHandlers();
    await _printToken();
  }

  Future<void> _requestPermissions() async {
    try {
      // Request permission for iOS. On Android 13+ you should also request
      // POST_NOTIFICATIONS at runtime (handled elsewhere or via permission_handler).
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      pr('FCM permission: ${settings.authorizationStatus}', t);

      // For iOS: show notifications when app is in foreground
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (e, st) {
      pr('Error requesting FCM permissions: $e\n$st', t);
    }
  }

  void _setupForegroundMessageHandler() {
    // Single onMessage listener — show a local notification for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      pr(
        'Foreground message received: ${message.notification?.title} / ${message.notification?.body}',
        t,
      );

      final notification = message.notification;
      final android = message.notification?.android;

      if (notification != null) {
        // Build notification details
        final notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            importance: Importance.max,
            priority: Priority.high,
            // icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(),
        );

        // Show local notification
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          notificationDetails,
          payload: message.data['payload'] ?? '',
        );
      }
    });
  }

  void _setupInteractionHandlers() {
    // Handle when the app is opened/tapped from a terminated/background notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      pr('Opened from notification: ${message.messageId}', t);
      // handle navigation if needed, using navigatorKey
    });

    // Optionally handle the case the app was opened from a terminated state via a notification
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        pr('App opened from terminated state by notification: ${message.messageId}', t);
        // handle navigation if needed
      }
    });

    // Token refresh handling
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      pr('FCM token refreshed: $newToken', t);
      // send new token to your server if needed
    });
  }

  Future<void> _printToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      pr('FCM token: $token', t);
    } catch (e, st) {
      pr('Error getting FCM token: $e\n$st', t);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeCubit()),
          BlocProvider(create: (_) => PreferencesCubit()),
          BlocProvider(create: (context) => WishesCubit()),
          BlocProvider(create: (context) => RestaurantCubit()),
          BlocProvider(create: (context) => StoreCubit()),
          BlocProvider(create: (context) => UserCubit()),
          BlocProvider(create: (context) => BlogsCubit()),
          BlocProvider(create: (context) => FavoritesCubit()),
          BlocProvider(create: (context) => SearchCubit()..init()),
        ],
        child: Builder(
          builder: (context) {
            final themeCubit = context.watch<ThemeCubit>();
            return MaterialApp(
              navigatorKey: navigatorKey,
              theme: themeCubit.state,
              debugShowCheckedModeBanner: false,
              initialRoute: AppRoutesNames.gpsSplashScreen,
              // initialRoute: AppRoutesNames.favoritesScreen,
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              onGenerateRoute: serviceLocator<AppRouter>().onGenerateRoute,
            );
          },
        ),
      ),
    );
  }
}
