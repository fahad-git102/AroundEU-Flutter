import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:sizer/sizer.dart';

class BusinessListItem extends StatelessWidget{
  String? title, country;
  Function(int val)? onOptionSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 9.0.sp),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black87.withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(1, 1), // Shadow position
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(4.sp))),
      child: Padding(
        padding: EdgeInsets.only(top: 7.sp, bottom: 7.0.sp, left: 10.sp),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ExtraMediumText(
                title: title??'',
                textColor: AppColors.lightBlack,
              ),
            ),
            SmallLightText(
              title: country??'',
              fontSize: 9.sp,
              textColor: AppColors.hyperLinkColor,
            ),
            PopupMenuButton<int>(
              onSelected: onOptionSelected,
              itemBuilder: (BuildContext context) =>
              <PopupMenuEntry<int>>[
                PopupMenuItem<int>(
                  value: 0,
                  child: ListTile(
                    leading: const Icon(Icons.edit),
                    title: SmallLightText(title: 'Edit'.tr()),
                  ),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: ListTile(
                    leading: const Icon(Icons.delete),
                    title: SmallLightText(title: 'Delete'.tr()),
                  ),
                ),
              ],
              icon: const Icon(Icons.more_vert),
            )
          ],
        ),
      ),
    );
  }

  BusinessListItem({
    this.title,
    this.country,
    this.onOptionSelected
  });

}