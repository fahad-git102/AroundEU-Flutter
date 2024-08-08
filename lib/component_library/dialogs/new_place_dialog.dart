import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/component_library/buttons/button.dart';
import 'package:groupchat/component_library/text_fields/simple_text_field.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/assets_names.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/views/places/place_search_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:groupchat/component_library/text_widgets/extra_large_medium_bold_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:sizer/sizer.dart';

import '../../core/size_config.dart';
import '../../data/country_model.dart';

class NewPlaceDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NewPlaceDialogState();
}

class _NewPlaceDialogState extends State<NewPlaceDialog> {
  XFile? pickedFile;
  var categories = [
    "Bars & Restaurants".tr(),
    "Sightseeing places".tr(),
    "Experience".tr()
  ];

  String? location;

  String? selectedCategory = "Bars & Restaurants".tr();
  CountryModel? selectedCountry;
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Consumer(builder: (ctx, ref, child){
        var appUserPro = ref.watch(appUserProvider);
        return Container(
          padding: EdgeInsets.all(13.0.sp),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 5.0.sp,
                ),
                ExtraLargeMediumBoldText(
                  title: 'Add New Place'.tr(),
                  fontSize: 16.0.sp,
                  textColor: AppColors.lightBlack,
                ),
                SizedBox(
                  height: 15.0.sp,
                ),
                InkWell(
                  onTap: () {
                    Utilities().showImagePickerDialog(context,
                        onCameraTap: () async {
                          Navigator.of(context).pop();
                          pickedFile = await Utilities.pickImage(imageSource: 'camera');
                          updateState();
                        }, onGalleryTap: () async {
                          Navigator.of(context).pop();
                          pickedFile =
                          await Utilities.pickImage(imageSource: 'gallery');
                          updateState();
                        });
                  },
                  child: Container(
                      height: 80.0.sp,
                      width: 90.0.sp,
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.0.sp),
                        child: pickedFile != null
                            ? Image.file(
                          File(pickedFile!.path),
                          fit: BoxFit.fill,
                        )
                            : Image.asset(
                          Images.noImagePlaceHolder,
                          fit: BoxFit.fill,
                        ),
                      )),
                ),
                SizedBox(
                  height: 17.0.sp,
                ),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 4.0.sp),
                    width: SizeConfig.screenWidth,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.lightFadedTextColor, width: 0.4.sp),
                        borderRadius: BorderRadius.all(
                            Radius.circular(4.sp))),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        value: selectedCategory,
                        style: TextStyle(color: AppColors.lightBlack),
                        items: categories.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        buttonStyleData: ButtonStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 5.0.sp),
                          height: 43,
                        ),
                        onChanged: (newValue) {
                          selectedCategory = newValue!;
                          updateState();
                        },
                      ),
                    )),
                SizedBox(height: 6.sp,),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 4.0.sp),
                    width: SizeConfig.screenWidth,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.lightFadedTextColor, width: 0.4.sp),
                        borderRadius: BorderRadius.all(
                            Radius.circular(4.sp))),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<CountryModel>(
                        value: selectedCountry?? appUserPro.countriesList?[0],
                        style: TextStyle(color: AppColors.lightBlack),
                        items: appUserPro.countriesList!.map((CountryModel country) {
                          return DropdownMenuItem<CountryModel>(
                            value: country,
                            child: Text(country.countryName??''),
                          );
                        }).toList(),
                        buttonStyleData: ButtonStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 5.0.sp),
                          height: 43,
                        ),
                        onChanged: (newValue) {
                          selectedCountry = newValue!;
                          updateState();
                        },
                      ),
                    )),
                SizedBox(height: 8.sp,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.lightFadedTextColor, width: 0.4.sp),
                            borderRadius: BorderRadius.all(
                                Radius.circular(4.sp))),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 10.0.sp),
                          child: InkWell(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PlaceSearchScreen()),
                              );
                              if(result!=null){
                                location = result;
                                updateState();
                              }
                            },
                            child: SmallLightText(
                              title: location??'Location'.tr(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textColor: AppColors.lightBlack,
                            ),
                          )
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.0.sp),
                      child: SmallLightText(
                        title: 'OR'.tr(),
                        textColor: AppColors.lightFadedTextColor,
                      ),
                    ),
                    Expanded(
                      child: Button(
                        text: 'Pick a location'.tr(),
                        btnTxtColor: AppColors.white,
                        btnColor: AppColors.fadedTextColor2,
                        tapAction: (){

                        },
                      ),
                    )
                  ],
                ),
                SizedBox(height: 6.0.sp,),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 3.0.sp, horizontal: 10.0.sp),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.lightFadedTextColor, width: 0.4.sp),
                      borderRadius: BorderRadius.all(
                          Radius.circular(4.sp))),
                  child: SimpleTextField(
                    controller: descriptionController,
                    minLines: 4,
                    noBorder: true,
                    hintText: 'Type here...'.tr(),
                  ),
                ),
                SizedBox(height: 8.sp,),
                Button(
                  text: 'Save'.tr(),
                  tapAction: (){

                  },
                ),
              ],
            ),
          ),
        );
      },),
    );
  }
}
