import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:groupchat/component_library/buttons/tile_item.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:sizer/sizer.dart';

import '../../core/assets_names.dart';

class HomeDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.darkWhite,
            ),
            child: Center(
              child: Image.asset(
                Images.logoAroundEU, // Replace with your image asset
                width: 120.0.sp,
                height: 120.0.sp,
              ),
            ),
          ),
          TileItem(
            icon: Images.globeIcon,
            title: 'Website'.tr(),
          ),
          Container(
            height: 0.7.sp,
            color: AppColors.extraLightFadedTextColor,
          ),
          SizedBox(height: 13.0.sp,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0.sp),
            child: SmallLightText(
              title: 'Follow us on'.tr(),
              textColor: AppColors.lightFadedTextColor,
            ),
          ),
          SizedBox(height: 5.0.sp,),
          TileItem(
            icon: Images.facebookMiniIcon,
            title: 'Facebook'.tr(),
          ),
          TileItem(
            icon: Images.instagramMiniIcon,
            title: 'Instagram'.tr(),
          ),
          TileItem(
            icon: Images.linkedinMiniIcon,
            title: 'LinkedIn'.tr(),
          ),
          TileItem(
            icon: Images.twitterMiniIcon,
            title: 'Twitter/X'.tr(),
          ),
          TileItem(
            icon: Images.youtubeMiniIcon,
            title: 'Youtube'.tr(),
          ),
          SizedBox(height: 4.0.sp,),
          Container(
            height: 0.7.sp,
            color: AppColors.extraLightFadedTextColor,
          ),
          SizedBox(height: 13.0.sp,),
          TileItem(
            icon: Images.coordinatorsIcon,
            title: 'Coordinators contact'.tr(),
          ),
          TileItem(
            icon: Images.emergencyContactIcon,
            title: 'Emergency contact'.tr(),
          ),
          TileItem(
            icon: Images.officeContactIcon,
            title: 'Office contact'.tr(),
          ),
          TileItem(
            icon: Images.privacyPolicyIcon,
            title: 'Privacy Policy'.tr(),
          ),
          TileItem(
            icon: Images.signOutIcon,
            title: 'Sign out'.tr(),
          ),
          SizedBox(height: 40.0.sp,),
        ],
      ),
    );
  }
}
