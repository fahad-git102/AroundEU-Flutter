import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/core/size_config.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_colors.dart';
import '../buttons/back_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String? title;
  final Function()? onTap;
  final Widget? trailingWidget;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const CustomAppBar({super.key, this.title, this.onTap, this.trailingWidget});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      color: Colors.transparent,
      child: Column(
        children: [
          SizedBox(height: 18.0.sp,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BackIconButton(
                  size: 24.0.sp,
                  onTap: onTap??(){
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: 10.0.sp,),
                Expanded(
                  child: ExtraMediumText(
                    title: title??'Places to Explore'.tr(),
                    textColor: AppColors.lightBlack,
                  ),
                ),
                trailingWidget??Container(),
              ],
            ),
          ),
          SizedBox(height: 15.0.sp,),
        ],
      ),
    );
  }
  
}