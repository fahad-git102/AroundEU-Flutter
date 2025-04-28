import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:groupchat/data/users_model.dart';
import 'package:groupchat/firebase/auth.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class NotificationService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<void> sendNotification(
      String chatId,
      List<AppUser?> userModelList,
      String groupName,
      String currentUserName) async {
    final uniqueTokens =
        _collectDeviceTokens(userModelList, Auth().currentUser?.uid ?? '');
    for(String item in uniqueTokens){
      final notificationData = _prepareNotificationData(
          item, chatId, groupName, currentUserName);

      notificationSendMessage(groupName, "$currentUserName sent a message in your group",
          item, {
            'type': 'msg',
            'chatId': chatId,
          });

      // await _sendCloudMessageNotification(notificationData);
    }
  }

  List<String> _collectDeviceTokens(
      List<AppUser?> userModelList, String currentUserUid) {
    final Set<String> tokenSet = {};

    for (var user in userModelList) {
      if (user?.uid != currentUserUid) {
        List<String?>? tokens = user?.deviceTokens;

        if (tokens != null) {
          for (var token in tokens) {
            if (token != null) {
              tokenSet.add(token);
            }
          }
        }
      }
    }

    return tokenSet.toList();
  }

  Map<String, dynamic> _prepareNotificationData(
      String token, String chatId, String title, String senderName) {
    print('chatttIDDD == $chatId');
    final Map<String, dynamic> notificationMap = {
      "title": title.toString(),
      "message": "$senderName sent a message in your group",
      "data": {
        "title": title.toString(),
        "message": "$senderName sent a message in your group",
        "chatID": chatId
      },
      "token": token.toString(),
    };

    return notificationMap;
  }


  Future<void> _sendCloudMessageNotification(Map<String, dynamic> data) async {
    print('sending data $data');
    try {
      final Map<String, String> stringData = data.map((key, value) => MapEntry(key, value.toString()));

      final HttpsCallable callable =
      _functions.httpsCallable('sendNotificationToIndividual');
      final response = await callable.call(stringData);
      print('Notification sent: ${response.data}');
    } catch (error) {
      print('Error sending notification: $error');
    }
  }

  static Future<String> getaceessToken() async {
    final serviceaccount = {
      "type": "service_account",
      "project_id": "eprojectconsult-9d70e",
      "private_key_id": "84d5a6a7c3e779f78f40bc9c8d78996a6330a8d3",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDFgCTVkrdjuIOv\n0nIUvcP272aleGvGYAzrN57drBi4fndynoKaguCtiMDeue0DI2S31EHTgpUv2Vxg\nCwkg3LZXUvHYy/nrygT7lbN5Ny6IgYQFPMwqc2ZiUuh7VSGC9W8oQV3LFZm0mVDR\nS0SbkfmKfe20Sm3wYkp9DqpZn3W2h3c5Dhn2pRxITVpbbAJbsq3dGanyAdlFOcCs\nPKeWL1DyGpckmFEsBMMWzMRyIp51nwFJIP1Hk0la7WjxDL8XJD+Y4PIy+LrsGjcy\nGm6UcmSK5ZrCsq90zCN65dzS8zNICDZeErkY08iiWWNx+6mR1gEB1CF3GgN3y/2A\nRaKJbuDhAgMBAAECggEACJk14VOAJvgJSa4Wl+cUIUvWcvVNcedMILB8+ucrc1rU\nLfoPMxVoHT4DMZ80HascjzFPRVtdzeW/cxH/7X2WdbJPg7ILuTOEKIThubEIllpX\nKlg1hlKcXkMASqBP83DmjEDeScFwve9f2KDXhZNjIx+s6ejEpQ7OcefhzEGYQSBM\njvnWys1Q9ayX7BJiZ6v4HEb6X6fARpVZVOxZvM10lpWxxTT4EbRzYajzS8XhX4SC\nssHElr6QkwNkymPeDHB94YWnaZbLggT5vFUm0eciHRZ90jcfBBsLONvdm6n8yXrn\nmjJypzMY/Ho8KKdXrQLT5Lq/FTjIdeBjKrg4mHwY8QKBgQD0vgX+z60WngG4Xpxg\ngCyST2RUzN72Ef+nhgdq0nomfkUqikMK1s9/50amhodVCrY4VpZt7dMV5R5C7c8m\nw6K4ywOhAIllB6zURlbeTDCMHZrvOnNYwsBCrQ/OkcPJO/WThKhBWX2/nxtZs7Af\ncl222hwzd1m1HWeUrAikOkJu2QKBgQDOldKswj7yTvnR4me8aQbyJaUfyxD+fZK0\n4fU0w/WkHLueocIx+QREL2HIh5KpDFo95hhm+XcMfcZfkQKQM4QwgzZlEjS8+jV3\ncJAd2+v60MjCqXjlq4OECjvZOeL/aklQf2AHT+xknMJ6ccjI39WFB74MMYOjMY9Q\ntOPwLpZNSQKBgHKAOIPXG26aa8mbEeQf8zpcRF9cHe/XydjRXsT+RcGej7NwTh9T\nEm8Pf8FG7Se/RDMlZ2l0u63hrH+5jJHhM07rQ/5eJumKZrRFWDzWPlw/OY40tWRQ\ncOyA1QVastOB5smmZaV1PdyZjo0wAPUlZ2y1rD3z15dhc2Vd+wkCbLQ5AoGADIbd\nPYiR1JOhZm66J5yexTQvLRxdLXFj4gAJpGd1j7wGTHo2kl0tOw08erJt3D5ZgoNf\nW28pHuLJkqXyZ9gX3fE27S4LcKIjd9ilhIn/Zzgd1F/+ar7ZvLn6IxP1hdNmGrF+\nmzLnfLpcuJwJttSL2AM+LPMbrluk+xnc8IWCq7ECgYBhHLIvNxYW6kcwPUAA9PGa\nOMdQWU6+P8/CwP0TNnskV4xOELv6BPRPfNbtVR4X6wv4MOdIim1U47004+i/0gOd\nbESiBOoGb+q60iGhAvT+cV04v9iehqmP9gUNLlTD2nJ1IgyN1DMjhfiravzp/wes\ndpGggeAhHx5Hgj87u4wD+Q==\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-vntq7@eprojectconsult-9d70e.iam.gserviceaccount.com",
      "client_id": "116810523236118142289",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-vntq7%40eprojectconsult-9d70e.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/userinfo.email"
    ];
    http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceaccount), scopes);
    auth.AccessCredentials credentials =
    await auth.obtainAccessCredentialsViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceaccount),
        scopes,
        client);
    client.close();
    return credentials.accessToken.data;
  }

  static notificationSendMessage(
      String title, String body, String friendDT, Map payLoad) async {
    final String token = await getaceessToken();

    try {
      http.Response response = await http.post(
        Uri.parse(
            "https://fcm.googleapis.com/v1/projects/eprojectconsult-9d70e/messages:send"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(
          <String, dynamic>{
            'message': {
              'token':
              friendDT,
              'notification': {
                'body': body,
                'title': title,
              },
              'android': {
                'priority': 'high',
                'notification': {
                  'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                },
              },
              'apns': {
                'headers': {
                  'apns-priority': '10',
                },
              },
              'data': payLoad
            },
          },
        ),
      );
    } catch (e) {
      print('Error sending FCM message: $e');
    }
  }

}


