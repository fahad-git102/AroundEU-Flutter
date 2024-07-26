import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/core/assets_names.dart';
import 'package:sizer/sizer.dart';

class HomeGridWidget extends StatelessWidget {
  final String? icon;
  final String? title;
  final Function()? onTap;

  const HomeGridWidget({super.key, this.onTap, this.icon, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.all(5.0.sp),
            child: Image.asset(icon ?? Images.chatIcon)),
        SizedBox(
          height: 5.0.sp,
        ),
        Center(
          child: SmallLightText(
            title: title,
            textColor: AppColors.lightBlack,
          ),
        )
      ],
    );
  }
}
