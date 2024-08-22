import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/data/coordinators_contact_model.dart';
import 'package:groupchat/data/emergency_contact_model.dart';
import 'package:groupchat/repositories/contacts_repository.dart';


final contactsProvider = ChangeNotifierProvider((ref) => ContactsProvider());

class ContactsProvider extends ChangeNotifier{

  List<CoordinatorsContact>? coordinatorsContactsList;
  List<EmergencyContactModel>? emergencyContactsList;

  void listenToCoordinators() {
    if(coordinatorsContactsList!=null){
      return;
    }
    ContactsRepository().getCoordinatorsContactsStream().listen((coordinatorsData) {
      coordinatorsContactsList ??= [];
      coordinatorsContactsList = coordinatorsData.entries.map((entry) {
        return CoordinatorsContact(
          id: entry.key,
          phone: entry.value.phone,
          text: entry.value.text
        );
      }).toList();
      notifyListeners();
    });
  }
  void listenToEmergencyContacts() {
    if(emergencyContactsList!=null){
      return;
    }
    ContactsRepository().getEmergencyContactsStream().listen((emergencyData) {
      emergencyContactsList ??= [];
      emergencyContactsList = emergencyData.values.toList();
      notifyListeners();
    });
  }
}