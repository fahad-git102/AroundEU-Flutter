import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groupchat/component_library/chat_widgets/first_letter_widget.dart';
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/core/size_config.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:sizer/sizer.dart';

import '../image_widgets/circle_image_avatar.dart';

class GroupItem extends StatelessWidget {
  String? imageUrl, title, subTile;
  int messagesCount;
  bool? showJoinButton;
  Function()? onJoinTap;
  int? lastMsgTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.sp),
      margin: EdgeInsets.only(bottom: 7.sp),
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.all(Radius.circular(6.sp)),
          boxShadow: [
            BoxShadow(
              color: Colors.black87.withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(1, 1), // Shadow position
            ),
          ]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          imageUrl != null || imageUrl?.isEmpty == true
              ? CircleImageAvatar(
                  imagePath: imageUrl,
                  borderWidth: 0.5.sp,
                  size: 35.0.sp,
                )
              : CircleLetterWidget(letter: title![0].toUpperCase()),
          SizedBox(
            width: 10.sp,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExtraMediumText(
                  title: title ?? '',
                  textColor: AppColors.lightBlack,
                ),
                subTile != null && subTile?.isNotEmpty == true
                    ? SizedBox(
                        height: 3.sp,
                      )
                    : Container(),
                subTile != null && subTile?.isNotEmpty == true
                    ? SmallLightText(
                        title: subTile ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textColor: AppColors.fadedTextColor,
                      )
                    : Container()
              ],
            ),
          ),
          SizedBox(
            width: 8.sp,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              showJoinButton == true?InkWell(
                onTap: onJoinTap,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.sp),
                  height: 21.sp,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(3.sp)),
                    border: Border.all(color: AppColors.mainColorDark, width: 0.4.sp),
                  ),
                  child: Center(
                    child: SmallLightText(
                      fontSize: 9.sp,
                      textColor: AppColors.mainColorDark,
                      title: "Join".tr(),
                    ),
                  ),
                ),
              ):Container(),
              messagesCount > 0
                  ? Container(
                      height: 17.sp,
                      width: 17.sp,
                      decoration: BoxDecoration(
                          color: AppColors.mainColor, shape: BoxShape.circle),
                      child: Center(
                        child: SmallLightText(
                          title: messagesCount > 99
                              ? '99+'
                              : messagesCount.toString(),
                          textColor: AppColors.lightBlack,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  : Container(),
              lastMsgTime != null && lastMsgTime! > 0
                  ? SizedBox(
                      height: 5.sp,
                    )
                  : Container(),
              lastMsgTime != null && lastMsgTime! > 0
                  ? SmallLightText(
                      title: Utilities().formatTimestamp(lastMsgTime ?? 0),
                      fontSize: 9.sp,
                      textColor: AppColors.fadedTextColor,
                    )
                  : Container()
            ],
          )
        ],
      ),
    );
  }

  GroupItem({
    this.imageUrl,
    this.messagesCount = 0,
    this.title,
    this.onJoinTap,
    this.showJoinButton = false,
    this.lastMsgTime,
    this.subTile,
  });
}
