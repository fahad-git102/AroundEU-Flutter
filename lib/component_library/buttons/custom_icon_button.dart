import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/assets_names.dart';

class CustomIconPngButton extends StatelessWidget {
  final String? icon;
  final double? size;
  final Function()? onTap;

  const CustomIconPngButton({super.key, this.onTap, this.icon, this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size??30.0.sp,
      width: size??30.0.sp,
      child: Center(
        child: InkWell(
            onTap: onTap,
            child: Padding(
                padding: EdgeInsets.all(4.0.sp),
                child: Image.asset(icon ?? Images.menuIcon))),
      ),
    );
  }
}
