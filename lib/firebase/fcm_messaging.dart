import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:groupchat/core/utilities_class.dart';

class FCMMessaging {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    // Request notification permissions from the user
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // Get FCM token for the device
    final fcmToken = await _firebaseMessaging.getToken();
    print('FCM token: $fcmToken');

    // Setup notification handling for different states


    // 1. Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a foreground message: ${message.messageId}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification!.title}');
        // Handle or display notification content (e.g., using a dialog, snackbar, etc.)
      }
    });

    // 2. Handle notifications when the app is in the background and opened by a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message opened the app: ${message.notification?.title}');
      // Perform actions based on the notification (e.g., navigate to a specific screen)
    });

    // 3. Handle notifications when the app is terminated and opened by a notification
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      print('App opened from a terminated state by notification: ${initialMessage.notification?.title}');
      // Perform actions based on the notification that opened the app from a terminated state
    }

    // Optional: For Android, set foreground notification options
    if (Platform.isAndroid) {
      _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }
}
