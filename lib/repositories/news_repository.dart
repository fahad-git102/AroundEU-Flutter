import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:groupchat/data/news_model.dart';

import '../core/static_keys.dart';
import '../core/utilities_class.dart';
import '../firebase/firebase_crud.dart';

class NewsRepository{
  Future<void> addNews(NewsModel newsModel, BuildContext context, Function() onComplete, Function(dynamic p0) onError) async {
    String? key = newsModel.id ?? FirebaseDatabase.instance.ref(news).push().key;
    newsModel.id = key;
    FirebaseCrud().setData(
      key: "$news/$key",
      context: context,
      data: newsModel.toMap(),
      onComplete: onComplete,
      onCatchError: onError,
    );
  }

  Future<void> updateNews(NewsModel newsModel, BuildContext context,
      Function() onComplete, Function(dynamic p0) onError) async {
    FirebaseCrud().updateData(
        key: "$news/${newsModel.id}",
        context: context,
        data: newsModel.toMap(),
        onComplete: onComplete,
        onCatchError: onError);
  }

  Stream<Map<String, NewsModel>> getNewsStream({required String myCountry}) {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    return dbRef.child(news)
        .orderByChild('country')
        .equalTo(myCountry)
        .onValue
        .map((event) {
      final data = event.snapshot.value != null
          ? Map<String, dynamic>.from(event.snapshot.value as Map)
          : {};
      return data.map((key, value) => MapEntry(key, NewsModel.fromMap(Map<String, dynamic>.from(value))));
    });
  }
  Stream<Map<String, NewsModel>> getAllNewsStream() {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    return dbRef.child(news)
        .onValue
        .map((event) {
      final data = event.snapshot.value != null
          ? Map<String, dynamic>.from(event.snapshot.value as Map)
          : {};
      return data.map((key, value) => MapEntry(key, NewsModel.fromMap(Map<String, dynamic>.from(value))));
    });
  }
  deleteNews(BuildContext ctx, String newsId,{Function()? onComplete, Function(dynamic p0)? onError}) {
    FirebaseDatabase.instance
        .ref(news)
        .child(newsId)
        .remove()
        .then((value) {
      onComplete!();
    }).onError((error, stackTrace){
      onError!(error);
    });
  }
}