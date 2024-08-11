import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:groupchat/core/static_keys.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:mime/mime.dart';

class FirebaseCrud {
  Future<void> setData({required String key,
    required BuildContext context,
    required Map<String, dynamic> data,
    required Function()? onComplete,
    Function(dynamic)? onCatchError}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(key);
    await ref.set(data).then((_) {
      onComplete!();
    }).catchError((error) {
      onCatchError!(error) ?? Utilities().showSnackbar(context, error.toString());
    });
  }

  Future<void> updateData({required String key,
    required BuildContext context,
    required Map<String, dynamic> data,
    required Function() onComplete,
    Function(dynamic)? onCatchError}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(key);
    await ref.update(data).then((_) {
      onComplete();
    }).catchError((error) {
      onCatchError!(error) ?? Utilities().showSnackbar(context, error.toString());
    });
  }

  Future<String> uploadImage({
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

  Future<Object?> getDateOnce({required String key}) async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child(key).get();
    if (snapshot.exists) {
      return snapshot.value;
    } else {
      return null;
    }
  }

  Future<Object?> getUserName({required String uid}) async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('$users/$uid/fullName').get();
    if (snapshot.exists) {
      return snapshot.value;
    } else {
      return null;
    }
  }

}