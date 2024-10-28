import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:groupchat/main.dart';
import 'package:groupchat/repositories/users_repository.dart';
import 'package:groupchat/views/notifications_test_screen.dart';

Future<void> handleBackgroundMessages(RemoteMessage message) async{
  print('Title : ${message.notification?.title}');
  print('Body : ${message.notification?.body}');
  print('Payload : ${message.data}');
}

class FcmService{
  final firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async{
    await firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true
    );

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
        handleNotificationResponse(notificationResponse.payload);
      },
    );

    final token = await firebaseMessaging.getToken();
    print('token is = $token');
    if(token!=null){
      await UsersRepository().updateUserToken(token, (){}, (p0){});
    }
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      await UsersRepository().updateUserToken(token, (){}, (p0){});
    });
    initPushNotifications();
  }

  void handleNotificationResponse(String? payload) {
    if (payload != null) {
      navigatorKey.currentState!.pushNamed(NotificationsTestScreen.route, arguments: payload);
    }
  }

  handleMessage(RemoteMessage? message){
    if(message==null) return;
    showForegroundNotification(message);
    navigatorKey.currentState!.pushNamed(NotificationsTestScreen.route, arguments: message);
  }

  Future initPushNotifications() async{
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true
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
      payload: message.data.toString(), // Send data as payload
    );
  }

}