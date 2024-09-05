import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/data/category_model.dart';
import 'package:groupchat/repositories/categories_repository.dart';

final categoriesProvider = ChangeNotifierProvider((ref) => CategoriesProvider());

class CategoriesProvider extends ChangeNotifier{

  List<String>? categoriesTitles;
  List<CategoryModel>? categoriesList;
  List<CategoryModel>? filteredCategoriesList;

  getCategoriesList(){
    if(categoriesTitles!=null){
      return;
    }
    categoriesTitles ??= [];
    categoriesTitles?.add('General Information'.tr());
    categoriesTitles?.add('Excursions'.tr());
    categoriesTitles?.add('Useful Information'.tr());
  }

  void listenToAllCategoriesForAdmin(String type){
    filteredCategoriesList = null;
    categoriesList = null;
    CategoriesRepository().getAllCategoriesStreamForAdmin(type).listen((categoriesData) {
      categoriesList = categoriesData.values.toList();
      categoriesList?.sort((a, b) => b.timeStamp!.compareTo(a.timeStamp!));
      filteredCategoriesList = categoriesData.values.toList();
      filteredCategoriesList?.sort((a, b) => b.timeStamp!.compareTo(a.timeStamp!));
      notifyListeners();
    });
  }

  void listenToCategories(String type, String myCountry) {
    if(categoriesList!=null){
      filteredCategoriesList = [];
      categoriesList?.forEach((element) {
        if(element.category == type){
          filteredCategoriesList?.add(element);
        }
      });
      notifyListeners();
      return;
    }
    categoriesList ??= [];
    CategoriesRepository().getCategoriesStream(myCountry).listen((categoriesData) {
      filteredCategoriesList = [];
      categoriesList = categoriesData.values.toList();
      categoriesList?.sort((a, b) => b.timeStamp!.compareTo(a.timeStamp!));
      categoriesList?.forEach((element) {
        if(element.category == type){
          filteredCategoriesList?.add(element);
        }
      });
      notifyListeners();
    });
  }

  clearPro(){
    filteredCategoriesList = null;
    categoriesList = null;
    categoriesTitles = null;
    notifyListeners();
  }
}