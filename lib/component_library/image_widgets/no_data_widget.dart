import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/core/assets_names.dart';
import 'package:sizer/sizer.dart';

class NoDataWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(Images.noDataIcon, height: 55.sp, width: 55.sp, color: AppColors.fadedTextColor,),
        SmallLightText(
          title: "No data found".tr(),
          textColor: AppColors.fadedTextColor,
        )
      ],
    );
  }

}