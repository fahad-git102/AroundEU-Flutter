import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:groupchat/core/static_keys.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:groupchat/data/company_model.dart';
import 'package:groupchat/data/company_time_scheduled.dart';
import 'package:groupchat/firebase/auth.dart';

import '../firebase/firebase_crud.dart';

class CompanyRepository {
  Future<void> addCompany(CompanyModel companyModel, BuildContext context,
      Function() onComplete, Function(dynamic p0) onError) async {
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

  Future<void> updateCompany(CompanyModel company, BuildContext context,
      Function() onComplete, Function(dynamic p0) onError) async {
    FirebaseCrud().updateData(
        key: "$companies/${company.id}",
        context: context,
        data: company.toMap(),
        onComplete: onComplete,
        onCatchError: onError);
  }

  deleteCompany(BuildContext ctx, String companyId) {
    FirebaseDatabase.instance
        .ref(companies)
        .child(companyId)
        .remove()
        .then((value) =>
            Utilities().showCustomToast(isError: false, message: 'Company deleted successfully'.tr()))
        .onError((error, stackTrace) =>
            Utilities().showCustomToast(isError: true, message: error.toString()));
  }

  Future<void> updateMyCompanySchedule(
      Map<String, dynamic> map, String id, BuildContext context,
      Function() onComplete,
      Function(dynamic p0) onError) async{
    FirebaseCrud().updateData(
        key: "$companyTimeScheduled/$id",
        context: context,
        data: map,
        onComplete: onComplete,
        onCatchError: onError);
  }

  Future<void> addMyCompanyTimeScheduled(
      CompanyTimeScheduled companyTScheduled,
      BuildContext context,
      Function() onComplete,
      Function(dynamic p0) onError) async {
    String? key =
        FirebaseDatabase.instance.ref(companyTimeScheduled).push().key;
    companyTScheduled.id = key;
    FirebaseCrud().setData(
      key: "$companyTimeScheduled/$key",
      context: context,
      data: companyTScheduled.toMap(),
      onComplete: onComplete,
      onCatchError: onError,
    );
  }

  Stream<Map<String, CompanyModel>> getCompaniesStream() {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    return dbRef.child(companies).onValue.map((event) {
      final data = event.snapshot.value != null
          ? Map<String, dynamic>.from(event.snapshot.value as Map)
          : {};
      return data.map((key, value) => MapEntry(
          key, CompanyModel.fromMap(Map<String, dynamic>.from(value))));
    });
  }

  Stream<Map<String, CompanyTimeScheduled>> getMyCompanyStream() {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    return dbRef
        .child(companyTimeScheduled)
        .orderByChild('uid')
        .equalTo(Auth().currentUser?.uid)
        .onValue
        .map((event) {
      final data = event.snapshot.value != null
          ? Map<String, dynamic>.from(event.snapshot.value as Map)
          : {};
      return data.map((key, value) => MapEntry(
          key, CompanyTimeScheduled.fromMap(Map<String, dynamic>.from(value))));
    });
  }

  Future<Map<dynamic, dynamic>?> getMyCompany(String id) async {
    var result = await FirebaseCrud().getDateOnce(key: '$companies/$id');

    if (result == null) {
      print("Error: No data found for id $id");
      return null; // or return an empty map {} if that's more appropriate
    }

    return result as Map<dynamic, dynamic>;
  }
}
