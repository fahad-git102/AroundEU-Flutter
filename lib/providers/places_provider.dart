import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/data/places_model.dart';
import 'package:groupchat/repositories/places_repository.dart';
import 'package:groupchat/repositories/users_repository.dart';

final placesProvider = ChangeNotifierProvider((ref) => PlacesProvider());

class PlacesProvider extends ChangeNotifier{

  List<EUPlace>? placesList;
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
      placesList ??= [];
      filteredPlacesList ??= [];
      placesList = placesData.values.toList();
      placesList?.sort((a, b) => b.timeStamp!.compareTo(a.timeStamp!));
      filteredPlacesList?.addAll(placesList!);
      _fetchUser(filteredPlacesList!);
      _fetchUser(placesList!);
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