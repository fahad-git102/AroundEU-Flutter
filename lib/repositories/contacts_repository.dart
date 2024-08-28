import 'package:firebase_database/firebase_database.dart';
import 'package:groupchat/core/static_keys.dart';
import 'package:groupchat/data/coordinators_contact_model.dart';
import 'package:groupchat/data/emergency_contact_model.dart';

class ContactsRepository{

  Stream<Map<String, CoordinatorsContact>> getCoordinatorsContactsStream() {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    return dbRef.child(coordinators)
        .onValue
        .map((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      return data.map((key, value) => MapEntry(key, CoordinatorsContact.fromMap(Map<String, dynamic>.from(value))));
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