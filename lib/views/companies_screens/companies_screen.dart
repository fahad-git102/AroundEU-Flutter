import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:groupchat/component_library/companies_widgets/companies_list_widget.dart';
import 'package:groupchat/component_library/dialogs/custom_dialog.dart';
import 'package:groupchat/component_library/text_fields/simple_text_field.dart';
import 'package:groupchat/core/size_config.dart';
import 'package:groupchat/core/static_keys.dart';
import 'package:groupchat/data/country_model.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/providers/companies_provider.dart';
import 'package:groupchat/repositories/companies_repository.dart';
import 'package:groupchat/views/companies_screens/company_detail_screen.dart';
import 'package:groupchat/views/drawer_screens/add_new_company_screen.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/app_bars/custom_app_bar.dart';
import '../../core/app_colors.dart';
import '../../core/assets_names.dart';
import '../../data/company_model.dart';

class CompaniesScreen extends StatefulWidget {
  static const route = 'CompaniesScreen';

  @override
  State<StatefulWidget> createState() => _CompaniesScreenState();
}

class _CompaniesScreenState extends State<CompaniesScreen> {
  CountryModel? selectedCountry;
  TextEditingController searchController = TextEditingController();

  updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(child: Consumer(
        builder: (ctx, ref, child) {
          var appUserPro = ref.watch(appUserProvider);
          var companiesPro = ref.watch(companiesProvider);
          if (selectedCountry == null &&
              (appUserPro.countriesList != null &&
                  appUserPro.countriesList!.isNotEmpty)) {
            selectedCountry = appUserPro.countriesList?.first;
          }
          if (companiesPro.allCompaniesList == null) {
            companiesPro.listenToCompanies(
                selectedCountry: appUserPro.countriesList?.first.countryName);
          }
          if(companiesPro.filteredCompaniesList==null&&companiesPro.allCompaniesList!=null){
            selectedCountry??= appUserPro.countriesList?[0];
            companiesPro.filterCompanies(companiesPro.selectedCountry?.countryName??
                selectedCountry?.countryName??appUserPro.countriesList?[0].countryName);
          }
          return Container(
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Images.mainBackground),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(
                  title: 'Companies'.tr(),
                  onTap: (){
                    companiesPro.filteredCompaniesList=null;
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  height: 10.0.sp,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                  child: Container(
                    width: SizeConfig.screenWidth,
                    padding: EdgeInsets.symmetric(vertical: 5.0.sp),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black87.withOpacity(0.25),
                            blurRadius: 4,
                            offset: const Offset(1, 1), // Shadow position
                          ),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(4.sp))),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<CountryModel>(
                        value: companiesPro.selectedCountry ??
                            selectedCountry ??
                            appUserPro.countriesList?.first,
                        style: TextStyle(color: AppColors.lightBlack),
                        items:
                            appUserPro.countriesList!.map((CountryModel value) {
                          return DropdownMenuItem<CountryModel>(
                            value: value,
                            child: Text(value.countryName ?? ''),
                          );
                        }).toList(),
                        buttonStyleData: ButtonStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 5.0.sp),
                          height: 43,
                        ),
                        onChanged: (newValue) {
                          selectedCountry = newValue!;
                          companiesPro.selectedCountry = selectedCountry;
                          companiesPro
                              .filterCompanies(selectedCountry?.countryName);
                          updateState();
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 7.0.sp,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                  child: Container(
                    width: SizeConfig.screenWidth,
                    padding: EdgeInsets.symmetric(vertical: 4.0.sp),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black87.withOpacity(0.25),
                            blurRadius: 4,
                            offset: const Offset(1, 1), // Shadow position
                          ),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(4.sp))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 3.0.sp, horizontal: 10.0.sp),
                      child: SimpleTextField(
                        controller: searchController,
                        noBorder: true,
                        onChanged: (str) {
                          companiesPro.searchCompanies(
                              str ?? '',
                              companiesPro.selectedCountry?.countryName ??
                                  selectedCountry?.countryName ??
                                  appUserPro.countriesList!.first.countryName!);
                        },
                        hintText: 'Search'.tr(),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 9.0.sp,
                ),
                Expanded(
                    child: companiesPro.allCompaniesList != null &&
                            companiesPro.filteredCompaniesList != null
                        ? ListView.builder(
                            itemCount:
                                companiesPro.filteredCompaniesList?.length,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 11.0.sp),
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, CompanyDetailScreen.route,
                                      arguments: {
                                        'company': companiesPro
                                            .filteredCompaniesList?[index]
                                            .toMap()
                                      });
                                },
                                child: CompaniesListWidget(
                                  isAdmin:
                                      appUserPro.currentUser?.admin ?? false,
                                  title: companiesPro
                                          .filteredCompaniesList?[index]
                                          .fullLegalName ??
                                      companiesPro.filteredCompaniesList?[index]
                                          .legalRepresentative ??
                                      '',
                                  companySize: companiesPro
                                          .filteredCompaniesList?[index].size ??
                                      '',
                                  address:
                                      '${companiesPro.filteredCompaniesList?[index].city}, ${companiesPro.filteredCompaniesList?[index].country}',
                                  onOptionSelected: (value) {
                                    if (value == 0) {
                                      Navigator.pushNamed(context, AddNewCompanyScreen.route, arguments: {
                                        'edit': true,
                                        'company': companiesPro.filteredCompaniesList?[index].toMap()
                                      });
                                    } else if (value == 1) {
                                      showDeleteCompanyDialog(companiesPro.filteredCompaniesList![index]);
                                    }
                                  },
                                ),
                              );
                            },
                          )
                        : Center(
                            child: SpinKitPulse(
                              color: AppColors.mainColorDark,
                            ),
                          ))
              ],
            ),
          );
        },
      )),
    );
  }

  showDeleteCompanyDialog(CompanyModel company){
    showDialog(context: context, builder: (ctx)=> CustomDialog(
      title2: "Are you sure you want to delete this company ?".tr(),
      btn1Text:'Delete'.tr(),
      btn2Text: 'Cancel'.tr(),
      btn1Outlined: true,
      btn1Color: AppColors.red,
      onBtn2Tap: (){
        Navigator.pop(context);
      },
      onBtn1Tap: (){
        CompanyRepository().deleteCompany(ctx, company.id??'');
        if(searchController.text.isNotEmpty){
          searchController.clear();
        }
        Navigator.pop(context);
      },
    ));
  }

}
