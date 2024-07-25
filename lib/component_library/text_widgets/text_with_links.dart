import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_colors.dart';

class TextWithLinks extends StatelessWidget {
  final String? title;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? linkColor, textColor;

  @override
  Widget build(BuildContext context) {
    return Linkify(
      onOpen: (link) async {
        if (!await launchUrl(Uri.parse(link.url))) {
          throw Exception('Could not launch ${link.url}');
        }
      },
      text: title ?? '',
      textAlign: textAlign??TextAlign.start,
      style: TextStyle(
          color: textColor ?? AppColors.hyperLinkColor,
          fontSize: fontSize ?? 12.0.sp, fontWeight: fontWeight??FontWeight.w300),
      linkStyle: TextStyle(
          color: linkColor ?? AppColors.hyperLinkColor,
          fontSize: fontSize ?? 12.0.sp,
          decoration: TextDecoration.underline, fontWeight: FontWeight.w400),
    );
  }

  const TextWithLinks({
    this.title,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.linkColor,
    this.textColor,
  });
}
