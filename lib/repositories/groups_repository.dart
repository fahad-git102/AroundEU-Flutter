import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:groupchat/data/group_model.dart';
import 'package:groupchat/data/message_model.dart';

import '../core/static_keys.dart';
import '../firebase/firebase_crud.dart';

class GroupsRepository{

  Future<void> addNewGroup(GroupModel groupModel, BuildContext context, Function() onComplete, Function(dynamic p0) onError) async {
    String? key = FirebaseDatabase.instance.ref(groups).push().key;
    groupModel.key = key;
    FirebaseCrud().setData(
      key: "$groups/$key",
      context: context,
      data: groupModel.toMap(),
      onComplete: onComplete,
      onCatchError: onError,
    );
  }

  Stream<Map<String, GroupModel>> getGroupsStream({required String businessKey}) {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    return dbRef.child(groups)
        .orderByChild('businessKey')
        .equalTo(businessKey)
        .onValue
        .map((event) {
      final data = event.snapshot.value != null
          ? Map<String, dynamic>.from(event.snapshot.value as Map)
          : {};
      return data.map((key, value) => MapEntry(key, GroupModel.fromMap(Map<String, dynamic>.from(value))));
    });
  }
  // Stream<Map<String, GroupModel>> getGroupsStream({required String businessKey}) {
  //   final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  //   return dbRef
  //       .child(groups)
  //       .orderByChild('businessKey')
  //       .equalTo(businessKey)
  //       .onValue
  //       .map((event) {
  //     final data = event.snapshot.value != null
  //         ? Map<String, dynamic>.from(event.snapshot.value as Map)
  //         : {};
  //     return data.map((key, value) {
  //       Map<String, dynamic> groupData = Map<String, dynamic>.from(value);
  //       if (groupData['messages'] != null) {
  //         List<MessageModel> messagesList = MessageModel.toListFromMap(groupData['messages']);
  //         messagesList.sort((a, b) {
  //           var aTimeStamp = a.timeStamp??0;
  //           var bTimeStamp = b.timeStamp??0;
  //           // DateTime aTime = _convertToDateTime(aTimeStamp);
  //           // DateTime bTime = _convertToDateTime(bTimeStamp);
  //           return bTimeStamp.compareTo(aTimeStamp);
  //           // return bTime.compareTo(aTime);
  //         });
  //         groupData['messages'] = messagesList;
  //       }
  //       return MapEntry(key, GroupModel.fromMap(groupData));
  //     });
  //   });
  // }

  DateTime _convertToDateTime(dynamic timeStamp) {
    if (timeStamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(timeStamp);
    }
    else if (timeStamp is String) {
      return DateTime.parse(timeStamp);
    }
    throw Exception("Unsupported timeStamp format: $timeStamp");
  }

}