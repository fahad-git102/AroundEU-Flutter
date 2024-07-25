import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Extra medium text
///
/// This text is medium in size and regular in text type.

class ExtraMediumText extends StatelessWidget {
  const ExtraMediumText(
      {Key? key,
        this.title = "",
        this.textColor,
        this.textAlign,
        this.maxLines,
        this.decrease=0,
        this.overflow, this.fontWeight, this.fontFamily})
      : super(key: key);
  final Color? textColor;
  final String? title;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final int? maxLines;
  final double? decrease;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
        title!,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontSize: 14.sp - decrease!,
            fontWeight: fontWeight??FontWeight.w600,
            fontFamily: fontFamily,
            color: textColor ?? Theme.of(context).primaryColor),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,);
  }
}