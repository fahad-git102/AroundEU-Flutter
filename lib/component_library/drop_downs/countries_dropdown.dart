import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_colors.dart';
import '../../core/size_config.dart';
import '../../data/country_model.dart';

class CountriesDropDown extends StatefulWidget{

  final CountryModel? selectedCountry;
  final Function(CountryModel country)? onChanged;

  const CountriesDropDown({super.key, this.selectedCountry, this.onChanged});

  @override
  State<StatefulWidget> createState() => _CountriesDropDownState();

}

class _CountriesDropDownState extends State<CountriesDropDown>{
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (ctx, ref, child){
      var appUserPro = ref.watch(appUserProvider);
      appUserPro.listenToCountries();
      return Container(
          padding: EdgeInsets.symmetric(vertical: 4.0.sp),
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.lightFadedTextColor, width: 0.4.sp),
              borderRadius: BorderRadius.all(
                  Radius.circular(4.sp))),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<CountryModel>(
              value: widget.selectedCountry?? appUserPro.countriesList?[0],
              style: TextStyle(color: AppColors.lightBlack),
              items: appUserPro.countriesList!=null?appUserPro.countriesList!.map((CountryModel country) {
                return DropdownMenuItem<CountryModel>(
                  value: country,
                  child: Text(country.countryName??''),
                );
              }).toList():[],
              buttonStyleData: ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 5.0.sp),
                height: 43,
              ),
              onChanged: (newValue) {
                widget.onChanged!(newValue!);
              },
            ),
          ));
    });
  }

}