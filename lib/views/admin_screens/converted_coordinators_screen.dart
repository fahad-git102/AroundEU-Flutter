import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/app_bars/custom_app_bar.dart';
import '../../component_library/dialogs/custom_dialog.dart';
import '../../component_library/image_widgets/circle_image_avatar.dart';
import '../../component_library/image_widgets/no_data_widget.dart';
import '../../component_library/text_fields/white_back_textfield.dart';
import '../../component_library/text_widgets/extra_medium_text.dart';
import '../../core/app_colors.dart';
import '../../core/assets_names.dart';
import '../../core/size_config.dart';
import '../../core/static_keys.dart';
import '../../core/utilities_class.dart';
import '../../providers/app_user_provider.dart';
import '../../repositories/users_repository.dart';

class ConvertedCoordinatorsScreen extends StatefulWidget {
  static const route = 'ConvertedCoordinatorsScreen';

  @override
  State<StatefulWidget> createState() => _ConvertedCoordinatorsScreenState();
}

class _ConvertedCoordinatorsScreenState extends State<ConvertedCoordinatorsScreen> {
  TextEditingController searchController = TextEditingController();
  bool? isLoading = false;
  bool? pageStarted = true;
  updateState(){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return PopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(child: Consumer(builder: (ctx, ref, child) {
          var appUserPro = ref.watch(appUserProvider);
          if(pageStarted == true){
            appUserPro.filteredCoordinatorsList = null;
            if(appUserPro.allCoordinatorsList==null){
              appUserPro.listenToCoordinators();
            }
            appUserPro.filterCoordinators('');
            pageStarted = false;
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
            child: Column(
              children: [
                CustomAppBar(
                  title: 'Converted Coordinators'.tr(),
                ),
                Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10.sp,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 13.sp),
                          child: WhiteBackTextField(
                            hintText: 'Search coordinators here...'.tr(),
                            controller: searchController,
                            onChanged: (val){
                              appUserPro.filterCoordinators(val.toString());
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10.sp,
                        ),
                        appUserPro.filteredCoordinatorsList == null
                            ? Center(
                          child: SpinKitPulse(
                            color: AppColors.mainColorDark,
                          ),
                        )
                            : appUserPro.filteredCoordinatorsList?.isEmpty == true
                            ? Center(
                          child: Padding(
                              padding: EdgeInsets.only(top: 50.sp),
                              child: NoDataWidget()),
                        )
                            : Expanded(
                          child: ListView.separated(
                              itemCount:
                              appUserPro.filteredCoordinatorsList?.length ?? 0,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              padding:
                              EdgeInsets.symmetric(horizontal: 13.sp),
                              itemBuilder:
                                  (BuildContext context, int index) {
                                return ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.sp, horizontal: 10.sp),
                                  leading: CircleImageAvatar(
                                    imagePath: appUserPro
                                        .filteredCoordinatorsList?[index].profileUrl,
                                    size: 40.sp,
                                    borderColor: AppColors.mainColorDark,
                                    borderWidth: 1.sp,
                                  ),
                                  title: ExtraMediumText(
                                    title:
                                    '${appUserPro.filteredCoordinatorsList?[index].firstName}'
                                        ' ${appUserPro.filteredCoordinatorsList?[index].surName}',
                                    textColor: AppColors.lightBlack,
                                  ),
                                  onTap: () {
                                    removeCoordinatorDialog(appUserPro.filteredCoordinatorsList?[index].uid??'',
                                        '${appUserPro.filteredCoordinatorsList?[index].firstName} ${appUserPro.filteredCoordinatorsList?[index].surName}');
                                  },
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Divider(
                                  height: 0.5.sp,
                                  color: AppColors.lightFadedTextColor,
                                );
                              }),
                        )
                      ],
                    ))
              ],
            ),
          );
        })),
      ),
    );
  }

  removeCoordinatorDialog(String uid, String name){
    showDialog(context: context, builder: (context) => CustomDialog(
      title2: "Are you sure you want to remove this coordinator ?".tr(args: [name]),
      btn1Text:'Yes'.tr(),
      btn2Text: 'No'.tr(),
      btn1Outlined: true,
      icon: Images.coordinatorsIcon,
      iconColor: AppColors.red,
      btn1Color: AppColors.mainColorDark,
      onBtn2Tap: (){
        Navigator.pop(context);
      },
      onBtn1Tap: (){
        Navigator.pop(context);
        makeTeacher(uid, name);
      },
    ));
  }

  makeTeacher(String userId, String name){
    isLoading = true;
    updateState();
    Map<String, String> user = {
      'userType': teacher
    };
    UsersRepository().updateUser(user, userId, context, (){
      isLoading = false;
      searchController.clear();
      FocusScope.of(context).requestFocus(FocusNode());
      updateState();
      Utilities().showCustomToast(message: '$name is a teacher now'.tr(args: [name]), isError: false);
    }, (p0){
      isLoading = false;
      updateState();
      Utilities().showCustomToast(message: p0.toString(), isError: true);
    });
  }
}