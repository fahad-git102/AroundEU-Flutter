import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

import '../core/static_keys.dart';
import '../data/places_model.dart';
import '../firebase/firebase_crud.dart';

class PlacesRepository{
  Future<void> addPlace(EUPlace place, BuildContext context, Function() onComplete, Function(dynamic p0) onError) async {
    String? key = place.key ?? FirebaseDatabase.instance.ref(places).push().key;
    FirebaseCrud().setData(
      key: "$places/$key",
      context: context,
      data: place.toMap(),
      onComplete: onComplete,
      onCatchError: onError,
    );
  }
  Future<Object?> getPlaces({String? myCountry}) async {
    final ref = FirebaseDatabase.instance.ref();
    final data = await ref.child(places).orderByChild('country')
        .equalTo(myCountry).once();
    if (data.snapshot.exists) {
      return data.snapshot.value;
    } else {
      return null;
    }
  }
  Stream<Map<String, EUPlace>> getPlacesStream({required String myCountry}) {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    return dbRef.child(places)
        .orderByChild('country')
        .equalTo(myCountry)
        .onValue
        .map((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      return data.map((key, value) => MapEntry(key, EUPlace.fromMap(Map<String, dynamic>.from(value))));
    });
  }
}