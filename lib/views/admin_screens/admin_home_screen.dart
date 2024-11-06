import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:groupchat/component_library/drawers/admin_home_drawer.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/providers/categories_provider.dart';
import 'package:groupchat/views/admin_screens/add_coordinator_screen.dart';
import 'package:groupchat/views/admin_screens/add_emergency_number_screen.dart';
import 'package:groupchat/views/admin_screens/add_new_country_screen.dart';
import 'package:groupchat/views/admin_screens/add_new_group_screen.dart';
import 'package:groupchat/views/admin_screens/add_news_screen.dart';
import 'package:groupchat/views/admin_screens/manage_business_list_screen.dart';
import 'package:groupchat/views/admin_screens/manage_places_screen.dart';
import 'package:groupchat/views/categories_screens/categories_screen.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/buttons/custom_icon_button.dart';
import '../../component_library/buttons/home_grid_widget.dart';
import '../../component_library/dialogs/sign_out_dialog.dart';
import '../../core/assets_names.dart';
import '../../core/size_config.dart';
import '../../firebase/auth.dart';
import '../auth/login_screen.dart';
import 'add_new_company_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  static const route = 'AdminHomeScreen';

  @override
  State<StatefulWidget> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final GlobalKey<ScaffoldState> _homeKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: _homeKey,
      drawer: AdminHomeDrawer(),
      body: SafeArea(child: Consumer(builder: (ctx, ref, child) {
        var appUserPro = ref.watch(appUserProvider);
        var categoriesPro = ref.watch(categoriesProvider);
        appUserPro.listenToCountries();
        appUserPro.listenToAdmins();
        appUserPro.listenToCoordinators();
        return Container(
          height: SizeConfig.screenHeight,
          padding: EdgeInsets.only(top: 15.0.sp, left: 13.0.sp, right: 13.0.sp),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomIconPngButton(
                    icon: Images.menuIcon,
                    size: 36.0.sp,
                    onTap: () {
                      _homeKey.currentState!.openDrawer();
                    },
                  ),
                  InkWell(
                    onTap: (){
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
                    },
                      child: SvgPicture.asset(
                    Images.logoutIcon,
                    color: AppColors.lightBlack,
                    height: 28.sp,
                    width: 28.sp,
                  ))
                ],
              ),
              Expanded(
                  child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      Images.logoAroundEU,
                      height: 170.0.sp,
                      width: 170.0.sp,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(
                      height: 20.sp,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: HomeGridWidget(
                            icon: Images.businessListIcon,
                            isSvg: true,
                            title: 'Business Lists'.tr(),
                            onTap: () {
                              Navigator.pushNamed(context, ManageBusinessListScreen.route);
                            },
                          ),
                        ),
                        Expanded(
                          child: HomeGridWidget(
                            isSvg: true,
                            icon: Images.managePlacesIcon,
                            title: 'Manage Places'.tr(),
                            onTap: () {
                              Navigator.pushNamed(context, ManagePlacesScreen.route);
                            },
                          ),
                        ),
                        Expanded(
                          child: HomeGridWidget(
                            icon: Images.newCountryIcon,
                            isSvg: true,
                            title: 'Add Country'.tr(),
                            onTap: () {
                              Navigator.pushNamed(context, AddNewCountryScreen.route);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.sp,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: HomeGridWidget(
                            icon: Images.newNewsIcon,
                            isSvg: true,
                            title: 'Add News'.tr(),
                            onTap: () {
                              Navigator.pushNamed(context, AddNewsScreen.route);
                            },
                          ),
                        ),
                        Expanded(
                          child: HomeGridWidget(
                            isSvg: true,
                            icon: Images.newGroupIcon,
                            title: 'Add Groups'.tr(),
                            onTap: () {
                              Navigator.pushNamed(context, AddNewGroupScreen.route);
                            },
                          ),
                        ),
                        Expanded(
                          child: HomeGridWidget(
                            icon: Images.newCompanyIcon,
                            isSvg: true,
                            title: 'Add Company'.tr(),
                            onTap: () {
                              Navigator.pushNamed(context, AddNewCompanyScreen.route);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.sp,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: HomeGridWidget(
                            icon: Images.newCategoriesIcon,
                            isSvg: true,
                            title: 'Add Categories'.tr(),
                            onTap: () {
                              Navigator.pushNamed(context, CategoriesScreen.route);
                            },
                          ),
                        ),
                        Expanded(
                          child: HomeGridWidget(
                            isSvg: true,
                            icon: Images.coordinatorsIcon,
                            title: 'Add Coordinators'.tr(),
                            onTap: () {
                              Navigator.pushNamed(context, AddCoordinatorsScreen.route);
                            },
                          ),
                        ),
                        Expanded(
                          child: HomeGridWidget(
                            icon: Images.emergencyContactIcon,
                            isSvg: true,
                            title: 'Emergency'.tr(),
                            onTap: () {
                              Navigator.pushNamed(context, AddEmergencyNumbersScreen.route);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ))
            ],
          ),
        );
      })),
    );
  }
}
