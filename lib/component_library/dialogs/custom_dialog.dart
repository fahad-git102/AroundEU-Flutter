import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_colors.dart';
import '../../core/assets_names.dart';
import '../buttons/button.dart';
import '../text_widgets/extra_large_medium_bold_text.dart';
import '../text_widgets/extra_medium_text.dart';

class CustomDialog extends StatelessWidget {
  final String? title1;
  final String? title2;
  final String? btn1Text;
  final String? btn2Text;
  final String? icon;
  final Color? btn1Color;
  final Color? btn2Color;
  final Color? iconColor;
  final bool? btn1Outlined;
  final bool? btn2Outlined;
  final double? iconSize;
  final Function()? onBtn1Tap;
  final Function()? onBtn2Tap;
  final bool? showBtn2;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Container(
        padding: EdgeInsets.all(20.0.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon ?? Images.successGreenIcon,
              height: iconSize??80.0.sp,
              width: iconSize??80.0.sp,
              color: iconColor,
            ),
            SizedBox(
              height: 10.0.sp,
            ),
            Visibility(
              visible: title1!=null,
              child: ExtraLargeMediumBoldText(
                title: title1 ?? "Success".tr(),
                textColor: AppColors.extraLightBlack,
              ),
            ),
            SizedBox(
              height: 5.0.sp,
            ),
            ExtraMediumText(
              title: title2 ?? "This is the second title",
              textColor: AppColors.extraLightBlack,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w300,
            ),
            SizedBox(
              height: 15.0.sp,
            ),
            Row(
              children: [
                Visibility(
                    visible: showBtn2 ?? true,
                    child: Expanded(
                        child: Button(
                            isIconFirst: false,
                            outLined: btn2Outlined??false,
                            btnColor: btn2Color??AppColors.mainColor,
                            text: btn2Text ?? "Cancel".tr(), tapAction: onBtn2Tap))),
                Visibility(
                    visible: showBtn2 ?? true,
                    child: SizedBox(
                      width: 5.0.sp,
                    )),
                Expanded(
                    child: Button(
                        outLined: btn1Outlined??false,
                        btnColor: btn1Color??AppColors.mainColor,
                        text: btn1Text ?? "Done".tr(), tapAction: onBtn1Tap)),
              ],
            )
          ],
        ),
      ),
    );
  }

  const CustomDialog({
    this.title1,
    this.title2,
    this.icon,
    this.iconColor,
    this.onBtn1Tap,
    this.onBtn2Tap,
    this.showBtn2,
    this.btn1Text,
    this.btn2Text,
    this.btn1Color,
    this.btn2Color,
    this.iconSize,
    this.btn1Outlined,
    this.btn2Outlined,
  });
}
