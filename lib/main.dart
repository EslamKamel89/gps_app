// lib/main.dart
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
import 'package:gps_app/core/helpers/firebase.dart'; // updated import
import 'package:gps_app/core/router/app_router.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/core/themes/theme_cubit.dart';
import 'package:gps_app/features/blogs/cubits/blogs_cubit.dart';
import 'package:gps_app/features/favorites/cubits/favorites_cubit.dart';
import 'package:gps_app/features/item_info/cubits/item_info_cubit.dart';
import 'package:gps_app/features/notifications/cubits/notification_cubit.dart';
import 'package:gps_app/features/report/cubits/add_report_cubit.dart';
import 'package:gps_app/features/report/cubits/block_user_cubit.dart';
import 'package:gps_app/features/search/cubits/search_cubit/search_cubit.dart';
import 'package:gps_app/features/user/preferences/cubits/preferences/preferences_cubit.dart';
import 'package:gps_app/features/user/restaurant_details/cubits/restaurant_cubit.dart';
import 'package:gps_app/features/user/store_details/cubits/store_cubit.dart';
import 'package:gps_app/features/user/user_details/cubits/user_cubit.dart';
import 'package:gps_app/features/wishlist/cubits/wishes_cubit.dart';
import 'package:intl/intl_standalone.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );

  final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
    // todo: onDidReceiveLocalNotification for older iOS if needed.
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
    macOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: onDidReceiveLocalNotificationResponse,
  );

  if (Platform.isAndroid) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

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
  @override
  void initState() {
    super.initState();

    Future.microtask(() => initializeNotifications());
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
          BlocProvider(create: (context) => AddReportCubit()),
          BlocProvider(create: (context) => BlockUserCubit()),
          BlocProvider(create: (context) => NotificationCubit()..notifications()),
          BlocProvider(create: (context) => ItemInfoCubit()),
        ],
        child: Builder(
          builder: (context) {
            final themeCubit = context.watch<ThemeCubit>();
            return MaterialApp(
              navigatorKey: navigatorKey,
              theme: themeCubit.state,
              debugShowCheckedModeBanner: false,
              initialRoute: AppRoutesNames.gpsSplashScreen,
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
