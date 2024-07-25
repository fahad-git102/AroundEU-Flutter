import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_colors.dart';


class ExtraLargeMediumBoldText extends StatelessWidget {
  const ExtraLargeMediumBoldText(
      {Key? key,
        this.title = "",
        this.textColor,
        this.textAlign,
        this.maxLines,
        this.fontWeight,
        this.fontSize, this.overFlow})
      : super(key: key);
  final Color? textColor;
  final String? title;
  final TextOverflow? overFlow;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final int? maxLines;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
        title!,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontSize: fontSize ?? 20.sp,
            fontWeight: fontWeight??FontWeight.w600,
            color: textColor ?? AppColors.black),
        textAlign: textAlign,
        overflow: overFlow,
        maxLines: maxLines,);
    }
}
