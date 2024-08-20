import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:sizer/sizer.dart';

import '../../core/assets_names.dart';
import 'custom_dialog.dart';

class SignOutDialog extends StatelessWidget{
  final Function()? onLogout;

  const SignOutDialog({super.key, this.onLogout});
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title2: 'Are you sure you want to logout ?'.tr(),
      showBtn2: true,
      btn2Text: "Cancel".tr(),
      btn1Text: "Logout".tr(),
      iconSize: 60.0.sp,
      btn1Color: AppColors.mainColorDark,
      btn1Outlined: true,
      icon: Images.logoutIcon,
      onBtn1Tap: onLogout,
      onBtn2Tap: (){
        Navigator.of(context).pop();
      },
    );
  }

}