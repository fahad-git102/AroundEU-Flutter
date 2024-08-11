import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/component_library/app_bars/custom_app_bar.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/text_widgets/extra_medium_text.dart';
import '../../core/assets_names.dart';
import '../../core/size_config.dart';

class ProfileHomeScreen extends StatefulWidget {
  static const route = 'ProfileHomeScreen';
  @override
  State<StatefulWidget> createState() => _ProfileHomeScreenState();
}

class _ProfileHomeScreenState extends State<ProfileHomeScreen> {
  List<String>? dataList;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    dataList = [];
    dataList?.add('Personal Information'.tr());
    dataList?.add('My Documents'.tr());
    dataList?.add('My Classes'.tr());
    dataList?.add('Settings'.tr());
    return Scaffold(
      body: SafeArea(child: Consumer(
        builder: (ctx, ref, child) {
          var appUserPro = ref.watch(appUserProvider);
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomAppBar(
                  title: "Profile Details".tr(),
                ),
                SizedBox(
                  height: 10.0.sp,
                ),
                Image.asset(
                  Images.logoAroundEU,
                  height: 100.0.sp,
                  width: 100.0.sp,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  height: 10.0.sp,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SmallLightText(
                      title: 'Joined On: '.tr(),
                      textColor: AppColors.lightBlack,
                    ),
                    SmallLightText(
                      title: Utilities().convertTimeStampToString(
                          appUserPro.currentUser?.joinedOn ?? 0,
                          format: 'dd MMM, yyyy'),
                      textColor: AppColors.hyperLinkColor,
                    )
                  ],
                ),
                SizedBox(
                  height: 20.0.sp,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: dataList?.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 13.sp),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 9.0.sp),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black87
                                      .withOpacity(0.25),
                                  blurRadius: 4,
                                  offset: const Offset(
                                      1, 1), // Shadow position
                                ),
                              ],
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4.sp))),
                          child: Padding(padding: EdgeInsets.all(10.sp), child: ExtraMediumText(
                            textColor: AppColors.lightBlack,
                            title: dataList?[index],
                          ),),
                        );
                      }),
                )
              ],
            ),
          );
        },
      )),
    );
  }
}
