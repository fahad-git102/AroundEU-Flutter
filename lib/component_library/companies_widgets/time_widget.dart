import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_colors.dart';
import '../text_widgets/small_light_text.dart';

class TimeWidget extends StatelessWidget{
  String? title, value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SmallLightText(
          title: title,
          textColor: AppColors.lightBlack,
        ),
        SizedBox(
          width: 10.0.sp,
        ),
        SmallLightText(
          title: value,
          fontSize: 13.0.sp,
          textColor: AppColors.hyperLinkColor,
        ),
      ],
    );;
  }

  TimeWidget({
    this.title,
    this.value,
  });
}