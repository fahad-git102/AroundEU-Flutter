import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_colors.dart';

class MediumBoldText extends StatelessWidget {
  const MediumBoldText(
      {Key? key,
        this.title = "",
        this.textColor,
        this.textAlign,
        this.maxLines})
      : super(key: key);
  final Color? textColor;
  final String? title;
  final TextAlign? textAlign;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
        title!,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: textColor ?? AppColors.black),
        textAlign: textAlign,);
  }
}