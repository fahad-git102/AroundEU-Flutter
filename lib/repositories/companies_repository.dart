import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:groupchat/core/static_keys.dart';
import 'package:groupchat/data/company_model.dart';
import 'package:groupchat/data/company_time_scheduled.dart';
import 'package:groupchat/firebase/auth.dart';

import '../firebase/firebase_crud.dart';

class CompanyRepository{
  Future<void> addCompany(CompanyModel companyModel, BuildContext context, Function() onComplete, Function(dynamic p0) onError) async {
    String? key = FirebaseDatabase.instance.ref(companies).push().key;
    companyModel.id = key;
    FirebaseCrud().setData(
      key: "$companies/$key",
      context: context,
      data: companyModel.toMap(),
      onComplete: onComplete,
      onCatchError: onError,
    );
  }
  Stream<Map<String, CompanyModel>> getCompaniesStream() {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    return dbRef.child(companies)
        .onValue
        .map((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      return data.map((key, value) => MapEntry(key, CompanyModel.fromMap(Map<String, dynamic>.from(value))));
    });
  }

  Stream<Map<String, CompanyTimeScheduled>> getMyCompanyStream() {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    return dbRef.child(companyTimeScheduled)
        .orderByChild('uid')
        .equalTo(Auth().currentUser?.uid)
        .onValue
        .map((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      return data.map((key, value) => MapEntry(key, CompanyTimeScheduled.fromMap(Map<String, dynamic>.from(value))));
    });
  }
  Future<Map<dynamic, dynamic>> getMyCompany(String id) async {
    var obj = await FirebaseCrud().getDateOnce(key: '$companies/$id')
    as Map<dynamic, dynamic>;
    return obj;
  }
}