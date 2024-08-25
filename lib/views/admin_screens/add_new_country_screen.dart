import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:groupchat/component_library/dialogs/new_country_dialog.dart';
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/repositories/users_repository.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/app_bars/custom_app_bar.dart';
import '../../component_library/dialogs/custom_dialog.dart';
import '../../core/app_colors.dart';
import '../../core/assets_names.dart';
import '../../core/size_config.dart';

class AddNewCountryScreen extends StatefulWidget {
  static const route = 'AddNewCountryScreen';
  @override
  State<StatefulWidget> createState() => _AddCountryState();
}

class _AddCountryState extends State<AddNewCountryScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          addCountryDialog();
        },
        child: Icon(
          Icons.add,
          color: AppColors.lightBlack,
        ),
      ),
      body: SafeArea(child: Consumer(builder: (ctx, ref, child) {
        var appUserPro = ref.watch(appUserProvider);
        appUserPro.listenToCountries();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                title: 'Countries'.tr(),
              ),
              SizedBox(
                height: 20.sp,
              ),
              Expanded(
                child: ListView.separated(
                    itemCount: appUserPro.countriesList?.length ?? 0,
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 17.sp),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(padding: EdgeInsets.symmetric(vertical: 15
                          .sp),
                        child: Row(
                          children: [
                            Expanded(child: ExtraMediumText(
                              title: appUserPro.countriesList?[index].countryName,
                              textColor: AppColors.lightBlack,
                            )),
                            InkWell(
                              onTap: (){
                                showDeleteCountryDialog(appUserPro.countriesList![index].id??'');
                              },
                              child: Padding(
                                  padding: EdgeInsets.all(4.sp),
                                  child: SvgPicture.asset(
                                Images.deleteIcon, color: AppColors.lightBlack,
                                height: 20.sp,
                                width: 20.sp,)),
                            )
                          ],
                        ),
                      );
                    }, separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        height: 0.4.sp,
                        color: AppColors.fadedTextColor,
                      );
                },),
              )
            ],
          ),
        );
      })),
    );
  }

  showDeleteCountryDialog(String id){
    showDialog(context: context, builder: (ctx)=> CustomDialog(
      title2: "Are you sure you want to delete this country ?".tr(),
      btn1Text:'Delete'.tr(),
      icon: Images.deleteIcon,
      iconColor: AppColors.red,
      btn2Text: 'Cancel'.tr(),
      btn1Outlined: true,
      btn1Color: AppColors.red,
      onBtn2Tap: (){
        Navigator.pop(context);
      },
      onBtn1Tap: (){
        UsersRepository().deleteCountry(ctx, id);
        Navigator.pop(context);
      },
    ));
  }

  addCountryDialog(){
    showDialog(context: context, builder: (ctx) => NewCountryDialog());
  }

}
