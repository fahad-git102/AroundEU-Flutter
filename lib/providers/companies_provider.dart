import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/data/company_time_scheduled.dart';
import 'package:groupchat/repositories/companies_repository.dart';

import '../data/company_model.dart';
import '../data/country_model.dart';

final companiesProvider = ChangeNotifierProvider((ref) => CompaniesProvider());

class CompaniesProvider extends ChangeNotifier {
  CompanyTimeScheduled? myCompanyTimeScheduled;
  List<CompanyModel>? allCompaniesList;
  List<CompanyModel>? filteredCompaniesList;
  CompanyModel? myCompany;
  CountryModel? selectedCountry;

  listenToCompanies({String? selectedCountry}) {
    allCompaniesList?.clear();
    filteredCompaniesList?.clear();
    CompanyRepository().getCompaniesStream().listen((companiesData) {
      allCompaniesList ??= [];
      filteredCompaniesList = [];

      allCompaniesList = companiesData.entries.map((entry) {
        return CompanyModel(
            id: entry.key,
            city: entry.value.city,
            companyDescription: entry.value.companyDescription,
            companyResponsibility: entry.value.companyResponsibility,
            contactPerson: entry.value.contactPerson,
            email: entry.value.email,
            country: entry.value.country,
            fullLegalName: entry.value.fullLegalName,
            legalAddress: entry.value.legalAddress,
            poastalCode: entry.value.poastalCode,
            selectedCountry: entry.value.selectedCountry,
            taskOfStudents: entry.value.taskOfStudents,
            telephone: entry.value.telephone,
            website: entry.value.website);
      }).toList();
      if (selectedCountry != null) {
        allCompaniesList?.forEach((element) {
          if (element.selectedCountry == selectedCountry) {
            filteredCompaniesList?.add(element);
          }
        });
      } else {
        filteredCompaniesList?.clear();
      }
      notifyListeners();
    });
  }

  resetSelectedCountry(CountryModel country){
    selectedCountry = country;
    notifyListeners();
  }

  void searchCompanies(String query, String selectedCountry) {
    filteredCompaniesList = allCompaniesList?.where((company) {
      final lowerCaseQuery = query.toLowerCase();
      return company.selectedCountry == selectedCountry&&(company.city?.toLowerCase().contains(lowerCaseQuery) == true ||
          company.fullLegalName?.toLowerCase().contains(lowerCaseQuery) == true ||
          company.country?.toLowerCase().contains(lowerCaseQuery) == true ||
          company.legalAddress?.toLowerCase().contains(lowerCaseQuery) == true ||
          false);
    }).toList();
    notifyListeners();
  }

  filterCompanies(String? selectedCountry) {
    filteredCompaniesList = [];
    if (selectedCountry != null) {
      allCompaniesList?.forEach((element) {
        if (element.selectedCountry == selectedCountry) {
          filteredCompaniesList?.add(element);
        }
      });
    } else {
      filteredCompaniesList?.clear();
    }
    notifyListeners();
  }

  listenToMyCompanyTimeScheduled() async {
    if(myCompanyTimeScheduled != null && myCompany != null){
      return;
    }
    CompanyRepository().getMyCompanyStream().listen((event) {
      if(event.entries.isNotEmpty){
        myCompanyTimeScheduled = event.values.first;
        myCompanyTimeScheduled?.id = event.keys.first;
        getMyCompany(myCompanyTimeScheduled?.companyId);
        notifyListeners();
      }
    });
  }

  getMyCompany(String? id) async {
    if (id != null) {
      var map = await CompanyRepository().getMyCompany(id);
      myCompany = CompanyModel.fromMap(map??{});
      notifyListeners();
    }
  }
}
