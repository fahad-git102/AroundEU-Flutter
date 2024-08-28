import 'dart:convert';
import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:groupchat/data/country_model.dart';
import 'package:groupchat/data/users_model.dart';
import 'package:mime/mime.dart';

import '../core/static_keys.dart';
import '../core/utilities_class.dart';
import '../firebase/auth.dart';
import '../firebase/firebase_crud.dart';

class UsersRepository{

  Future<void> addUser(AppUser user, BuildContext context, Function() onComplete, Function(dynamic p0) onError) async {
    FirebaseCrud().setData(
      key: "$users/${Auth().currentUser!.uid}",
      context: context,
      data: user.toMap(),
      onComplete: onComplete,
      onCatchError: onError,
    );
  }

  Future<void> addCountry(CountryModel country, BuildContext context, Function() onComplete, Function(dynamic p0) onError) async {
    String? key = FirebaseDatabase.instance.ref(countries).push().key;
    FirebaseCrud().setData(
      key: "$countries/$key",
      context: context,
      data: country.toMap(),
      onComplete: onComplete,
      onCatchError: onError,
    );
  }

  Future<void> updateUser(Map<String, dynamic> user, BuildContext context, Function() onComplete, Function(dynamic p0) onError) async {
    FirebaseCrud().updateData(
      key: "$users/${Auth().currentUser!.uid}",
      context: context,
      data: user,
      onComplete: onComplete,
    );
  }

  Future<String> uploadProfileImage({
    required BuildContext context,
    required File file}) async {
    final bytes = await file.readAsBytes();
    var b64 = base64.encode(bytes);
    var mime = lookupMimeType('', headerBytes: bytes);
    var extension = extensionFromMime(mime!);
    var path = '$media/${DateTime
        .now()
        .millisecondsSinceEpoch}_${file.path
        .split('/')
        .last}';
    final storageRef =
    FirebaseStorage.instance.ref().child(path);
    await storageRef
        .putString(b64,
        format: PutStringFormat.base64,
        metadata: SettableMetadata(contentType: extension ?? 'image/png'))
        .then((p0) => print('uploaded to firebase storage successfully'));
    String downloadUrl = (await FirebaseStorage.instance
        .ref()
        .child(path)
        .getDownloadURL())
        .toString();
    return downloadUrl;
  }

  Future<Map<dynamic, dynamic>> getCurrentUser() async {
    var obj = await FirebaseCrud().getDateOnce(key: '$users/${Auth().currentUser!.uid}')
    as Map<dynamic, dynamic>;
    return obj;
  }

  Future<Object?> getAllUsers({required String key}) async {
    var obj = await FirebaseCrud().getDateOnce(key: users)
    as Map<dynamic, dynamic>;
    return obj;
  }

  Stream<AppUser> getUserStream(String uid) {
    var dfRef = FirebaseDatabase.instance.ref();
    return dfRef.child(users).child(uid).onValue.map((event) {
      final data = event.snapshot.value != null
          ? Map<String, dynamic>.from(event.snapshot.value as Map)
          : {};
      return AppUser.fromMap(data);
    });
  }

  Stream<Map<String, CountryModel>> getCountriesStream() {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    return dbRef.child(countries).onValue.map((event) {
      final data = event.snapshot.value != null
          ? Map<String, dynamic>.from(event.snapshot.value as Map)
          : {};
      return data.map((key, value) => MapEntry(key, CountryModel.fromMap(Map<String, dynamic>.from(value))));
    });
  }

  deleteCountry(BuildContext ctx, String countryId) {
    FirebaseDatabase.instance
        .ref(countries)
        .child(countryId)
        .remove()
        .then((value) =>
        Utilities().showSnackbar(ctx, 'Country deleted successfully'.tr()))
        .onError((error, stackTrace) =>
        Utilities().showSnackbar(ctx, error.toString()));
  }

}