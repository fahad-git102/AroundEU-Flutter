import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groupchat/component_library/chat_widgets/first_letter_widget.dart';
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/core/size_config.dart';
import 'package:sizer/sizer.dart';

import '../image_widgets/circle_image_avatar.dart';

class GroupItem extends StatelessWidget {
  String? imageUrl, title, subTile;
  int messagesCount;

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
                  size: 40.0.sp,
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
          SizedBox(width: 8.sp,),
          messagesCount>0?Container(
            height: 17.sp,
            width: 17.sp,
            decoration: BoxDecoration(
                color: AppColors.mainColor, shape: BoxShape.circle),
            child: Center(
              child: SmallLightText(
                title: messagesCount > 99 ? '99+' : messagesCount.toString(),
                textColor: AppColors.lightBlack,
                fontSize: 10.sp,
              ),
            ),
          ):Container()
        ],
      ),
    );
  }

  GroupItem({
    this.imageUrl,
    this.messagesCount = 0,
    this.title,
    this.subTile,
  });
}
