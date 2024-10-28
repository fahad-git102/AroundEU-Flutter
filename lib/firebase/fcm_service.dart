import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
        handleNotificationResponse(notificationResponse.payload);
      },
    );

    _fcmToken = await firebaseMessaging.getToken();
    print('FCM token is = $_fcmToken');
    _saveTokenIfLoggedIn();
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      _fcmToken = token;
      _saveTokenIfLoggedIn();
    });

    initPushNotifications();
  }

  void handleNotificationResponse(String? payload) {
    if (payload != null) {
      navigatorKey.currentState!.pushNamed(NotificationsTestScreen.route, arguments: payload);
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

  void _saveToken() {
    if (_fcmToken != null) {
      UsersRepository().updateUserToken(_fcmToken!, () {}, (error) {});
    }
  }

  Future<void> updateTokenOnLogin() async {
    if (_fcmToken != null) {
      _saveToken();
    }else{
      _fcmToken = await firebaseMessaging.getToken();
      print('New FCM token is = $_fcmToken');
      _saveTokenIfLoggedIn();
      FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
        _fcmToken = token;
        _saveTokenIfLoggedIn();
      });
    }
  }

  handleMessage(RemoteMessage? message) {
    if (message == null) return;
    showForegroundNotification(message);
    navigatorKey.currentState!.pushNamed(NotificationsTestScreen.route, arguments: message);
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
