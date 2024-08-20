import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:groupchat/data/news_model.dart';

import '../core/static_keys.dart';
import '../firebase/firebase_crud.dart';

class NewsRepository{
  Future<void> addNews(NewsModel newsModel, BuildContext context, Function() onComplete, Function(dynamic p0) onError) async {
    String? key = newsModel.id ?? FirebaseDatabase.instance.ref(news).push().key;
    FirebaseCrud().setData(
      key: "$news/$key",
      context: context,
      data: newsModel.toMap(),
      onComplete: onComplete,
      onCatchError: onError,
    );
  }
  Stream<Map<String, NewsModel>> getNewsStream({required String myCountry}) {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    return dbRef.child(news)
        .orderByChild('country')
        .equalTo(myCountry)
        .onValue
        .map((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      return data.map((key, value) => MapEntry(key, NewsModel.fromMap(Map<String, dynamic>.from(value))));
    });
  }
}