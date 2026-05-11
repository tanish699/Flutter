import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  // ================= INITIALIZE =================
  Future<void> init() async {
    // Permission
    await _firebaseMessaging.requestPermission();
    // Get Token
    String? token = await _firebaseMessaging.getToken();
    debugPrint("FCM TOKEN:");
    debugPrint(token);

    // Android Notification Setup
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(settings);

    // Foreground Messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      showNotification(
        title: message.notification?.title ?? "",
        body: message.notification?.body ?? "",
      );
    });
  }

  // ================= SHOW LOCAL NOTIFICATION =================

  Future<void> showNotification({

    required String title,
    required String body,

  }) async {

    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(

      'default_channel',
      'Default Notifications',

      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
    NotificationDetails(
      android: androidDetails,
    );

    await _localNotifications.show(
      0,
      title,
      body,
      details,
    );
  }
}