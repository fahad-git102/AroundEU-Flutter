import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:sizer/sizer.dart';

import '../../core/size_config.dart';

class CompaniesListWidget extends StatelessWidget{

  String? title, address, companySize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      padding: EdgeInsets.all(10.0.sp),
      margin: EdgeInsets.only(bottom: 9.0.sp),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black87.withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(
                  1, 1), // Shadow position
            ),
          ],
          borderRadius: BorderRadius.all(
              Radius.circular(8.sp))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ExtraMediumText(
                  fontWeight: FontWeight.w300,
                  title: title,
                  textColor: AppColors.blue,
                ),
              ),
              SmallLightText(
                textColor: AppColors.fadedTextColor2,
                title: companySize,
              )
            ],
          ),
          SizedBox(height: 2.0.sp,),
          ExtraMediumText(
            textColor: AppColors.lightBlack,
            title: address,
            decrease: 2,
          )
        ],
      ),
    );
  }

  CompaniesListWidget({
    this.title,
    this.address,
    this.companySize,
  });
}