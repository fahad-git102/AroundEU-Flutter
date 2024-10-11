import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/component_library/buttons/custom_icon_button.dart';
import 'package:groupchat/component_library/drawers/home_drawer.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/core/permissions_manager.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/providers/companies_provider.dart';
import 'package:groupchat/views/categories_screens/categories_screen.dart';
import 'package:groupchat/views/companies_screens/companies_screen.dart';
import 'package:groupchat/views/news_screens/news_screen.dart';
import 'package:groupchat/views/profile_screens/profile_home_screen.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/buttons/home_grid_widget.dart';
import '../../component_library/dialogs/select_country_dialog.dart';
import '../../core/assets_names.dart';
import '../../core/size_config.dart';
import '../../core/utilities_class.dart';
import '../../firebase/auth.dart';
import '../auth/login_screen.dart';
import '../companies_screens/company_detail_screen.dart';
import '../places_screens/places_screen.dart';

class HomeScreen extends StatefulWidget{
  static const route = 'HomeScreen';
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  bool? dialogShown = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    PermissionsManager().checkPermissions();
    return Consumer(builder: (ctx, ref, child){
      var appUserPro = ref.watch(appUserProvider);
      if(context.mounted){
        if(appUserPro.currentUser?.selectedCountry==null||appUserPro.currentUser?.selectedCountry?.isEmpty==true){
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if(dialogShown == false){
              dialogShown = true;
              showDialog(context: context, barrierDismissible: false, builder: (ctx) => SelectCountryDialog(
                title: 'Select Country'.tr(),
                showCancel: false,
                onItemSelect: (countryModel){
                  Navigator.pop(context);
                  updateUserCountry(appUserPro, countryModel?.countryName);
                },
              ));
            }
          });
        }
      }
      appUserPro.listenToCountries();
      appUserPro.listenToAdmins();
      return Scaffold(
        key: _scaffoldKey,
        drawer: HomeDrawer(),
        body: SafeArea(
          child: Container(
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Images.mainBackground),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(height: 10.0.sp,),
                        Image.asset(
                          Images.logoAroundEU,
                          height: 220.0.sp,
                          width: 220.0.sp,
                          fit: BoxFit.fill,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: HomeGridWidget(
                                icon: Images.profileIcon,
                                title: 'Profile Details'.tr(),
                                onTap: (){
                                  Navigator.pushNamed(context, ProfileHomeScreen.route);
                                },
                              ),
                            ),
                            Expanded(
                              child: HomeGridWidget(
                                icon: Images.chatIcon,
                                title: 'Chat'.tr(),
                                onTap: (){
                              print(appUserPro.currentUser?.uid);
                                },
                              ),
                            ),
                            Expanded(
                              child: HomeGridWidget(
                                icon: Images.newsIcon,
                                title: 'News'.tr(),
                                onTap: (){
                                  Navigator.pushNamed(context, NewsScreen.route);
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: HomeGridWidget(
                                icon: Images.placesIcon,
                                title: 'Places'.tr(),
                                onTap: (){
                                  Navigator.pushNamed(context, PlacesScreen.route);
                                },
                              ),
                            ),
                            Expanded(
                              child: Consumer(builder: (ctx, ref, child){
                                var companiesPro = ref.watch(companiesProvider);
                                if(companiesPro.myCompanyTimeScheduled==null||companiesPro.myCompany==null){
                                  companiesPro.listenToMyCompanyTimeScheduled();
                                }
                                return HomeGridWidget(
                                  icon: Images.myCompanyIcon,
                                  title: 'My Company'.tr(),
                                  onTap: (){
                                    if(companiesPro.myCompanyTimeScheduled!=null && companiesPro.myCompany!=null){
                                      Navigator.pushNamed(context, CompanyDetailScreen.route, arguments: {
                                        'company': companiesPro.myCompany?.toMap(),
                                        'fromHome': true
                                      });
                                    }else{
                                      Navigator.pushNamed(context, CompaniesScreen.route);
                                    }
                                  },
                                );
                              },),
                            ),
                            Expanded(
                              child: HomeGridWidget(
                                icon: Images.categoriesIcon,
                                title: 'Categories'.tr(),
                                onTap: (){
                                  Navigator.pushNamed(context, CategoriesScreen.route);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.0.sp,),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.0.sp),
                          child: Center(
                            child: SmallLightText(
                              title: 'Powered by Eprojectconsult',
                              textColor: AppColors.fadedTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0.sp),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: CustomIconPngButton(
                          icon: Images.menuIcon,
                          size: 36.0.sp,
                          onTap: (){
                            _scaffoldKey.currentState!.openDrawer();
                          },
                        ),
                      ),
                    )
                  ],
                )
            ),
          ),
        ),
      );
    });
  }

  updateUserCountry(AppUserProvider userPro, String? selectedCountry){
    userPro.updateSelectedCountry(context, userPro, selectedCountry, () {
      userPro.getCurrentUser();
    }, (p0) {
      userPro.clearPro();
      Auth().signOut();
      Utilities().showErrorMessage(context,
          barrierDismissible: false,
          message: 'Error: ${p0.toString()}'.tr(), onBtnTap: () {
            Navigator.pushNamedAndRemoveUntil(context, LoginScreen.route, (route) => false);
          });
    });
  }

}