import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/data/places_model.dart';
import 'package:groupchat/repositories/places_repository.dart';
import 'package:groupchat/repositories/users_repository.dart';

final placesProvider = ChangeNotifierProvider((ref) => PlacesProvider());

class PlacesProvider extends ChangeNotifier{

  List<EUPlace>? placesList;
  List<EUPlace>? pendingPlacesList;
  List<EUPlace>? allPlacesForAdminList;
  List<EUPlace>? filteredPlacesList;
  String? selectedCategory = "All".tr();

  void _fetchUser(List<EUPlace> list) {
    for (int i = 0; i<list.length; i++) {
      UsersRepository().getUserStream(list[i].uid??'').listen((userData) {
        list[i].creatorName = '${userData.firstName} ${userData.surName}';
        notifyListeners();
      });
    }
  }

  void listenToPlaces(String myCountry) {
    placesList?.clear();
    filteredPlacesList?.clear();
    PlacesRepository().getPlacesStream(myCountry: myCountry).listen((placesData) {
      if(placesData.isNotEmpty){
        placesList ??= [];
        filteredPlacesList = [];
        placesList = placesData.entries.map((entry) {
          return EUPlace(
              key: entry.key,
              description: entry.value.description,
              uid: entry.value.uid,
              imageUrl: entry.value.imageUrl,
              category: entry.value.category,
              status: entry.value.status,
              country: entry.value.country,
              creatorName: entry.value.creatorName,
              timeStamp: entry.value.timeStamp,
              location: entry.value.location
          );
        }).toList();
        placesList?.removeWhere((element) => element.status == null || element.status != 'approved');
        placesList?.sort((a, b) => b.timeStamp!.compareTo(a.timeStamp!));
        filteredPlacesList?.addAll(placesList!);
        _fetchUser(filteredPlacesList!);
        _fetchUser(placesList!);
        notifyListeners();
      }else{
        placesList = [];
        filteredPlacesList = [];
        notifyListeners();
      }
    });
  }

  listenToPendingPlaces(){
    if(pendingPlacesList!=null){
      return;
    }
    PlacesRepository().getPendingPlacesStream().listen((placesData) {
      if(placesData.isNotEmpty){
        pendingPlacesList ??= [];
        pendingPlacesList = placesData.entries.map((entry) {
          return EUPlace(
              key: entry.key,
              description: entry.value.description,
              uid: entry.value.uid,
              imageUrl: entry.value.imageUrl,
              category: entry.value.category,
              status: entry.value.status,
              country: entry.value.country,
              creatorName: entry.value.creatorName,
              timeStamp: entry.value.timeStamp,
              location: entry.value.location
          );
        }).toList();
        pendingPlacesList?.sort((a, b) => b.timeStamp!.compareTo(a.timeStamp!));
        _fetchUser(pendingPlacesList??[]);
        notifyListeners();
      }else{
        pendingPlacesList = [];
        notifyListeners();
      }

    });
  }

  void listenToAllPlacesForAdmin() {
    if(allPlacesForAdminList!=null){
      return;
    }
    allPlacesForAdminList?.clear();
    PlacesRepository().getAllPlacesStream().listen((placesData) {
      allPlacesForAdminList??=[];
      allPlacesForAdminList = placesData.entries.map((entry) {
        return EUPlace(
            key: entry.key,
            description: entry.value.description,
            uid: entry.value.uid,
            imageUrl: entry.value.imageUrl,
            category: entry.value.category,
            status: entry.value.status,
            country: entry.value.country,
            creatorName: entry.value.creatorName,
            timeStamp: entry.value.timeStamp,
            location: entry.value.location
        );
      }).toList();
      allPlacesForAdminList?.sort((a, b) => b.timeStamp!.compareTo(a.timeStamp!));
      _fetchUser(allPlacesForAdminList!);
      notifyListeners();
    });
  }

  void filterPlacesList(){
    if(selectedCategory == 'All'.tr()){
      filteredPlacesList?.clear();
      filteredPlacesList?.addAll(placesList!);
    }else{
      filteredPlacesList?.clear();
      for(int a = 0; a < placesList!.length; a++){
        if(placesList?[a].category == selectedCategory){
          filteredPlacesList?.add(placesList![a]);
        }
      }
    }
    notifyListeners();
  }

}