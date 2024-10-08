import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:groupchat/component_library/text_widgets/extra_large_medium_bold_text.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_colors.dart';
import '../../core/assets_names.dart';
import '../buttons/button.dart';
import '../text_widgets/small_light_text.dart';

class DeleteMessageBottomsheet extends StatefulWidget {
  final Function()? onDeleteForMeTap;
  final Function()? onDeleteForEveryoneTap;
  final Function()? onCancelTap;
  final bool? showEveryoneButton;
  const DeleteMessageBottomsheet({super.key, this.onDeleteForMeTap, this.showEveryoneButton= false, this.onCancelTap, this.onDeleteForEveryoneTap});

  @override
  State<DeleteMessageBottomsheet> createState() => _DeleteMessageBottomsheetState();
}

class _DeleteMessageBottomsheetState extends State<DeleteMessageBottomsheet> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.sp),
              topRight: Radius.circular(20.sp),
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 7.sp,),
                    SvgPicture.asset(
                      Images.deleteBig,
                      height: 80.sp,
                      width: 80.sp,
                    ),
                    SizedBox(
                      height: 10.sp,
                    ),
                    ExtraLargeMediumBoldText(
                      title: 'Delete Message'.tr(),
                      textColor: AppColors.lightBlack,
                    ),
                    SizedBox(
                      height: 10.sp,
                    ),
                    SmallLightText(
                      textAlign: TextAlign.center,
                      title: 'Are you sure you want to delete this message? Please confirm that this action cannot be undone.'.tr(),
                      textColor: AppColors.fadedTextColor,
                    ),
                    SizedBox(
                      height: 15.sp,
                    ),
                    Button(
                        btnColor: AppColors.red,
                        text: 'Delete for me'.tr(),
                        btnTxtColor: AppColors.white,
                        tapAction: widget.onDeleteForMeTap),
                    SizedBox(
                      height: 6.sp,
                    ),
                    Button(
                        btnColor: AppColors.red,
                        btnTxtColor: AppColors.white,
                        text: 'Delete for everyone'.tr(),
                        tapAction: widget.onDeleteForEveryoneTap),
                    SizedBox(
                      height: 10.sp,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 3.sp),
                      child: SmallLightText(
                        title: "No, Cancel".tr(),
                        textDecoration: TextDecoration.underline,
                        textColor: AppColors.lightBlack,
                      ),
                    ),
                    SizedBox(
                      height: 10.sp,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.sp, right: 15.sp),
                child: Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: widget.onCancelTap ??  (){
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(3.0.sp),
                        child: SvgPicture.asset(
                          Images.closeNormal,
                          height: 16.sp,
                          width: 16.sp,
                          color: AppColors.lightBlack,
                        ),
                      ),
                    )),
              ),
            ],
          ),
        );
      },
    );
  }
}
