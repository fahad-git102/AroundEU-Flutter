import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/core/assets_names.dart';
import 'package:sizer/sizer.dart';

class HomeGridWidget extends StatelessWidget {
  final String? icon;
  final String? title;
  final Function()? onTap;
  final bool? isSvg;
  final double? iconSize;

  const HomeGridWidget(
      {super.key,
      this.onTap,
      this.icon,
      this.title,
      this.isSvg = false,
      this.iconSize});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.all(5.0.sp),
              child: isSvg == true
                  ? Padding(
                      padding: EdgeInsets.all(5.sp),
                      child: SvgPicture.asset(
                        icon!,
                        height: iconSize ?? 53.sp,
                        width: iconSize ?? 53.sp,
                        color: AppColors.lightBlack,
                      ))
                  : Image.asset(icon ?? Images.chatIcon)),
          SizedBox(
            height: 5.0.sp,
          ),
          Center(
            child: SmallLightText(
              title: title,
              textAlign: TextAlign.center,
              textColor: AppColors.lightBlack,
            ),
          )
        ],
      ),
    );
  }
}
