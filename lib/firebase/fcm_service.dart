import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:groupchat/core/static_keys.dart';
import 'package:groupchat/views/chat_screens/chat_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../repositories/users_repository.dart';
import '../views/notifications_test_screen.dart';
import 'auth.dart';

Future<void> handleBackgroundMessages(RemoteMessage message) async{
  print('Title : ${message.notification?.title}');
  print('Body : ${message.notification?.body}');
  print('Payload : ${message.data}');
}

class FcmService {
  final firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  String? _fcmToken;

  Future<void> initNotifications() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: DarwinInitializationSettings());
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
        handleNotificationResponse(notificationResponse.payload);
      },
    );

    _fcmToken = await firebaseMessaging.getToken();
    // _fcmToken = Platform.isAndroid?await firebaseMessaging.getToken(): Platform.isIOS? await firebaseMessaging.getAPNSToken():'';
    print('FCM token is 1 = $_fcmToken');
    _saveTokenIfLoggedIn();
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      _fcmToken = token;
      _saveTokenIfLoggedIn();
    });

    initPushNotifications();
  }

  void handleNotificationResponse(String? payload) {
    // print('payloadddd isss == $payload');
    // if (payload != null) {
    //   navigatorKey.currentState!.pushNamed(ChatScreen.route, arguments: payload);
    // }
    if (payload != null) {
      final Map<String, dynamic> data = jsonDecode(payload);
      final chatId = data['chatId'];
      navigatorKey.currentState!.pushNamed(
        ChatScreen.route,
        arguments: {'groupId': chatId},
      );
    }
  }

  void _saveTokenIfLoggedIn() {
    if (_isUserLoggedIn()) {
      _saveToken();
    }
  }

  bool _isUserLoggedIn() {
    return Auth().currentUser!=null;
  }

  Future<void> _saveToken() async {
    if (_fcmToken != null) {
      UsersRepository().updateUserToken(_fcmToken!, () {}, (error) {});
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(fcmToken, _fcmToken!);
    }
  }

  Future<void> updateTokenOnLogin() async {
    if (_fcmToken != null) {
      _saveToken();
    }else{
      _fcmToken = Platform.isAndroid?await firebaseMessaging.getToken(): Platform.isIOS? await firebaseMessaging.getAPNSToken():'';
      print('FCM token is 2 = $_fcmToken');
      _saveTokenIfLoggedIn();
      FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
        _fcmToken = token;
        _saveTokenIfLoggedIn();
      });
    }
  }

  handleMessage(RemoteMessage? message) {
    print('messssaggggeggeee == ${message?.data['chatId']}');
    if (message == null) return;
    showForegroundNotification(message);
    final chatId = message.data['chatId'];

    if (chatId != null) {
      showForegroundNotification(message);
      navigatorKey.currentState!.pushNamed(
        ChatScreen.route,
        arguments: {
          'groupId': chatId
        },
      );
    }
    // navigatorKey.currentState!.pushNamed(NotificationsTestScreen.route, arguments: message);
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onMessage.listen(showForegroundNotification);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessages);
  }

  Future<void> showForegroundNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: message.data.toString(),
    );
  }
}
