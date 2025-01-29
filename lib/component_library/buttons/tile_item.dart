import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/core/assets_names.dart';
import 'package:sizer/sizer.dart';

class TileItem extends StatelessWidget {
  final String? title;
  final String? icon;
  final Function()? onTap;

  const TileItem({
    super.key,
    this.title,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(12.0.sp),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon??Images.globeIcon,
              height: 17.0.sp,
              width: 17.0.sp,
              color: AppColors.lightBlack,
            ),
            SizedBox(width: 10.0.sp,),
            Expanded(
              child: ExtraMediumText(
                title: title??'Website'.tr(),
                decrease: 2,
                textColor: AppColors.lightBlack,
              ),
            )
          ],
        ),
      ),
    );
  }
}
