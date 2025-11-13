// lib/core/helpers/firebase.dart
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/firebase_options.dart';
import 'package:permission_handler/permission_handler.dart';

/// Background handler - must be a top-level function and preserved for release.
/// Marking as an entry-point prevents tree shaking in release mode.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase in background isolate if you use Firebase APIs here
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  pr('Background message: ${message.messageId}', 'FCM');
}

/// Local notifications plugin instance (shared)
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Android notification channel used for foreground local notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);

/// Initialize notification system: request permissions, set handlers, and get token.
Future<void> initializeNotifications() async {
  try {
    // Android runtime permission for POST_NOTIFICATIONS (Android 13+)
    await _ensureAndroidNotificationPermission();

    // iOS permission request (alerts, badge, sound)
    if (Platform.isIOS) {
      await requestPermissions();
    }

    // Register foreground/background handlers
    setupForegroundMessageHandler();
    setupInteractionHandlers();

    // Ensure local notification channel exists (Android)
    if (Platform.isAndroid) {
      await _createAndroidNotificationChannel();
    }

    // Get and log current token (send to your server here)
    await getFcmToken();
  } catch (e, st) {
    pr('Error initializing notifications: $e\n$st', 'FCM');
  }
}

/// Request iOS permission for notifications.
Future<void> requestPermissions() async {
  try {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    pr('FCM permission (iOS): ${settings.authorizationStatus}', 'FCM');

    // For iOS: ensure foreground notifications are presented
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  } catch (e, st) {
    pr('Error requesting FCM permissions (iOS): $e\n$st', 'FCM');
  }
}

/// Ensure Android 13+ runtime permission for notifications is requested.
/// Uses permission_handler package.
Future<void> _ensureAndroidNotificationPermission() async {
  if (!Platform.isAndroid) return;

  try {
    final status = await Permission.notification.status;
    pr('Android notification permission status: $status', 'FCM');

    if (!status.isGranted) {
      final result = await Permission.notification.request();
      pr('Android notification permission requested: $result', 'FCM');
    }
  } catch (e, st) {
    pr('Error checking/requesting Android notification permission: $e\n$st', 'FCM');
  }
}

/// Create Android notification channel using flutter_local_notifications.
Future<void> _createAndroidNotificationChannel() async {
  try {
    final androidImpl =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl != null) {
      await androidImpl.createNotificationChannel(channel);
      pr('Android notification channel created: ${channel.id}', 'FCM');
    } else {
      pr('Android implementation for local notifications not available', 'FCM');
    }
  } catch (e, st) {
    pr('Error creating Android notification channel: $e\n$st', 'FCM');
  }
}

/// Foreground message handler: shows a local notification for notification payloads
/// and for data-only payloads constructs a local notification from data fields.
void setupForegroundMessageHandler() {
  FirebaseMessaging.onMessage.listen(
    (RemoteMessage message) {
      pr(
        'Foreground message received: ${message.notification?.title} / ${message.notification?.body}',
        'FCM',
      );

      final notification = message.notification;

      // Build notification details shared across both Android & iOS
      final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
        iOS: const DarwinNotificationDetails(),
      );

      if (notification != null) {
        // System-sent notification payload (usually from Firebase Console)
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          notificationDetails,
          payload: message.data['payload'] ?? '',
        );
        return;
      }

      // data-only message fallback: show a local notification built from data fields
      if (message.data.isNotEmpty) {
        final title = message.data['title'] ?? 'Notification';
        final body = message.data['body'] ?? '';
        flutterLocalNotificationsPlugin.show(
          title.hashCode,
          title,
          body,
          notificationDetails,
          payload: message.data['payload'] ?? '',
        );
      }
    },
    onError: (error) {
      pr('Error in onMessage listener: $error', 'FCM');
    },
  );
}

/// Handlers for notification interaction and token refresh.
void setupInteractionHandlers() {
  // App opened from background by tapping notification
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    pr('Opened from notification: ${message.messageId}', 'FCM');
    // Optionally handle navigation based on message.data
  });

  // App launched from terminated state by tapping a notification
  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      pr('App opened from terminated state by notification: ${message.messageId}', 'FCM');
      // Optionally handle initial navigation
    }
  });

  // Token refresh handling
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    pr('FCM token refreshed: $newToken', 'FCM');
    // TODO: send the new token to your backend
  });
}

/// Retrieve the current FCM token (and optionally send to backend).
Future<String?> getFcmToken() async {
  try {
    final token = await FirebaseMessaging.instance.getToken();
    pr('FCM token: $token', 'FCM');
    return token;
  } catch (e, st) {
    pr('Error getting FCM token: $e\n$st', 'FCM');
    return null;
  }
}
