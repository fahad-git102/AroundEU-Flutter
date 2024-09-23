import 'package:flutter/cupertino.dart';
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:sizer/sizer.dart';

class SenderMessageWidget extends StatefulWidget{

  String? text;

  @override
  State<StatefulWidget> createState() => _SenderMessageState();

  SenderMessageWidget({
    this.text,
  });
}

class _SenderMessageState extends State<SenderMessageWidget>{
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(12.sp),
        margin: EdgeInsets.only(bottom: 10.sp),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(7.sp)),
          color: AppColors.mainColor
        ),
        child: IntrinsicWidth(
          child: Align(
            alignment: Alignment.centerRight,
            child: SmallLightText(
              title: widget.text,
              fontSize: 12.sp,
              textColor: AppColors.lightBlack,
            ),
          ),
        ),
      ),
    );
  }

}