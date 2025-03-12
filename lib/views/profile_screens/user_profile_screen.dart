import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/component_library/text_widgets/extra_large_medium_bold_text.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/data/company_model.dart';
import 'package:groupchat/data/company_time_scheduled.dart';
import 'package:groupchat/data/users_model.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/repositories/companies_repository.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/app_bars/custom_app_bar.dart';
import '../../component_library/companies_widgets/time_widget.dart';
import '../../component_library/image_widgets/circle_image_avatar.dart';
import '../../component_library/text_widgets/extra_medium_text.dart';
import '../../core/assets_names.dart';
import '../../core/size_config.dart';

class UserProfileScreen extends ConsumerStatefulWidget{
  static const route = 'UserProfileScreen';
  final String? userId;

  const UserProfileScreen({super.key, this.userId});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreen();
}

class _UserProfileScreen extends ConsumerState<UserProfileScreen>{

  AppUser? user;
  CompanyTimeScheduled? companyTimeScheduled;
  CompanyModel? company;
  bool? isLoading = false;

  Future<void> fetchUser() async {
    isLoading = true;
    AppUser? fetchedUser = await ref.read(appUserProvider).getUserById(widget.userId??'');
    if (fetchedUser != null) {
      setState(() {
        user = fetchedUser;
        isLoading = false;
      });
      fetchCompanyTimeScheduled(widget.userId??'');
    }
  }

  Future<void> fetchCompanyTimeScheduled(String uid) async {
    try {
      var map = await CompanyRepository().getCompanyTimeSchduled(uid);
      if(map!=null){
        final Map<String, dynamic> rawData = Map<String, dynamic>.from(map);
        rawData.forEach((key, value) {
          final Map<String, dynamic> scheduleData = Map<String, dynamic>.from(value);
          setState(() {
            companyTimeScheduled = CompanyTimeScheduled.fromMap(scheduleData);
          });
          print('scheduled');
          print(companyTimeScheduled?.toMap());
        });
        var companyMap = await CompanyRepository().getMyCompany(companyTimeScheduled?.companyId??'');
        setState(() {
          company = CompanyModel.fromMap(companyMap??{});
        });
        print('company');
        print(company?.toMap());
      }
    } catch (e) {
      print('Error fetching company time schedule: $e');
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(child: Container(
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
          children: [
            CustomAppBar(
              title: 'User Profile'.tr(),
            ),
            CircleImageAvatar(
              imagePath: user?.profileUrl,
              size: 90.0.sp,
            ),
            SizedBox(height: 7.sp,),
            ExtraLargeMediumBoldText(
              title: '${user?.firstName} ${user?.surName}',
              textColor: AppColors.lightBlack,
              fontSize: 22.sp,
            ),
            SmallLightText(
              title: user?.userType??'',
              textColor: AppColors.fadedTextColor,
            ),
            SizedBox(height: 10.sp,),
            Expanded(
              child: Container(
                width: SizeConfig.screenWidth,
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
                    children: [
                      SizedBox(height: 8.sp,),
                      titleValueItem('EMAIL'.tr(), user?.email??''),
                      SizedBox(height: 10.sp,),
                      titleValueItem('DATE OF BIRTH'.tr(), user?.dob??''),
                      SizedBox(height: 10.sp,),
                      titleValueItem('Phone Number'.tr(), user?.phone??''),
                      SizedBox(height: 10.sp,),
                      titleValueItem('WORKS AT'.tr(), company?.fullLegalName??company?.legalRepresentative??'Not Found'.tr()),
                      companyTimeScheduled != null
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
                                  itemCount: companyTimeScheduled?.selectedDays
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
                                        title: companyTimeScheduled
                                            ?.selectedDays?[index],
                                        textColor:
                                        AppColors.hyperLinkColor,
                                      ),
                                    );
                                  }),
                            ),
                            SizedBox(height: 10.sp,),
                            companyTimeScheduled != null
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
                                      TimeWidget(
                                          title: 'From:'.tr(),
                                          value: companyTimeScheduled
                                              ?.morningFrom ??
                                              ''),
                                      TimeWidget(
                                          title: 'To:'.tr(),
                                          value: companyTimeScheduled
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
                                      TimeWidget(
                                          title: 'From:'.tr(),
                                          value: companyTimeScheduled
                                              ?.noonFrom ??
                                              ''),
                                      TimeWidget(
                                          title: 'To:'.tr(),
                                          value: companyTimeScheduled
                                              ?.noonTo ??
                                              ''),
                                    ],
                                  )
                                ],
                              ),
                            )
                                : Container(),
                          ],
                        ),
                      )
                          : Container(),
                      SizedBox(height: 10.sp,),
                      SmallLightText(
                        title: 'ABOUT'.tr(),
                        textColor: AppColors.lightBlack,
                      ),
                      SizedBox(
                        height: 4.0.sp,
                      ),
                      Container(
                        width: SizeConfig.screenWidth,
                        padding: EdgeInsets.symmetric(horizontal: 13.0.sp, vertical: 10.sp),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: AppColors.lightFadedTextColor,
                                width: 0.4.sp),
                            borderRadius:
                            BorderRadius.all(Radius.circular(4.sp))),
                        child: ExtraMediumText(
                          title: user?.about??'',
                          textColor: AppColors.lightBlack,
                        ),
                      ),
                      SizedBox(height: 20.sp,)
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.sp,)
          ],
        ),
      )),
    );
  }

  Widget titleValueItem(String title, String value){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SmallLightText(
          title: title??'EMAIL'.tr(),
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
            title: value,
            textColor: AppColors.lightBlack,
          ),
        ),
      ],
    );
  }

}