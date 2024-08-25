import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groupchat/core/assets_names.dart';
import 'package:groupchat/data/social_media_links.dart';
import 'package:groupchat/views/drawer_screens/add_new_company_screen.dart';
import 'package:groupchat/views/home_screens/admin_home_screen.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_colors.dart';
import '../buttons/tile_item.dart';

class AdminHomeDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AdminHomeDrawer();
}

class _AdminHomeDrawer extends State<AdminHomeDrawer> {
  final List<SocialMediaLink> list = [
    SocialMediaLink(
        index: 1,
        name: 'Manage Business List'.tr(),
        icon: Images.businessListIcon),
    SocialMediaLink(
        index: 2, name: 'Manage Places'.tr(), icon: Images.managePlacesIcon),
    SocialMediaLink(
        index: 3, name: 'Add new Country'.tr(), icon: Images.newCountryIcon),
    SocialMediaLink(index: 4, name: 'Add News'.tr(), icon: Images.newNewsIcon),
    SocialMediaLink(
        index: 5, name: 'Add Groups'.tr(), icon: Images.newGroupIcon),
    SocialMediaLink(
        index: 6, name: 'Add new Company'.tr(), icon: Images.newCompanyIcon),
    SocialMediaLink(
        index: 7, name: 'Add Categories'.tr(), icon: Images.newCategoriesIcon),
    SocialMediaLink(
        index: 8, name: 'Add Coordinators'.tr(), icon: Images.coordinatorsIcon),
    SocialMediaLink(
        index: 9,
        name: 'Add Emergency Numbers'.tr(),
        icon: Images.emergencyContactIcon),
    SocialMediaLink(index: 10, name: 'Sign out'.tr(), icon: Images.logoutIcon),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
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
          ListView.builder(
            itemCount: list.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return TileItem(
                icon: list[index].icon,
                title: list[index].name,
                onTap: () async {
                  switch (list[index].index) {
                    case 1:
                      Navigator.pushNamed(context, AdminHomeScreen.route);
                      break;
                    case 2:
                      break;
                    case 3:
                      break;
                    case 4:
                      break;
                    case 5:
                      break;
                    case 6:
                      Navigator.pushNamed(context, AddNewCompanyScreen.route);
                      break;
                    case 7:
                      break;
                    case 8:
                      break;
                    case 9:
                      break;
                    case 10:
                      break;
                  }
                },
              );
            },
          )
        ],
      ),
    );
  }
}
