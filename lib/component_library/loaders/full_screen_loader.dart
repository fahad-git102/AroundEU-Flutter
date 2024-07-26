import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_colors.dart';
import '../../core/size_config.dart';

class FullScreenLoader extends StatefulWidget {
  FullScreenLoader({Key? key,this.loading=false,this.showShadow=true}) : super(key: key);
  bool? loading;
  bool? showShadow;
  @override
  State<FullScreenLoader> createState() => _FullScreenLoaderState();
}

class _FullScreenLoaderState extends State<FullScreenLoader> {
  @override
  Widget build(BuildContext context) {
    return  widget.loading==true?Container(
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      decoration:widget.showShadow==true? BoxDecoration(
          color: Theme.of(context).shadowColor.withOpacity(0.1)
      ):null,
      child: Center(
        child: SizedBox(
          height: 30.sp,
          width: 30.sp,
          child:  Center(child: CircularProgressIndicator(color: AppColors.mainColor,)),
        ),
      ),
    ):Container();
  }
}