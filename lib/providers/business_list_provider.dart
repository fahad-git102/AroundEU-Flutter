import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/data/business_list_model.dart';
import 'package:groupchat/repositories/business_list_repository.dart';

import '../firebase/auth.dart';

final businessListProvider = ChangeNotifierProvider((ref) => BusinessListProvider());

class BusinessListProvider extends ChangeNotifier{
  List<BusinessList>? businessLists, filteredBusinessList;

  // listenToBusinessList(){
  //   if(businessLists!=null){
  //     return;
  //   }
  //   BusinessListRepository().getBusinessListStream().listen((businessData){
  //     businessLists??=[];
  //     businessLists = businessData.values.toList();
  //     businessLists?.sort((a, b) => b.timeStamp!.compareTo(a.timeStamp!));
  //
  //     for(BusinessList item in businessLists??[]){
  //       if(item.unReadFlags!=null){
  //         if(item.unReadFlags!.containsKey(Auth().currentUser?.uid) &&
  //             item.unReadFlags![Auth().currentUser?.uid] == true){
  //           item.showDot = true;
  //         }else{
  //           item.showDot = false;
  //         }
  //       }
  //     }
  //
  //     notifyListeners();
  //   });
  // }

  listenToBusinessList() {
    if (businessLists != null) {
      return;
    }

    BusinessListRepository().getBusinessListStream().listen((businessData) {
      businessLists ??= [];
      List<BusinessList> incomingBusinessLists = businessData.values.toList();
      incomingBusinessLists.sort((a, b) => b.timeStamp!.compareTo(a.timeStamp!));
      for (BusinessList incomingItem in incomingBusinessLists) {
        int index = businessLists!.indexWhere((item) => item.key == incomingItem.key);
        if (index != -1) {
          businessLists![index] = incomingItem;
        } else {
          businessLists!.add(incomingItem);
        }
        if(filteredBusinessList!=null && filteredBusinessList!.isNotEmpty){
          int index = filteredBusinessList!.indexWhere((item) => item.key == incomingItem.key);
          if (index != -1) {
            filteredBusinessList![index] = incomingItem;
          }
        }
      }
      businessLists!.sort((a, b) => b.timeStamp!.compareTo(a.timeStamp!));
      for (BusinessList item in businessLists!) {
        if (item.unReadFlags != null) {
          if (item.unReadFlags!.containsKey(Auth().currentUser?.uid) &&
              item.unReadFlags![Auth().currentUser?.uid] == true) {
            item.showDot = true;
          } else {
            item.showDot = false;
          }
        }
      }

      notifyListeners();
    });
  }


  filterBusinessListByCountry(String countryId){
    filteredBusinessList = [];
    for(BusinessList item in businessLists??[]){
      if(item.countryId == countryId){
        filteredBusinessList?.add(item);
      }
    }
  }

}