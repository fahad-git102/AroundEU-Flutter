import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/component_library/buttons/custom_icon_button.dart';
import 'package:groupchat/component_library/drawers/home_drawer.dart';
import 'package:groupchat/component_library/loaders/full_screen_loader.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/core/permissions_manager.dart';
import 'package:groupchat/core/static_keys.dart';
import 'package:groupchat/firebase/firebase_crud.dart';
import 'package:groupchat/firebase/firebase_notification_service.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/providers/business_list_provider.dart';
import 'package:groupchat/providers/categories_provider.dart';
import 'package:groupchat/providers/companies_provider.dart';
import 'package:groupchat/providers/groups_provider.dart';
import 'package:groupchat/providers/news_provider.dart';
import 'package:groupchat/repositories/groups_repository.dart';
import 'package:groupchat/repositories/users_repository.dart';
import 'package:groupchat/views/categories_screens/categories_screen.dart';
import 'package:groupchat/views/chat_screens/select_business_screen.dart';
import 'package:groupchat/views/companies_screens/companies_screen.dart';
import 'package:groupchat/views/news_screens/news_screen.dart';
import 'package:groupchat/views/profile_screens/profile_home_screen.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/bottomsheets/pin_input_bottomsheet.dart';
import '../../component_library/buttons/home_grid_widget.dart';
import '../../component_library/dialogs/select_country_dialog.dart';
import '../../core/assets_names.dart';
import '../../core/size_config.dart';
import '../../core/utilities_class.dart';
import '../../data/group_model.dart';
import '../../firebase/auth.dart';
import '../auth/login_screen.dart';
import '../chat_screens/chat_screen.dart';
import '../companies_screens/company_detail_screen.dart';
import '../places_screens/places_screen.dart';

class HomeScreen extends StatefulWidget{
  static const route = 'HomeScreen';
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  bool? dialogShown = false;
  bool? isCoordinator = false;
  bool? isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  updateState(){
    setState(() {});
  }

  @override
  void initState() {
    PermissionsManager().checkPermissions();
    FirebaseCrud.initNotification(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer(builder: (ctx, ref, child){
      var appUserPro = ref.watch(appUserProvider);
      var groupsPro = ref.watch(groupsProvider);
      var businessPro = ref.watch(businessListProvider);
      if (context.mounted) {
        if(appUserPro.currentUser?.joinedGroupId!=null && appUserPro.currentUser?.joinedGroupId?.isNotEmpty==true){
          groupsPro.listenToGroupById(appUserPro.currentUser?.joinedGroupId??'');
        }
        if (appUserPro.currentUser?.userType == coordinator) {
          isCoordinator = true;
          if(appUserPro.coordinatorsCountryModel==null){
            appUserPro.getCoordinatorsCountry();
          }
        } else {
          if (appUserPro.currentUser?.selectedCountry == null || appUserPro.currentUser?.selectedCountry?.isEmpty == true) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              if (dialogShown == false) {
                dialogShown = true;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) => SelectCountryDialog(
                    title: 'Select Country'.tr(),
                    showCancel: false,
                    onItemSelect: (countryModel) {
                      Navigator.pop(context);
                      updateUserCountry(appUserPro, countryModel?.countryName);
                    },
                  ),
                );
              }
            });
          }
        }
      }

      appUserPro.listenToCountries();
      appUserPro.listenToAdmins();
      if(appUserPro.allCoordinatorsList==null){
        appUserPro.listenToCoordinators();
      }
      businessPro.listenToBusinessList();
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
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13.sp),
                  child: Utilities().getDeviceType()=='phone'?homeGrids(ref):SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: homeGrids(ref),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0.sp, left: 13.sp),
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
                ),
                FullScreenLoader(
                  loading: isLoading,
                )
              ],
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

  Widget homeGrids(WidgetRef ref){
    var appUserPro = ref.watch(appUserProvider);
    return  Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // SmallLightText(
        //   title: 'chatID == $chatId',
        // ),
        SizedBox(height: 10.0.sp,),
        Image.asset(
          Images.logoAroundEU,
          height: Utilities().getDeviceType()=='phone'?220.sp:420.0,
          width: Utilities().getDeviceType()=='phone'?220.sp:420.0,
          fit: BoxFit.fill,
        ),
        appUserPro.currentUser?.userType==coordinator?InkWell(
          onTap: (){
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (ctx) => SelectCountryDialog(
                title: 'Select Country'.tr(),
                showCancel: false,
                onItemSelect: (countryModel) async {
                  Navigator.pop(context);
                  ref.watch(newsProvider).newsList = null;
                  ref.watch(categoriesProvider).categoriesList = null;
                  ref.watch(categoriesProvider).filteredCategoriesList = null;
                  await Utilities().saveMap(coordinatorsCountry, countryModel?.toMap() ?? {});
                  appUserPro.coordinatorsCountryModel = null;
                  updateState();
                },
              ),
            );
          },
          child: Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SmallLightText(
                  title: 'Coordinator\'s Country: '.tr(),
                  textColor: AppColors.lightBlack,
                  fontSize: 10.sp,
                ),
                SizedBox(width: 4.sp,),
                SmallLightText(
                  title: appUserPro.coordinatorsCountryModel?.countryName??'',
                  textColor: AppColors.lightBlack,
                  fontSize: 13.sp,
                )
              ],
            ),
          ),
        ):Container(),
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
                  if(appUserPro.currentUser?.userType == student || appUserPro.currentUser?.userType == teacher){
                    if(appUserPro.currentUser?.joinedGroupId!=null && appUserPro.currentUser?.joinedGroupId?.isNotEmpty==true){
                      Navigator.pushNamed(
                          context, ChatScreen.route, arguments: {
                        'groupId': appUserPro.currentUser?.joinedGroupId
                      });
                    }else{
                      showPinInputStudentsBottomSheet(context, ref);
                    }
                  }else if(appUserPro.currentUser?.userType == coordinator){
                    ref.watch(businessListProvider).filteredBusinessList = null;
                    Navigator.pushNamed(context, SelectBusinessScreen.route);
                  }
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
        Utilities().getDeviceType()=='phone'?SizedBox(height: 2.sp,):SizedBox(height: 15.0.sp,),
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
    );
  }

  void showPinInputStudentsBottomSheet(BuildContext context, WidgetRef ref) async {
    var appUserPro = ref.watch(appUserProvider);
    final pin = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PinInputBottomSheet(title: "Enter 5-Digit PIN".tr(),),
    );
    if (pin != null) {
      isLoading = true;
      updateState();
      List<GroupModel> groups = await GroupsRepository().getGroupsWithPin(pin);
      if (groups.isNotEmpty) {
        GroupModel group = groups[groups.length-1];
        List<String?>? list = group.approvedMembers ?? [];
        if(!list.contains(Auth().currentUser?.uid)){
          list.add(Auth().currentUser?.uid);
          var map = {'approvedMembers': list};
          GroupsRepository().updateGroup(map, group.key??'', context, (){
            Map<String, dynamic> joinedMap = {
              'joinedGroupId': group.key
            };
            UsersRepository().updateUser(joinedMap, Auth().currentUser?.uid??'', context, (){
              appUserPro.getCurrentUser();
              isLoading = false;
              updateState();
              Navigator.pushNamed(
                  context, ChatScreen.route,
                  arguments: {
                    'groupId': group.key
                  });
            }, (p0){
              isLoading = false;
              updateState();
              Utilities().showCustomToast(message: p0.toString(), isError: true);
            });
          }, (p0){
            isLoading = false;
            updateState();
            Utilities().showCustomToast(message: p0.toString(), isError: true);
          });
        }else{
          Map<String, dynamic> joinedMap = {
            'joinedGroupId': group.key
          };
          UsersRepository().updateUser(joinedMap, Auth().currentUser?.uid??'', context, (){
            appUserPro.getCurrentUser();
            isLoading = false;
            updateState();
            Navigator.pushNamed(
                context, ChatScreen.route,
                arguments: {
                  'groupId': group.key
                });
          }, (p0){
            isLoading = false;
            updateState();
            Utilities().showCustomToast(message: p0.toString(), isError: true);
          });
        }
      } else {
        isLoading = false;
        updateState();
        Utilities().showCustomToast(message: 'No groups found with this pin'.tr(), isError: true);
      }
    }
  }

}