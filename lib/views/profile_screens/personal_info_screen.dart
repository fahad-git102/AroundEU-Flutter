import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/component_library/app_bars/custom_app_bar.dart';
import 'package:groupchat/component_library/dialogs/update_profile_dialog.dart';
import 'package:groupchat/component_library/text_fields/simple_text_field.dart';
import 'package:groupchat/component_library/text_widgets/extra_large_medium_bold_text.dart';
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/core/disabled_focus_node.dart';
import 'package:groupchat/core/size_config.dart';
import 'package:groupchat/core/static_keys.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/providers/companies_provider.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/image_widgets/circle_image_avatar.dart';
import '../../core/assets_names.dart';

class PersonalInfoScreen extends StatefulWidget {
  static const route = 'PersonalInfoScreen';

  @override
  State<StatefulWidget> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  TextEditingController? aboutController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(child: Consumer(
        builder: (ctx, ref, child) {
          var appUserPro = ref.watch(appUserProvider);
          var companyPro = ref.watch(companiesProvider);
          aboutController?.text = appUserPro.currentUser?.about ?? '';
          if (appUserPro.currentUser == null) {
            appUserPro.getCurrentUser();
          }
          if (companyPro.myCompanyTimeScheduled == null) {
            companyPro.listenToMyCompanyTimeScheduled();
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
            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomAppBar(
                  title: 'Personal Information'.tr(),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleImageAvatar(
                      imagePath: appUserPro.currentUser?.profileUrl,
                      size: 60.0.sp,
                    ),
                    SizedBox(
                      width: 10.0.sp,
                    ),
                    Expanded(
                      child: ExtraLargeMediumBoldText(
                        textColor: AppColors.lightBlack,
                        fontWeight: FontWeight.w300,
                        title:
                            '${appUserPro.currentUser?.firstName} ${appUserPro.currentUser?.surName}',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0.sp,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SmallLightText(
                      title: 'Basic Info'.tr(),
                      textColor: AppColors.lightBlack,
                    ),
                    InkWell(
                      onTap: (){
                        showDialog(context: context, barrierDismissible: true, builder: (ctx) => UpdateProfileDialog(
                          firstName: appUserPro.currentUser?.firstName,
                          surName: appUserPro.currentUser?.surName,
                          about: appUserPro.currentUser?.about,
                        ));
                      },
                      child: Padding(
                          padding: EdgeInsets.all(4.0.sp),
                          child: Icon(
                            Icons.edit,
                            color: AppColors.lightBlack,
                            size: 20.0.sp,
                          )),
                    )
                  ],
                ),
                SizedBox(height: 8.0.sp,),
                Divider(
                  height: 0.5.sp,
                  color: AppColors.fadedTextColor2,
                ),
                SizedBox(
                  height: 12.0.sp,
                ),
                Expanded(
                  child: Container(
                    height: SizeConfig.screenWidth,
                    width: SizeConfig.screenWidth,
                    margin: EdgeInsets.only(bottom: 12.0.sp),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black87.withOpacity(0.25),
                            blurRadius: 4,
                            offset: const Offset(1, 1), // Shadow position
                          ),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(7.sp))),
                    padding: EdgeInsets.all(13.0.sp),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SmallLightText(
                            title: 'EMAIL'.tr(),
                            textColor: AppColors.lightBlack,
                          ),
                          SizedBox(
                            height: 4.0.sp,
                          ),
                          Container(
                            width: SizeConfig.screenWidth,
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0.sp, horizontal: 13.0.sp),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: AppColors.lightFadedTextColor,
                                    width: 0.4.sp),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.sp))),
                            child: ExtraMediumText(
                              title: appUserPro.currentUser?.email,
                              textColor: AppColors.lightBlack,
                            ),
                          ),
                          SizedBox(
                            height: 12.sp,
                          ),
                          SmallLightText(
                            title: 'NAME'.tr(),
                            textColor: AppColors.lightBlack,
                          ),
                          SizedBox(
                            height: 4.0.sp,
                          ),
                          Container(
                            width: SizeConfig.screenWidth,
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0.sp, horizontal: 13.0.sp),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: AppColors.lightFadedTextColor,
                                    width: 0.4.sp),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.sp))),
                            child: ExtraMediumText(
                              title:
                                  '${appUserPro.currentUser?.firstName} ${appUserPro.currentUser?.surName}',
                              textColor: AppColors.lightBlack,
                            ),
                          ),
                          SizedBox(
                            height: 12.sp,
                          ),
                          SmallLightText(
                            title: 'DATE OF BIRTH'.tr(),
                            textColor: AppColors.lightBlack,
                          ),
                          SizedBox(
                            height: 4.0.sp,
                          ),
                          Container(
                            width: SizeConfig.screenWidth,
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0.sp, horizontal: 13.0.sp),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: AppColors.lightFadedTextColor,
                                    width: 0.4.sp),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.sp))),
                            child: ExtraMediumText(
                              title: appUserPro.currentUser?.dob,
                              textColor: AppColors.lightBlack,
                            ),
                          ),
                          companyPro.myCompany != null &&
                                  companyPro.myCompanyTimeScheduled != null
                              ? SizedBox(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 12.sp,
                                      ),
                                      SmallLightText(
                                        title: 'WORKS AT'.tr(),
                                        textColor: AppColors.lightBlack,
                                      ),
                                      SizedBox(
                                        height: 4.0.sp,
                                      ),
                                      Container(
                                        width: SizeConfig.screenWidth,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0.sp,
                                            horizontal: 13.0.sp),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: AppColors
                                                    .lightFadedTextColor,
                                                width: 0.4.sp),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4.sp))),
                                        child: ExtraMediumText(
                                          title: companyPro.myCompany != null
                                              ? companyPro
                                                      .myCompany?.fullLegalName ??
                                                  companyPro.myCompany
                                                      ?.legalRepresentative ??
                                                  'Not Found'.tr()
                                              : '',
                                          textColor: AppColors.lightBlack,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Container(),
                          companyPro.myCompanyTimeScheduled != null
                              ? SizedBox(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 15.sp,
                                      ),
                                      SmallLightText(
                                        title: 'WORKING DAYS'.tr(),
                                        textColor: AppColors.lightBlack,
                                      ),
                                      SizedBox(
                                        height: 35.0.sp,
                                        child: ListView.builder(
                                            itemCount: companyPro
                                                .myCompanyTimeScheduled
                                                ?.selectedDays
                                                ?.length,
                                            shrinkWrap: true,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    top: 4.0.sp,
                                                    bottom: 5.0.sp,
                                                    right: 9.0.sp),
                                                child: ExtraMediumText(
                                                  title: companyPro
                                                      .myCompanyTimeScheduled
                                                      ?.selectedDays?[index],
                                                  textColor:
                                                      AppColors.hyperLinkColor,
                                                ),
                                              );
                                            }),
                                      )
                                    ],
                                  ),
                                )
                              : Container(),
                          companyPro.myCompanyTimeScheduled != null
                              ? SizedBox(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10.sp,
                                      ),
                                      SmallLightText(
                                        title: 'Morning:'.tr(),
                                        textColor: AppColors.fadedTextColor,
                                      ),
                                      SizedBox(
                                        height: 4.0.sp,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          timeWidget(
                                              'From:'.tr(),
                                              companyPro.myCompanyTimeScheduled
                                                      ?.morningFrom ??
                                                  ''),
                                          timeWidget(
                                              'To:'.tr(),
                                              companyPro.myCompanyTimeScheduled
                                                      ?.morningTo ??
                                                  ''),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 12.sp,
                                      ),
                                      SmallLightText(
                                        title: 'Afternoon:'.tr(),
                                        textColor: AppColors.fadedTextColor,
                                      ),
                                      SizedBox(
                                        height: 4.0.sp,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          timeWidget(
                                              'From:'.tr(),
                                              companyPro.myCompanyTimeScheduled
                                                      ?.noonFrom ??
                                                  ''),
                                          timeWidget(
                                              'To:'.tr(),
                                              companyPro.myCompanyTimeScheduled
                                                      ?.noonTo ??
                                                  ''),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            height: 15.0.sp,
                          ),
                          SmallLightText(
                            title: 'ABOUT'.tr(),
                            textColor: AppColors.lightBlack,
                          ),
                          SizedBox(
                            height: 4.0.sp,
                          ),
                          Container(
                            width: SizeConfig.screenWidth,
                            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: AppColors.lightFadedTextColor,
                                    width: 0.4.sp),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.sp))),
                            child: SimpleTextField(
                              controller: aboutController,
                              minLines: 4,
                              noBorder: true,
                              focusNode: AlwaysDisabledFocusNode(),
                            ),
                          ),
                          SizedBox(
                            height: 20.0.sp,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      )),
    );
  }

  Widget timeWidget(String title, String value) {
    return Row(
      children: [
        SmallLightText(
          title: title,
          textColor: AppColors.lightBlack,
        ),
        SizedBox(
          width: 10.0.sp,
        ),
        SmallLightText(
          title: value,
          fontSize: 13.0.sp,
          textColor: AppColors.hyperLinkColor,
        ),
      ],
    );
  }
}
