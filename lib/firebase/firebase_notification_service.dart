import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import '../main.dart';
import '../views/chat_screens/chat_screen.dart';

String? chatId;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

class NotificationServices {
  static String? lastMessageId;
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<bool?> requestNotificationPermission(
      BuildContext context) async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      return true;
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      return false;
    } else {
      _showPermissionDialog(context);
    }
    return false;
  }

  static _showPermissionDialog(BuildContext context) {
    showAdaptiveDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog.adaptive(
          title: const Text("Notification Permission Required"),
          content: const Text(
              "Please enable notification permissions to receive updates."),
          actions: <Widget>[
            TextButton(
              child: FittedBox(
                  fit: BoxFit.scaleDown, child: const Text("Open Settings")),
              onPressed: () async {
                // Open app settings
                await openAppSettings();
              },
            ),
            TextButton(
              child:
              FittedBox(fit: BoxFit.scaleDown, child: const Text("Close")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void initLocalNotification(context, RemoteMessage message) async {
    const androidInitializationSettings =
    AndroidInitializationSettings("@mipmap/ic_launcher");
    final iosInitializationSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
      requestCriticalPermission: true,
      // onDidReceiveLocalNotification: (id, title, body, payload) =>
      //     handleMessage(context, message),
    );
    final initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) {
          handleMessage(navigatorKey.currentContext, message);
        });
  }

  static void firebaseInIt(context) async {
    if (Platform.isIOS) {
      foregroundMessaging();
    }
    FirebaseMessaging.onMessage.listen((message) async {
      if(message.notification!=null){
        initLocalNotification(context, message);
        showNotification(message);
      }
    });
  }

  static Future<void> showNotification(RemoteMessage message) async {
    List<ActiveNotification> activeNotification =
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()!
        .getActiveNotifications();
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      "high_importance_channel",
      "High Importance Notifications",
      importance: Importance.high,
    );
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (activeNotification.isEmpty || activeNotification.length == 1) {
      AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
          channel.id.toString(), channel.name.toString(),
          channelDescription: "high_importance_channel",
          importance: Importance.high,
          priority: Priority.high,
          color: const Color(0xffFD2B24),
          ticker: "ticker");
      DarwinNotificationDetails darwinNotificationDetails =
      const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      NotificationDetails notificationDetails = NotificationDetails(
          android: androidNotificationDetails, iOS: darwinNotificationDetails);

      Future.delayed(
          Duration.zero,
              () => flutterLocalNotificationsPlugin.show(
              0,
              message.notification?.title.toString(),
              message.notification?.body.toString(),
              notificationDetails));
    }

    if (activeNotification.length > 1) {
      List<String> lines =
      activeNotification.map((e) => e.title.toString()).toList();
      InboxStyleInformation inboxStyleInformation = InboxStyleInformation(lines,
          contentTitle: "${activeNotification.length - 1} messages",
          summaryText: "${activeNotification.length - 1} messages");
      AndroidNotificationDetails groupAndroidNotificationDetails =
      AndroidNotificationDetails(
          channel.id.toString(), channel.name.toString(),
          channelDescription: "high_importance_channel",
          groupKey: '0',
          setAsGroupSummary: true,
          importance: Importance.high,
          priority: Priority.high,
          color: const Color(0xffFD2B24),
          autoCancel: true,
          styleInformation: inboxStyleInformation,
          ticker: "ticker");

      NotificationDetails groupNotificationDetails = NotificationDetails(
        android: groupAndroidNotificationDetails,
      );

      Future.delayed(
          Duration.zero,
              () => flutterLocalNotificationsPlugin.show(
              0,
              message.notification?.title.toString(),
              message.notification?.body.toString(),
              groupNotificationDetails));
    }
  }

  static Future<String?> getDeviceToken() async {
    return await messaging.getToken();
  }

  static Future<void> setupInteractMessage(BuildContext context) async {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? initialMessage) {
      if (initialMessage != null) {
        _processMessage(initialMessage);
        // handleMessage(navigatorKey.currentContext, initialMessage);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _processMessage(message);
      // handleMessage(navigatorKey.currentContext, message);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static void _processMessage(RemoteMessage message) {
    if (lastMessageId == message.messageId) {
      return; // Prevent duplicate processing
    }
    lastMessageId = message.messageId;
    handleMessage(navigatorKey.currentContext, message);
  }

  static Future foregroundMessaging() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
  }

  static handleMessage(context, RemoteMessage message) async {
    if (message.data['type'] == 'msg'){
      chatId = message.data['chatId'];
      print('Message got in Notification = ${message.data}');
      Navigator.pushNamed(
          context, ChatScreen.route, arguments: {
        'groupId': chatId
      });
    }
  }
}
