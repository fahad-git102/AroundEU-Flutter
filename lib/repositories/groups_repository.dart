import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:groupchat/data/group_model.dart';

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

}