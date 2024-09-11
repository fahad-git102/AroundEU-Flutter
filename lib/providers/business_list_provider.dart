import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/data/business_list_model.dart';
import 'package:groupchat/repositories/business_list_repository.dart';

final businessListProvider = ChangeNotifierProvider((ref) => BusinessListProvider());

class BusinessListProvider extends ChangeNotifier{
  List<BusinessList>? businessLists;

  listenToBusinessList(){
    if(businessLists!=null){
      return;
    }
    BusinessListRepository().getBusinessListStream().listen((businessData){
      businessLists??=[];
      businessLists = businessData.values.toList();
      businessLists?.sort((a, b) => b.timeStamp!.compareTo(a.timeStamp!));
      notifyListeners();
    });
  }
}