import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:groupchat/core/static_keys.dart';
import 'package:groupchat/data/coordinators_contact_model.dart';
import 'package:groupchat/data/emergency_contact_model.dart';

import '../firebase/firebase_crud.dart';

class ContactsRepository{

  Future<void> addEmergencyContact(EmergencyContactModel contact, BuildContext context, Function() onComplete, Function(dynamic p0) onError) async {
    String? key = FirebaseDatabase.instance.ref(emergency).push().key;
    contact.key = key;
    FirebaseCrud().setData(
      key: "$emergency/$key",
      context: context,
      data: contact.toMap(),
      onComplete: onComplete,
      onCatchError: onError,
    );
  }

  Stream<Map<String, CoordinatorsContact>> getCoordinatorsContactsStream() {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    return dbRef.child(coordinators)
        .onValue
        .map((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      return data.map((key, value) => MapEntry(key, CoordinatorsContact.fromMap(Map<String, dynamic>.from(value))));
    });
  }

  deleteEmergencyContact(BuildContext ctx, String contactId,{Function()? onComplete, Function(dynamic p0)? onError}) {
    FirebaseDatabase.instance
        .ref(emergency)
        .child(contactId)
        .remove()
        .then((value) {
      onComplete!();
    }).onError((error, stackTrace){
      onError!(error);
    });
  }

  Stream<Map<String, EmergencyContactModel>> getEmergencyContactsStream() {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    return dbRef.child(emergency)
        .onValue
        .map((event) {
      final data = event.snapshot.value != null
          ? Map<String, dynamic>.from(event.snapshot.value as Map)
          : {};
      return data.map((key, value) => MapEntry(key, EmergencyContactModel.fromMap(Map<String, dynamic>.from(value))));
    });
  }

}