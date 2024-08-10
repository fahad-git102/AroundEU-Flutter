import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:groupchat/core/static_keys.dart';
import 'package:groupchat/data/category_model.dart';

import '../firebase/firebase_crud.dart';

class CategoriesRepository{
  Future<void> addCategory(CategoryModel categoryModel, BuildContext context, Function() onComplete, Function(dynamic p0) onError) async {
    String? key = FirebaseDatabase.instance.ref(categories).push().key;
    categoryModel.categoryId = key;
    FirebaseCrud().setData(
      key: "$categories/$key",
      context: context,
      data: categoryModel.toMap(),
      onComplete: onComplete,
      onCatchError: onError,
    );
  }
  Stream<Map<String, CategoryModel>> getCategoriesStream(String myCountry) {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    return dbRef.child(categories)
        .orderByChild('country')
        .equalTo(myCountry)
        .onValue
        .map((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      return data.map((key, value) => MapEntry(key, CategoryModel.fromMap(Map<String, dynamic>.from(value))));
    });
  }
}