import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/data/country_model.dart';
import 'package:groupchat/data/users_model.dart';
import 'package:groupchat/repositories/users_repository.dart';

import '../core/static_keys.dart';
import '../firebase/auth.dart';

final appUserProvider = ChangeNotifierProvider((ref) => AppUserProvider());

class AppUserProvider extends ChangeNotifier{

  AppUser? currentUser;
  List<CountryModel>? countriesList;

  getCurrentUser() async {
    var map = await UsersRepository().getCurrentUser();
    currentUser = AppUser.fromMap(map);
    notifyListeners();
  }

  void listenToCountries() {
    if(countriesList!=null){
      return;
    }
    countriesList??=[];
    UsersRepository().getCountriesStream().listen((countriesData) {
      countriesList = countriesData.values.toList();
      notifyListeners();
    });
  }
}