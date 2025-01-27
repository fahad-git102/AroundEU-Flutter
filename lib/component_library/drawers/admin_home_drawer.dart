import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/core/assets_names.dart';
import 'package:groupchat/data/social_media_links.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/providers/categories_provider.dart';
import 'package:groupchat/views/admin_screens/add_new_company_screen.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_colors.dart';
import '../../core/utilities_class.dart';
import '../../firebase/auth.dart';
import '../../views/admin_screens/add_coordinator_screen.dart';
import '../../views/admin_screens/add_emergency_number_screen.dart';
import '../../views/admin_screens/add_new_country_screen.dart';
import '../../views/admin_screens/add_new_group_screen.dart';
import '../../views/admin_screens/add_news_screen.dart';
import '../../views/admin_screens/manage_business_list_screen.dart';
import '../../views/admin_screens/manage_places_screen.dart';
import '../../views/auth/login_screen.dart';
import '../../views/categories_screens/categories_screen.dart';
import '../buttons/tile_item.dart';
import '../dialogs/sign_out_dialog.dart';

class AdminHomeDrawer extends ConsumerStatefulWidget {
  @override
  ConsumerState<AdminHomeDrawer> createState() => _AdminHomeDrawer();
}

class _AdminHomeDrawer extends ConsumerState<AdminHomeDrawer> {
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
    SocialMediaLink(index: 11, name: 'Delete Account'.tr(), icon: Images.deleteIcon),
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
                Images.logoAroundEU,
                width: 120.0.sp,
                height: 120.0.sp,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
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
                        Navigator.pushNamed(context, ManageBusinessListScreen.route);
                        break;
                      case 2:
                        Navigator.pushNamed(context, ManagePlacesScreen.route);
                        break;
                      case 3:
                        Navigator.pushNamed(context, AddNewCountryScreen.route);
                        break;
                      case 4:
                        Navigator.pushNamed(context, AddNewsScreen.route);
                        break;
                      case 5:
                        Navigator.pushNamed(context, AddNewGroupScreen.route);
                        break;
                      case 6:
                        Navigator.pushNamed(context, AddNewCompanyScreen.route);
                        break;
                      case 7:
                        Navigator.pushNamed(context, CategoriesScreen.route);
                        break;
                      case 8:
                        Navigator.pushNamed(context, AddCoordinatorsScreen.route);
                        break;
                      case 9:
                        Navigator.pushNamed(context, AddEmergencyNumbersScreen.route);
                        break;
                      case 10:
                        var appUserPro = ref.watch(appUserProvider);
                        var categoriesPro = ref.watch(categoriesProvider);
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (ctx) => SignOutDialog(
                              onLogout: () {
                                appUserPro.clearPro();
                                categoriesPro.clearPro();
                                Auth().signOut();
                                Navigator.pushNamedAndRemoveUntil(
                                    context, LoginScreen.route, (route) => false);
                              },
                            ));
                        break;
                      case 11:
                        Utilities()
                            .showDeleteConfirmationDialog(context);
                        break;
                    }
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
