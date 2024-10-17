import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:groupchat/data/country_model.dart';
import 'package:groupchat/data/users_model.dart';
import 'package:groupchat/repositories/users_repository.dart';

import '../core/static_keys.dart';
import '../firebase/auth.dart';

final appUserProvider = ChangeNotifierProvider((ref) => AppUserProvider());

class AppUserProvider extends ChangeNotifier{

  AppUser? currentUser;
  CountryModel? coordinatorsCountryModel;
  List<CountryModel>? countriesList;
  List<AppUser>? allTeachersList, filteredTeachersList, usersCache, allAdminsList;

  getCurrentUserStream() async {
    UsersRepository().streamCurrentUser().listen((userData) {
      currentUser = userData;
      notifyListeners();
    });
  }

  getCurrentUser() async {
    var map = await UsersRepository().getCurrentUser();
    currentUser = AppUser.fromMap(map);
    notifyListeners();
  }

  getCoordinatorsCountry() async {
    var map = await Utilities().getMap(coordinatorsCountry);
    if(map!=null && map.isNotEmpty){
      coordinatorsCountryModel = CountryModel.fromMap(map);
      notifyListeners();
    }else{
      listenToCountries();
      coordinatorsCountryModel = countriesList?[0];
      notifyListeners();
    }
  }
  
  void listenToCountries() {
    if(countriesList!=null){
      return;
    }
    countriesList??=[];
    UsersRepository().getCountriesStream().listen((countriesData) {
      countriesList = countriesData.entries.map((entry){
        return CountryModel(
          id: entry.key,
          countryName: entry.value.countryName,
          pincode: entry.value.pincode
        );
      }).toList();
      notifyListeners();
    });
  }

  listenToAdmins(){
    if(allAdminsList!=null){
      return;
    }
    UsersRepository().getAllAdminsStream().listen((usersData) {
      if(usersData.isNotEmpty){
        allAdminsList ??= [];
        allAdminsList = usersData.values.toList();
        notifyListeners();
      }else{
        allAdminsList = [];
        notifyListeners();
      }
    });
  }

  void listenToTeachers() {
    if(allTeachersList!=null){
      filterTeachers('');
      return;
    }
    UsersRepository().getAllTeachersStream().listen((usersData) {
      if(usersData.isNotEmpty){
        allTeachersList = usersData.values.toList();
        allTeachersList?.sort((a, b) => a.firstName!.compareTo(b.firstName??''));
        filterTeachers('');
        notifyListeners();
      }else{
        allTeachersList = [];
        notifyListeners();
      }
    });
  }

  void filterTeachers(String query) {
    filteredTeachersList = null;
    if(allTeachersList!=null){
      if (query.isEmpty) {
        filteredTeachersList = List.from(allTeachersList!); // Reset to full list if query is empty
      } else {
        filteredTeachersList = allTeachersList!.where((teacher) {
          String fullName = "${teacher.firstName} ${teacher.surName}".toLowerCase();
          return fullName.contains(query.toLowerCase());
        }).toList();
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  clearPro(){
    currentUser = null;
  }

  CountryModel? getCountryById(String id){
    for(CountryModel country in countriesList??[]){
      if(country.id == id){
        return country;
      }
    }
    return null;
  }

  Future<List<AppUser?>> getUsersListByIds(List<String?>? usersIds) async {
    if (usersIds == null || usersIds.isEmpty) [];
    List<AppUser> fetchedUsers = [];
    await Future.wait(usersIds!.map((id) async {
      AppUser? user = await getUserById(id??'');
      if (user != null) {
        fetchedUsers.add(user);
      }
    }));
    return fetchedUsers;
  }

  Future<AppUser?> getUserById(String userId) async {
    if(usersCache!=null){
      for(AppUser user in usersCache??[]){
        if(user.uid == userId){
          return user;
        }
      }
    }
    if(allTeachersList!=null){
      for(AppUser user in allTeachersList??[]){
        if(user.uid == userId){
          return user;
        }
      }
    }
    DatabaseReference userRef = FirebaseDatabase.instance.ref().child(users).child(userId);
    try {
      DatabaseEvent event = await userRef.once();
      if (event.snapshot.exists) {
        usersCache??=[];
        usersCache?.add(AppUser.fromMap(event.snapshot.value as Map<dynamic, dynamic>));
        return AppUser.fromMap(event.snapshot.value as Map<dynamic, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching user name: $e");
      return null;
    }
  }


  updateSelectedCountry(BuildContext context, AppUserProvider userPro, String? selectedCountry, Function()? onComplete, Function(dynamic p0)? onError) async {
    Map<String, dynamic> map =  {
      'selectedCountry': selectedCountry,
    };
    UsersRepository().updateCurrentUser(map, context, onComplete!, onError!);
  }
}