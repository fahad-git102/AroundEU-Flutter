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
}
