import 'package:cloud_functions/cloud_functions.dart';
import 'package:groupchat/data/users_model.dart';
import 'package:groupchat/firebase/auth.dart';

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

      await _sendCloudMessageNotification(notificationData);
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
    final Map<String, dynamic> notificationMap = {
      "title": title.toString(),
      "message": "$senderName sent a message in your group",
      "data": {
        "title": title.toString(),
        "message": "$senderName sent a message in your group"
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

}
