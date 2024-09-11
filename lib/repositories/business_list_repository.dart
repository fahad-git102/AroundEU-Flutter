import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:groupchat/data/business_list_model.dart';

import '../core/static_keys.dart';
import '../firebase/firebase_crud.dart';

class BusinessListRepository{

  Future<void> addBusinessList(BusinessList businessListModel, BuildContext context,
      Function() onComplete, Function(dynamic p0) onError) async {
    String? key = FirebaseDatabase.instance.ref(businessLists).push().key;
    businessListModel.key = key;
    FirebaseCrud().setData(
      key: "$businessLists/$key",
      context: context,
      data: businessListModel.toMap(),
      onComplete: onComplete,
      onCatchError: onError,
    );
  }

  Stream<Map<String, BusinessList>> getBusinessListStream() {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    return dbRef.child(businessLists)
        .orderByChild('deleted')
        .equalTo(false)
        .onValue
        .map((event) {
      final data = event.snapshot.value != null
          ? Map<String, dynamic>.from(event.snapshot.value as Map)
          : {};
      return data.map((key, value) => MapEntry(key, BusinessList.fromMap(Map<String, dynamic>.from(value))));
    });
  }

  Future<void> updateBusinessList(BusinessList business, BuildContext context,
      Function() onComplete, Function(dynamic p0) onError) async {
    FirebaseCrud().updateData(
        key: "$businessLists/${business.key}",
        context: context,
        data: business.toMap(),
        onComplete: onComplete,
        onCatchError: onError);
  }

  deleteBusinessList(BuildContext ctx, String businessKey,
      Function() onComplete, Function(dynamic p0) onError) {
    Map<String, dynamic> map = {
      'deleted': true
    };
    FirebaseCrud().updateData(
        key: "$businessLists/$businessKey",
        context: ctx,
        data: map,
        onComplete: onComplete,
        onCatchError: onError);
  }

}