import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_colors.dart';

class SmallLightText extends StatelessWidget {
  const SmallLightText(
      {Key? key,
        this.title = "",
        this.textColor,
        this.textAlign,
        this.lineThrough=false,
        this.textDecoration,
        this.maxLines,
        this.overflow, this.fontWeight, this.fontSize})
      : super(key: key);
  final Color? textColor;
  final String? title;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextDecoration? textDecoration;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? lineThrough;

  @override
  Widget build(BuildContext context) {
    return Text(
        title!,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontSize: fontSize??10.5.sp,
            fontWeight: fontWeight??FontWeight.w300,
            decoration: textDecoration ?? (lineThrough==true?TextDecoration.lineThrough:TextDecoration.none),
            color: textColor ?? AppColors.black),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,

        );
    }
}