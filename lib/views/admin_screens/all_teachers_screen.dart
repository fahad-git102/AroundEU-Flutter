import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:groupchat/component_library/dialogs/custom_dialog.dart';
import 'package:groupchat/component_library/image_widgets/circle_image_avatar.dart';
import 'package:groupchat/component_library/text_fields/white_back_textfield.dart';
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/core/size_config.dart';
import 'package:groupchat/core/static_keys.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/repositories/users_repository.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/app_bars/custom_app_bar.dart';
import '../../component_library/image_widgets/no_data_widget.dart';
import '../../core/assets_names.dart';
import '../../core/utilities_class.dart';

class AllTeachersScreen extends StatefulWidget {
  static const route = 'AllTeachersScreen';

  @override
  State<StatefulWidget> createState() => _AllTeachersScreen();
}

class _AllTeachersScreen extends State<AllTeachersScreen> {
  TextEditingController searchController = TextEditingController();
  bool? isLoading = false;
  updateState(){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(child: Consumer(builder: (ctx, ref, child) {
        var appUserPro = ref.watch(appUserProvider);
        appUserPro.listenToTeachers();
        appUserPro.filterTeachers('');
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
                title: 'Make Coordinator'.tr(),
              ),
              Expanded(
                  child: Column(
                children: [
                  SizedBox(
                    height: 7.sp,
                  ),
                  Center(
                    child: SmallLightText(
                      title: 'Select any teacher to make coordinator'.tr(),
                      textColor: AppColors.lightFadedTextColor,
                    ),
                  ),
                  SizedBox(
                    height: 10.sp,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13.sp),
                    child: WhiteBackTextField(
                      hintText: 'Search teachers here...'.tr(),
                      controller: searchController,
                      onChanged: (val){
                        appUserPro.filterTeachers(val.toString());
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.sp,
                  ),
                  appUserPro.filteredTeachersList == null
                      ? Center(
                          child: SpinKitPulse(
                            color: AppColors.mainColorDark,
                          ),
                        )
                      : appUserPro.filteredTeachersList?.isEmpty == true
                          ? Center(
                              child: Padding(
                                  padding: EdgeInsets.only(top: 50.sp),
                                  child: NoDataWidget()),
                            )
                          : Expanded(
                              child: ListView.separated(
                                  itemCount:
                                      appUserPro.filteredTeachersList?.length ?? 0,
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
                                            .filteredTeachersList?[index].profileUrl,
                                        size: 40.sp,
                                        borderColor: AppColors.mainColorDark,
                                        borderWidth: 1.sp,
                                      ),
                                      title: ExtraMediumText(
                                        title:
                                            '${appUserPro.filteredTeachersList?[index].firstName}'
                                            ' ${appUserPro.filteredTeachersList?[index].surName}',
                                        textColor: AppColors.lightBlack,
                                      ),
                                      onTap: () {
                                        makeCoordinatorDialog(appUserPro.filteredTeachersList?[index].uid??'',
                                            '${appUserPro.filteredTeachersList?[index].firstName} ${appUserPro.filteredTeachersList?[index].surName}');
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
    );
  }

  makeCoordinatorDialog(String uid, String name){
    showDialog(context: context, builder: (context) => CustomDialog(
      title2: "Are you sure you want to make coordinator ?".tr(args: [name]),
      btn1Text:'Yes'.tr(),
      btn2Text: 'No'.tr(),
      btn1Outlined: true,
      icon: Images.coordinatorsIcon,
      iconColor: AppColors.mainColorDark,
      btn1Color: AppColors.mainColorDark,
      onBtn2Tap: (){
        Navigator.pop(context);
      },
      onBtn1Tap: (){
        Navigator.pop(context);
        makeCoordinator(uid, name);
      },
    ));
  }

  makeCoordinator(String userId, String name){
    isLoading = true;
    updateState();
    Map<String, String> user = {
      'userType': coordinator
    };
    UsersRepository().updateUser(user, userId, context, (){
      isLoading = false;
      updateState();
      Utilities().showCustomToast(message: '$name is a coordinator now'.tr(args: [name]), isError: false);
    }, (p0){
      isLoading = false;
      updateState();
      Utilities().showCustomToast(message: p0.toString(), isError: true);
    });
  }

}
