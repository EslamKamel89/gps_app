import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/firebase_options.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  pr('Background message: ${message.messageId}', 'FCM');
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);

Future<void> initializeNotifications() async {
  await requestPermissions();
  setupForegroundMessageHandler();
  setupInteractionHandlers();
  await getFcmToken();
}

Future<void> requestPermissions() async {
  try {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    pr('FCM permission: ${settings.authorizationStatus}', 'FCM');

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  } catch (e, st) {
    pr('Error requesting FCM permissions: $e\n$st', 'FCM');
  }
}

void setupForegroundMessageHandler() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    pr(
      'Foreground message received: ${message.notification?.title} / ${message.notification?.body}',
      'fCM',
    );

    final notification = message.notification;
    final android = message.notification?.android;

    if (notification != null) {
      final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      );

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

void setupInteractionHandlers() {
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    pr('Opened from notification: ${message.messageId}', 'FCM');
  });

  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      pr('App opened from terminated state by notification: ${message.messageId}', 'FCM');
    }
  });

  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    pr('FCM token refreshed: $newToken', 'FCM');
  });
}

Future<String?> getFcmToken() async {
  try {
    final token = await FirebaseMessaging.instance.getToken();
    pr('FCM token: $token', 'FCM');
    return token;
  } catch (e, st) {
    pr('Error getting FCM token: $e\n$st', 'FCM');
  }
  return null;
}
