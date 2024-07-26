import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/core/assets_names.dart';
import 'package:sizer/sizer.dart';

class BackIconButton extends StatelessWidget {
  final Function()? onTap;
  final String? icon;
  final double? size;
  final Color? color;

  const BackIconButton({super.key, this.onTap, this.icon, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
        child: SvgPicture.asset(
      icon??Images.backIcon,
      height: size??30.0.sp,
      width: size??30.0.sp,
      color: color??AppColors.lightBlack,
    ));
  }
}
