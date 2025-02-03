import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:groupchat/data/group_model.dart';

import '../core/static_keys.dart';
import '../data/message_model.dart';
import '../firebase/auth.dart';
import '../firebase/firebase_crud.dart';

class GroupsRepository {
  Future<void> addNewGroup(GroupModel groupModel, BuildContext context,
      Function() onComplete, Function(dynamic p0) onError) async {
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

  readAllMessages(String groupId){
    FirebaseDatabase.instance.ref(groups).child('$groupId/unReadCounts/${Auth().currentUser?.uid}').set(0);
  }

  Future<void> updateGroup(Map<String, dynamic> map, String groupId, BuildContext context,
      Function() onComplete, Function(dynamic p0) onError) async {
    FirebaseCrud().updateData(
        key: "$groups/$groupId",
        context: context,
        data: map,
        onComplete: onComplete,
        onCatchError: onError);
  }

  deleteMessage(BuildContext ctx, String messageKey, String groupKey,
      Function() onComplete, Function(dynamic p0) onError) {
    FirebaseDatabase.instance
        .ref(groups)
        .child('$groupKey/$messages/$messageKey')
        .remove()
        .then((value) {
      onComplete();
    }).onError((error, stackTrace){
      onError(error);
    });
  }

  Future<List<GroupModel>> getGroupsWithPin(String pin) async {
    final databaseRef = FirebaseDatabase.instance.ref(groups);
    Query query = databaseRef.orderByChild('pincode').equalTo(pin);
    List<GroupModel> groupsWithPin = [];
    try {
      DatabaseEvent event = await query.once();
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          groupsWithPin.add(GroupModel.fromMap(value));
        });
      }
    } catch (error) {
      print("Failed to load groups: $error");
    }

    return groupsWithPin;
  }


  Future<void> sendMessage(MessageModel messageModel, String groupId, BuildContext context,
      Function() onComplete, Function(dynamic p0) onError) async {
    String? key = FirebaseDatabase.instance.ref(groups).push().key;
    messageModel.key = key;
    FirebaseCrud().setData(
        key: '$groups/$groupId/$messages/$key',
        context: context,
        data: messageModel.toMap(),
        onComplete: onComplete,
      onCatchError: onError
    );
  }

  Stream<Map<String, GroupModel>> getGroupsStream(
      {required String businessKey}) {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    return dbRef
        .child(groups)
        .orderByChild('businessKey')
        .equalTo(businessKey)
        .onValue
        .map((event) {
      final data = event.snapshot.value != null
          ? Map<String, dynamic>.from(event.snapshot.value as Map)
          : {};
      return data.map((key, value) =>
          MapEntry(key, GroupModel.fromMap(Map<String, dynamic>.from(value))));
    });
  }

  Future<void> deleteGroup(BuildContext ctx, String groupId, {Function()? onComplete, Function(dynamic p0)? onError}) async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    try {
      DatabaseEvent event = await dbRef.child(users).orderByChild("joinedGroupId").equalTo(groupId).once();
      if (event.snapshot.value != null) {
        Map<String, dynamic> usersMap = Map<String, dynamic>.from(event.snapshot.value as Map);

        for (String userId in usersMap.keys) {
          await dbRef.child(users).child(userId).child("joinedGroupId").remove();
        }
      }
      await dbRef.child("groups").child(groupId).remove();
      if (onComplete != null) {
        onComplete();
      }
    } catch (error) {
      if (onError != null) {
        onError(error);
      }
    }
  }


  Stream<GroupModel?> getGroupStreamById({required String groupId}) {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    return dbRef
        .child(groups)
        .child(groupId)
        .onValue
        .map((event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map;
        return GroupModel.fromMap(Map<String, dynamic>.from(data));
      } else {
        return null;
      }
    });
  }

}
