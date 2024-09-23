import 'package:flutter/cupertino.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_colors.dart';
import '../text_widgets/extra_medium_text.dart';

class ReceiverMessageWidget extends StatefulWidget{
  String? text;
  @override
  State<StatefulWidget> createState() => _ReceiverMessageState();

  ReceiverMessageWidget({
    this.text,
  });
}

class _ReceiverMessageState extends State<ReceiverMessageWidget>{
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SmallLightText(
            title: 'Sender name',
            textColor: AppColors.lightBlack,
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10.sp),
            padding: EdgeInsets.all(12.sp),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(7.sp)),
                color: AppColors.mainColor.withOpacity(0.3)
            ),
            child: IntrinsicWidth(
              child: Align(
                alignment: Alignment.centerLeft,
                child: SmallLightText(
                  fontSize: 12.sp,
                  title: widget.text,
                  textColor: AppColors.lightBlack,
                ),
              ),
            ),
          ),
        ],
      ),
    );;
  }

}