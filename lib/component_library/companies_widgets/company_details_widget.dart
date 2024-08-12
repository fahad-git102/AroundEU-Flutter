import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_colors.dart';

class CompanyDetailWidget extends StatelessWidget{
  String? title, value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(top: 2.0.sp),
            child: SmallLightText(
              title: title,
              textColor: AppColors.lightBlack,
            ),
          ),
        ),
        SizedBox(width: 13.0.sp,),
        Expanded(
          flex: 3,
          child: ExtraMediumText(
            title: value,
            decrease: 3,
            textColor: AppColors.lightBlack,
          ),
        ),
      ],
    );
  }

  CompanyDetailWidget({
    this.title,
    this.value,
  });
}