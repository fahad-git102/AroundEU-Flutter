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

  Future<void> updatePlace(Map<String, dynamic> map, String placeKey, BuildContext context,
      Function() onComplete, Function(dynamic p0) onError) async {
    FirebaseCrud().updateData(
        key: "$places/$placeKey",
        context: context,
        data: map,
        onComplete: onComplete,
        onCatchError: onError);
  }

  deletePlace(BuildContext ctx, String placeKey,
      Function() onComplete, Function(dynamic p0) onError) {
    FirebaseDatabase.instance
        .ref(places)
        .child(placeKey)
        .remove()
        .then((value) {
          onComplete();
    }).onError((error, stackTrace){
      onError(error);
    });
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
      final data = event.snapshot.value != null
          ? Map<String, dynamic>.from(event.snapshot.value as Map)
          : {};
      return data.map((key, value) => MapEntry(key, EUPlace.fromMap(Map<String, dynamic>.from(value))));
    });
  }
  Stream<Map<String, EUPlace>> getAllPlacesStream() {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    return dbRef.child(places)
        .onValue
        .map((event) {
      final data = event.snapshot.value != null
          ? Map<String, dynamic>.from(event.snapshot.value as Map)
          : {};
      return data.map((key, value) => MapEntry(key, EUPlace.fromMap(Map<String, dynamic>.from(value))));
    });
  }

  Stream<Map<String, EUPlace>> getPendingPlacesStream() {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    return dbRef.child(places)
        .orderByChild('status')
        .equalTo('pending')
        .onValue
        .map((event) {
      final data = event.snapshot.value != null
          ? Map<String, dynamic>.from(event.snapshot.value as Map)
          : {};
      return data.map((key, value) => MapEntry(key, EUPlace.fromMap(Map<String, dynamic>.from(value))));
    });
  }
}