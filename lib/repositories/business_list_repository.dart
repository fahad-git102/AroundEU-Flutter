import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:groupchat/data/business_list_model.dart';

import '../core/static_keys.dart';
import '../data/group_model.dart';
import '../firebase/auth.dart';
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

  resetFlagForMe(BuildContext context, BusinessList? businesslist) async {
    if(businesslist?.unReadFlags == null){
      return;
    }
    if(businesslist?.unReadFlags?.containsKey(Auth().currentUser?.uid) == true && businesslist?.unReadFlags?[Auth().currentUser?.uid] == true){
      final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
      await databaseRef.child('$businessLists/${businesslist?.key}').child("unReadFlags").update({
        Auth().currentUser?.uid??'': false,
      }).then((_) {
        print("Flag updated successfully.");
      }).catchError((error) {
        print("Failed to update flag: $error");
      });
    }
  }

  incrementUnreadFlagsForCountries(
      BuildContext context, GroupModel groupModel, BuildContext ctx,
      List<String> adminIds, List<String> coordinatorsIds, BusinessList businessList,
      Function() onComplete, Function(dynamic) onError) {
    bool shouldLoad = false;
    if(businessList.unReadFlags!=null){
      for(var entry in businessList.unReadFlags!.entries){
        if(entry.key!=Auth().currentUser?.uid&&entry.value == false){
          shouldLoad = true;
        }
      }
    }else{
      shouldLoad = true;
    }

    final usersList = [
      ...groupModel.approvedMembers
          ?.where((item) => item != Auth().currentUser?.uid && coordinatorsIds.contains(item))
          ?? <String>[],
      ...adminIds
    ];

    if(usersList.length!=businessList.unReadFlags?.length){
      shouldLoad = true;
    }

    if(shouldLoad){
      Map<String, dynamic> newMap = {for (var element in usersList.where((e) => e != null)) element!: true};
      FirebaseCrud().updateData(
          key: "$businessLists/${businessList.key}/unReadFlags",
          context: ctx,
          data: newMap,
          onComplete: onComplete,
          onCatchError: onError);
    }

  }


}