import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:groupchat/component_library/buttons/button.dart';
import 'package:groupchat/component_library/dialogs/select_group_categories_dialog.dart';
import 'package:groupchat/component_library/text_fields/white_back_textfield.dart';
import 'package:groupchat/component_library/text_widgets/extra_large_medium_bold_text.dart';
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/core/assets_names.dart';
import 'package:groupchat/core/size_config.dart';
import 'package:sizer/sizer.dart';

class AddNewGroupDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddNewGroupDialog();
}

class _AddNewGroupDialog extends State<AddNewGroupDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  List<String>? pickedFiles = [
    'file 1',
    'file 2',
    'file 3',
    'file 4',
    'file 5',
    'file 6'
  ];

  List<String> categories = ['Accommodation', 'Food', 'Classes', 'Others'];
  List<String>? selectedCategories = [];
  List<bool> isSelectedCategories = List.generate(4, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        padding: EdgeInsets.all(13.sp),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExtraLargeMediumBoldText(
                title: 'Add new Group'.tr(),
                textColor: AppColors.lightBlack,
              ),
              SizedBox(
                height: 15.sp,
              ),
              WhiteBackTextField(
                controller: nameController,
                hintText: 'Name'.tr(),
              ),
              SizedBox(
                height: 7.sp,
              ),
              WhiteBackTextField(
                controller: pincodeController,
                hintText: 'Pincode'.tr(),
                allowNumersOnly: true,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              SizedBox(
                height: 7.sp,
              ),
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => SelectGroupCategoriesDialog(
                            categories: categories,
                            isSelected: isSelectedCategories,
                            selectedCategories: selectedCategories,
                          ));
                },
                child: Container(
                  width: SizeConfig.screenWidth,
                  padding: EdgeInsets.all(10.sp),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: AppColors.lightFadedTextColor, width: 0.4.sp),
                      borderRadius: BorderRadius.all(Radius.circular(4.sp))),
                  child: SmallLightText(
                    fontSize: 11.5.sp,
                    title: selectedCategories?.isNotEmpty == true
                        ? selectedCategories?.join(', ')
                        : 'Select Categories'.tr(),
                    textColor: selectedCategories?.isNotEmpty == true
                        ?AppColors.lightBlack:AppColors.extraLightGrey,
                  ),
                ),
              ),
              SizedBox(
                height: 7.sp,
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(vertical: 7.0.sp, horizontal: 10.0.sp),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: AppColors.lightFadedTextColor, width: 0.4.sp),
                    borderRadius: BorderRadius.all(Radius.circular(4.sp))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SmallLightText(
                      title: 'Pick files for selected categories'.tr(),
                      textColor: AppColors.lightFadedTextColor,
                      fontSize: 10.sp,
                    ),
                    SizedBox(
                      height: 3.sp,
                    ),
                    Container(
                      width: SizeConfig.screenWidth,
                      padding: EdgeInsets.symmetric(vertical: 8.sp),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.mainColorDark, width: 0.5.sp),
                          borderRadius: BorderRadius.all(Radius.circular(4.sp)),
                          color: AppColors.white),
                      child: Center(
                          child: SvgPicture.asset(
                        Images.pickFileIcon,
                        height: 17.sp,
                        width: 17.sp,
                        color: AppColors.mainColorDark,
                      )),
                    ),
                    SizedBox(height: 10.sp),
                    if (pickedFiles?.isNotEmpty == true)
                      SizedBox(
                        height: 30.sp,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: pickedFiles?.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(right: 7.sp),
                              padding: EdgeInsets.symmetric(horizontal: 9.sp),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.blue),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                child: SmallLightText(
                                  title: pickedFiles?[index],
                                  textColor: AppColors.lightBlack,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 12.sp,
              ),
              Button(text: 'Save'.tr(), tapAction: () {})
            ],
          ),
        ),
      ),
    );
  }
}
